Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308051A6192;
	Tue, 30 Jul 2024 16:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357542; cv=none; b=tEWVvAg4M4I+8fz72SY9JDg7vm1dngKYDPEoRkypjb7On7ImN896aqIzgbpEpY9MqyuUDF5RXz+4xlpReZE03LhhzFsY+KCS+l/R0Q9GkH880D5f5lGTOlFLxw0xqyttey5UElUmxYdk2s1K04QWO8qVfDhxa90K9ImSqJmIDZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357542; c=relaxed/simple;
	bh=HTA2Igguke9FX9sdUKgzczzzNdPIEnY827Zp7cp5OQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gRU/9nGGNwUgcZUO8bcRx6v0OD5XXSHqn7M6YTJU53mw8Ybl4S+F9KMcWHWmGOOCxnTQ+lUdQMrFrkl/gv+GmY49A2674y+VPapP2NgjZlVnTUIsgXlPJFIfuQC+14gcs4VV7G74uta7zB8Ga0xGYK+Sk8STs0NdCQiAc8XyMxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IYeziIWe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IYeziIWe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93445C4AF10;
	Tue, 30 Jul 2024 16:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357542;
	bh=HTA2Igguke9FX9sdUKgzczzzNdPIEnY827Zp7cp5OQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IYeziIWelCUSwZ09io/+rDNw43PkDqCZnjdckfM3IQ/dTPAw/jRq2GdCngHNCAIon
	 GGyA15A9GUnR6r3T8Ubx0ZgolOS3cvzMWZnIWu6Ba6+6PkZdYWr+lth4xKbHOCc1zK
	 G91KRAgFSN6nXHeu+WaLhOMqqVMZq7J9sTknj704=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Paolo Pisati <p.pisati@gmail.com>,
	Michael Schmitz <schmitzmic@gmail.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 6.1 302/440] m68k: amiga: Turn off Warp1260 interrupts during boot
Date: Tue, 30 Jul 2024 17:48:55 +0200
Message-ID: <20240730151627.622201103@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


