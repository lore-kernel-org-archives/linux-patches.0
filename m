Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1BA739A7FD;
	Tue, 21 Jul 2026 18:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658551; cv=none; b=r2vsvytziq5K9Da7df6oEiKkhPO22p3g4mXvMuZQ+wG2Mm3M2YakTeuEeIyi41bKJ7negWD3nLnRmNx3T0kodCJ/euH7fYBnSFry4LNjwjvCEdSFXODUa2JtSKkXfPf2bTMrYXQx/uEDW4t+KqbzeHFyk77aKO/IoJKEy8o2Fko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658551; c=relaxed/simple;
	bh=x/LVARd6jMmewVfbL6Gu91S12T85JaDm4a5wN2gIlAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pCpbqAD0k+XNILXmOM1LFWlc/YN80jZGYa1XxkX1RrVnXozNJJuJxCTbdmht6hgc6snplql511yAZoy1ZjqAhXn+20HyqGF3cTRGJ9NyyXtJRMHRcjc1hohSKNGBlQNW34Q8uPiYKqo+3BGRDLHBihQAM4ULCwPa950BO2RTbzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CrAlkHm3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CrAlkHm3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236001F000E9;
	Tue, 21 Jul 2026 18:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658550;
	bh=L1F+vtXi1c1LRSyEXJWXIAuTbdVVIBxRW6LFQ6LSTh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CrAlkHm3XGDPkDGkK5c3DZKiwXxulLWf5YF6lvvJtlaR24Iy6m8fwhflOmv7QbK55
	 4h41R3zyRt90u2WSM8zwWZC25NpdxJPSH+f520xrxg9mdEgIgfKEV1uoaRbNWU6Yiz
	 2Plme7vRSrjIgWYjbEGHYOLD1LNzmMXc/mJPmfVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Ma <aaron.ma@canonical.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.18 1186/1611] x86/video: Only fall back to vga_default_device() without screen info
Date: Tue, 21 Jul 2026 17:21:42 +0200
Message-ID: <20260721152542.109677171@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


