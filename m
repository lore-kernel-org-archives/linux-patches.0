Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6AE313DDC0;
	Wed, 19 Jun 2024 13:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718804092; cv=none; b=P4ata8AMqaZtffL6E/9UHPb4/7iC7c4vaMiOPMQCvRi5ExVYX0feOhvT7YBCPIWrnnYAksSIwKq0V1mcsaSvfmyfW2zkjsvF9cD87tDy/GAM6hkQirAv1WS5zXYemBGFdN/Um4GioP293EzYkt0t2zEO/oh0KcNLAwE6/xJVBk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718804092; c=relaxed/simple;
	bh=EbXn3MFCUnExG6VzJbGwZoAEb8ClQIpfY3jVJRlKlXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tpP8nM/RaJfjGoQsfq95oHYIj3cbi8LCgpQ5xHfgMvSPSaIzY+oKATDYy6aLkzxlH6XvMGW1CpsZRErID9325JlFQGOU9FSfYvXydEuO5LTptx2Ev1s31lsBc98sNWdj7ZZrZFAHZnICUNwQ0ZgkYD+StzEiyT0CRmrOnIRy/1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KTaoMSVn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KTaoMSVn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 571F8C2BBFC;
	Wed, 19 Jun 2024 13:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718804092;
	bh=EbXn3MFCUnExG6VzJbGwZoAEb8ClQIpfY3jVJRlKlXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KTaoMSVn7SefZ5Wp2mLoLC6Ggn/BgaMnbcnKBVpIkcLhJmY0/naJKTU9N4Psa2tX/
	 1Ka9yYIxoSVMNpV58dKlBcfgulpYD9eXa7goJtdq5bBz+VW1XLyHqT8pJ9qfcBelmy
	 z/VHRyzOsFLF5Ydy9M0gacxTbbJEh/UA0nN3pB0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	syzbot+07a2e4a1a57118ef7355@syzkaller.appspotmail.com,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Jakub Sitnicki <jakub@cloudflare.com>
Subject: [PATCH 6.1 175/217] sock_map: avoid race between sock_map_close and sk_psock_put
Date: Wed, 19 Jun 2024 14:56:58 +0200
Message-ID: <20240619125603.441042462@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

commit 4b4647add7d3c8530493f7247d11e257ee425bf0 upstream.

sk_psock_get will return NULL if the refcount of psock has gone to 0, which
will happen when the last call of sk_psock_put is done. However,
sk_psock_drop may not have finished yet, so the close callback will still
point to sock_map_close despite psock being NULL.

This can be reproduced with a thread deleting an element from the sock map,
while the second one creates a socket, adds it to the map and closes it.

That will trigger the WARN_ON_ONCE:

------------[ cut here ]------------
WARNING: CPU: 1 PID: 7220 at net/core/sock_map.c:1701 sock_map_close+0x2a2/0x2d0 net/core/sock_map.c:1701
Modules linked in:
CPU: 1 PID: 7220 Comm: syz-executor380 Not tainted 6.9.0-syzkaller-07726-g3c999d1ae3c7 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
RIP: 0010:sock_map_close+0x2a2/0x2d0 net/core/sock_map.c:1701
Code: df e8 92 29 88 f8 48 8b 1b 48 89 d8 48 c1 e8 03 42 80 3c 20 00 74 08 48 89 df e8 79 29 88 f8 4c 8b 23 eb 89 e8 4f 15 23 f8 90 <0f> 0b 90 48 83 c4 08 5b 41 5c 41 5d 41 5e 41 5f 5d e9 13 26 3d 02
RSP: 0018:ffffc9000441fda8 EFLAGS: 00010293
RAX: ffffffff89731ae1 RBX: ffffffff94b87540 RCX: ffff888029470000
RDX: 0000000000000000 RSI: ffffffff8bcab5c0 RDI: ffffffff8c1faba0
RBP: 0000000000000000 R08: ffffffff92f9b61f R09: 1ffffffff25f36c3
R10: dffffc0000000000 R11: fffffbfff25f36c4 R12: ffffffff89731840
R13: ffff88804b587000 R14: ffff88804b587000 R15: ffffffff89731870
FS:  000055555e080380(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000000207d4000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 unix_release+0x87/0xc0 net/unix/af_unix.c:1048
 __sock_release net/socket.c:659 [inline]
 sock_close+0xbe/0x240 net/socket.c:1421
 __fput+0x42b/0x8a0 fs/file_table.c:422
 __do_sys_close fs/open.c:1556 [inline]
 __se_sys_close fs/open.c:1541 [inline]
 __x64_sys_close+0x7f/0x110 fs/open.c:1541
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb37d618070
Code: 00 00 48 c7 c2 b8 ff ff ff f7 d8 64 89 02 b8 ff ff ff ff eb d4 e8 10 2c 00 00 80 3d 31 f0 07 00 00 74 17 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 48 c3 0f 1f 80 00 00 00 00 48 83 ec 18 89 7c
RSP: 002b:00007ffcd4a525d8 EFLAGS: 00000202 ORIG_RAX: 0000000000000003
RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 00007fb37d618070
RDX: 0000000000000010 RSI: 00000000200001c0 RDI: 0000000000000004
RBP: 0000000000000000 R08: 0000000100000000 R09: 0000000100000000
R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>

Use sk_psock, which will only check that the pointer is not been set to
NULL yet, which should only happen after the callbacks are restored. If,
then, a reference can still be gotten, we may call sk_psock_stop and cancel
psock->work.

As suggested by Paolo Abeni, reorder the condition so the control flow is
less convoluted.

After that change, the reproducer does not trigger the WARN_ON_ONCE
anymore.

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Reported-by: syzbot+07a2e4a1a57118ef7355@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=07a2e4a1a57118ef7355
Fixes: aadb2bb83ff7 ("sock_map: Fix a potential use-after-free in sock_map_close()")
Fixes: 5b4a79ba65a1 ("bpf, sockmap: Don't let sock_map_{close,destroy,unhash} call itself")
Cc: stable@vger.kernel.org
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/r/20240524144702.1178377-1-cascardo@igalia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/sock_map.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -1623,19 +1623,23 @@ void sock_map_close(struct sock *sk, lon
 
 	lock_sock(sk);
 	rcu_read_lock();
-	psock = sk_psock_get(sk);
-	if (unlikely(!psock)) {
-		rcu_read_unlock();
-		release_sock(sk);
-		saved_close = READ_ONCE(sk->sk_prot)->close;
-	} else {
+	psock = sk_psock(sk);
+	if (likely(psock)) {
 		saved_close = psock->saved_close;
 		sock_map_remove_links(sk, psock);
+		psock = sk_psock_get(sk);
+		if (unlikely(!psock))
+			goto no_psock;
 		rcu_read_unlock();
 		sk_psock_stop(psock);
 		release_sock(sk);
 		cancel_delayed_work_sync(&psock->work);
 		sk_psock_put(sk, psock);
+	} else {
+		saved_close = READ_ONCE(sk->sk_prot)->close;
+no_psock:
+		rcu_read_unlock();
+		release_sock(sk);
 	}
 
 	/* Make sure we do not recurse. This is a bug.


