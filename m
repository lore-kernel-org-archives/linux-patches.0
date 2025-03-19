Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7343C1C5F2D;
	Wed, 19 Mar 2025 14:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394841; cv=none; b=LVZNaX52lgm4oRIRVJO3hpXzeWsIzlyF5ZiQqNvOqhS6ezOzGEik+PkPA39gJyqCu2pdM13ju/qWUaeiwRmR+8xIsOoIWMIVJw+fmfXOHELUE9DW5/kHDvijizuSg3EljD6UhuWf+ErX+ULhh8TwQ6uEbSrABr+pL3ojavLfbPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394841; c=relaxed/simple;
	bh=t3A4g2aulZ0x8oGGyqXjKhk2dvekxmLCZF6g7m4P4Kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CvmNv0HLi2ufGKJgsI9Ps5AuFEPCXC0LTqXZ2T/P6kUVfFFFhe5D4w7kV9fEXe5EQrKemeIyrR0O1hn9SeCZjvs91W5McBk0FWgIFRj/orbIWcYPBFylsVWMX1sggsEashEYuVCkoC7FS8lzu2CqK+H8Y3Ayz5cg2U46eVnGq5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xhpPFsmw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xhpPFsmw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47B6DC4CEE4;
	Wed, 19 Mar 2025 14:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394841;
	bh=t3A4g2aulZ0x8oGGyqXjKhk2dvekxmLCZF6g7m4P4Kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xhpPFsmwcD0HhekHHJ431NOJp3/iV0zoUXBxwTrmEF+z/KKEg2FSCgZ8a61sNKWQM
	 1EBnGLDCZjUFZfFt0OvQVskdHVxBVA3Y6iY0f0oLQYeuNKAFhOJhjG1k9z8q48i+Hy
	 jKgnN7P+qtEfZrPhQGPX4Af1na6yQdMBe4N+z2lE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Saurabh Sengar <ssengar@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 005/241] fbdev: hyperv_fb: iounmap() the correct memory when removing a device
Date: Wed, 19 Mar 2025 07:27:55 -0700
Message-ID: <20250319143027.829392949@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Kelley <mhklinux@outlook.com>

[ Upstream commit 7241c886a71797cc51efc6fadec7076fcf6435c2 ]

When a Hyper-V framebuffer device is removed, or the driver is unbound
from a device, any allocated and/or mapped memory must be released. In
particular, MMIO address space that was mapped to the framebuffer must
be unmapped. Current code unmaps the wrong address, resulting in an
error like:

[ 4093.980597] iounmap: bad address 00000000c936c05c

followed by a stack dump.

Commit d21987d709e8 ("video: hyperv: hyperv_fb: Support deferred IO for
Hyper-V frame buffer driver") changed the kind of address stored in
info->screen_base, and the iounmap() call in hvfb_putmem() was not
updated accordingly.

Fix this by updating hvfb_putmem() to unmap the correct address.

Fixes: d21987d709e8 ("video: hyperv: hyperv_fb: Support deferred IO for Hyper-V frame buffer driver")
Signed-off-by: Michael Kelley <mhklinux@outlook.com>
Reviewed-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Link: https://lore.kernel.org/r/20250209235252.2987-1-mhklinux@outlook.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Message-ID: <20250209235252.2987-1-mhklinux@outlook.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/hyperv_fb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/hyperv_fb.c b/drivers/video/fbdev/hyperv_fb.c
index 7fdb5edd7e2e8..363e4ccfcdb77 100644
--- a/drivers/video/fbdev/hyperv_fb.c
+++ b/drivers/video/fbdev/hyperv_fb.c
@@ -1080,7 +1080,7 @@ static void hvfb_putmem(struct hv_device *hdev, struct fb_info *info)
 
 	if (par->need_docopy) {
 		vfree(par->dio_vp);
-		iounmap(info->screen_base);
+		iounmap(par->mmio_vp);
 		vmbus_free_mmio(par->mem->start, screen_fb_size);
 	} else {
 		hvfb_release_phymem(hdev, info->fix.smem_start,
-- 
2.39.5



