Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1CE33FE15;
	Sat, 30 May 2026 17:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161424; cv=none; b=Pc6qwlMkFbpPt7i9E/KiMmr58T2Go9E+WF7rQFGPyntsL3EXcRDM5LV0tOUbnHbUR71pUdMX+hYyQ/hptuQu5hgxTNnR6vb4MhNmK7pWrh1GAr8hZTte4QNkdMRoZ0pvLIPKzDbcTC4/Vq/R+DcP6qX35Ezg9fyYKcsSH4P5hgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161424; c=relaxed/simple;
	bh=L9dgEFhSs1xfdWx0N17hdDOCIDb6pO74maiqO2oiHJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nJL5cb9qcmAaV3NTIIfG1feIAQtcmfyuCfbyDeXYpikE8HTo8G8833IsSXVKqF4r8rKKW/venaj7mx6JEUy9FA49N7GmC/hRvB9ooVoMtn7dvOl1fgi3EnpIz61yFWFtap/SQyXnssnL+wXx5Bip+pvNpwOtmh+VhuAI9jOt/hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wOEEjst6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wOEEjst6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F12541F00893;
	Sat, 30 May 2026 17:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161423;
	bh=fLZV4ZQgk3RJEEdcnuIrRWfxv4ovz5EKbdChZk1AnVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wOEEjst6WDejHHJa/h3vbdLQ8IktOi5gu8aKnef5oPM6o65qxcbz1mBnNE/Sc1P74
	 QjfYKHWhtV2PL7qlhA7riydjL3jr5Yn27rYPdaeQnI5yuxapqpV6PH8LrumHf/cdmU
	 Zsy41PmMRIRyIg5YyriJwNBUKYjk08DDMlHw3IpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Michal Luczaj <mhal@rbox.co>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 619/969] bpf, sockmap: Fix af_unix iter deadlock
Date: Sat, 30 May 2026 18:02:23 +0200
Message-ID: <20260530160317.528753371@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Luczaj <mhal@rbox.co>

[ Upstream commit 4d328dd695383224aa750ddee6b4ad40c0f8d205 ]

bpf_iter_unix_seq_show() may deadlock when lock_sock_fast() takes the fast
path and the iter prog attempts to update a sockmap. Which ends up spinning
at sock_map_update_elem()'s bh_lock_sock():

WARNING: possible recursive locking detected
test_progs/1393 is trying to acquire lock:
ffff88811ec25f58 (slock-AF_UNIX){+...}-{3:3}, at: sock_map_update_elem+0xdb/0x1f0

but task is already holding lock:
ffff88811ec25f58 (slock-AF_UNIX){+...}-{3:3}, at: __lock_sock_fast+0x37/0xe0

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(slock-AF_UNIX);
  lock(slock-AF_UNIX);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

4 locks held by test_progs/1393:
 #0: ffff88814b59c790 (&p->lock){+.+.}-{4:4}, at: bpf_seq_read+0x59/0x10d0
 #1: ffff88811ec25fd8 (sk_lock-AF_UNIX){+.+.}-{0:0}, at: bpf_seq_read+0x42c/0x10d0
 #2: ffff88811ec25f58 (slock-AF_UNIX){+...}-{3:3}, at: __lock_sock_fast+0x37/0xe0
 #3: ffffffff85a6a7c0 (rcu_read_lock){....}-{1:3}, at: bpf_iter_run_prog+0x51d/0xb00

Call Trace:
 dump_stack_lvl+0x5d/0x80
 print_deadlock_bug.cold+0xc0/0xce
 __lock_acquire+0x130f/0x2590
 lock_acquire+0x14e/0x2b0
 _raw_spin_lock+0x30/0x40
 sock_map_update_elem+0xdb/0x1f0
 bpf_prog_2d0075e5d9b721cd_dump_unix+0x55/0x4f4
 bpf_iter_run_prog+0x5b9/0xb00
 bpf_iter_unix_seq_show+0x1f7/0x2e0
 bpf_seq_read+0x42c/0x10d0
 vfs_read+0x171/0xb20
 ksys_read+0xff/0x200
 do_syscall_64+0x6b/0x3a0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

Fixes: 2c860a43dd77 ("bpf: af_unix: Implement BPF iterator for UNIX domain socket.")
Suggested-by: Kuniyuki Iwashima <kuniyu@google.com>
Suggested-by: Martin KaFai Lau <martin.lau@linux.dev>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260414-unix-proto-update-null-ptr-deref-v4-2-2af6fe97918e@rbox.co
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -3598,15 +3598,14 @@ static int bpf_iter_unix_seq_show(struct
 	struct bpf_prog *prog;
 	struct sock *sk = v;
 	uid_t uid;
-	bool slow;
 	int ret;
 
 	if (v == SEQ_START_TOKEN)
 		return 0;
 
-	slow = lock_sock_fast(sk);
+	lock_sock(sk);
 
-	if (unlikely(sk_unhashed(sk))) {
+	if (unlikely(sock_flag(sk, SOCK_DEAD))) {
 		ret = SEQ_SKIP;
 		goto unlock;
 	}
@@ -3616,7 +3615,7 @@ static int bpf_iter_unix_seq_show(struct
 	prog = bpf_iter_get_info(&meta, false);
 	ret = unix_prog_seq_show(prog, &meta, v, uid);
 unlock:
-	unlock_sock_fast(sk, slow);
+	release_sock(sk);
 	return ret;
 }
 


