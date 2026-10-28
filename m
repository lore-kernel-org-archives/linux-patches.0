Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207835;
	b=gb61wXhE1LxmbWaOOGeYpQhzM1XJuuwOxpvOAi727TF0GDCLjqH9qveRViopxfnrUEyW
	 fFH65IzlVNUpK4yUPXubZt15TNC8I77fFUuHZsDVR3+ktu/78RSLlI94w6LQ8DTWeMP2F
	 /083oZMbVPZ5rDxnTp2JGP6NLLUV/q7ve0tpqPgcTR6fpDDZy9OKQQ1DlCNH+7yCNG4wB
	 ibCFSvVvpv8t9GFD4HDqnlUP2Vv03JSAvtk6e3k/1pxnnByQfwGYbroRsLNk9rWlvWk+v
	 Wz/kmSvTHUmRLgQI5p6rC3JrCtdZnnBzTXc2BRr1pt3b0lIVfPHfSe0TV/Hxg2JTTwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207835;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9T0mqqTw1uhCIIl1u8kIUxvpuRl8B8rCRs99Kgv3Z6M=;
	b=bAqESairrI9lYCJ+UHve5Iia87NhWog9lNOSS/co5wtKazN0PMWRR+F5YaDgu4wY3x24
	 x3sHTkPZ2l/VrlXUqXpmb9TCIJF9VgHpfBKVXEcF8sw1B16s3Mrkanbe+nu7D9dPTljUi
	 KFgp/grDo4K+5PSBm2eUKL8ohvZpW+KjeROENm86f/chAEracKNn0/+kOhSlG+iWH3UaY
	 1Qa03zrMPRiKnQOqSUn31d92VMupf40UujARmMhWnlFwowZQqyYetDm5XIQb6Z0ugXCoJ
	 CYb8dRpcsdcYTrYP7GYHllrCCSQ+oN3mlahClcY0qj1WjzWxy2/PwcJrh6nexKnZ3Lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0QEIf7pU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AFA1606A32F;
	Wed, 28 Oct 2026 17:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0QEIf7pU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE481F01828;
	Wed, 28 Oct 2026 17:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207835;
	bh=9T0mqqTw1uhCIIl1u8kIUxvpuRl8B8rCRs99Kgv3Z6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0QEIf7pUVQ4NnpVvp4ShWKRWnCMj/L0GNhXURTCeXrErDKjYNnP2nqtTfhFPZFh79
	 QBjwZZcyZD6rwsBXyNQctLGWotSU12FgR4Y+Nkh0a0nM5PrF3k+BEdffh5gsWG+td8
	 Ki3imJpceRkcV33uUIH7bS8SUc/D2ZnPDxb5VbmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 156/247] rose: clear stale N(R)/N(S) before (re)transmitting a data frame
Date: Wed, 28 Oct 2026 17:59:19 +0100
Message-ID: <20261028165951.107252505@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

rose_kick() transmits a skb_clone() of each data frame and keeps the
original on ack_queue. The clone shares its data buffer with the
original, so the sequence numbers that rose_send_iframe() ORs into
byte 2 of the header are also left in the queued original.

After a RESET, rose_requeue_frames() puts those originals back on the
write queue and rose_kick() sends them again with vs/vr restarted at
zero. rose_send_iframe() only ORs the new values into byte 2, so the
retransmitted frame carries the bitwise OR of the old and new N(R) and
N(S). The peer rejects the invalid N(R) with a new RESET REQUEST, the
frames are requeued again, and the two nodes reset each other forever.

This was observed on a live FPAC network: a White Pages circuit between
two nodes looping on RESET REQUEST / RESET CONFIRMATION / DATA at about
2000 frames per second, with DATA frames resent as "R3 S7" right after
a reset instead of "R0 S0", until the application was restarted.

Clear everything but the M bit before setting the sequence numbers, as
x25_send_iframe() does for modulo 8 circuits.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
(cherry picked from commit b16b091aeb78faac22cf2b850246826d23f4a335)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/rose_out.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/rose/rose_out.c b/net/rose/rose_out.c
index 9050e33c96042..6672fc65a7651 100644
--- a/net/rose/rose_out.c
+++ b/net/rose/rose_out.c
@@ -34,6 +34,7 @@ static void rose_send_iframe(struct sock *sk, struct sk_buff *skb)
 	if (skb == NULL)
 		return;
 
+	skb->data[2] &= ROSE_M_BIT;
 	skb->data[2] |= (rose->vr << 5) & 0xE0;
 	skb->data[2] |= (rose->vs << 1) & 0x0E;
 
-- 
2.53.0



