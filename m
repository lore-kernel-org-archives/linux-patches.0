Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0484C1E51FA;
	Mon, 23 Jun 2025 21:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713911; cv=none; b=R+cSibawPbb+eVXOvabFmQLNKtKW7oNFkr9rol94ov4cp7uOfyJaK5+vULNwz2SBeOI18phzW8zJFZ5n/JTvFxInMxvbi/MRkepiwFPT2rLSQtgNzAjobeIzmEjsqXJnAWoCbLtjj2sRLBB2ZLDBfDxo4NkLSt5NKrNS9YckagM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713911; c=relaxed/simple;
	bh=XKCeQiR/hwbcDB54xdEwjPF9kjJKTZbog/ZkUb0ZuL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T4NaeE23PIAoOjfZCKPM1gJzoUGygvwq3rWyRB8OL4o6RHZ03/RdTpwObzZXFczHJKicb16Y+hKFFYEix/JZqfuD6qSvYXU8m7jEuuvDjpz4Y9Tybi7M3iNFeNkJumuMBaolci10UXHuS9gCcl4cY6HLQurSR7OusZ74yjTv05Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RJPKa9Gk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RJPKa9Gk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB9EC4CEF0;
	Mon, 23 Jun 2025 21:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713910;
	bh=XKCeQiR/hwbcDB54xdEwjPF9kjJKTZbog/ZkUb0ZuL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RJPKa9GkJGwlyxLvx6eL3opYItbkM3Big8+FdaeMDIaHHsAb+sKAXjxZNB1J+6zcH
	 kJJU/GaERfCtca+Q9zGpcqseD75sZkaO4AVP1l2TCfufhICsamvgQra/Gf1fA6MFWl
	 PWU7L9KjgV1gjCZiRzz+CPqhxWFpE609fT6xl9AI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Xing <kernelxing@tencent.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 353/592] net: atlantic: generate software timestamp just before the doorbell
Date: Mon, 23 Jun 2025 15:05:11 +0200
Message-ID: <20250623130708.839548374@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index c1d1673c5749d..b565189e59139 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -123,7 +123,6 @@ static netdev_tx_t aq_ndev_start_xmit(struct sk_buff *skb, struct net_device *nd
 	}
 #endif
 
-	skb_tx_timestamp(skb);
 	return aq_nic_xmit(aq_nic, skb);
 }
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index bf3aa46887a1c..e71cd10e4e1f1 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -898,6 +898,8 @@ int aq_nic_xmit(struct aq_nic_s *self, struct sk_buff *skb)
 
 	frags = aq_nic_map_skb(self, skb, ring);
 
+	skb_tx_timestamp(skb);
+
 	if (likely(frags)) {
 		err = self->aq_hw_ops->hw_ring_tx_xmit(self->aq_hw,
 						       ring, frags);
-- 
2.39.5



