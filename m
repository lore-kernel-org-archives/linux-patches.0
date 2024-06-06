Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D691BE24C;
	Thu,  6 Jun 2024 14:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683533; cv=none; b=moNvBP0sE1zhtIiqR5DaIdLGd+g+dSOvnDR4DoOQtC3MzdCAS+iX7Qm/FDDmGDPWbm7UkyMHwgHpAJGsSf1PNboagOnEC+IlkIlkSWNA6KSzNymceUBU7x3irIVPI0DY50MJIbdgLwXTGt5CABvo9mRbnccMDajqZvThRp8y7Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683533; c=relaxed/simple;
	bh=bM4wWM0jyErvR4Kwcs5E1enjsWVAzqF7bQbHHlutHFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VvSgbUUT77aL8BOFAdwqKs9DoZvzzSe/PT/13NMLVwq5GGMoP3Xb8tZ8xl/n7AePTgOo32BG25KJcjHi9bUqEhxcv5wIe4sWgyGITODlBENJXtx1nPBT7SE3F72fbCxyaHdjLraoChT40JmaP0IDe3kxoOQHNAz+ne9tgmhGtYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vekCo3+C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vekCo3+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92912C2BD10;
	Thu,  6 Jun 2024 14:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683533;
	bh=bM4wWM0jyErvR4Kwcs5E1enjsWVAzqF7bQbHHlutHFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vekCo3+CuusJvHB+sNV8P1nzvsJUvZBJHdm+K1b81P9rbsxsBCWQzkASxF7P0YHNL
	 p0oULrQyJ4OU3VO4a8a6uKD99GhSRuPzEieTioqAWPgbPb9ZxZXXE3uJsOEjW3ReQY
	 ejjA6cuqYMR5W/vhXAndRaU4OGHmnMtC2ERYdfiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Xing <kernelxing@tencent.com>,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 424/473] tcp: remove 64 KByte limit for initial tp->rcv_wnd value
Date: Thu,  6 Jun 2024 16:05:53 +0200
Message-ID: <20240606131713.776768718@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

From: Jason Xing <kernelxing@tencent.com>

[ Upstream commit 378979e94e953c2070acb4f0e0c98d29260bd09d ]

Recently, we had some servers upgraded to the latest kernel and noticed
the indicator from the user side showed worse results than before. It is
caused by the limitation of tp->rcv_wnd.

In 2018 commit a337531b942b ("tcp: up initial rmem to 128KB and SYN rwin
to around 64KB") limited the initial value of tp->rcv_wnd to 65535, most
CDN teams would not benefit from this change because they cannot have a
large window to receive a big packet, which will be slowed down especially
in long RTT. Small rcv_wnd means slow transfer speed, to some extent. It's
the side effect for the latency/time-sensitive users.

To avoid future confusion, current change doesn't affect the initial
receive window on the wire in a SYN or SYN+ACK packet which are set within
65535 bytes according to RFC 7323 also due to the limit in
__tcp_transmit_skb():

    th->window      = htons(min(tp->rcv_wnd, 65535U));

In one word, __tcp_transmit_skb() already ensures that constraint is
respected, no matter how large tp->rcv_wnd is. The change doesn't violate
RFC.

Let me provide one example if with or without the patch:
Before:
client   --- SYN: rwindow=65535 ---> server
client   <--- SYN+ACK: rwindow=65535 ----  server
client   --- ACK: rwindow=65536 ---> server
Note: for the last ACK, the calculation is 512 << 7.

After:
client   --- SYN: rwindow=65535 ---> server
client   <--- SYN+ACK: rwindow=65535 ----  server
client   --- ACK: rwindow=175232 ---> server
Note: I use the following command to make it work:
ip route change default via [ip] dev eth0 metric 100 initrwnd 120
For the last ACK, the calculation is 1369 << 7.

When we apply such a patch, having a large rcv_wnd if the user tweak this
knob can help transfer data more rapidly and save some rtts.

Fixes: a337531b942b ("tcp: up initial rmem to 128KB and SYN rwin to around 64KB")
Signed-off-by: Jason Xing <kernelxing@tencent.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Link: https://lore.kernel.org/r/20240521134220.12510-1-kerneljasonxing@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 15f814c1e1693..05bd4b73287d7 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -229,7 +229,7 @@ void tcp_select_initial_window(const struct sock *sk, int __space, __u32 mss,
 	if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_workaround_signed_windows))
 		(*rcv_wnd) = min(space, MAX_TCP_WINDOW);
 	else
-		(*rcv_wnd) = min_t(u32, space, U16_MAX);
+		(*rcv_wnd) = space;
 
 	if (init_rcv_wnd)
 		*rcv_wnd = min(*rcv_wnd, init_rcv_wnd * mss);
-- 
2.43.0



