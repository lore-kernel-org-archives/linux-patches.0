Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BAE33CD2;
	Wed,  7 Aug 2024 15:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043745; cv=none; b=UomErEbbnHGusQyh2jzcM3YnB+SugsNdeS+ZJgvnLSTMHOfZt2ntys948R6+HJjcKzsKgHnaFdJ4DQPlnkOfBLAyuR94ZF3eQdb9EIoNlnTMVkOlAfGoUwafrE/iJdbV5Q0lb3D3GSGy1tdzu0+h0iMElctQbHg1POzEqwqw/Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043745; c=relaxed/simple;
	bh=SjxM0MfBqgfxv4ygZQzJhKlkHGoNMOwE4jUfqsFR+DA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DxAEzGSF3OMvsjOSzQ45ceSM52PEoZvBhpv/UzpuhN+hHGzIFA2BQxWtPx1miAN7/xz4Mx2+FmtjLRv6CxMJLTnMcIyshYgDQUxPd/Wkj4NqPcL9DeunsnfgeiO7rvpAMhyLs9uEHcj9fMZcdYci+1DKovim+w3SsBfJWv1XXVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jk2GSGtZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jk2GSGtZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 130ABC32781;
	Wed,  7 Aug 2024 15:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043745;
	bh=SjxM0MfBqgfxv4ygZQzJhKlkHGoNMOwE4jUfqsFR+DA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jk2GSGtZcG6S4/Ha8n7aBL8Mbn4n9Hd0VjdbrNfI8h0h9DAHM6kzUTLiXHfTflW5a
	 GGUk702FSa5j1LiHKNlher9WpxqBcB+40hEqRrUvLbQvr5SWH4jngMGDUBSInoA6kM
	 xGzSCNHMo6dTdSGzsqAXXiwrKJs7FAMuIKP9Mr8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 57/86] ALSA: hda: Conditionally use snooping for AMD HDMI
Date: Wed,  7 Aug 2024 17:00:36 +0200
Message-ID: <20240807150041.123848718@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
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

[ Upstream commit 478689b5990deb626a0b3f1ebf165979914d6be4 ]

The recent regression report revealed that the use of WC pages for AMD
HDMI device together with AMD IOMMU leads to unexpected truncation or
noises.  The issue seems triggered by the change in the kernel core
memory allocation that enables IOMMU driver to use always S/G
buffers.  Meanwhile, the use of WC pages has been a workaround for the
similar issue with standard pages in the past.  So, now we need to
apply the workaround conditionally, namely, only when IOMMU isn't in
place.

This patch modifies the workaround code to check the DMA ops at first
and apply the snoop-off only when needed.

Fixes: f5ff79fddf0e ("dma-mapping: remove CONFIG_DMA_REMAP")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=219087
Link: https://patch.msgid.link/20240731170521.31714-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_controller.h |  2 +-
 sound/pci/hda/hda_intel.c      | 10 +++++++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/hda_controller.h b/sound/pci/hda/hda_controller.h
index 8556031bcd68e..f31cb31d46362 100644
--- a/sound/pci/hda/hda_controller.h
+++ b/sound/pci/hda/hda_controller.h
@@ -28,7 +28,7 @@
 #else
 #define AZX_DCAPS_I915_COMPONENT 0		/* NOP */
 #endif
-/* 14 unused */
+#define AZX_DCAPS_AMD_ALLOC_FIX	(1 << 14)	/* AMD allocation workaround */
 #define AZX_DCAPS_CTX_WORKAROUND (1 << 15)	/* X-Fi workaround */
 #define AZX_DCAPS_POSFIX_LPIB	(1 << 16)	/* Use LPIB as default */
 #define AZX_DCAPS_AMD_WORKAROUND (1 << 17)	/* AMD-specific workaround */
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index a26f2a2d44cf2..695026c647e1e 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -40,6 +40,7 @@
 
 #ifdef CONFIG_X86
 /* for snoop control */
+#include <linux/dma-map-ops.h>
 #include <asm/set_memory.h>
 #include <asm/cpufeature.h>
 #endif
@@ -300,7 +301,7 @@ enum {
 
 /* quirks for ATI HDMI with snoop off */
 #define AZX_DCAPS_PRESET_ATI_HDMI_NS \
-	(AZX_DCAPS_PRESET_ATI_HDMI | AZX_DCAPS_SNOOP_OFF)
+	(AZX_DCAPS_PRESET_ATI_HDMI | AZX_DCAPS_AMD_ALLOC_FIX)
 
 /* quirks for AMD SB */
 #define AZX_DCAPS_PRESET_AMD_SB \
@@ -1718,6 +1719,13 @@ static void azx_check_snoop_available(struct azx *chip)
 	if (chip->driver_caps & AZX_DCAPS_SNOOP_OFF)
 		snoop = false;
 
+#ifdef CONFIG_X86
+	/* check the presence of DMA ops (i.e. IOMMU), disable snoop conditionally */
+	if ((chip->driver_caps & AZX_DCAPS_AMD_ALLOC_FIX) &&
+	    !get_dma_ops(chip->card->dev))
+		snoop = false;
+#endif
+
 	chip->snoop = snoop;
 	if (!snoop) {
 		dev_info(chip->card->dev, "Force to non-snoop mode\n");
-- 
2.43.0



