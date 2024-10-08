Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6363A1DEFEA;
	Tue,  8 Oct 2024 13:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393612; cv=none; b=ffjSYKb0q82G0W/zEC2+yUTOHt4LNTBlzEkOkDSf1CuYrG63B0BDYg7HiW6ctLvH181Vyw2aTtUvaqLN8bvUq7VLdxsnQyxa3iXOnB0TufBNBE+29MscnNyu1UO4ut3lUKi8l18eT6EazbK4FKCTgQiT5H1QCWfKGXL/NTSi8I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393612; c=relaxed/simple;
	bh=0bW8dZwXG4xZnMshE8rH8Xf+0ubTvoU9ppaoI9RV7/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T3OWWziI6uEQiHfXCkfx8/nuBOdpOo6XZx5DLlPcJG1djnL7bhp4ZsTagbUguhJxdOJL9XewS660TUYfkSVuAU2BCdNAnr5pJYKEJ0U8MfalojWGvkIQkcSSZHdrRTYhKrwtcCxIxzK2nxMKmlykVbZCtkOsTTi04G9a/UG+n+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rtF1wnDj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rtF1wnDj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB815C4CECE;
	Tue,  8 Oct 2024 13:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393612;
	bh=0bW8dZwXG4xZnMshE8rH8Xf+0ubTvoU9ppaoI9RV7/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rtF1wnDjB/YCKDrZJONMSZOa/k2SgO7xL/WkynBy7JslAUY7SFwvIz7HvnojA7L8Z
	 3TtE00p1+WeDy1Y9+oO4G+bJVFKrq2PY25IiX/Hzh99v7AjW4eIDGuAsYRSvy7nO3a
	 Z0OGl+WIz8e/YHYh0kVQjU/Su4e/AzH69SMshFOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salvatore Bonaccorso <carnil@debian.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 204/386] Revert "ALSA: hda: Conditionally use snooping for AMD HDMI"
Date: Tue,  8 Oct 2024 14:07:29 +0200
Message-ID: <20241008115637.435200441@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -302,7 +301,7 @@ enum {
 
 /* quirks for ATI HDMI with snoop off */
 #define AZX_DCAPS_PRESET_ATI_HDMI_NS \
-	(AZX_DCAPS_PRESET_ATI_HDMI | AZX_DCAPS_AMD_ALLOC_FIX)
+	(AZX_DCAPS_PRESET_ATI_HDMI | AZX_DCAPS_SNOOP_OFF)
 
 /* quirks for AMD SB */
 #define AZX_DCAPS_PRESET_AMD_SB \
@@ -1716,13 +1715,6 @@ static void azx_check_snoop_available(st
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


