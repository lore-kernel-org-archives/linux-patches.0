Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F2F2772A;
	Thu, 15 Aug 2024 14:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732323; cv=none; b=Iby/dv0LIBLg3OdK9lU7IJk7ifZ8U/IFJlhDTfvG+cxduMXCBNxUHzTfbff9AL1YgIhhiQosk2ariJ2NqJ+1luNkzN3nwPqvvtx1L+pTyuC2llHQC8nnSMm/fx3YNMT8odWggw2zlnDoJ2LWjOXPWy1F0jwpWu/KRWAszJjYSCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732323; c=relaxed/simple;
	bh=aTTqMMAbiGWB9ozP2Y86ZxN1mKGHQI7UNFYeTSN+Poc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WEx3xfHZbB7VG73VsslETqxukTn571fEktXrbyWIeWoSNVundHGKzR4VvoUftpgkeJQl7892au4EMPmxD287t0xdog+RP6/Bj1veaQRh+OEz/aE6SjUBnY6AW6b8VGJmStgBQnmtHRXTaTU8ErClYHFGqoHGumPCqYO8beQhm8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MuOUU22y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MuOUU22y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C410DC32786;
	Thu, 15 Aug 2024 14:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732323;
	bh=aTTqMMAbiGWB9ozP2Y86ZxN1mKGHQI7UNFYeTSN+Poc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MuOUU22yZi0Cu58IwxnoWBTaQLHbfUrELkvVODQbhxk5iMwZM2p0ZdNtB6ZQ5+d9M
	 ZNx2jc55kxLL8JibvI2XJ4Qm4p3IGfDBsqzUE+5rRnkgKX/7PKRQezMKb8Tip4mzO8
	 5/M3l6sRojIii6Rhtld2DMg0dbIOGEoLM0Rm80yM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Paolo Pisati <p.pisati@gmail.com>,
	Michael Schmitz <schmitzmic@gmail.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 5.10 143/352] m68k: amiga: Turn off Warp1260 interrupts during boot
Date: Thu, 15 Aug 2024 15:23:29 +0200
Message-ID: <20240815131924.787484306@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -179,6 +179,15 @@ int __init amiga_parse_bootinfo(const st
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
 


