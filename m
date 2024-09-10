Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A15D19068E;
	Tue, 10 Sep 2024 10:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962618; cv=none; b=fY8LXAX8L4eygd5CJbuLbeU8wBMCZDgbvksnYl24qASG6crIvYpXVR5+kimlfTbT2dtdQmrkGK3JZHWIWOJAYOWOKVtzuYcY63+/iWN5DropTMQ4fL1RVidCfB9MSQcsdDZXP1j7J/KaRdbflKVIXqxyU5A0F1BJkbyuSPJeGtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962618; c=relaxed/simple;
	bh=JiYhoHmnbRtq5LhmEYI6EZZBIu8QirIwvVEPl91kBiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZyplHwKCip9STnxtW345DYKkuaLSfrQak3RGqPEYAcTSc8rYPTRunbGaaiTZhZhLyC0zMaq9EVYv9+jevvYN2ahhxH4dBpDoPJW/ZDuPDN6j752/0K6qYUP3qOZ56P23STk7GUGqm6zjeiOfUMQ7eyIPdbLQMkTM1pV7rzFhKZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AaOXorZp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AaOXorZp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF246C4CEC3;
	Tue, 10 Sep 2024 10:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962618;
	bh=JiYhoHmnbRtq5LhmEYI6EZZBIu8QirIwvVEPl91kBiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AaOXorZpc/EtMTn/UCpb+U/TcLKeGApQRl9rsfhrs6FkzasQjzgKD+/l6tAVf4r7A
	 8Y7IGihRgW466bGgKK/uwb7X2vjCWPnoCAFdYxlC/sthQX1QJoZcFbQIMONWrCqNjx
	 ZgarfnsgwLIkdCg2ow+FC7OTv1PcvbfGJ71wxMcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+58c03971700330ce14d8@syzkaller.appspotmail.com,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Cong Wang <cong.wang@bytedance.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 057/121] tcp_bpf: fix return value of tcp_bpf_sendmsg()
Date: Tue, 10 Sep 2024 11:32:12 +0200
Message-ID: <20240910092548.525935336@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Wang <cong.wang@bytedance.com>

[ Upstream commit fe1910f9337bd46a9343967b547ccab26b4b2c6e ]

When we cork messages in psock->cork, the last message triggers the
flushing will result in sending a sk_msg larger than the current
message size. In this case, in tcp_bpf_send_verdict(), 'copied' becomes
negative at least in the following case:

468         case __SK_DROP:
469         default:
470                 sk_msg_free_partial(sk, msg, tosend);
471                 sk_msg_apply_bytes(psock, tosend);
472                 *copied -= (tosend + delta); // <==== HERE
473                 return -EACCES;

Therefore, it could lead to the following BUG with a proper value of
'copied' (thanks to syzbot). We should not use negative 'copied' as a
return value here.

  ------------[ cut here ]------------
  kernel BUG at net/socket.c:733!
  Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
  Modules linked in:
  CPU: 0 UID: 0 PID: 3265 Comm: syz-executor510 Not tainted 6.11.0-rc3-syzkaller-00060-gd07b43284ab3 #0
  Hardware name: linux,dummy-virt (DT)
  pstate: 61400009 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
  pc : sock_sendmsg_nosec net/socket.c:733 [inline]
  pc : sock_sendmsg_nosec net/socket.c:728 [inline]
  pc : __sock_sendmsg+0x5c/0x60 net/socket.c:745
  lr : sock_sendmsg_nosec net/socket.c:730 [inline]
  lr : __sock_sendmsg+0x54/0x60 net/socket.c:745
  sp : ffff800088ea3b30
  x29: ffff800088ea3b30 x28: fbf00000062bc900 x27: 0000000000000000
  x26: ffff800088ea3bc0 x25: ffff800088ea3bc0 x24: 0000000000000000
  x23: f9f00000048dc000 x22: 0000000000000000 x21: ffff800088ea3d90
  x20: f9f00000048dc000 x19: ffff800088ea3d90 x18: 0000000000000001
  x17: 0000000000000000 x16: 0000000000000000 x15: 000000002002ffaf
  x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
  x11: 0000000000000000 x10: ffff8000815849c0 x9 : ffff8000815b49c0
  x8 : 0000000000000000 x7 : 000000000000003f x6 : 0000000000000000
  x5 : 00000000000007e0 x4 : fff07ffffd239000 x3 : fbf00000062bc900
  x2 : 0000000000000000 x1 : 0000000000000000 x0 : 00000000fffffdef
  Call trace:
   sock_sendmsg_nosec net/socket.c:733 [inline]
   __sock_sendmsg+0x5c/0x60 net/socket.c:745
   ____sys_sendmsg+0x274/0x2ac net/socket.c:2597
   ___sys_sendmsg+0xac/0x100 net/socket.c:2651
   __sys_sendmsg+0x84/0xe0 net/socket.c:2680
   __do_sys_sendmsg net/socket.c:2689 [inline]
   __se_sys_sendmsg net/socket.c:2687 [inline]
   __arm64_sys_sendmsg+0x24/0x30 net/socket.c:2687
   __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
   invoke_syscall+0x48/0x110 arch/arm64/kernel/syscall.c:49
   el0_svc_common.constprop.0+0x40/0xe0 arch/arm64/kernel/syscall.c:132
   do_el0_svc+0x1c/0x28 arch/arm64/kernel/syscall.c:151
   el0_svc+0x34/0xec arch/arm64/kernel/entry-common.c:712
   el0t_64_sync_handler+0x100/0x12c arch/arm64/kernel/entry-common.c:730
   el0t_64_sync+0x19c/0x1a0 arch/arm64/kernel/entry.S:598
  Code: f9404463 d63f0060 3108441f 54fffe81 (d4210000)
  ---[ end trace 0000000000000000 ]---

Fixes: 4f738adba30a ("bpf: create tcp_bpf_ulp allowing BPF to monitor socket TX/RX data")
Reported-by: syzbot+58c03971700330ce14d8@syzkaller.appspotmail.com
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://patch.msgid.link/20240821030744.320934-1-xiyou.wangcong@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_bpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 7adefee59cef..6736d0e6b1c6 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -506,7 +506,7 @@ static int tcp_bpf_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 		err = sk_stream_error(sk, msg->msg_flags, err);
 	release_sock(sk);
 	sk_psock_put(sk, psock);
-	return copied ? copied : err;
+	return copied > 0 ? copied : err;
 }
 
 static int tcp_bpf_sendpage(struct sock *sk, struct page *page, int offset,
-- 
2.43.0



