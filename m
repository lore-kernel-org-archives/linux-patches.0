Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1361519BE;
	Wed,  5 Feb 2025 14:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765212; cv=none; b=bsNXQBTfwZWA9VHTTXQRTeq7W7sTb/QAxaRoBfFF7LgVVrfu51mjb4OFALf3C/25oHig8lf8O4ryimoPQDfpuomK8unmYJOlvcnJEVMRspRWUnxJ50/OBJGkMuLFEFjDDG/4CII6mu0NtkwYqVur/XaUehw4mNuXriAesZhGuIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765212; c=relaxed/simple;
	bh=Dx//Tlu1acGzaPufw5nBa+jGFwNq4/Oi+AK5pwz8N3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WN/wiH/ZpwNRrEdVmpGHkgRjs0epEZyKXv/7rYrQlzwKkm+EMkvHDZsB+cl+JI2UI1sw1yc7TQtvsNt2FDZHgJlqAA3lNJu/roZTdPVFy1c+oaavpjP4tU4xnTpAan7c7+XzRSra4DNDoaRgyi+KxoPuFwfQz7q+ws3hzBFguaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BMZh74q5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BMZh74q5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F687C4CED1;
	Wed,  5 Feb 2025 14:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765212;
	bh=Dx//Tlu1acGzaPufw5nBa+jGFwNq4/Oi+AK5pwz8N3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BMZh74q5eQuUtsN+0rqK+MT1Wjs7qyZ8tC+SCEcoUfmJYHqrGM6zGEq++DAPHxxxe
	 vlGoH1F84+pkh36IZQNddnb67k74vSAuIaLnvhpfaEPyqD5SK6pxWEAEj/jK78zuCS
	 QrMQWQp2jVYmlIQrK4xzjEB0Ua2geDPbl4897yOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 200/590] wifi: mt76: mt7915: fix omac index assignment after hardware reset
Date: Wed,  5 Feb 2025 14:39:15 +0100
Message-ID: <20250205134502.932008925@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit cd043bbba6f9b71ebe0781d1bd2107565363c4b9 ]

Reset per-phy mac address slot mask in order to avoid leaking entries.

Fixes: 8a55712d124f ("wifi: mt76: mt7915: enable full system reset support")
Link: https://patch.msgid.link/20241230194202.95065-12-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index b890a58d37300..799e8d2cc7e6e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -1444,9 +1444,11 @@ static void
 mt7915_mac_full_reset(struct mt7915_dev *dev)
 {
 	struct mt76_phy *ext_phy;
+	struct mt7915_phy *phy2;
 	int i;
 
 	ext_phy = dev->mt76.phys[MT_BAND1];
+	phy2 = ext_phy ? ext_phy->priv : NULL;
 
 	dev->recovery.hw_full_reset = true;
 
@@ -1476,6 +1478,9 @@ mt7915_mac_full_reset(struct mt7915_dev *dev)
 
 	memset(dev->mt76.wcid_mask, 0, sizeof(dev->mt76.wcid_mask));
 	dev->mt76.vif_mask = 0;
+	dev->phy.omac_mask = 0;
+	if (phy2)
+		phy2->omac_mask = 0;
 
 	i = mt76_wcid_alloc(dev->mt76.wcid_mask, MT7915_WTBL_STA);
 	dev->mt76.global_wcid.idx = i;
-- 
2.39.5



