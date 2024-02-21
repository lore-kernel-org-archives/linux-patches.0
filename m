Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8FA055E5E;
	Wed, 21 Feb 2024 13:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523559; cv=none; b=GCaXS3AI1h9ulSA/HoYuOknG9ODh1Buw3wyfQMnaPyG4Z8BkB0tU8mL9ER8JZSdd1L1piJfJ/o8fRHQCjVvH+Kk5jUL8hpEn3dZ43O7vleHvL7YvhTgib20DAGl1q646c6/N9VfDfM87IX+ScuiWVcGY7zdz9Iloqs4SWlvDEoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523559; c=relaxed/simple;
	bh=BLeOqfWCCe2wFULvUWu98wjX6A17RUvv2qRnANY+c8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JuoKZyYqx0CKWvmJx1fqevdhmI8sdNpmIsONtucocAVudgX9PhdTZSEM+km7TWz9rp4SXjuOGIY9s79NZ3clyeTMOippYi6OSnMJzFQfX1gW8HqTm2s32OfYDx+IiOfqMuH9MYIYE6pt+Fre0P7ox7Ugd3Y0E3S9e5a8BKSx9nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YT4F6z4x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YT4F6z4x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A90C43390;
	Wed, 21 Feb 2024 13:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523558;
	bh=BLeOqfWCCe2wFULvUWu98wjX6A17RUvv2qRnANY+c8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YT4F6z4xbjguJvjsU8rWFvTb24OQkmJarzQ8JWvnH1K4u5V6vcTJy1tUcMU0S2Z67
	 RGHS8ZeJbdnkls+PMJeCOB25uViPVMG90Ib6k5pzPtZFqwWvRIpGmVaylmMVH1rG1K
	 oudYCNWjQ/pYFb9YTtRkSOuqKemXeyO1Y+nF9OjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Suti <peter.suti@streamunlimited.com>
Subject: [PATCH 5.15 472/476] staging: fbtft: core: set smem_len before fb_deferred_io_init call
Date: Wed, 21 Feb 2024 14:08:43 +0100
Message-ID: <20240221130025.447181560@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Suti <peter.suti@streamunlimited.com>

commit 81e878887ff82a7dd42f22951391069a5d520627 upstream.

The fbtft_framebuffer_alloc() calls fb_deferred_io_init() before
initializing info->fix.smem_len.  It is set to zero by the
framebuffer_alloc() function.  It will trigger a WARN_ON() at the
start of fb_deferred_io_init() and the function will not do anything.

Fixes: 856082f021a2 ("fbdev: defio: fix the pagelist corruption")
Signed-off-by: Peter Suti <peter.suti@streamunlimited.com>
Link: https://lore.kernel.org/r/20220727073550.1491126-1-peter.suti@streamunlimited.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/fbtft/fbtft-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/fbtft/fbtft-core.c
+++ b/drivers/staging/fbtft/fbtft-core.c
@@ -657,7 +657,6 @@ struct fb_info *fbtft_framebuffer_alloc(
 	fbdefio->delay =            HZ / fps;
 	fbdefio->sort_pagereflist = true;
 	fbdefio->deferred_io =      fbtft_deferred_io;
-	fb_deferred_io_init(info);
 
 	snprintf(info->fix.id, sizeof(info->fix.id), "%s", dev->driver->name);
 	info->fix.type =           FB_TYPE_PACKED_PIXELS;
@@ -668,6 +667,7 @@ struct fb_info *fbtft_framebuffer_alloc(
 	info->fix.line_length =    width * bpp / 8;
 	info->fix.accel =          FB_ACCEL_NONE;
 	info->fix.smem_len =       vmem_size;
+	fb_deferred_io_init(info);
 
 	info->var.rotate =         pdata->rotate;
 	info->var.xres =           width;


