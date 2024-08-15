Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C3B7DA9E;
	Thu, 15 Aug 2024 13:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729736; cv=none; b=HWgNBrHXDrRF9GNRuC90H9o3VdtcjT7I6uoEqxRHh2f/t23JqAcSEo8zUgZssaltaZCv8QtD4JW1oLmZw8u49NqfJs57U0GRZHHYKMJe81vEUUkls1CCC+3Nrk0ge6woINQOzaXKGCOYqEv20bDeGWO1f80FJaDbPR7iu44Oga8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729736; c=relaxed/simple;
	bh=csgut/2T5u7TtnbGkHwmFlVVdz2pV6VpWg693pKqYUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VII8Uz0UTlBfRiX2kNj/Jv6KZCB1FNUjG8DYkGjRh1VpzokKpzJGz3JprCJbrW+HOM6tGfoM3pKRHCugNnaY8wlQK4SJGMR48q4BRomKsNS5uaQ1lpfEc54o1O38skCZ2YeoRvvA2sInTuKOlZ0hf7qEI5J5ZNjP4SWtKuhEuso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZTTzTWd+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZTTzTWd+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E92FBC32786;
	Thu, 15 Aug 2024 13:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729736;
	bh=csgut/2T5u7TtnbGkHwmFlVVdz2pV6VpWg693pKqYUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZTTzTWd+c3Q/HOjCEaf81YzWDUGpiM/YQUVdZ9hQ98BOeRfBbVuixf4KUfwMYaWD6
	 Ra6aZzFxRmhRkUSo2f/0vF8c6FsFEqzYGJhRC8+07p5vT4ZH0NfFLfZDCvKQw4TC6+
	 czzmqVVJeoB88l5XYKX7mblwMRokES4x35K6Z5/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Paolo Pisati <p.pisati@gmail.com>,
	Michael Schmitz <schmitzmic@gmail.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 5.15 191/484] m68k: amiga: Turn off Warp1260 interrupts during boot
Date: Thu, 15 Aug 2024 15:20:49 +0200
Message-ID: <20240815131948.791272981@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


