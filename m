Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512BE321F48;
	Mon, 27 Oct 2025 19:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593468; cv=none; b=nHA8g2OmG1noy1CcFzWgWFYNrKLHkpnMfux2Taa9vkd0Mv2EBgz8F4RQTKmaV0rLy4WOoLTrurhnn+wc3BwDNP2+csPyetcd2PTaFP/KC0rfvIN5/FcwP0KFdqBHqngSNzr1xO6b6vlenQZGNy/5Oc6Fyzh3+624dpgmjLVShjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593468; c=relaxed/simple;
	bh=WHZD+THu76bUh2NkrWDx2xcoWpWpsanBcB9FTbxUt3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LJil/38+E1nyAg8UTIP3vbouOsafLpKNDfXsMB0KEzu48vAuehd4Ml5hga97T6/jd6u42AnJH03livLdwoXoht6d2NYUmsq3fzL34y21Maou3E7dZgbquZp2exkonAJULV4JEuX3WxcnjANHFloCXOjB12rOhlF5JltSC6n2tjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qDgv/Vy9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qDgv/Vy9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E16CC4CEF1;
	Mon, 27 Oct 2025 19:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593467;
	bh=WHZD+THu76bUh2NkrWDx2xcoWpWpsanBcB9FTbxUt3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qDgv/Vy9HR8m/y7UaAokn3FvKtWE9THzfZyh+PZDUEYLSFhEFVWaoRyOkM5jyLXFB
	 vnJP1hBM1i843kSe6riWsJ1eQOQaGTvm8MTnlFk18SeomjrQoy8GwA42cmjhQVzCPb
	 mpH9saTEGTL2t/JAsnBpNaNgrJQqeZk6gaKTU6i4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Martinez Canillas <javierm@redhat.com>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 142/184] drm/panic: Fix 24bit pixel crossing page boundaries
Date: Mon, 27 Oct 2025 19:37:04 +0100
Message-ID: <20251027183518.765987060@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

From: Jocelyn Falempe <jfalempe@redhat.com>

[ Upstream commit 23437509a69476d4f896891032d62ac868731668 ]

When using page list framebuffer, and using RGB888 format, some
pixels can cross the page boundaries, and this case was not handled,
leading to writing 1 or 2 bytes on the next virtual address.

Add a check and a specific function to handle this case.

Fixes: c9ff2808790f0 ("drm/panic: Add support to scanout buffer as array of pages")
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://lore.kernel.org/r/20251009122955.562888-7-jfalempe@redhat.com
Signed-off-by: Jocelyn Falempe <jfalempe@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panic.c | 46 +++++++++++++++++++++++++++++++++++--
 1 file changed, 44 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_panic.c b/drivers/gpu/drm/drm_panic.c
index 1bc15c44207b4..f52752880e1c9 100644
--- a/drivers/gpu/drm/drm_panic.c
+++ b/drivers/gpu/drm/drm_panic.c
@@ -174,6 +174,33 @@ static void drm_panic_write_pixel24(void *vaddr, unsigned int offset, u32 color)
 	*p = color & 0xff;
 }
 
+/*
+ * Special case if the pixel crosses page boundaries
+ */
+static void drm_panic_write_pixel24_xpage(void *vaddr, struct page *next_page,
+					  unsigned int offset, u32 color)
+{
+	u8 *vaddr2;
+	u8 *p = vaddr + offset;
+
+	vaddr2 = kmap_local_page_try_from_panic(next_page);
+
+	*p++ = color & 0xff;
+	color >>= 8;
+
+	if (offset == PAGE_SIZE - 1)
+		p = vaddr2;
+
+	*p++ = color & 0xff;
+	color >>= 8;
+
+	if (offset == PAGE_SIZE - 2)
+		p = vaddr2;
+
+	*p = color & 0xff;
+	kunmap_local(vaddr2);
+}
+
 static void drm_panic_write_pixel32(void *vaddr, unsigned int offset, u32 color)
 {
 	u32 *p = vaddr + offset;
@@ -231,7 +258,14 @@ static void drm_panic_blit_page(struct page **pages, unsigned int dpitch,
 					page = new_page;
 					vaddr = kmap_local_page_try_from_panic(pages[page]);
 				}
-				if (vaddr)
+				if (!vaddr)
+					continue;
+
+				// Special case for 24bit, as a pixel might cross page boundaries
+				if (cpp == 3 && offset + 3 > PAGE_SIZE)
+					drm_panic_write_pixel24_xpage(vaddr, pages[page + 1],
+								      offset, fg32);
+				else
 					drm_panic_write_pixel(vaddr, offset, fg32, cpp);
 			}
 		}
@@ -321,7 +355,15 @@ static void drm_panic_fill_page(struct page **pages, unsigned int dpitch,
 				page = new_page;
 				vaddr = kmap_local_page_try_from_panic(pages[page]);
 			}
-			drm_panic_write_pixel(vaddr, offset, color, cpp);
+			if (!vaddr)
+				continue;
+
+			// Special case for 24bit, as a pixel might cross page boundaries
+			if (cpp == 3 && offset + 3 > PAGE_SIZE)
+				drm_panic_write_pixel24_xpage(vaddr, pages[page + 1],
+							      offset, color);
+			else
+				drm_panic_write_pixel(vaddr, offset, color, cpp);
 		}
 	}
 	if (vaddr)
-- 
2.51.0



