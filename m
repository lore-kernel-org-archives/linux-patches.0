Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0571F946
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:24:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A8FC433C9;
	Fri, 21 Jul 2023 16:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956669;
	bh=/3SoltwMI42/XF05RtByg7qawtRF9zbf4jhmkfdSWeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eNFdb/QQ+eZQ1Zk3XGwWMYU4ejCum/BzASKBn613BL/WBTbMyDEllnP9shlYm8bnH
	 +alaiEMKb+USrwHB+2AEn0w8JDqQwNcWmfeMdLCptoaSJtAcOsgvblYi3EQuCTaMY3
	 q4llwMub2CDF0QdLqsWRpitd+egluS+cWGtXYr24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Greg Thelen <gthelen@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.4 250/292] perf/x86: Fix lockdep warning in for_each_sibling_event() on SPR
Date: Fri, 21 Jul 2023 18:05:59 +0200
Message-ID: <20230721160539.657762091@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Namhyung Kim <namhyung@kernel.org>

commit 27c68c216ee1f1b086e789a64486e6511e380b8a upstream.

On SPR, the load latency event needs an auxiliary event in the same
group to work properly.  There's a check in intel_pmu_hw_config()
for this to iterate sibling events and find a mem-loads-aux event.

The for_each_sibling_event() has a lockdep assert to make sure if it
disabled hardirq or hold leader->ctx->mutex.  This works well if the
given event has a separate leader event since perf_try_init_event()
grabs the leader->ctx->mutex to protect the sibling list.  But it can
cause a problem when the event itself is a leader since the event is
not initialized yet and there's no ctx for the event.

Actually I got a lockdep warning when I run the below command on SPR,
but I guess it could be a NULL pointer dereference.

  $ perf record -d -e cpu/mem-loads/uP true

The code path to the warning is:

  sys_perf_event_open()
    perf_event_alloc()
      perf_init_event()
        perf_try_init_event()
          x86_pmu_event_init()
            hsw_hw_config()
              intel_pmu_hw_config()
                for_each_sibling_event()
                  lockdep_assert_event_ctx()

We don't need for_each_sibling_event() when it's a standalone event.
Let's return the error code directly.

Fixes: f3c0eba28704 ("perf: Add a few assertions")
Reported-by: Greg Thelen <gthelen@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20230704181516.3293665-1-namhyung@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/core.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3993,6 +3993,13 @@ static int intel_pmu_hw_config(struct pe
 		struct perf_event *leader = event->group_leader;
 		struct perf_event *sibling = NULL;
 
+		/*
+		 * When this memload event is also the first event (no group
+		 * exists yet), then there is no aux event before it.
+		 */
+		if (leader == event)
+			return -ENODATA;
+
 		if (!is_mem_loads_aux_event(leader)) {
 			for_each_sibling_event(sibling, leader) {
 				if (is_mem_loads_aux_event(sibling))


