Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE0F4086A;
	Tue, 11 Nov 2025 00:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822426; cv=none; b=n8ZjIfLcPpnEYOOeuFM/0PfBYZlEx8dkPtFhgyue85FHxGCDN+JM0GswF76WZiDeKdiRT/YK/pyrDaukNUenQPVppT86E8j3sB22NGaKu8CHnWs0VU+QnTs/dS+P/vfL04fB3qZXuMqwvSBmNjVVSEWac+PwVZSGHhKyISbFElQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822426; c=relaxed/simple;
	bh=kRavFmBcNnNUBWeEZFiNAvVT6t5ZefIdV4zOY2VFu+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQfZlcZ4BYW6bzFB+tgXkmLj9a+TJJ+ObiL5UvqUGPhdKGwAffNqGZ3qZNEPKG27NNrggXQZLftdBNb2+0iuRWWLDMlaAc5ms0YBe3o4sWs3dAWRjb69bEjfsEUn0aP1oeB/VWi5YANqmGSisa/4CmGJ2mlrpX8FLzGOyb+Mvk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LJZvAgs2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LJZvAgs2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89222C4CEFB;
	Tue, 11 Nov 2025 00:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822425;
	bh=kRavFmBcNnNUBWeEZFiNAvVT6t5ZefIdV4zOY2VFu+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LJZvAgs2jwZ41KUg1oR9PVTBA4qQjSpw4qzuFwWd6Ok9biqbS2/MYfX3AW8VdbqsT
	 VYOJptyt7xn22D5lpWERsPp/nV601jv0i5lbQeHufiB12ZayukB1q0Mhg0V3HxuGfn
	 eSEbW3uF2B6J7klgHbYYSrBZcIVT2DKT3RbrTnpo=
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
Subject: [PATCH 6.17 105/849] drm/ast: Clear preserved bits from register output value
Date: Tue, 11 Nov 2025 09:34:35 +0900
Message-ID: <20251111004538.940185021@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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
@@ -284,13 +284,13 @@ static inline void __ast_write8_i(void _
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


