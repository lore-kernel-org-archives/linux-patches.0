Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313E418B0A;
	Wed, 25 Feb 2026 01:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983227; cv=none; b=US6794S4LlcI1AHTLlefxjH/gifqOYUR2QfsMzDGmmYSkxACsjicKYfSV5XyiBqw1f3yD/yf3kU9XYqNjO6oxhPk3W6HfNfOrwYLLJADYMwmIHbGWaXVXgHqkxClKS9WkZxY5Clmk1HIdroQ9MjhEUV6iiIWCaQ1Uoo7NzuyM6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983227; c=relaxed/simple;
	bh=PwKtIreEysPNatSvuoUgJXa9W0A1BwNZHMwpAsWTogM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwI4+70udq+JJy2C/J4ZtbdJ4bs+ap1Id8Q5gGxrvPulE/TuN4+p0wRQbQ8Ep2HRHb8oG1jad7LmYNh7drhlMC6tqzVm30xGgW3APD7ZGNtqASd6VjCUoFlbzDVxIU52ced90wUmw5Q0IMgXY4JTwRw1xqme2PGhnUqcOVE+bcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MjKKTkI8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MjKKTkI8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A05C116D0;
	Wed, 25 Feb 2026 01:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983227;
	bh=PwKtIreEysPNatSvuoUgJXa9W0A1BwNZHMwpAsWTogM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MjKKTkI8GWVCRgwV+xN7+Qx+WCZjAyG6crixQ0tAZDXqZeoXLFHDMsAT9ukkLbGfk
	 flrWywnTXAXOjO82Irqg9fiDO6DNkjtR4mR3gRM6XxSdGFSHHo5r54tYcNGFNm7d3d
	 P29435x2+X9TcXQxGFed61F4XU7u4xXtt1VuybpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 371/781] tcp: tcp_tx_timestamp() must look at the rtx queue
Date: Tue, 24 Feb 2026 17:18:00 -0800
Message-ID: <20260225012408.788367736@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 838eb9687691d29915797a885b861fd09353386e ]

tcp_tx_timestamp() is only called at the end of tcp_sendmsg_locked()
before the final tcp_push().

By the time it is called, it is possible all the copied data
has been sent already (transmit queue is empty).

If this is the case, use the last skb in the rtx queue.

Fixes: 75c119afe14f ("tcp: implement rb-tree based retransmit queue")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Link: https://patch.msgid.link/20260127123828.4098577-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index d5319ebe24525..81666571ecfb5 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -501,6 +501,9 @@ static void tcp_tx_timestamp(struct sock *sk, struct sockcm_cookie *sockc)
 	struct sk_buff *skb = tcp_write_queue_tail(sk);
 	u32 tsflags = sockc->tsflags;
 
+	if (unlikely(!skb))
+		skb = skb_rb_last(&sk->tcp_rtx_queue);
+
 	if (tsflags && skb) {
 		struct skb_shared_info *shinfo = skb_shinfo(skb);
 		struct tcp_skb_cb *tcb = TCP_SKB_CB(skb);
-- 
2.51.0



