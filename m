Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3E516F84F;
	Wed,  2 Oct 2024 13:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875504; cv=none; b=mlh0sdGa6sHLFPeW+p/WKG82qJLKitDx6uuvRC3R3ehpvOtUCu+pDDdC7FM0nQWzh+SME8YwANZZwp7UZ04qlSGRQhlfMQZLekA4yEhNVazjAn3eM+zjBJpIoRVwbG2htrZOO8x0QWzRlv6HJCRedrbJFOp5gYvo5NO6dpMGhAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875504; c=relaxed/simple;
	bh=G/cv97kYDmTdWECc5DlRp8dlTokW/fTAv4aXNeKHIdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ihOIDNydyFzvDhx7bmlo76IgLrtdq4yqHiri57HrUXE0YMUme4PhGtP9/nBesg6n6SwcVWHfoXk0ygZ2BTWNODG2mC93HNSF/YYV8KWmJXWY2w928fIJxYK7kTkRrL9rtGtdz0HHBxEtC/UIFt00ic2JgZIigYY4UvHMgRXglDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y02G3WZd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y02G3WZd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D448C4CEC5;
	Wed,  2 Oct 2024 13:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875503;
	bh=G/cv97kYDmTdWECc5DlRp8dlTokW/fTAv4aXNeKHIdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y02G3WZdjasg4lh0P6P8c0Pfc1JpxV0yE7X5udl+VajVMVzfQobDQ+xuvkR4sRAti
	 BdbYsZrEIE8xCq+AUpr1o67U+w8s0eTDt2yzIUGpKWOpjPtpE9EhLj/i/8kB5a6F8F
	 ZC7m2pjOEZ1fuHCFJOXTeTJA6DdLwH6ovmyi3uTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 091/695] wifi: mt76: mt7996: fix uninitialized TLV data
Date: Wed,  2 Oct 2024 14:51:29 +0200
Message-ID: <20241002125826.111717165@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 9e461f4a2329109571f4b10f9bcad28d07e6ebb3 ]

Use skb_put_zero instead of skb_put

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Link: https://patch.msgid.link/20240827093011.18621-23-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index c4c60c60155d3..0484caf3ed833 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -735,7 +735,7 @@ void mt7996_mcu_rx_event(struct mt7996_dev *dev, struct sk_buff *skb)
 static struct tlv *
 mt7996_mcu_add_uni_tlv(struct sk_buff *skb, u16 tag, u16 len)
 {
-	struct tlv *ptlv = skb_put(skb, len);
+	struct tlv *ptlv = skb_put_zero(skb, len);
 
 	ptlv->tag = cpu_to_le16(tag);
 	ptlv->len = cpu_to_le16(len);
-- 
2.43.0



