Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31CEF4086A;
	Tue, 11 Nov 2025 00:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822539; cv=none; b=F96YbrYtLoLDxblmra2Pjqg5X1ghxMd1AYSyjOHqgyksO+f8HxEyh/bxxmMPVza7BTuevQImy23o+ltIznK/V4/LFA0bTxvYD1nvxwcAH+NLuwkM4FVJOfS5y2H+s98syu4fgE8v6i0A2zU3mgklMw31UYXBSvqsD2l9IVbpefA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822539; c=relaxed/simple;
	bh=mLAbZWt94PTOtXEifTefyp2iBHzy6ZaQlw4nH2UfIu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dheFPslYUw0uXfh4pkwbd52xXlApv/A31oQ8OsegsGtQocNjtEEjzHPJcs/EqjhoeWs9vGC1isymik6fFq0vjlPgpI55/GDC74yrZU7j9h1hBI6h3YSfXjQwPbhy2gVQ5hjCXPlNtVDZM8Sw7O8bqcQEt7tIlfPpmkGtjBcr8cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fq4rwBXX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fq4rwBXX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA258C16AAE;
	Tue, 11 Nov 2025 00:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822539;
	bh=mLAbZWt94PTOtXEifTefyp2iBHzy6ZaQlw4nH2UfIu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fq4rwBXXOzy5dYN6xbkRAHehiILWv6pjO9aFk8u5tl1OXU/Br84rj4/kOzoIBJJGV
	 WMkj2gni2Rbl7p6Rcmw1DLiAbcKhUcKBaVS5nXW4NrKZ8m8rw67VTIK+GX2zCFe7bL
	 QXnzvbkdzjhBtzI31gXGFXC9B/n5Y+qdnZjGmjhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Peter Schneider <pschneider1968@googlemail.com>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Nick Bowler <nbowler@draconx.ca>,
	Douglas Anderson <dianders@chromium.org>,
	Dave Airlie <airlied@redhat.com>,
	dri-devel@lists.freedesktop.org
Subject: [PATCH 6.12 070/565] drm/ast: Clear preserved bits from register output value
Date: Tue, 11 Nov 2025 09:38:46 +0900
Message-ID: <20251111004528.526435608@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

commit a9fb41b5def8e1e0103d5fd1453787993587281e upstream.

Preserve the I/O register bits in __ast_write8_i_masked() as specified
by preserve_mask. Accidentally OR-ing the output value into these will
overwrite the register's previous settings.

Fixes display output on the AST2300, where the screen can go blank at
boot. The driver's original commit 312fec1405dd ("drm: Initial KMS
driver for AST (ASpeed Technologies) 2000 series (v2)") already added
the broken code. Commit 6f719373b943 ("drm/ast: Blank with VGACR17 sync
enable, always clear VGACRB6 sync off") triggered the bug.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reported-by: Peter Schneider <pschneider1968@googlemail.com>
Closes: https://lore.kernel.org/dri-devel/a40caf8e-58ad-4f9c-af7f-54f6f69c29bb@googlemail.com/
Tested-by: Peter Schneider <pschneider1968@googlemail.com>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Fixes: 6f719373b943 ("drm/ast: Blank with VGACR17 sync enable, always clear VGACRB6 sync off")
Fixes: 312fec1405dd ("drm: Initial KMS driver for AST (ASpeed Technologies) 2000 series (v2)")
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Nick Bowler <nbowler@draconx.ca>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Jocelyn Falempe <jfalempe@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v3.5+
Link: https://patch.msgid.link/20251024073626.129032-1-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/ast/ast_drv.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/ast/ast_drv.h
+++ b/drivers/gpu/drm/ast/ast_drv.h
@@ -286,13 +286,13 @@ static inline void __ast_write8_i(void _
 	__ast_write8(addr, reg + 1, val);
 }
 
-static inline void __ast_write8_i_masked(void __iomem *addr, u32 reg, u8 index, u8 read_mask,
+static inline void __ast_write8_i_masked(void __iomem *addr, u32 reg, u8 index, u8 preserve_mask,
 					 u8 val)
 {
-	u8 tmp = __ast_read8_i_masked(addr, reg, index, read_mask);
+	u8 tmp = __ast_read8_i_masked(addr, reg, index, preserve_mask);
 
-	tmp |= val;
-	__ast_write8_i(addr, reg, index, tmp);
+	val &= ~preserve_mask;
+	__ast_write8_i(addr, reg, index, tmp | val);
 }
 
 static inline u32 ast_read32(struct ast_device *ast, u32 reg)


