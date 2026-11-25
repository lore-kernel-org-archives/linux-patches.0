Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618347;
	b=gXF5bhqmzFiehcxy7s8CgW4aEu9Llu00/VeXZcS/3QQ/+//6mGIIxAh0gpIS5OBhHB1m
	 EHQRcr+PKGKXbfDHsta2KBkoFMyw912txlL/ggNdBLgOucdHEYGOzcrmt93zOFjRRL6Hp
	 VvpF6iNb9nNh8O3mOfheLZnzM6tF0aptF6flvFp/voXxFEPhgmrPSSRPl2La2Ugts0mYy
	 0S2stQ4otTS+VhIZptTvYurxsLgWp6dyExkh8PPxvAxCjaLZlJ7E3LKNoQ8O1eY3VxwlL
	 eH8AanCNv6tZgLJqZL1N2c3SWYmghKYNaswtZuKj3ls2U1NfRn/zvlJjE4gF5SGQd4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618347;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cKuiB13jBNXs2DkfFIwahlBML88U/ar98ymw0ObVork=;
	b=P0l3Gb3vIK0qfyrshnOjN2NNoPOAzSDNJ7/sO+npQz0rRgkik0JRif++tse3lkKRLpPf
	 Lmxv6uxSutegDMTowr7w9J268J+W6TjgEezUU9XToP6IRO4R4GekPKrL9hf8Yhbgo07/f
	 f7IB3/+0AwyT9V3BBtYI2xx1mXucBJ1/cl1E8hzQ9qpFnTo3pJKcgNCd7HkA4lDcQpa/Y
	 tN5aFEOd0xS3EPX4BsnWSlKGfcko25ONCvWAqBt/herhCFDPYPSgReoorBPFMJas4rQLx
	 368z/Sq0yBfdpNwDz1tHumyZE/GgAl6/dOZtjBEmUGs4zc1JZSjYLkdHZsW/1XcgaRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q7Ctp7ZN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3181D606A31E;
	Wed, 25 Nov 2026 14:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q7Ctp7ZN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26AB71F000F4;
	Wed, 25 Nov 2026 14:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618346;
	bh=cKuiB13jBNXs2DkfFIwahlBML88U/ar98ymw0ObVork=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q7Ctp7ZNpmwBwRlcU/8L2jMJ0srT7rPEBiQwSVGt7ctZX+rLH8UTVaZ6+aJl9+muM
	 S1vmhZNOdjhJ3dmlXN571V9BwwuoEtqZoU47e5CqnzaP8TtN8DrJs4W+ZxGK0tVo/T
	 wEpXwblZwXjurd6s/50Bxg4vNxDUYEFsHEJbd8nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cunhao Lu <1579567540@qq.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0250/1005] can: skb: make CAN skb allocation failure paths IRQ-safe
Date: Wed, 25 Nov 2026 15:26:28 +0100
Message-ID: <20261125143827.594457113@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Cunhao Lu <1579567540@qq.com>

[ Upstream commit d4b616a38118e81cfb206babd052db260d7abf6c ]

The CAN skb allocation helpers are used from hardware interrupt receive
handlers. If can_skb_ext_add() fails, they release the newly allocated skb
with kfree_skb(), which is not safe in hardware interrupt context.

Use dev_kfree_skb_any() for the allocation failure paths in
alloc_can_skb(), alloc_canfd_skb(), and alloc_canxl_skb().

Fixes: 96ea3a1e2d31 ("can: add CAN skb extension infrastructure")
Signed-off-by: Cunhao Lu <1579567540@qq.com>
Link: https://patch.msgid.link/tencent_C825C17D442F801351CE2FBC4984064B4605@qq.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/dev/skb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/dev/skb.c b/drivers/net/can/dev/skb.c
index 9e274147ffe56..738d5968dfa68 100644
--- a/drivers/net/can/dev/skb.c
+++ b/drivers/net/can/dev/skb.c
@@ -229,7 +229,7 @@ struct sk_buff *alloc_can_skb(struct net_device *dev, struct can_frame **cf)
 
 	csx = can_skb_ext_add(skb);
 	if (!csx) {
-		kfree_skb(skb);
+		dev_kfree_skb_any(skb);
 		goto out_error_cc;
 	}
 
@@ -260,7 +260,7 @@ struct sk_buff *alloc_canfd_skb(struct net_device *dev,
 
 	csx = can_skb_ext_add(skb);
 	if (!csx) {
-		kfree_skb(skb);
+		dev_kfree_skb_any(skb);
 		goto out_error_fd;
 	}
 
@@ -298,7 +298,7 @@ struct sk_buff *alloc_canxl_skb(struct net_device *dev,
 
 	csx = can_skb_ext_add(skb);
 	if (!csx) {
-		kfree_skb(skb);
+		dev_kfree_skb_any(skb);
 		goto out_error_xl;
 	}
 
-- 
2.53.0



