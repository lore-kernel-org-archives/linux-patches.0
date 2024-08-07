Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6602278C67;
	Wed,  7 Aug 2024 15:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043402; cv=none; b=P9tgiHUHzxwnjeus38iX2naMZvsQ/aDGWquxI57mlVSVEGtqDVrlG60Nz1rMVF879Z3dIIiUgISZxwHcoqXLh2KAOUsuGzVCBZWTDYLZ/EBvf2VBaigXMURfFKsyjgcOxP772NtJyhD/dRTOyYFjrtVQPBXklZU5LCw19FT99UU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043402; c=relaxed/simple;
	bh=AXA+miPA+XjkNHPujoRKZJrz0T+XZZ/77KDcwdO05mk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GN2QY7kPj1LPRup232P9+NDrMk5iH3fyiMLtdsT+eX/UDipte5bL+riDdpysQrekpKyu5yR64RaC65q7Rl3AOKKsUW8X9wLQ+r24JDzZM4Ku7bnlyp7ISIjhdWCJquFOoVdhT6BXu+wUXMwU639y9cRZ848UqyqG1uYIiFnnCrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zTdSdYab; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zTdSdYab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0808C4AF0B;
	Wed,  7 Aug 2024 15:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043402;
	bh=AXA+miPA+XjkNHPujoRKZJrz0T+XZZ/77KDcwdO05mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zTdSdYabJ5Xjqxnqbu2mOJRiDjB4KeB+Bp3b+RHgFsHw0Pv3pb3cOktU6xx3oaOCe
	 4oAggcm2+TWqhYqCYVrGOx/rPdqJH9RwaCxV8gMa+X+8SjRZXiV1v14EFeuEOL1n0M
	 ERyhK8wKbwbPsxNXhXEDUi85wtTOIIeWCBg0JJGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 077/121] ALSA: hda: Conditionally use snooping for AMD HDMI
Date: Wed,  7 Aug 2024 17:00:09 +0200
Message-ID: <20240807150021.933809042@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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
index a6a9d353fe635..d5c9f113e477a 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -40,6 +40,7 @@
 
 #ifdef CONFIG_X86
 /* for snoop control */
+#include <linux/dma-map-ops.h>
 #include <asm/set_memory.h>
 #include <asm/cpufeature.h>
 #endif
@@ -301,7 +302,7 @@ enum {
 
 /* quirks for ATI HDMI with snoop off */
 #define AZX_DCAPS_PRESET_ATI_HDMI_NS \
-	(AZX_DCAPS_PRESET_ATI_HDMI | AZX_DCAPS_SNOOP_OFF)
+	(AZX_DCAPS_PRESET_ATI_HDMI | AZX_DCAPS_AMD_ALLOC_FIX)
 
 /* quirks for AMD SB */
 #define AZX_DCAPS_PRESET_AMD_SB \
@@ -1715,6 +1716,13 @@ static void azx_check_snoop_available(struct azx *chip)
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



