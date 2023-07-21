Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6AB1F941
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:17:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A362BC433C8;
	Fri, 21 Jul 2023 16:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956272;
	bh=NoJ2NKdqLQA7IKSwiojgIsg3ZlTlviPpkJnQ7NbdBHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e/iiBTZm2+qyw2/AUWze1jR6Pk2TyGMpf3wkdhpcTW/7XSMYxf+9BMlFy/xH9yUtX
	 nDv8i7cUWlgoPUKdWv9iqPIYNuDSftFdrxzSdgDm7ceX2eJ5UMeeOkuLuhifDrbjrL
	 zAYs6OnWnEuLus7caYgg/BGIGxCyxJrh3grPIYEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.4 133/292] mtd: rawnand: meson: fix unaligned DMA buffers handling
Date: Fri, 21 Jul 2023 18:04:02 +0200
Message-ID: <20230721160534.548819100@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arseniy Krasnov <AVKrasnov@sberdevices.ru>

commit 98480a181a08ceeede417e5b28f6d0429d8ae156 upstream.

Meson NAND controller requires 8 bytes alignment for DMA addresses,
otherwise it "aligns" passed address by itself thus accessing invalid
location in the provided buffer. This patch makes unaligned buffers to
be reallocated to become valid.

Fixes: 8fae856c5350 ("mtd: rawnand: meson: add support for Amlogic NAND flash controller")
Cc: <Stable@vger.kernel.org>
Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20230615080815.3291006-1-AVKrasnov@sberdevices.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/meson_nand.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/mtd/nand/raw/meson_nand.c
+++ b/drivers/mtd/nand/raw/meson_nand.c
@@ -76,6 +76,7 @@
 #define GENCMDIADDRH(aih, addr)		((aih) | (((addr) >> 16) & 0xffff))
 
 #define DMA_DIR(dir)		((dir) ? NFC_CMD_N2M : NFC_CMD_M2N)
+#define DMA_ADDR_ALIGN		8
 
 #define ECC_CHECK_RETURN_FF	(-1)
 
@@ -842,6 +843,9 @@ static int meson_nfc_read_oob(struct nan
 
 static bool meson_nfc_is_buffer_dma_safe(const void *buffer)
 {
+	if ((uintptr_t)buffer % DMA_ADDR_ALIGN)
+		return false;
+
 	if (virt_addr_valid(buffer) && (!object_is_on_stack(buffer)))
 		return true;
 	return false;


