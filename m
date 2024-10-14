Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30411AB6C1;
	Mon, 14 Oct 2024 14:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917316; cv=none; b=fJqCLm0lAaNkQdJ/i5SCKIFFK0C1XbaAzkAouKdLa5/BEAAP8ivDLYplhxpxgIHu3h4PRf7z+GqQOAPBsaKFfnp/SJiSIzFwMRq0SR6AWm/WNUcawxb8X4c4QNiiZxxKZseyeNvJ9ObtZ9HXdDMEHlBMXEJzWLyCPSxbCkeIEWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917316; c=relaxed/simple;
	bh=+1LvYCRqLc4ssegtPtS1boMMVo8r3q2kn3w4aOVkjgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uLfWxLezYY1z5Sqi8aTS7jgY7mV1Y/PaygkevU+lG/Mkbw7jdouPhuK6jui1yyXZO/H5NngeWrR9MetuZTYpctM0K1ZlsJkWRKwI1Sx/L2Zl5D6Dzn0PQzO7TWXwdZKuztfqxMZDjRSCNpqGtatY7OsXov7mppiCRCqGxneKQgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aeT/aoKM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aeT/aoKM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 176FCC4CEC3;
	Mon, 14 Oct 2024 14:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917316;
	bh=+1LvYCRqLc4ssegtPtS1boMMVo8r3q2kn3w4aOVkjgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aeT/aoKMTKEGnyUGOaZBbbIs/lXarg7Am3qNSV4c6ayYmtCfMrhJkC0Tou9UxVc4q
	 SAq5h3p+PdUfMxCW4Lm5YqsCWD/piDUOx9mIaJunhArWa5UO1pIP5xRLo7TygXFOgn
	 dN13hOacuiTty4VPMZ/h+Fx4PHPV+fsDoNQGUNeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederic Weisbecker <frederic@kernel.org>,
	syzbot+943d34fa3cf2191e3068@syzkaller.appspotmail.com,
	Thomas Gleixner <tglx@linutronix.de>,
	Hillf Danton <hdanton@sina.com>,
	Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 208/213] kthread: unpark only parked kthread
Date: Mon, 14 Oct 2024 16:21:54 +0200
Message-ID: <20241014141051.080219600@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frederic Weisbecker <frederic@kernel.org>

commit 214e01ad4ed7158cab66498810094fac5d09b218 upstream.

Calling into kthread unparking unconditionally is mostly harmless when
the kthread is already unparked. The wake up is then simply ignored
because the target is not in TASK_PARKED state.

However if the kthread is per CPU, the wake up is preceded by a call
to kthread_bind() which expects the task to be inactive and in
TASK_PARKED state, which obviously isn't the case if it is unparked.

As a result, calling kthread_stop() on an unparked per-cpu kthread
triggers such a warning:

	WARNING: CPU: 0 PID: 11 at kernel/kthread.c:525 __kthread_bind_mask kernel/kthread.c:525
	 <TASK>
	 kthread_stop+0x17a/0x630 kernel/kthread.c:707
	 destroy_workqueue+0x136/0xc40 kernel/workqueue.c:5810
	 wg_destruct+0x1e2/0x2e0 drivers/net/wireguard/device.c:257
	 netdev_run_todo+0xe1a/0x1000 net/core/dev.c:10693
	 default_device_exit_batch+0xa14/0xa90 net/core/dev.c:11769
	 ops_exit_list net/core/net_namespace.c:178 [inline]
	 cleanup_net+0x89d/0xcc0 net/core/net_namespace.c:640
	 process_one_work kernel/workqueue.c:3231 [inline]
	 process_scheduled_works+0xa2c/0x1830 kernel/workqueue.c:3312
	 worker_thread+0x86d/0xd70 kernel/workqueue.c:3393
	 kthread+0x2f0/0x390 kernel/kthread.c:389
	 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
	 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
	 </TASK>

Fix this with skipping unecessary unparking while stopping a kthread.

Link: https://lkml.kernel.org/r/20240913214634.12557-1-frederic@kernel.org
Fixes: 5c25b5ff89f0 ("workqueue: Tag bound workers with KTHREAD_IS_PER_CPU")
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Reported-by: syzbot+943d34fa3cf2191e3068@syzkaller.appspotmail.com
Tested-by: syzbot+943d34fa3cf2191e3068@syzkaller.appspotmail.com
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kthread.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -622,6 +622,8 @@ void kthread_unpark(struct task_struct *
 {
 	struct kthread *kthread = to_kthread(k);
 
+	if (!test_bit(KTHREAD_SHOULD_PARK, &kthread->flags))
+		return;
 	/*
 	 * Newly created kthread was parked when the CPU was offline.
 	 * The binding was lost and we need to set it again.


