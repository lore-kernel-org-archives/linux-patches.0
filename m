Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFE9348463;
	Thu, 17 Sep 2026 16:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664209; cv=none; b=tinsRoQRZq4nc+LsI1VqaZI/iY7x9xo1rnwS+d2pWHoJ9yvsD+ZSOA9GpYX+7cFUrtsNh6opR2PliL6M7+ZsKKWRUYeyvBMxIsRPRfnQSAAaCJetrZBS9oNQlrIEk+l5tFNEPwvlzDSgH5DgCZHgkeen6l5cqjLVjMQ81pQtTFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664209; c=relaxed/simple;
	bh=sNaGKXQwE046i2oWCU3I6w2BsIjkg2/dzwmCLe8f+VA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d9+SsCcnnPERXw1vQaMKe1tybRoaiJEVxQ14uKv8GOPXMzBzZsjo/waKEuXXUJ3NpYU0GjtBXjzbwOgcBxHp2eAVDIjgYk/pCTn+zgEhK73nNDskZsadY3QXSrY1dn24rWATwU2pXMrKRN3UMsbpx0nR62G3DLdTgtRmuTYR1Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q6rIcLQ7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q6rIcLQ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94CF31F000FF;
	Thu, 17 Sep 2026 16:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664208;
	bh=ffILHBs4KtxvVf7spmvVpQRmzUrnprnMfouQlY/G940=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q6rIcLQ7a2g8LAiWJRSBLx/kpStv9x2JGej4SrayyMia51fUIj56H0N/gte5dqOQ5
	 hMsIFsYqXNcAH8GifVD0uZ7b3qkLT5GIJp+YEd2ye8iwz/3NB2R04RImspUVfywoHz
	 Ir8F7R++W8kjF1ObMnh9dWuXsLQ1kEvFExf4HoZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Timur Tabi <ttabi@nvidia.com>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0257/1250] drm/nouveau/bios: skip the IFR header if present
Date: Thu, 17 Sep 2026 16:00:52 +0100
Message-ID: <20260917151559.121584629@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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



