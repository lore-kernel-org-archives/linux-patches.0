Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E323BB12A;
	Thu, 17 Sep 2026 17:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667701; cv=none; b=T0eeDqyNYtBce9y7qDb/bdpmqmPR1mIGyJ3qYCEqJwJaKRvBhE5x886tevSBKo5942P3wqjC3QoyvNv4smKzenA46Sd+lWkUFRZTLzQfJXFZGN/6LKRZgoT5yE1pC7k5dp8ZaDBGhfMH/l/OUirEfRZfdJ1YghmlqOcLNGNsrZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667701; c=relaxed/simple;
	bh=qAQCuJCXAe7svlC21G9SXDxlq88ygqO+O1vB/A5mmWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BKREmlhLxNl77R/YiZkiT/wozq9q4b22TzLjO/WzoDuJ1wzjGhfJboqkbITanfdvJbtLq52aPrJzbi2aZ5q3sibvkXaXcBkc6tFXx/x/kse9yTWQXqSBrCjFQ+ImYf/58efSxolaWvx+95daOciwF78wLDyHv638OHupo9lxoLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fw4xqfgE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fw4xqfgE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 613971F000FF;
	Thu, 17 Sep 2026 17:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667699;
	bh=oHSVGp0AO+mXrNWS3BX3bvznlkMcyfcNuJjCOun2YGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fw4xqfgEJ5tmZbpXuuYbBRpU7l80nzsXLSPWKgMpWp2oEYClww0mRKkj8yQSjZ+aW
	 8CUJpO+8Grx9AFnGsNJpnTjvP49U2yuJ1v4B/Q7PEPEINdxwE0KBFZIMlRi8/tccPT
	 Q1j/sf9VoKR0fGTSBP7V5yrW0YPlY4v8jLS9Lex4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Timur Tabi <ttabi@nvidia.com>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0181/1102] drm/nouveau/bios: skip the IFR header if present
Date: Thu, 17 Sep 2026 16:02:04 +0100
Message-ID: <20260917151544.106910734@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Timur Tabi <ttabi@nvidia.com>

[ Upstream commit 4beeac5d2015df1017732ce4c57d634f557dd304 ]

The GPU's ROM may begin with an Init-from-ROM (IFR) header that precedes
the PCI Expansion ROM images (VBIOS).  When present, the PROM shadow
method must parse this header to determine the offset where the PCI ROM
images actually begin, and adjust all subsequent reads accordingly.

On most GPUs this is not needed because either the PRAMIN shadow method
(which reads from VRAM via the display engine) succeeds first, or the IFR
microcode has already applied the ROM offset so that PROM reads
transparently skip the header.  However, on GA100 neither of these
applies: GA100 has no display engine (so PRAMIN is unavailable), and the
IFR offset is not applied to PROM reads on this GPU.

Signed-off-by: Timur Tabi <ttabi@nvidia.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/20260430223838.2530778-9-ttabi@nvidia.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/nouveau/nvkm/subdev/bios/shadowrom.c  | 110 ++++++++++++++++--
 1 file changed, 101 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/bios/shadowrom.c b/drivers/gpu/drm/nouveau/nvkm/subdev/bios/shadowrom.c
index 39144ceb117b4..9e171b1bad732 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/bios/shadowrom.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/bios/shadowrom.c
@@ -24,34 +24,126 @@
 
 #include <subdev/pci.h>
 
