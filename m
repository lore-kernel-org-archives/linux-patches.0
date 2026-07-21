Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C7B3EF672;
	Tue, 21 Jul 2026 17:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654236; cv=none; b=rLPj+eOhzwoCCZ+RT4NCsZvqhLgmfF/9xGCy4cwFitpcbmpNeNUvlxuxgi2IXuXG6HN/3tC0dXzoiPubMQTHSnRPC2IjnbzuD013mmRtRR5NWRxRIL3RB45JekKQ/lFQEC+Y398GpTrmv+1jmAZrWPPfHiyaw3Kpb1gyHV6m8oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654236; c=relaxed/simple;
	bh=sy56G/rRXMX8nv9EoMkigNls09z9aRmzX2wui6keTfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QuI1aYHcXIbpKs0tAOAZQkYPwxmTqDogquoBmJ3F8oqeOBYMZQTLWpdSH7V9EJLt9UrQs1Fblq64MJgQRuzBarXoAzZBi2CVYysE3QYn5Lw8SQYtPRNLyacL+Ew5vg+KPQWxnFIBu0DaBTgoYi5uAa9L6lpdjgy5Tgw9xohMs90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TbYmwxev; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TbYmwxev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF2CF1F000E9;
	Tue, 21 Jul 2026 17:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654235;
	bh=923nfgNefhhGA7+5Xr/z4S+iptm69zdBvrufcVtj3Jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TbYmwxevwKEhMoTEXDZ/BaHKBJGcjbrvMIeyl0xigDjpFZejSqeo4obb9zbHB46Yg
	 jIq/NcbsWd58wmWJBs3KGDa0k0HFD1OvRzIGV2xPkdDf32Lf7Wepm/TYphiV8TidjE
	 SOw3Mag2ePRZuAYuAjWoGux6/nVsFCZcbl7DqfmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Ma <aaron.ma@canonical.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 7.1 1629/2077] x86/video: Only fall back to vga_default_device() without screen info
Date: Tue, 21 Jul 2026 17:21:42 +0200
Message-ID: <20260721152631.178018651@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 596b3678326d3d1aed7c19423b6746f1ce09688a upstream.

Some multi GPU systems may have a VGA compatible device, but that might not be
used for display.  If due to enumeration order this device is found before the
one actually used for display then multiple devices may show the boot_display
attribute, confusing userspace.

When screen info is valid, use it exclusively to find the primary device so
that only the device backing the framebuffer is reported.  Only when no
framebuffer has been set up does it make sense to fall back to the default VGA
device.  This ensures at most one primary graphics device, preferably the one
with the framebuffer.

Fixes: ad90860bd10ee ("fbcon: Use screen info to find primary device")
Closes: https://lore.kernel.org/linux-pci/20260618081803.2790848-1-aaron.ma@canonical.com/#t
Reported-by: Aaron Ma <aaron.ma@canonical.com>
Suggested-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Tested-by: Aaron Ma <aaron.ma@canonical.com>
Cc: <stable@kernel.org>
Link: https://patch.msgid.link/20260623141505.1816786-1-mario.limonciello@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/video/video-common.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- a/arch/x86/video/video-common.c
+++ b/arch/x86/video/video-common.c
@@ -43,21 +43,26 @@ bool video_is_primary_device(struct devi
 	if (!pci_is_display(pdev))
 		return false;
 
-	if (pdev == vga_default_device())
-		return true;
-
 #ifdef CONFIG_SCREEN_INFO
 	numres = screen_info_resources(si, res, ARRAY_SIZE(res));
-	for (i = 0; i < numres; ++i) {
-		if (!(res[i].flags & IORESOURCE_MEM))
-			continue;
+	if (numres > 0) {
+		for (i = 0; i < numres; ++i) {
+			if (!(res[i].flags & IORESOURCE_MEM))
+				continue;
+
+			if (pci_find_resource(pdev, &res[i]))
+				return true;
+		}
 
-		if (pci_find_resource(pdev, &res[i]))
-			return true;
+		return false;
 	}
 #endif
 
-	return false;
+	/*
+	 * No framebuffer was set up by the firmware/bootloader, so fall back
+	 * to the default VGA device.
+	 */
+	return pdev == vga_default_device();
 }
 EXPORT_SYMBOL(video_is_primary_device);
 


