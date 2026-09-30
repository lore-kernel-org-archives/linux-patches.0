Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08C24F0526;
	Wed, 30 Sep 2026 16:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785874; cv=none; b=FfT9XpsHbsfYz9nPfcR7Bxzk7fIdoZ5ICzR5O0t2WyhwKhn8BeZt1ckzWhIn5CXmtH7w3BIQHkkzgn9AqL48K9h6l4XKqBGGOBFb7tuM92Pw7icqvAFtUiPnHdsspthq7/ecXSQgu0qI082aze6fN3L2Ec1+enF5imjy9fL5x6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785874; c=relaxed/simple;
	bh=TUbI3cJZ9zVX8f7+4d57MzN/gBXeeKpXCQZTf9z6P+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ufjN5CsyBIHeZdrZN0HDBjVp10UyUkQyaQwgxEKa1G/s04PwMSyByK3xihqRSVNNB+lQJoe/s/x9CykR7ROpSboOFC2WHHLIFqUimjPiMl/5hH1NIlF7EbDci/KZ6Mb0usBQD9curdQoZfQKe6hFTeN/vOvsuH1zmgQP4JlSE/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=In4NAGzV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="In4NAGzV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B1C1F000FF;
	Wed, 30 Sep 2026 16:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785872;
	bh=et55ssTLcAzbAhnJMslS9vfZdZqfu/De0MpkgnotcYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=In4NAGzV6UTGe7bsXH/ZeNRxvy/AjjW2pxQyh2/y6FPu2s6SyPT/WHX/aZpj3MpBV
	 G4jOC9wUnhbNKlXbpQhNzitOYxyxPTyAdoXIIJEsNxWv/y0Xg1NQEzjgQrczHsPo1F
	 U3qcdrql56jM0zxyw3L/LSHudz3kTrwJKr9QkrM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 662/982] drm/ast: Rework definition of I/O read and write helpers
Date: Wed, 30 Sep 2026 17:23:18 +0200
Message-ID: <20260930152430.984115558@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit faf67f640fa6c036d19727e294a2915e3fe5bf7c ]

Ast defines a number of I/O helpers for accessing hardware. Only 4 of
the many generated functions are actually used. Replace the respective
generator macros with those 4 functions. No functional changes.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230221155745.27484-3-tzimmermann@suse.de
Stable-dep-of: 073a30d75f30 ("drm/vc4: Use managed KMS polling to fix UAF on unbind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ast/ast_drv.h | 48 ++++++++++-------------------------
 1 file changed, 14 insertions(+), 34 deletions(-)

diff --git a/drivers/gpu/drm/ast/ast_drv.h b/drivers/gpu/drm/ast/ast_drv.h
index 22328693fcf33..58fcad3ba0dfb 100644
--- a/drivers/gpu/drm/ast/ast_drv.h
+++ b/drivers/gpu/drm/ast/ast_drv.h
@@ -237,45 +237,25 @@ struct ast_private *ast_device_create(const struct drm_driver *drv,
 #define AST_IO_VGACRCB_HWC_ENABLED     BIT(1)
 #define AST_IO_VGACRCB_HWC_16BPP       BIT(0) /* set: ARGB4444, cleared: 2bpp palette */
 
-#define __ast_read(x) \
-static inline u##x ast_read##x(struct ast_private *ast, u32 reg) { \
-u##x val = 0;\
-val = ioread##x(ast->regs + reg); \
-return val;\
+static inline u32 ast_read32(struct ast_private *ast, u32 reg)
+{
+	return ioread32(ast->regs + reg);
 }
 
-__ast_read(8);
-__ast_read(16);
-__ast_read(32)
-
-#define __ast_io_read(x) \
-static inline u##x ast_io_read##x(struct ast_private *ast, u32 reg) { \
-u##x val = 0;\
-val = ioread##x(ast->ioregs + reg); \
-return val;\
+static inline void ast_write32(struct ast_private *ast, u32 reg, u32 val)
+{
+	iowrite32(val, ast->regs + reg);
 }
 
-__ast_io_read(8);
-__ast_io_read(16);
-__ast_io_read(32);
-
-#define __ast_write(x) \
-static inline void ast_write##x(struct ast_private *ast, u32 reg, u##x val) {\
-	iowrite##x(val, ast->regs + reg);\
-	}
-
-__ast_write(8);
-__ast_write(16);
-__ast_write(32);
-
-#define __ast_io_write(x) \
-static inline void ast_io_write##x(struct ast_private *ast, u32 reg, u##x val) {\
-	iowrite##x(val, ast->ioregs + reg);\
-	}
+static inline u8 ast_io_read8(struct ast_private *ast, u32 reg)
+{
+	return ioread8(ast->ioregs + reg);
+}
 
-__ast_io_write(8);
-__ast_io_write(16);
-#undef __ast_io_write
+static inline void ast_io_write8(struct ast_private *ast, u32 reg, u8 val)
+{
+	iowrite8(val, ast->ioregs + reg);
+}
 
 static inline void ast_set_index_reg(struct ast_private *ast,
 				     uint32_t base, uint8_t index,
-- 
2.53.0



