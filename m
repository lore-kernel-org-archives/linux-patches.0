Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B60199FBA;
	Mon, 23 Jun 2025 22:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717328; cv=none; b=jKqSeHXCSGUPkv7aaHwOjfbmK3wSsEzQDjHcraUnLnXZH+A5gIXXjudFnj10zCBJOv3JyP5aSB5UAVSVh9C4LETUHPiMBoxO6+x/ttntoGzowekqrRuZdoyXZOrsdxoCr6E6d9P42HyQ97iM3ER1deP6ycVd7VHFGi0/vXlHHUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717328; c=relaxed/simple;
	bh=XFxtQG0lftDgI1elvpPEmOFuH/kRN+5srjxn0ZCxWps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bX4oTcY95FXWzSLQ+s6YNOY99QSPG0EI1Nqw6FDMVzUmV3FTyY/2ctdIlp9wOnS70v+i7C7E1a+JCj3J4XmcC1JDqNzoBf2FdUqSLt+S8SvubizshZyMjEmP2o09c/xI8a6NqLnRcnwMCZXaZYNV3LL8zgCEcxuDPEq78xeBvgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BO5uU22c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BO5uU22c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF59C4CEEA;
	Mon, 23 Jun 2025 22:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717328;
	bh=XFxtQG0lftDgI1elvpPEmOFuH/kRN+5srjxn0ZCxWps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BO5uU22cyO8gNPSfApByMmsJnRkSOq7OwZNgK/dRcp+5j7bHcoeZ4/6/UInQP3WtT
	 0sPhN2mDGE/MyYvqyVisUl3l6L1PSxu0lVA6iDR8SFaSHr2lQzcXdSDjlDVylbckmQ
	 7q4JpZvdHj/fGFMJfPCVHnx3XKOhbp96s3rBRiII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Xing <kernelxing@tencent.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 405/508] net: atlantic: generate software timestamp just before the doorbell
Date: Mon, 23 Jun 2025 15:07:30 +0200
Message-ID: <20250623130655.201286619@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit 285ad7477559b6b5ceed10ba7ecfed9d17c0e7c6 ]

Make sure the call of skb_tx_timestamp is as close as possible to the
doorbell.

Signed-off-by: Jason Xing <kernelxing@tencent.com>
Link: https://patch.msgid.link/20250510134812.48199-2-kerneljasonxing@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_main.c | 1 -
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c  | 2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
index 77609dc0a08d6..9d877f436e335 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -122,7 +122,6 @@ static netdev_tx_t aq_ndev_start_xmit(struct sk_buff *skb, struct net_device *nd
 	}
 #endif
 
-	skb_tx_timestamp(skb);
 	return aq_nic_xmit(aq_nic, skb);
 }
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index a467c8f91020b..3bfd9027cccac 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -893,6 +893,8 @@ int aq_nic_xmit(struct aq_nic_s *self, struct sk_buff *skb)
 
 	frags = aq_nic_map_skb(self, skb, ring);
 
+	skb_tx_timestamp(skb);
+
 	if (likely(frags)) {
 		err = self->aq_hw_ops->hw_ring_tx_xmit(self->aq_hw,
 						       ring, frags);
-- 
2.39.5



