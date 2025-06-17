Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E6C2DFF08;
	Tue, 17 Jun 2025 15:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175920; cv=none; b=Lgncpul+QoPsFvRajGo67iYzwGFPTc4WVxCqhsrUltkbnzwVRMIcUjZtt91ZmyjBdXQUwGTbj657N3525Wcy7tPq0JMqOkfJ0KwtXdv4DXlPWSva3JrbrvxVxSvvuxCYdd0eeo2s9eeD1IdhHzpr3IwpyUTxat4oVBAyqV7LF9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175920; c=relaxed/simple;
	bh=eWNmAgSUz7oANR4QaRrXG/qqaREh2vwY9qkPQ0RjsS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RaIEtfvEbWBggCT5KCzEwslkAfsE1rTqaMKzcCb5IH5U2lFMNOrzFMUIx4D/PYP7RJmFVHnu7pIxm3uAWcacLoulLsVcHwqXMlop79XB9Y0SIlo4+ZnOZpm6FA0OeiAkl3X1tiQ5QFX6a5o6KsN3qpqhYYDuI+/qM9MMRmX02NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KauITTA0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KauITTA0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C2DC4CEE3;
	Tue, 17 Jun 2025 15:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175920;
	bh=eWNmAgSUz7oANR4QaRrXG/qqaREh2vwY9qkPQ0RjsS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KauITTA0TldYRkb4w2hMjebtxDpxM87CjNwfSaklqS+ZF134ydDx1pifJ1qP8Ew0c
	 FSE4ZXxB6SdoTDIc/DtF9xB48RXKCeVPJFRAVAiU9Uro72T2o3GUFXXWJ/gpJCumgu
	 ugrHZqq2iAHM9rz4AKXjyrldEXvRm8klLbrlxCME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Maria Casanova Crespo <jmcasanova@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 117/780] drm/v3d: fix client obtained from axi_ids on V3D 4.1
Date: Tue, 17 Jun 2025 17:17:05 +0200
Message-ID: <20250617152456.266546205@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jose Maria Casanova Crespo <jmcasanova@igalia.com>

[ Upstream commit d0e4c6537005dd106b101d4434a0c3dafd936d05 ]

In the case of MMU errors caused by the TFU unit, the
client that causes the MMU error is expected to be reported.
But in the case of MMU TFU errors, a non existing client was
being reported. This happened because the client calculation
was taking into account more than the bits 0-7 from the
axi_id that were representing the client.

[   27.845132] v3d fec00000.v3d: MMU error from client ? (13) at 0x3bb1000, pte invalid

Masking the bits and using the correct axi_id ranges fixes the
calculation to report the real guilty client on V3D 4.1 and 4.2.

Make the MMU error print axi_id with hexadecimal as used in the
ranges.

Fixes: 38c2c7917adc ("drm/v3d: Fix and extend MMU error handling.")
Signed-off-by: Jose Maria Casanova Crespo <jmcasanova@igalia.com>
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Link: https://lore.kernel.org/r/20250425122522.18425-1-jmcasanova@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/v3d/v3d_irq.c | 37 +++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/v3d/v3d_irq.c b/drivers/gpu/drm/v3d/v3d_irq.c
index 29f63f572d35b..d6ce1324905df 100644
--- a/drivers/gpu/drm/v3d/v3d_irq.c
+++ b/drivers/gpu/drm/v3d/v3d_irq.c
@@ -186,27 +186,38 @@ v3d_hub_irq(int irq, void *arg)
 		u32 axi_id = V3D_READ(V3D_MMU_VIO_ID);
 		u64 vio_addr = ((u64)V3D_READ(V3D_MMU_VIO_ADDR) <<
 				(v3d->va_width - 32));
-		static const char *const v3d41_axi_ids[] = {
-			"L2T",
-			"PTB",
-			"PSE",
-			"TLB",
-			"CLE",
-			"TFU",
-			"MMU",
-			"GMP",
+		static const struct {
+			u32 begin;
+			u32 end;
+			const char *client;
+		} v3d41_axi_ids[] = {
+			{0x00, 0x20, "L2T"},
+			{0x20, 0x21, "PTB"},
+			{0x40, 0x41, "PSE"},
+			{0x60, 0x80, "TLB"},
+			{0x80, 0x88, "CLE"},
+			{0xA0, 0xA1, "TFU"},
+			{0xC0, 0xE0, "MMU"},
+			{0xE0, 0xE1, "GMP"},
 		};
 		const char *client = "?";
 
 		V3D_WRITE(V3D_MMU_CTL, V3D_READ(V3D_MMU_CTL));
 
 		if (v3d->ver >= V3D_GEN_41) {
-			axi_id = axi_id >> 5;
-			if (axi_id < ARRAY_SIZE(v3d41_axi_ids))
-				client = v3d41_axi_ids[axi_id];
+			size_t i;
+
+			axi_id = axi_id & 0xFF;
+			for (i = 0; i < ARRAY_SIZE(v3d41_axi_ids); i++) {
+				if (axi_id >= v3d41_axi_ids[i].begin &&
+				    axi_id < v3d41_axi_ids[i].end) {
+					client = v3d41_axi_ids[i].client;
+					break;
+				}
+			}
 		}
 
-		dev_err(v3d->drm.dev, "MMU error from client %s (%d) at 0x%llx%s%s%s\n",
+		dev_err(v3d->drm.dev, "MMU error from client %s (0x%x) at 0x%llx%s%s%s\n",
 			client, axi_id, (long long)vio_addr,
 			((intsts & V3D_HUB_INT_MMU_WRV) ?
 			 ", write violation" : ""),
-- 
2.39.5



