Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8131B4F13;
	Mon, 14 Oct 2024 15:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919140; cv=none; b=KU8RTJzX+E3pOkd4zJGnMmLriMfSoRQnN1CnWDZq5NYa8dBLEk6BAx8edGbycpO53iYS6k04zHe9iUDePehel7uGC3qAD/5Z74FhhloehVDLCtiyFpVr3igi6CYn75AHKzFMj42+PKolbECnJBzvVHeMazOqSCZ4q78MPRQSJ1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919140; c=relaxed/simple;
	bh=YQv38f7d5sSjbjEKL88HKuLFIHZWcrB+yf4EXJ2AYNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OjGYRVDszZZZkmD8GRw0uboa5qlQ3fBP9Ad+ev6rMB5szGit6eKczQ2e2lrTIPb90kFnYHgaWD9TFRcPyFBvBb+OTjc6ugv+scmR2v4lUsHYDIaMVDuCm9c2dYN3I4WyJrMyLO1VjvUdKBskzDTtVKoGHInbD5URdtCEgbEn06M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mh32CEdN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mh32CEdN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 120D5C4CEC3;
	Mon, 14 Oct 2024 15:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919140;
	bh=YQv38f7d5sSjbjEKL88HKuLFIHZWcrB+yf4EXJ2AYNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mh32CEdNKzCbZixVu3ZF5ItCwwyVzLA5MGs25H50T5YvvL1qbvTrQdGEZSuUp78QN
	 AWFRSEOe6rkDQtNZursGRY+oj1XGZSujUW7RsPREACcKJDcJ8U0iC/m2nojUcnzsEF
	 Sx5drP0jUGSggEiNB9t7uVeaQs1HWKgLG7ea+3xE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salvatore Bonaccorso <carnil@debian.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 523/798] Revert "ALSA: hda: Conditionally use snooping for AMD HDMI"
Date: Mon, 14 Oct 2024 16:17:57 +0200
Message-ID: <20241014141238.525806055@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit 3f7f36a4559ef78a6418c5f0447fbfbdcf671956 upstream.

This reverts commit 478689b5990deb626a0b3f1ebf165979914d6be4.

The fix seems leading to regressions for other systems.
Also, the way to check the presence of IOMMU via get_dma_ops() isn't
reliable and it's no longer applicable for 6.12.  After all, it's no
right fix, so let's revert it at first.

To be noted, the PCM buffer allocation has been changed to try the
continuous pages at first since 6.12, so the problem could be already
addressed without this hackish workaround.

Reported-by: Salvatore Bonaccorso <carnil@debian.org>
Closes: https://lore.kernel.org/ZvgCdYfKgwHpJXGE@eldamar.lan
Link: https://patch.msgid.link/20241002155948.4859-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/hda_controller.h |    2 +-
 sound/pci/hda/hda_intel.c      |   10 +---------
 2 files changed, 2 insertions(+), 10 deletions(-)

--- a/sound/pci/hda/hda_controller.h
+++ b/sound/pci/hda/hda_controller.h
@@ -28,7 +28,7 @@
 #else
 #define AZX_DCAPS_I915_COMPONENT 0		/* NOP */
 #endif
-#define AZX_DCAPS_AMD_ALLOC_FIX	(1 << 14)	/* AMD allocation workaround */
+/* 14 unused */
 #define AZX_DCAPS_CTX_WORKAROUND (1 << 15)	/* X-Fi workaround */
 #define AZX_DCAPS_POSFIX_LPIB	(1 << 16)	/* Use LPIB as default */
 #define AZX_DCAPS_AMD_WORKAROUND (1 << 17)	/* AMD-specific workaround */
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -40,7 +40,6 @@
 
 #ifdef CONFIG_X86
 /* for snoop control */
-#include <linux/dma-map-ops.h>
 #include <asm/set_memory.h>
 #include <asm/cpufeature.h>
 #endif
@@ -301,7 +300,7 @@ enum {
 
 /* quirks for ATI HDMI with snoop off */
 #define AZX_DCAPS_PRESET_ATI_HDMI_NS \
-	(AZX_DCAPS_PRESET_ATI_HDMI | AZX_DCAPS_AMD_ALLOC_FIX)
+	(AZX_DCAPS_PRESET_ATI_HDMI | AZX_DCAPS_SNOOP_OFF)
 
 /* quirks for AMD SB */
 #define AZX_DCAPS_PRESET_AMD_SB \
@@ -1719,13 +1718,6 @@ static void azx_check_snoop_available(st
 	if (chip->driver_caps & AZX_DCAPS_SNOOP_OFF)
 		snoop = false;
 
-#ifdef CONFIG_X86
-	/* check the presence of DMA ops (i.e. IOMMU), disable snoop conditionally */
-	if ((chip->driver_caps & AZX_DCAPS_AMD_ALLOC_FIX) &&
-	    !get_dma_ops(chip->card->dev))
-		snoop = false;
-#endif
-
 	chip->snoop = snoop;
 	if (!snoop) {
 		dev_info(chip->card->dev, "Force to non-snoop mode\n");