+#define NV_PBUS_IFR_FMT_FIXED0_SIGNATURE_VALUE 0x4947564E	/* "NVGI" */
+#define NV_ROM_DIRECTORY_IDENTIFIER 0x44524652			/* "RFRD" */
+
+struct priv {
+	struct nvkm_device *device;
+	u32 pci_rom_offset;
+};
+
 static u32
 nvbios_prom_read(void *data, u32 offset, u32 length, struct nvkm_bios *bios)
 {
-	struct nvkm_device *device = data;
+	struct priv *priv = data;
+	struct nvkm_device *device = priv->device;
 	u32 i;
-	if (offset + length <= 0x00100000) {
-		for (i = offset; i < offset + length; i += 4)
-			*(u32 *)&bios->data[i] = nvkm_rd32(device, 0x300000 + i);
-		return length;
-	}
-	return 0;
+
+	/* Make sure we don't try to read past the end of data[] */
+	if (offset + length > bios->size)
+		return 0;
+
+	/* Make sure the read falls within the 1MB PROM window */
+	if (offset + priv->pci_rom_offset + length > 0x00100000)
+		return 0;
+
+	for (i = offset; i < offset + length; i += 4)
+		*(u32 *)&bios->data[i] = nvkm_rd32(device, 0x300000 + priv->pci_rom_offset + i);
+	return length;
 }
 
 static void
 nvbios_prom_fini(void *data)
 {
-	struct nvkm_device *device = data;
+	struct priv *priv = data;
+	struct nvkm_device *device = priv->device;
+
 	nvkm_pci_rom_shadow(device->pci, true);
+
+	kfree(data);
 }
 
 static void *
 nvbios_prom_init(struct nvkm_bios *bios, const char *name)
 {
 	struct nvkm_device *device = bios->subdev.device;
+	struct priv *priv;
+	u32 fixed0;
+
+	/* There is no PROM on NV4x iGPUs */
 	if (device->card_type == NV_40 && device->chipset >= 0x4c)
 		return ERR_PTR(-ENODEV);
+
+	priv = kzalloc_obj(*priv);
+	if (!priv)
+		return ERR_PTR(-ENOMEM);
+
+	/* Disable the PCI ROM shadow so that we can read PROM. */
 	nvkm_pci_rom_shadow(device->pci, false);
-	return device;
+
+	/*
+	 * Check for an IFR header. If present, parse it to find the actual PCI ROM header.
+	 *
+	 * The IFR header is documented in Documentation/gpu/nova/core/vbios.rst
+	 */
+	fixed0 = nvkm_rd32(device, 0x300000);
+	if (fixed0 == NV_PBUS_IFR_FMT_FIXED0_SIGNATURE_VALUE) {
+		u32 fixed1 = nvkm_rd32(device, 0x300004);
+		u8 version = (fixed1 >> 8) & 0xff;
+		u32 fixed2, data_size, offset, signature;
+
+		switch (version) {
+		case 1:
+		case 2:
+			data_size = (fixed1 >> 16) & 0x7fff;
+			priv->pci_rom_offset = nvkm_rd32(device, 0x300000 + data_size + 4);
+			break;
+		case 3:
+			fixed2 = nvkm_rd32(device, 0x300008);
+			data_size = fixed2 & 0x000fffff;
+
+			/* ROM directory offset */
+			offset = nvkm_rd32(device, 0x300000 + data_size) + 4096;
+
+			signature = nvkm_rd32(device, 0x300000 + offset);
+			if (signature != NV_ROM_DIRECTORY_IDENTIFIER) {
+				nvkm_error(&bios->subdev, "could not find IFR ROM directory\n");
+				goto fail;
+			}
+
+			priv->pci_rom_offset = nvkm_rd32(device, 0x300000 + offset + 8);
+
+			break;
+		default:
+			nvkm_error(&bios->subdev, "unsupported IFR header version %u\n",
+				   version);
+			goto fail;
+		}
+
+		/* Double-check that the offset is valid */
+		if (priv->pci_rom_offset >= 0x00100000) {
+			nvkm_error(&bios->subdev,
+				   "PCI ROM offset of 0x%x is too large\n", priv->pci_rom_offset);
+			goto fail;
+		}
+
+		/* If there is an IFR header, there must also be a PCI ROM header. */
+		signature = nvkm_rd32(device, 0x300000 + priv->pci_rom_offset) & 0xffff;
+		if (signature != 0xaa55) {
+			nvkm_error(&bios->subdev,
+				   "could not find PCI ROM signature at offset 0x%x\n",
+				   priv->pci_rom_offset);
+			goto fail;
+		}
+	}
+
+	priv->device = device;
+	return priv;
+
+fail:
+	nvkm_pci_rom_shadow(device->pci, true);
+	kfree(priv);
+	return ERR_PTR(-ENODEV);
 }
 
 const struct nvbios_source
-- 
2.53.0



