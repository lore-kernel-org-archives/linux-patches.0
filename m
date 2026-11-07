Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065283;
	b=Q9VpFEeJX6/wDxAYbiNiP92Q+gSgD2OU1m4CIgzDQKso25qC2fiDFCv5Jo483+b4L9MX
	 xlVy1UjNUmvHIoeG9WxkjAOPHYZAL0mNzxwUEOVjB+/deoq4teVZn55igPZi4az7vYbda
	 8g1I2hDW8D03hMjvfa36ZNCPEMMjfhHHDY5qd6iNd3Rlu+tHiMuxUmfSKyvArFZztWOJi
	 OVafBWSpVOcQSBfniGVdeMKagetW+EDO+X4bXTPYdqyzCK2YMYCNKjHnNwWgePIo/qhLi
	 xaq5H82hpGJFXeGdu+haDkNHPNSGkItFHFjMsi79v6tb5avexc0eOY7cF5DVf0CGlqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065283;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u1UoSpWvw+u4unU5qN4gIek/8JP2794gDuuJBVPD9JA=;
	b=anerD0u9PH01IPXYuqkUfCyuMJaNM1vE5cos33Tahmrr8c+R5NyU7CT4z7TaRLAFN1sZ
	 u6cllnPwqogE65cmwGLOJfR1HvHjLx9CKsQw/B0RtM9rQrwy+wJ8DujJFL5kh0motS8Co
	 +7INs2UItlgpqRcd/lfrk20OSdWCX+/tS3yLEH53i0X6JeX1mIBx4Q9hTN1q2bEqHua95
	 PRcAi0V22IGWrXSIQzulMjzua732rk6j6vSM9IyLyMuYcm7ePe070cMkdWYDdibIvu6Hd
	 HIrLZXDQkT0R43G6G7flfxkz63CuOQHtZQR6Z5qkMBh3wIgctTPn25uEywxXQBUYfhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LiXPbfxf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DF2606A326;
	Sat,  7 Nov 2026 15:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LiXPbfxf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 377641F008A1;
	Sat,  7 Nov 2026 15:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065283;
	bh=u1UoSpWvw+u4unU5qN4gIek/8JP2794gDuuJBVPD9JA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LiXPbfxfCAiMaIpAz8q4QVXLReLTG6EPrDQHx8p4C80mQl2ssQo93kx8mZi3FBi44
	 ICvGEoc01a6EExIVFCsumJPE38Rm55BqHOZsG7oKXbPWWq9H5lEFFPfYYDqoOM3sXx
	 tWUMMKc01MbhxQV3mFCkh+iHc/F5MlONX0iahYz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 7.3 1044/1257] cgroup: dont kill migrated processes through their exiting threads
Date: Sat,  7 Nov 2026 08:55:40 -0500
Message-ID: <20261107135008.144227505@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

[ Upstream commit 5f4a3f743acc96987ae5c2e966947942c34ba56c ]

Since commit da13e0e72a73 ("cgroup: fix cgroup.kill for exited thread
group leader"), __cgroup_kill() visits every thread in the cgroup and
sends SIGKILL with PIDTYPE_TGID, so each visited thread takes down its
whole thread group.

A thread that has started exiting can stay in a cgroup after its process
has been moved out of it. cgroup_migrate_add_task() skips PF_EXITING
tasks, and the thread is only unlinked by cgroup_task_dead() after its
final context switch. mm_release() clears the thread's clear_child_tid
word and wakes the joiner well before that, so pthread_join() can return
while the thread is still in the old cgroup.

If cgroup.kill is written in that window, __cgroup_kill() finds the
exiting thread and complete_signal() passes the group-wide SIGKILL on to
a live thread, killing a process that already left the cgroup. The cgroup
selftest test_stress.sh runs into this: test_cgcore_proc_migration()
joins its threads, moves itself back to the root cgroup, and cg_destroy()
falls back to cgroup.kill on the old cgroup when rmdir() fails with
EBUSY, so test_core kills itself. KernelCI has been reporting
"with_stress.sh: line 94: ... Killed" on several arm64 boards since the
commit reached linux-next.

Keep visiting every thread, but go back to sending SIGKILL to the thread
that was found. A SIGKILL sent to a live thread still kills its whole
thread group, so both cases fixed by that commit stay fixed, and
task_can_queue_signal() drops one sent to a thread that is already
exiting.

Fixes: da13e0e72a73 ("cgroup: fix cgroup.kill for exited thread group leader")
Cc: stable@vger.kernel.org # v5.14+
Link: https://lore.kernel.org/all/179272264722.329188.4773475583351189022@6e52bff8000c/
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index a1cc11009e49e..2d582603a7114 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4299,7 +4299,7 @@ static void __cgroup_kill(struct cgroup *cgrp)
 		if (__fatal_signal_pending(task))
 			continue;
 
-		do_send_sig_info(SIGKILL, SEND_SIG_NOINFO, task, PIDTYPE_TGID);
+		send_sig(SIGKILL, task, 0);
 	}
 	css_task_iter_end(&it);
 }
-- 
2.53.0



