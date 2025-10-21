Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6FE9350A0D;
	Tue, 21 Oct 2025 20:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077399; cv=none; b=fgfd5cMxRfy6cfUdHkOFPIz1M/WHZ6NzOiGcIUU8UTQGKpfq6cCCfTJ2TB28eQEwsxSFg7ojb6mkOjlXB+U257UhoTlTmF+8Hoye8CnjBc4qQLmTeLKkRHaLGVQwq20nCSgm9L4cluAMZcGDBDx0eVIT8p7WPsSN6rko4bM/z1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077399; c=relaxed/simple;
	bh=PB7B/AipzO93x44/hRYdq2OUS4rKuXptvT7Psx9fFh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y3HddBdgt4nvzpmTZZbEyuMT8gTUH51c5oRFL+LdQuYAeybDQQwvLiR2AIwlgFOEvX/WcGM2FegCZRGjMDhDGmMSr61pxPf5xwt5wl9Niy5PU0qvoegIIFWbwl9HX01heYY7iqltRSQMQl6lX92KEQL2EmOwKsbTnuV8iShi0+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fB8ADAYp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fB8ADAYp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E48C4CEF1;
	Tue, 21 Oct 2025 20:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077399;
	bh=PB7B/AipzO93x44/hRYdq2OUS4rKuXptvT7Psx9fFh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fB8ADAYponwkGpHh9MqGJkYBdRQjrlRG/AwaLo10l8zQovjSdDqCym09buShsC5H9
	 PM0Qb1Zinem5rIUn5AfC0DQH03jW0QXxY2G5BTGVQOjSf5KfVZi/w5I+CaazaFVpxh
	 dk2UsGVnmMSJJfFHfg7ZyRCs7wdV5A5wtafj/BpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Nick Bowler <nbowler@draconx.ca>,
	Douglas Anderson <dianders@chromium.org>,
	Dave Airlie <airlied@redhat.com>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	dri-devel@lists.freedesktop.org
Subject: [PATCH 6.17 040/159] drm/ast: Blank with VGACR17 sync enable, always clear VGACRB6 sync off
Date: Tue, 21 Oct 2025 21:50:17 +0200
Message-ID: <20251021195044.163217433@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

commit 6f719373b943a955fee6fc2012aed207b65e2854 upstream.

Blank the display by disabling sync pulses with VGACR17<7>. Unblank
by reenabling them. This VGA setting should be supported by all Aspeed
hardware.

Ast currently blanks via sync-off bits in VGACRB6. Not all BMCs handle
VGACRB6 correctly. After disabling sync during a reboot, some BMCs do
not reenable it after the soft reset. The display output remains dark.
When the display is off during boot, some BMCs set the sync-off bits in
VGACRB6, so the display remains dark. Observed with  Blackbird AST2500
BMCs. Clearing the sync-off bits unconditionally fixes these issues.

Also do not modify VGASR1's SD bit for blanking, as it only disables GPU
access to video memory.

v2:
- init vgacrb6 correctly (Jocelyn)

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: ce3d99c83495 ("drm: Call drm_atomic_helper_shutdown() at shutdown time for misc drivers")
Tested-by: Nick Bowler <nbowler@draconx.ca>
Reported-by: Nick Bowler <nbowler@draconx.ca>
Closes: https://lore.kernel.org/dri-devel/wpwd7rit6t4mnu6kdqbtsnk5bhftgslio6e2jgkz6kgw6cuvvr@xbfswsczfqsi/
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Jocelyn Falempe <jfalempe@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v6.7+
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Link: https://lore.kernel.org/r/20251014084743.18242-1-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/ast/ast_mode.c |   18 ++++++++++--------
 drivers/gpu/drm/ast/ast_reg.h  |    1 +
 2 files changed, 11 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/ast/ast_mode.c
+++ b/drivers/gpu/drm/ast/ast_mode.c
@@ -836,22 +836,24 @@ ast_crtc_helper_atomic_flush(struct drm_
 static void ast_crtc_helper_atomic_enable(struct drm_crtc *crtc, struct drm_atomic_state *state)
 {
 	struct ast_device *ast = to_ast_device(crtc->dev);
+	u8 vgacr17 = 0x00;
+	u8 vgacrb6 = 0xff;
 
-	ast_set_index_reg_mask(ast, AST_IO_VGACRI, 0xb6, 0xfc, 0x00);
-	ast_set_index_reg_mask(ast, AST_IO_VGASRI, 0x01, 0xdf, 0x00);
+	vgacr17 |= AST_IO_VGACR17_SYNC_ENABLE;
+	vgacrb6 &= ~(AST_IO_VGACRB6_VSYNC_OFF | AST_IO_VGACRB6_HSYNC_OFF);
+
+	ast_set_index_reg_mask(ast, AST_IO_VGACRI, 0x17, 0x7f, vgacr17);
+	ast_set_index_reg_mask(ast, AST_IO_VGACRI, 0xb6, 0xfc, vgacrb6);
 }
 
 static void ast_crtc_helper_atomic_disable(struct drm_crtc *crtc, struct drm_atomic_state *state)
 {
 	struct drm_crtc_state *old_crtc_state = drm_atomic_get_old_crtc_state(state, crtc);
 	struct ast_device *ast = to_ast_device(crtc->dev);
-	u8 vgacrb6;
+	u8 vgacr17 = 0xff;
 
-	ast_set_index_reg_mask(ast, AST_IO_VGASRI, 0x01, 0xdf, AST_IO_VGASR1_SD);
-
-	vgacrb6 = AST_IO_VGACRB6_VSYNC_OFF |
-		  AST_IO_VGACRB6_HSYNC_OFF;
-	ast_set_index_reg_mask(ast, AST_IO_VGACRI, 0xb6, 0xfc, vgacrb6);
+	vgacr17 &= ~AST_IO_VGACR17_SYNC_ENABLE;
+	ast_set_index_reg_mask(ast, AST_IO_VGACRI, 0x17, 0x7f, vgacr17);
 
 	/*
 	 * HW cursors require the underlying primary plane and CRTC to
--- a/drivers/gpu/drm/ast/ast_reg.h
+++ b/drivers/gpu/drm/ast/ast_reg.h
@@ -29,6 +29,7 @@
 #define AST_IO_VGAGRI			(0x4E)
 
 #define AST_IO_VGACRI			(0x54)
+#define AST_IO_VGACR17_SYNC_ENABLE	BIT(7) /* called "Hardware reset" in docs */
 #define AST_IO_VGACR80_PASSWORD		(0xa8)
 #define AST_IO_VGACR99_VGAMEM_RSRV_MASK	GENMASK(1, 0)
 #define AST_IO_VGACRA1_VGAIO_DISABLED	BIT(1)


