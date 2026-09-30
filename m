Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369B23FA5F0;
	Wed, 30 Sep 2026 16:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785871; cv=none; b=XoYKcsqhb3jralcJsUYGyLP3EMRm5tYS0Jh+bCW9R8d5H0bvLV1sZu9GL8ffOdH0ZArZxvUFogb7BlUYV/uDG0EbJk4jOjdAcSOoJ1HldfAYWhuFDI8ZiVZM201vmz2YvCdbGpY2WVZVL5saPgFQIVAf3DtJWmPPk9BitF6KLdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785871; c=relaxed/simple;
	bh=l28emElvU+9WTb62QG+/ElmriFXSWVmmZaGSXSn6dh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HhMLKI+K10aQ0NCs5X6IrdrAzConlGpOMS6DQZSGNlWi11lik2Ceuc+CDSBmnW3f1xVMDXP9uVMXgkxc5h9/fjvioaDvv1JL5pbMrkVEUeDdv/Bl0W+5BbG7OtyQZoTo1PcFaTXlow87V/XVxhK/HxPhsruR+gO3aedqe8mbcwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uduIiVDf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uduIiVDf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856421F000FF;
	Wed, 30 Sep 2026 16:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785870;
	bh=gazKtYMOQmZtef2FUF8NwEOOX9lC6e77N1gg8ZNFOYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uduIiVDfCVYUSf2twR5dFDbwV5u7u0fo+/wOEsllBF6UuMWt+E7rPcTG5NQCp/wdB
	 qMzfvaBFob9S+9tcC9qVLWFI7XvpAmw0y7v7O85h92bVdnai60Ich0sel8u11WnQB5
	 UOUnKHWJvZ/YeVHZBN1CKeIxfI5n4Kwaaf7eTVKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 661/982] drm/ast: Remove little-endianism from I/O helpers
Date: Wed, 30 Sep 2026 17:23:17 +0200
Message-ID: <20260930152430.962707775@linuxfoundation.org>
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

[ Upstream commit a38410860628909712ea6a2becd42bab56c70e9a ]

Replace one call to ast_io_write16() with two calls to ast_io_write8()
in ast_set_index_reg(). The combined 16-bit-wide write of an index
register and the corresponding data register only works on little-
endian systems. Write both registers independent from each other.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230221155745.27484-2-tzimmermann@suse.de
Stable-dep-of: 073a30d75f30 ("drm/vc4: Use managed KMS polling to fix UAF on unbind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ast/ast_drv.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/ast/ast_drv.h b/drivers/gpu/drm/ast/ast_drv.h
index 2e44b971c3a6b..22328693fcf33 100644
--- a/drivers/gpu/drm/ast/ast_drv.h
+++ b/drivers/gpu/drm/ast/ast_drv.h
@@ -281,7 +281,9 @@ static inline void ast_set_index_reg(struct ast_private *ast,
 				     uint32_t base, uint8_t index,
 				     uint8_t val)
 {
-	ast_io_write16(ast, base, ((u16)val << 8) | index);
+	ast_io_write8(ast, base, index);
+	++base;
+	ast_io_write8(ast, base, val);
 }
 
 void ast_set_index_reg_mask(struct ast_private *ast,
-- 
2.53.0



