Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1800226FA60;
	Wed, 25 Feb 2026 01:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771984038; cv=none; b=lFvIR+SP3rpio46qWEJAnTz8onIpXERUTIMM35/VfUHvusRgZVbbStvdTWW9OGEsAhas1QIYRFgafBhmmMfWTdkWnc7g/2JCdZpcvvFmg/vM+lHh1tRwtKc4XB/TXpgzXmgXpEEGKbAo0LOpipLufF3hlXm3rgGKUkvCOWy+hsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771984038; c=relaxed/simple;
	bh=paEhbyEoSzARe4Xm717NCxdO1t2+GY/oiVwQp0THhIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JDVr+J9m8iVmQkRMehSkh9HZEUqNehArrTWNIyYgMYu+kujxcTDX35KW9/rOQruusoD3vlb7F4FLarZXz1Zl6lIrf+56WktNXwTLOx+rOmokO0AroqTpMSOs7fu0LWQcxXwWvAmsax6YY73Rpgx4TqpHQp2RZAQZeI90EQAcFQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vf2U4al0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vf2U4al0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB65C116D0;
	Wed, 25 Feb 2026 01:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771984038;
	bh=paEhbyEoSzARe4Xm717NCxdO1t2+GY/oiVwQp0THhIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vf2U4al0QUOvabnvJyBFOSvdDJXPPQSnmIBSsSl1RYckpBt+df/KSbOIXF0QI78Ys
	 RV0JPGs/k4ncD0JLmzYEmrnAmx9761f7nKyHWWORk7qX5mVkE7xCft4m7QXlBmlE92
	 /rIm7L4vX5iFi7TlAMqTuqtxFY684ZBiu83e3x/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 281/641] tcp: tcp_tx_timestamp() must look at the rtx queue
Date: Tue, 24 Feb 2026 17:20:07 -0800
Message-ID: <20260225012355.584611567@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 74079eab89804..e35825656e6ea 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -503,6 +503,9 @@ static void tcp_tx_timestamp(struct sock *sk, struct sockcm_cookie *sockc)
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



