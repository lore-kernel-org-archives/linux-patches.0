Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8486FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:11:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2EF5C433C7;
	Sun, 17 Sep 2023 20:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981496;
	bh=iKIzAitrDlGK5iZAqFXorrI7QUZVUW6BEdYSkk2fcw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AWpfjwUb3eyAvKXrO4DcdH1vaYUkY4C1e+BRr22K39TfGWoB4aCIb/yh2lNHzo5nc
	 AhYGvjVRyCQWEk4jCDz7OTRL4NYnBUebAl1CPKr0eBwegqzPuwhigs7GGSbnf39YFZ
	 z0rcaPhKKIG2J+/V0bsU0sVOlt6AjCVPWTrW+FuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	"Joel Fernandes (Google)" <joel@joelfernandes.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 063/511] refscale: Fix uninitalized use of wait_queue_head_t
Date: Sun, 17 Sep 2023 21:08:10 +0200
Message-ID: <20230917191115.406012681@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

[ Upstream commit f5063e8948dad7f31adb007284a5d5038ae31bb8 ]

Running the refscale test occasionally crashes the kernel with the
following error:

[ 8569.952896] BUG: unable to handle page fault for address: ffffffffffffffe8
[ 8569.952900] #PF: supervisor read access in kernel mode
[ 8569.952902] #PF: error_code(0x0000) - not-present page
[ 8569.952904] PGD c4b048067 P4D c4b049067 PUD c4b04b067 PMD 0
[ 8569.952910] Oops: 0000 [#1] PREEMPT_RT SMP NOPTI
[ 8569.952916] Hardware name: Dell Inc. PowerEdge R750/0WMWCR, BIOS 1.2.4 05/28/2021
[ 8569.952917] RIP: 0010:prepare_to_wait_event+0x101/0x190
  :
[ 8569.952940] Call Trace:
[ 8569.952941]  <TASK>
[ 8569.952944]  ref_scale_reader+0x380/0x4a0 [refscale]
[ 8569.952959]  kthread+0x10e/0x130
[ 8569.952966]  ret_from_fork+0x1f/0x30
[ 8569.952973]  </TASK>

The likely cause is that init_waitqueue_head() is called after the call to
the torture_create_kthread() function that creates the ref_scale_reader
kthread.  Although this init_waitqueue_head() call will very likely
complete before this kthread is created and starts running, it is
possible that the calling kthread will be delayed between the calls to
torture_create_kthread() and init_waitqueue_head().  In this case, the
new kthread will use the waitqueue head before it is properly initialized,
which is not good for the kernel's health and well-being.

The above crash happened here:

	static inline void __add_wait_queue(...)
	{
		:
		if (!(wq->flags & WQ_FLAG_PRIORITY)) <=== Crash here

The offset of flags from list_head entry in wait_queue_entry is
-0x18. If reader_tasks[i].wq.head.next is NULL as allocated reader_task
structure is zero initialized, the instruction will try to access address
0xffffffffffffffe8, which is exactly the fault address listed above.

This commit therefore invokes init_waitqueue_head() before creating
the kthread.

Fixes: 653ed64b01dc ("refperf: Add a test to measure performance of read-side synchronization")
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Acked-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/refscale.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/rcu/refscale.c b/kernel/rcu/refscale.c
index 5abb0cf52803a..fda220e2c0426 100644
--- a/kernel/rcu/refscale.c
+++ b/kernel/rcu/refscale.c
@@ -849,12 +849,11 @@ ref_scale_init(void)
 	VERBOSE_SCALEOUT("Starting %d reader threads\n", nreaders);
 
 	for (i = 0; i < nreaders; i++) {
+		init_waitqueue_head(&reader_tasks[i].wq);
 		firsterr = torture_create_kthread(ref_scale_reader, (void *)i,
 						  reader_tasks[i].task);
 		if (firsterr)
 			goto unwind;
-
-		init_waitqueue_head(&(reader_tasks[i].wq));
 	}
 
 	// Main Task
-- 
2.40.1



