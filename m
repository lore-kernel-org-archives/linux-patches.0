Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8241E497;
	Thu, 23 May 2024 13:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470303; cv=none; b=qMMmQY9o3dtYKZXShUoUFXzG9y+wNDHguoAO42AMoWclI557GaROl3TFl4+r3qfEjE3VPsRySkj63eBAORLbYKkFnGCxv8OJeLZMBHK3Mr74Q6cAsBtpH93vRIhqCQl7KvdP24g3b2R/ES5Vk+nS2E2tGC9cR2etzKaIlLFgHhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470303; c=relaxed/simple;
	bh=z0AOapHuaWe1GggyBxwjP1nJe5/dMvNQGb8EQhL4IcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LjiGKtqyb8mLftnGCh3310folyiYtCujxEQppBo6b9P3heUNkqLbz++Xa8bj+pY5CTEEnkoUPdDGgu8fPfQjhQpHPcu4CHTtn6K5FA+ncBGdWRbZmx3L78jjRLfXz5Akq07ZU1GTaZNp7UQecPxS+0FSm9o9MPI+uRIr19aNw+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RKa1Yi+D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RKa1Yi+D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE8E2C2BD10;
	Thu, 23 May 2024 13:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470303;
	bh=z0AOapHuaWe1GggyBxwjP1nJe5/dMvNQGb8EQhL4IcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RKa1Yi+D9x4HPm/HLJ/Fi5XYIsZsEjr3PQed2flEFxNaOcVVao4LiqBaULC23+ouE
	 8lkJlDGFTd9fzHANHu1Ht6g6sTIoywklCfrWokxzBbszYhCVCwMga1A1txzyu3H6Gv
	 zve1GbQRwFW0Pk9/ZW9qZ6yeksvzTOtURngX1my4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	syzbot <syzkaller@googlegroups.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	"yenchia.chen" <yenchia.chen@mediatek.com>
Subject: [PATCH 5.15 14/23] netlink: annotate data-races around sk->sk_err
Date: Thu, 23 May 2024 15:13:10 +0200
Message-ID: <20240523130328.493219114@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130327.956341021@linuxfoundation.org>
References: <20240523130327.956341021@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

commit d0f95894fda7d4f895b29c1097f92d7fee278cb2 upstream.

syzbot caught another data-race in netlink when
setting sk->sk_err.

Annotate all of them for good measure.

BUG: KCSAN: data-race in netlink_recvmsg / netlink_recvmsg

write to 0xffff8881613bb220 of 4 bytes by task 28147 on cpu 0:
netlink_recvmsg+0x448/0x780 net/netlink/af_netlink.c:1994
sock_recvmsg_nosec net/socket.c:1027 [inline]
sock_recvmsg net/socket.c:1049 [inline]
__sys_recvfrom+0x1f4/0x2e0 net/socket.c:2229
__do_sys_recvfrom net/socket.c:2247 [inline]
__se_sys_recvfrom net/socket.c:2243 [inline]
__x64_sys_recvfrom+0x78/0x90 net/socket.c:2243
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

write to 0xffff8881613bb220 of 4 bytes by task 28146 on cpu 1:
netlink_recvmsg+0x448/0x780 net/netlink/af_netlink.c:1994
sock_recvmsg_nosec net/socket.c:1027 [inline]
sock_recvmsg net/socket.c:1049 [inline]
__sys_recvfrom+0x1f4/0x2e0 net/socket.c:2229
__do_sys_recvfrom net/socket.c:2247 [inline]
__se_sys_recvfrom net/socket.c:2243 [inline]
__x64_sys_recvfrom+0x78/0x90 net/socket.c:2243
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

value changed: 0x00000000 -> 0x00000016

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 28146 Comm: syz-executor.0 Not tainted 6.6.0-rc3-syzkaller-00055-g9ed22ae6be81 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/06/2023

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20231003183455.3410550-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: yenchia.chen <yenchia.chen@mediatek.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netlink/af_netlink.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -352,7 +352,7 @@ static void netlink_overrun(struct sock
 	if (!(nlk->flags & NETLINK_F_RECV_NO_ENOBUFS)) {
 		if (!test_and_set_bit(NETLINK_S_CONGESTED,
 				      &nlk_sk(sk)->state)) {
-			sk->sk_err = ENOBUFS;
+			WRITE_ONCE(sk->sk_err, ENOBUFS);
 			sk_error_report(sk);
 		}
 	}
@@ -1591,7 +1591,7 @@ static int do_one_set_err(struct sock *s
 		goto out;
 	}
 
-	sk->sk_err = p->code;
+	WRITE_ONCE(sk->sk_err, p->code);
 	sk_error_report(sk);
 out:
 	return ret;
@@ -2006,7 +2006,7 @@ static int netlink_recvmsg(struct socket
 	    atomic_read(&sk->sk_rmem_alloc) <= sk->sk_rcvbuf / 2) {
 		ret = netlink_dump(sk);
 		if (ret) {
-			sk->sk_err = -ret;
+			WRITE_ONCE(sk->sk_err, -ret);
 			sk_error_report(sk);
 		}
 	}
@@ -2442,7 +2442,7 @@ void netlink_ack(struct sk_buff *in_skb,
 
 	skb = nlmsg_new(payload + tlvlen, GFP_KERNEL);
 	if (!skb) {
-		NETLINK_CB(in_skb).sk->sk_err = ENOBUFS;
+		WRITE_ONCE(NETLINK_CB(in_skb).sk->sk_err, ENOBUFS);
 		sk_error_report(NETLINK_CB(in_skb).sk);
 		return;
 	}


