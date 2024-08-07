Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D8727448;
	Wed,  7 Aug 2024 15:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043287; cv=none; b=R91kqPDZOZwkP7U6e/8/wyzAo35ak02MOzk5ul8+lnnz4+oBeQfUXVzbfdy1eFuJCX3CHsn+64G7JZXHWMEFXuxTb2AntyZun/Ysx9iQ5s+xxCC1MvwfBTHBkWiLwUEdd6siNShCyh45ocrhENEcPWzvqPlyy2Lfo14VAH4pnjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043287; c=relaxed/simple;
	bh=z1BDHlVSOqdnrDiIVNavIKomsbybbSU/LNhotR2GMdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hZgBxrc9XQ7tOQes22QWx1Hff9d1VIci+pVTCWA6Wj+dX0R8WcTN2wrMMLJ7gbJkKwp7n75PwHpjohLE7JIWyJ/XXBuheI7Jf2JMI6whuIW6Wk0EkHGjjqWluWuEZhKsRGRTHaLXyHHgroRFroarUDLNKET1d1OF6nK/V9ju29A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yYNMh/zS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yYNMh/zS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C521C32781;
	Wed,  7 Aug 2024 15:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043287;
	bh=z1BDHlVSOqdnrDiIVNavIKomsbybbSU/LNhotR2GMdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yYNMh/zScIypPVOyx4X2ImtFV4G4+jlJWvAysaNM+c7t9LoOYyVPnZr7CXIOcax2w
	 AbvOV0eTuUBX0uGbwZa7LcGx6OIjJZPxNRuSh1P+Jci4GKuLN8Po75T1zjnIpla+cC
	 /6Ai6EPdb6eHWyVZ4OBsE22OFmKJBlkFuuMsGG7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 036/121] fbdev: vesafb: Detect VGA compatibility from screen infos VESA attributes
Date: Wed,  7 Aug 2024 16:59:28 +0200
Message-ID: <20240807150020.530453644@linuxfoundation.org>
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

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit c2bc958b2b03e361f14df99983bc64a39a7323a3 ]

Test the vesa_attributes field in struct screen_info for compatibility
with VGA hardware. Vesafb currently tests bit 1 in screen_info's
capabilities field which indicates a 64-bit lfb address and is
unrelated to VGA compatibility.

Section 4.4 of the Vesa VBE 2.0 specifications defines that bit 5 in
the mode's attributes field signals VGA compatibility. The mode is
compatible with VGA hardware if the bit is clear. In that case, the
driver can access VGA state of the VBE's underlying hardware. The
vesafb driver uses this feature to program the color LUT in palette
modes. Without, colors might be incorrect.

The problem got introduced in commit 89ec4c238e7a ("[PATCH] vesafb: Fix
incorrect logo colors in x86_64"). It incorrectly stores the mode
attributes in the screen_info's capabilities field and updates vesafb
accordingly. Later, commit 5e8ddcbe8692 ("Video mode probing support for
the new x86 setup code") fixed the screen_info, but did not update vesafb.
Color output still tends to work, because bit 1 in capabilities is
usually 0.

Besides fixing the bug in vesafb, this commit introduces a helper that
reads the correct bit from screen_info.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 5e8ddcbe8692 ("Video mode probing support for the new x86 setup code")
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Cc: <stable@vger.kernel.org> # v2.6.23+
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/vesafb.c |  2 +-
 include/linux/screen_info.h  | 10 ++++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/vesafb.c b/drivers/video/fbdev/vesafb.c
index ea89accbec385..a21581b40256c 100644
--- a/drivers/video/fbdev/vesafb.c
+++ b/drivers/video/fbdev/vesafb.c
@@ -259,7 +259,7 @@ static int vesafb_probe(struct platform_device *dev)
 	if (si->orig_video_isVGA != VIDEO_TYPE_VLFB)
 		return -ENODEV;
 
-	vga_compat = (si->capabilities & 2) ? 0 : 1;
+	vga_compat = !__screen_info_vbe_mode_nonvga(si);
 	vesafb_fix.smem_start = si->lfb_base;
 	vesafb_defined.bits_per_pixel = si->lfb_depth;
 	if (15 == vesafb_defined.bits_per_pixel)
diff --git a/include/linux/screen_info.h b/include/linux/screen_info.h
index 75303c126285a..6a4a3cec4638b 100644
--- a/include/linux/screen_info.h
+++ b/include/linux/screen_info.h
@@ -49,6 +49,16 @@ static inline u64 __screen_info_lfb_size(const struct screen_info *si, unsigned
 	return lfb_size;
 }
 
+static inline bool __screen_info_vbe_mode_nonvga(const struct screen_info *si)
+{
+	/*
+	 * VESA modes typically run on VGA hardware. Set bit 5 signals that this
+	 * is not the case. Drivers can then not make use of VGA resources. See
+	 * Sec 4.4 of the VBE 2.0 spec.
+	 */
+	return si->vesa_attributes & BIT(5);
+}
+
 static inline unsigned int __screen_info_video_type(unsigned int type)
 {
 	switch (type) {
-- 
2.43.0



