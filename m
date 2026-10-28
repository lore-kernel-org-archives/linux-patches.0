Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210800;
	b=zPkz5ElQNVsHet3HDn8Llnijs2LAczV1fHP/MlZZcceKOYSEHjKGXc+AU1kwqOoGo7qu
	 tHG30ywpFN4Mm7mdo/qeUsK50l0bvaiQmE7pAZg/tBNT0B4wryDT093kFH9olhE3vRZ1F
	 Vko84iSyl2oAYe7n50lhqG0PShFwDXMtm62V9QQqbj4ibx2RTvXgDLhMGkE9qBmHCeWNm
	 9kx6ywFtRC3hFN9s3VJ1DZFNMfgig4Tk2UT5xwgaZW/p6EJERR4FK7KuqghDJfxdrReE3
	 Vpf3a4fOwU/7hgk9SgFtVURBUvs3WAkhwBqQak8m3DfqgoHCvQ+2tI6wQvmSfGsMnog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210800;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nOQOE01eFMTXAww+WoSTI6OoM9cMI74llXJeORzUy3Y=;
	b=KGM8WufyqjFaIUe0FDbWuGYeov3GsTH+HfPhI+3ewvJyk6CgLULretEyOpW81jOAIxzj
	 6BuFAyiE24cWhnw3JaxjiIShwCNc6stwNNl9zIhYiZj6S/VrisejAUV3afS2jTJrb68N7
	 MwYXyLFSrPGTJZ39/IQSswch9FdcoQUajx5CCc+irZJ9S5uCOP8ar4wWLn4Rp5oEytwUu
	 cn3kYHtgRN8JUS9tJiduVk0O6gFE0OiptBtbU9yhf48hXV41pKQoPAaYAb4AG922mUEH/
	 O4k34AWhANp8otyC/bwwMdMD/9rkPfpdACRoP6J8xNExPWUr5pYwAOnCX7CQkMNCYzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iMzNSkoR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C6D606A31D;
	Wed, 28 Oct 2026 18:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iMzNSkoR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 841771F01825;
	Wed, 28 Oct 2026 18:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210800;
	bh=nOQOE01eFMTXAww+WoSTI6OoM9cMI74llXJeORzUy3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iMzNSkoRtaBpSG2pRVLHRmObl2EWv79qBfj+aD/bnjbpfDyb5JMC6H7gzekmK3yoL
	 wyjToLWw7FRKJjqkRiWpfgvcZyW3qwVnp4GEIIqdcfNKl1ZcRlPOVs7+RlgEKUgo0S
	 //CfrNRoDN68ucKTdv99xmAu8ZsV3MVqhk630To4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+2fe61cb2a86066be6985@syzkaller.appspotmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 153/571] perf/core: Fix WARN in perf_sigtrap()
Date: Wed, 28 Oct 2026 17:55:00 +0100
Message-ID: <20261028170011.646133381@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 3da6bb419750f3ad834786d6ba7c9d5d062c770b ]

Since exit_task_work() runs after perf_event_exit_task_context() updated
ctx->task to TASK_TOMBSTONE, perf_sigtrap() from perf_pending_task() might
observe event->ctx->task == TASK_TOMBSTONE.

Swap the early exit tests in order not to hit WARN_ON_ONCE().

Closes: https://syzkaller.appspot.com/bug?extid=2fe61cb2a86066be6985
Reported-by: syzbot <syzbot+2fe61cb2a86066be6985@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/b1c224bd-97f9-462c-a3e3-125d5e19c983@I-love.SAKURA.ne.jp
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index dc59568a538f6..40d31c3e1eb7a 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6691,18 +6691,18 @@ void perf_event_wakeup(struct perf_event *event)
 static void perf_sigtrap(struct perf_event *event)
 {
 	/*
-	 * We'd expect this to only occur if the irq_work is delayed and either
-	 * ctx->task or current has changed in the meantime. This can be the
-	 * case on architectures that do not implement arch_irq_work_raise().
+	 * Both perf_pending_task() and perf_pending_irq() can race with the
+	 * task exiting.
 	 */
-	if (WARN_ON_ONCE(event->ctx->task != current))
+	if (current->flags & PF_EXITING)
 		return;
 
 	/*
-	 * Both perf_pending_task() and perf_pending_irq() can race with the
-	 * task exiting.
+	 * We'd expect this to only occur if the irq_work is delayed and either
+	 * ctx->task or current has changed in the meantime. This can be the
+	 * case on architectures that do not implement arch_irq_work_raise().
 	 */
-	if (current->flags & PF_EXITING)
+	if (WARN_ON_ONCE(event->ctx->task != current))
 		return;
 
 	send_sig_perf((void __user *)event->pending_addr,
-- 
2.53.0



