Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047517;
	b=SI1tCmywzbqWGUj2GBQSFM0o+QDnUfaNf5LtZWbXMUim7f50rCSHj1iCaaVvqTKXyRPx
	 oqtrOP1theiWFFuYlMykoZ1teDww5+KYFIcGf5FkWrVbAkJKKxXLxt/5LH5am1c452DJ/
	 lLV5ey7W0iyXrAEaeZCJJgtGoJeVlTLqDr+wWvJYEgiBpioIpV6G3iB2UQR8iF9c910SC
	 bJkzo0dFBTVsSD3viuDHZ32Dx6CyTqfZcheQYo+q3MfcpPokUoT6L6hujktcTjGmNiI95
	 8mpWTJW9sv7Ch5381rLPSmgRUCAKKsNhQDNuWgCvGhPC45MlWXmIRbOZzC/JLdo0rRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047517;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A6lEUMNTobe1Skqhi6XesubyLfciey1YsZYfkH6r5rI=;
	b=WqdUt6DciQoW4CkH8nvwqjDYUc/Z83yINr7VudR1/7VkkbZ/Dl7ozgu1rvvtYYOm4gB3
	 ogDiv4g/z8MznWGIms1Dkt7GifOOTiy63yIc0YUMOaY6ZTsoEYRDbrReI7MBSz0ThY9uj
	 aBtYbjkjT4NLR9fLl+LCdwFsZHaOgjAMnxqH9NDf+qwRd4eo+YQzLMr+L6dfVxG19iZtt
	 1VKkP4MGixDjLjv+J2+vTR5lV2X/DAVsazgKS4DElp3X+tvEgyz9S5nSUT6//001CIKr4
	 +ksQgkWvfd2307yg622n2NIUG7pquSQ0pmLs3KxjDebeWTfLQec83ZJP1CGr8+Ywl8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uh3CqPIw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDA1606A32A;
	Thu, 19 Nov 2026 00:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uh3CqPIw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8F81F000C4;
	Thu, 19 Nov 2026 00:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047517;
	bh=A6lEUMNTobe1Skqhi6XesubyLfciey1YsZYfkH6r5rI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uh3CqPIwaWV6k6A7WK6gbL19d8mb6nd7jBqLts6BXTcKbKNURVo22/B6/dWd/yNr3
	 3TDCAt8zofRttX5bXAfzNhowF25YV3/sdqDG0KfiwyaM7fnSYa1neUXwX0KzvKF5tJ
	 gt88dmo3945+ex+YwnJh0cmmND1LLPe5gH+dr6gg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol@kernel.org>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1640/2857] can: dev: can_dropped_invalid_skb: drop CAN XL frames on non-CAN XL devices
Date: Wed, 18 Nov 2026 15:44:34 +0100
Message-ID: <20261118150300.385551286@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Mailhol <mailhol@kernel.org>

[ Upstream commit 0fce44e29fce4b07642491b098afb41bd571e4f2 ]

Sending a PF_PACKET bypasses the CAN framework logic and can directly
reach a CAN driver's xmit() function. The PF_PACKET framework only
checks that skb->len does not exceed the net_device MTU.

For a CAN device that is not CAN XL capable, anything above CANFD_MTU
(72 bytes) is therefore dropped before it reaches the driver. However,
CAN XL frames are variable length. can_is_canxl_skb() accepts lengths in
the range CANXL_HDR_SIZE + CANXL_MIN_DLEN up to CANXL_MTU, i.e. 13 to
2060 bytes.

As a result, an ETH_P_CANXL skb with a length between 13 and 72 bytes
can pass both the MTU and the can_dropped_invalid_skb() checks.

A driver that does not support CAN XL will interpret canxl_frame->flags
as a length because of the overlap with can_frame->len. And because
CANXL_XLF is set, the resulting length is between 128 and 255. For
drivers that do not check can_frame->len before copying can_frame->data,
as most drivers do, this results in a buffer overflow of up to 247
bytes.

Drop ETH_P_CANXL skbs if the device does not have the CAN_CAP_XL
capability. Keep can_is_canxl_skb() for the validation of CAN XL skbs.

Closes: https://sashiko.dev/#/patchset/20260731-master-v5-0-5b27029dee20@qq.com?part=1
Fixes: fb08cba12b52 ("can: canxl: update CAN infrastructure for CAN XL frames")
Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
Link: https://patch.msgid.link/20260731-drop_canxl_frames-v1-1-7387b70353b3@kernel.org
Cc: stable@kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
[ sashal: replaced the unavailable can_cap_enabled() capability check with can_is_canxl_dev_mtu(dev->mtu) ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/dev/skb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/dev/skb.c b/drivers/net/can/dev/skb.c
index 6fb1f9b2a9e20..4f5eec05db220 100644
--- a/drivers/net/can/dev/skb.c
+++ b/drivers/net/can/dev/skb.c
@@ -354,7 +354,8 @@ bool can_dropped_invalid_skb(struct net_device *dev, struct sk_buff *skb)
 		break;
 
 	case ETH_P_CANXL:
-		if (!can_is_canxl_skb(skb))
+		if (!can_is_canxl_dev_mtu(dev->mtu) ||
+		    !can_is_canxl_skb(skb))
 			goto inval_skb;
 		break;
 
-- 
2.53.0



