Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED93C1A76A1;
	Tue, 30 Jul 2024 17:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360215; cv=none; b=L7MJYsz7j0AqrX0cYCm+QGoUm5zTc7q77tMXQ1ti4CkKfz/K+HWd+eVR3hktBNnFAzLFkDHm07jc9nBV0LZf7ZP0ERou/YW0jsDHoU/tHluf9t+B7V/ktCUD9n5ixq8Dr53uzvvHiSYo+IU68/Vy4EaMahSK1mNuf7fOw+HLdpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360215; c=relaxed/simple;
	bh=EeB+W5DSevJLGwAuh9OLlmC+wS9HPYaxZI9zj5QC+rI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QXxQVZBmVa1UJ01ThiiD5VxGxscUGBem2/cbfYcs58HFQxYG+NAEfzeEKDJWUE/pZoOas6bFx3uZJ55l9gMAUlRtl0/lm9Zv1/2hx3C4VpqPm4Q1siOVBiEQfTBPoItXuu7BcDhSmst3gSj8DQD3i50H5/FXqNX/5w1pu7CXf7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HvkDG4vH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HvkDG4vH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C6C9C32782;
	Tue, 30 Jul 2024 17:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360214;
	bh=EeB+W5DSevJLGwAuh9OLlmC+wS9HPYaxZI9zj5QC+rI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HvkDG4vHfJSn08PKsVth2VeD2KcPnPqd8A72z4OEK299aMIq6LOdaNUE5kwpyyfu/
	 sY7ldDT2fHpO/im9D8I8lEjgK0PkTQkmnp1X8cq1MLO1PW77wmsIoOUAPo98alHEps
	 0H/XYi4xbMRGBPY3mm5lhoDdHdhWj8vX1cg6sX8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Paolo Pisati <p.pisati@gmail.com>,
	Michael Schmitz <schmitzmic@gmail.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 6.10 590/809] m68k: amiga: Turn off Warp1260 interrupts during boot
Date: Tue, 30 Jul 2024 17:47:46 +0200
Message-ID: <20240730151748.133399136@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Pisati <p.pisati@gmail.com>

commit 1d8491d3e726984343dd8c3cdbe2f2b47cfdd928 upstream.

On an Amiga 1200 equipped with a Warp1260 accelerator, an interrupt
storm coming from the accelerator board causes the machine to crash in
local_irq_enable() or auto_irq_enable().  Disabling interrupts for the
Warp1260 in amiga_parse_bootinfo() fixes the problem.

Link: https://lore.kernel.org/r/ZkjwzVwYeQtyAPrL@amaterasu.local
Cc: stable <stable@kernel.org>
Signed-off-by: Paolo Pisati <p.pisati@gmail.com>
Reviewed-by: Michael Schmitz <schmitzmic@gmail.com>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/r/20240601153254.186225-1-p.pisati@gmail.com
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/m68k/amiga/config.c       |    9 +++++++++
 include/uapi/linux/zorro_ids.h |    3 +++
 2 files changed, 12 insertions(+)

--- a/arch/m68k/amiga/config.c
+++ b/arch/m68k/amiga/config.c
@@ -180,6 +180,15 @@ int __init amiga_parse_bootinfo(const st
 			dev->slotsize = be16_to_cpu(cd->cd_SlotSize);
 			dev->boardaddr = be32_to_cpu(cd->cd_BoardAddr);
 			dev->boardsize = be32_to_cpu(cd->cd_BoardSize);
+
+			/* CS-LAB Warp 1260 workaround */
+			if (be16_to_cpu(dev->rom.er_Manufacturer) == ZORRO_MANUF(ZORRO_PROD_CSLAB_WARP_1260) &&
+			    dev->rom.er_Product == ZORRO_PROD(ZORRO_PROD_CSLAB_WARP_1260)) {
+
+				/* turn off all interrupts */
+				pr_info("Warp 1260 card detected: applying interrupt storm workaround\n");
+				*(uint32_t *)(dev->boardaddr + 0x1000) = 0xfff;
+			}
 		} else
 			pr_warn("amiga_parse_bootinfo: too many AutoConfig devices\n");
 #endif /* CONFIG_ZORRO */
--- a/include/uapi/linux/zorro_ids.h
+++ b/include/uapi/linux/zorro_ids.h
@@ -449,6 +449,9 @@
 #define  ZORRO_PROD_VMC_ISDN_BLASTER_Z2				ZORRO_ID(VMC, 0x01, 0)
 #define  ZORRO_PROD_VMC_HYPERCOM_4				ZORRO_ID(VMC, 0x02, 0)
 
+#define ZORRO_MANUF_CSLAB					0x1400
+#define  ZORRO_PROD_CSLAB_WARP_1260				ZORRO_ID(CSLAB, 0x65, 0)
+
 #define ZORRO_MANUF_INFORMATION					0x157C
 #define  ZORRO_PROD_INFORMATION_ISDN_ENGINE_I			ZORRO_ID(INFORMATION, 0x64, 0)
 


