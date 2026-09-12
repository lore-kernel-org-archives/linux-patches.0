Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5933428498;
	Sat, 12 Sep 2026 10:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209316; cv=none; b=aJ4TiTk+GJoStVHHnRsV5bbJKXzJc2qpOvN560uv+izTiDbTVCPpQpyT6IalkhgX8Bl4v+7dttbKtgUodA9GK8tIbd6qrPhf92BHiD49dKeytHoCwxpLLJIqyGDXLIf7YKPCD1roN767j5mOjion24VI4FVpD8np5CVjUZ6f6Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209316; c=relaxed/simple;
	bh=aadZuwOx9+ZJvxbR+2GQfXEWd7oSSV4ZgwK8BN5yDzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LSGfYAld66oj+pHnwDVhZVA+8MdX4DgHIdyzSALD4TKR8Dvbw3EgyDhJGWh4Az3qqPfRbGgXiMpDznnwdDjyCGyrWgU1nrdyZMIEjgsc3mpdaQNo+LnFv6dK0xqMT/uk6fA6Tswpc1fgxu1KZedCcviSNEgOmajKEd3JFk3PMq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QZCl7Ivs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZCl7Ivs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 861431F000FF;
	Sat, 12 Sep 2026 10:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209315;
	bh=80nAunMBHkqxe/SK+/DnXMjAx8kq4eToXqlW0j8E3K0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QZCl7IvsYe5luQeELssCOd8bDgl/wDKM4r81Mupog/IT04yxqWtO8NDCmHkZcqDlD
	 AKIQtSAsX3FkF4vYHkodz0NAKi9fTBsPRTqZwdyB1FtS9kS9ub8+gnVKRcccd7xkGi
	 fadvMerzbGYBkkYx/vjTJUibEMnC6aaCoVU9a9AM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0797/1518] wifi: mt76: mt7996: do not attach hif2 WED when the main WED attach failed
Date: Sat, 12 Sep 2026 08:49:26 +0200
Message-ID: <20260912065641.462315717@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 7c1924332e986019c6bcddf55c843361cccac73f ]

If the WED attach for the primary PCIe function fails, the probe path
still attached wed_hif2 for the secondary function, leaving the device
in an inconsistent half-WED configuration that crashes later. The hif2
call also re-enabled hwrro_mode, which the failed primary attach had
just turned off.

Skip the hif2 WED setup when the primary WED device is not active.

Fixes: 83eafc9251d6 ("wifi: mt76: mt7996: add wed tx support")
Link: https://patch.msgid.link/20260727150434.1778520-6-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mmio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c b/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
index 4f63dcb19b259..e37b95f5b00b8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
@@ -490,6 +490,9 @@ int mt7996_mmio_wed_init(struct mt7996_dev *dev, void *pdev_ptr,
 	if (!wed_enable)
 		return 0;
 
+	if (hif2 && !mtk_wed_device_active(&dev->mt76.mmio.wed))
+		return 0;
+
 	dev->mt76.hwrro_mode = is_mt7996(&dev->mt76) ? MT76_HWRRO_V3
 						     : MT76_HWRRO_V3_1;
 
-- 
2.53.0



