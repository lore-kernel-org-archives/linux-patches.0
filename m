Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC8C3DEFE1;
	Mon,  4 May 2026 14:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904806; cv=none; b=ge9ltBuIp6jhy7LLcyWo+tJgE7YGfEb1XDWHXw3xAYxjxdf5jiiEh0zScpgOANHVKCgwRqIupkKbS0/f/kH/SXy+FfT7dmpHJngIA4rYpbfDwUN3S4yoaZFzBEsGDz6IqFCAlJEBNeQbSZNDjDVdOISkS9cJygDWUWIo8xD7BxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904806; c=relaxed/simple;
	bh=t2g3rwux+3MW+HQRaSpwxPXqGx5CL661AUmVlKWgnUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SqoAuvcLMkJ8FGVVNPGrtVJdAKa0EvLfe6hbOBq0lI9/ePnNkwpzpP/S4VDuzFNCSCOs5AxMrDEPhkJ3xqvSZBXd5zNjPjcDCbkOfymXbkUBUKKxp2iPuXic55OsZje0SBL3iwzjmD++Uae4ArZqMcw4QTkl5tD/0vtyoGsT9G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ebxlntjy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ebxlntjy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E0DC2BCB8;
	Mon,  4 May 2026 14:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904805;
	bh=t2g3rwux+3MW+HQRaSpwxPXqGx5CL661AUmVlKWgnUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ebxlntjyr9hhnkD3d/7KcAnAjYSrsDx5+QGaT7YVHt9iK5aHMvcPTdp5iOeszEjTG
	 EyhL6rpgQW/Yb4M0HIjHBWKyaM2ALcHsbI/Un/HxAFjWOEPgq1NlOc2skVI1QioopC
	 b6ar/RgzmRuOwTJV01gLiFrsYagnd0XF2D423hIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 182/215] wifi: mt76: mt792x: fix mt7925u USB WFSYS reset handling
Date: Mon,  4 May 2026 15:53:21 +0200
Message-ID: <20260504135136.862897520@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 56154fef47d104effa9f29ed3db4f805cbc0d640 ]

mt7925u uses different reset/status registers from mt7921u. Reusing the
mt7921u register set causes the WFSYS reset to fail.

Add a chip-specific descriptor in mt792xu_wfsys_reset() to select the
correct registers and fix mt7925u failing to initialize after a warm
reboot.

Fixes: d28e1a48952e ("wifi: mt76: mt792x: introduce mt792x-usb module")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Link: https://patch.msgid.link/20260311002825.15502-2-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt792x_regs.h |    4 ++++
 drivers/net/wireless/mediatek/mt76/mt792x_usb.c  |   13 ++++++++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/mediatek/mt76/mt792x_regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_regs.h
@@ -390,6 +390,10 @@
 #define MT_CBTOP_RGU_WF_SUBSYS_RST	MT_CBTOP_RGU(0x600)
 #define MT_CBTOP_RGU_WF_SUBSYS_RST_WF_WHOLE_PATH BIT(0)
 
+#define MT7925_CBTOP_RGU_WF_SUBSYS_RST	0x70028600
+#define MT7925_WFSYS_INIT_DONE_ADDR	0x184c1604
+#define MT7925_WFSYS_INIT_DONE		0x00001d1e
+
 #define MT_HW_BOUND			0x70010020
 #define MT_HW_CHIPID			0x70010200
 #define MT_HW_REV			0x70010204
--- a/drivers/net/wireless/mediatek/mt76/mt792x_usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_usb.c
@@ -224,6 +224,15 @@ static const struct mt792xu_wfsys_desc m
 	.need_status_sel = true,
 };
 
+static const struct mt792xu_wfsys_desc mt7925_wfsys_desc = {
+	.rst_reg = MT7925_CBTOP_RGU_WF_SUBSYS_RST,
+	.done_reg = MT7925_WFSYS_INIT_DONE_ADDR,
+	.done_mask = U32_MAX,
+	.done_val = MT7925_WFSYS_INIT_DONE,
+	.delay_ms = 20,
+	.need_status_sel = false,
+};
+
 int mt792xu_dma_init(struct mt792x_dev *dev, bool resume)
 {
 	int err;
@@ -254,7 +263,9 @@ EXPORT_SYMBOL_GPL(mt792xu_dma_init);
 
 int mt792xu_wfsys_reset(struct mt792x_dev *dev)
 {
-	const struct mt792xu_wfsys_desc *desc = &mt7921_wfsys_desc;
+	const struct mt792xu_wfsys_desc *desc = is_mt7925(&dev->mt76) ?
+						&mt7925_wfsys_desc :
+						&mt7921_wfsys_desc;
 	u32 val;
 	int i;
 


