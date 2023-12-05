Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3A96FAF;
	Tue,  5 Dec 2023 03:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q/1+CErQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD7CC433C8;
	Tue,  5 Dec 2023 03:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746938;
	bh=5hfGj8NkRJgQXnWe/19tRb+yKSqcSdCOsHEFTwSDiwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q/1+CErQY9d9eydNG59fjzEhVKGbshQ6Y+0uFHCOaWJEb9ux+C604v7x8qTYS4kSU
	 BjtQN1bdfJpQeVlCheQtbPo/PZZB2jnNbnwYFKEEwEmIJGiz9ZfGInFinPPm7LWyw8
	 H9U2YeHNjTpF40K0PkLqVKGooDHTrGSsjgN3pH64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Andi Kleen <ak@linux.intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@redhat.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 49/71] perf intel-pt: Adjust sample flags for VM-Exit
Date: Tue,  5 Dec 2023 12:16:47 +0900
Message-ID: <20231205031520.713653676@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031517.859409664@linuxfoundation.org>
References: <20231205031517.859409664@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 695fc4510615f8db40ebaf7a2c011f0a594b5f77 ]

Use the change of NR to detect whether an asynchronous branch is a VM-Exit.

Note VM-Entry is determined from the vmlaunch or vmresume instruction,
in which case, sample flags will show "VMentry" even if the VM-Entry fails.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: https://lore.kernel.org/r/20210218095801.19576-10-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: f2d87895cbc4 ("perf intel-pt: Fix async branch flags")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/intel-pt.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/intel-pt.c b/tools/perf/util/intel-pt.c
index e90f1044a8397..e073c7108c6c9 100644
--- a/tools/perf/util/intel-pt.c
+++ b/tools/perf/util/intel-pt.c
@@ -899,13 +899,16 @@ static void intel_pt_sample_flags(struct intel_pt_queue *ptq)
 	if (ptq->state->flags & INTEL_PT_ABORT_TX) {
 		ptq->flags = PERF_IP_FLAG_BRANCH | PERF_IP_FLAG_TX_ABORT;
 	} else if (ptq->state->flags & INTEL_PT_ASYNC) {
-		if (ptq->state->to_ip)
+		if (!ptq->state->to_ip)
+			ptq->flags = PERF_IP_FLAG_BRANCH |
+				     PERF_IP_FLAG_TRACE_END;
+		else if (ptq->state->from_nr && !ptq->state->to_nr)
+			ptq->flags = PERF_IP_FLAG_BRANCH | PERF_IP_FLAG_CALL |
+				     PERF_IP_FLAG_VMEXIT;
+		else
 			ptq->flags = PERF_IP_FLAG_BRANCH | PERF_IP_FLAG_CALL |
 				     PERF_IP_FLAG_ASYNC |
 				     PERF_IP_FLAG_INTERRUPT;
-		else
-			ptq->flags = PERF_IP_FLAG_BRANCH |
-				     PERF_IP_FLAG_TRACE_END;
 		ptq->insn_len = 0;
 	} else {
 		if (ptq->state->from_ip)
-- 
2.42.0



