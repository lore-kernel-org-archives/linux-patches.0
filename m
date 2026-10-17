Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019D0397929;
	Sat, 17 Oct 2026 16:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254236; cv=none; b=YQmlkIvUhl3Nk19W+IwleZ98gerlEZtAo/BroTFh12IMpVne9YPNTHUsWmVmwGVSENvfN/Z01ELSy/RV2nSiZgNmIADsD8jNX9p45VYsTgSFRuKtQTNpp8kXFapbo7OE3BhHiQ0F78IYeXUTy+MdGF5h6bHrVV6/s81mKpNszpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254236; c=relaxed/simple;
	bh=lzhmRn8yU5I/WBZr0ETPU4Djsx33sLnJqUoH4UObe04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ltdJPT8CeumougJc9LPcRIBlMC33riKaYkTLQuiorvKfthve7WBN4mcpV/fde5QTmalQqCZV0FORuFV1L5zyGYkVvc7f7QQee+MdXn8KoN5pF8yRhkS7hLof2j0uwI7AOXgYbr/MniKed8XCnh5GpAE9R9BTC3i97W2PU2cBukA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RnjujgkN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RnjujgkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA531F000C4;
	Sat, 17 Oct 2026 16:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254234;
	bh=p+BFmkqZ/CsYDsn5XdV0RkXwDIILqVaCUtddNDbA9f4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RnjujgkNPxwqjye+F2glIrXGOg+8e5Cw5JdHgt/W3BMtGdMsZF3EwOSRERwAFexy3
	 QZWgIzDvG7TBDp/qbTokox1bVH/F+WzMG4CoBLb1ITTLtn+03ppVKZoItLhE7b4Cgs
	 TijhpeW5NT4WeMYAPLNo3m44lMRfC3YHrbhasNLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 339/869] fbdev: omap2: fix use-after-free in omapfb_mmap
Date: Sat, 17 Oct 2026 17:53:00 +0200
Message-ID: <20261017160045.773923053@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Hongling Zeng <zenghongling@kylinos.cn>

[ Upstream commit 7958e67375aa111522086286bba13cfc0816ce8d ]

omapfb_mmap() has a race condition with OMAPFB_SETUP_PLANE ioctl that
can lead to use-after-free:

The fb_mmap() entry point holds mm_lock but not lock (fb_info->lock),
while ioctl handlers like OMAPFB_SETUP_PLANE hold lock but not mm_lock.
This allows concurrent execution.

In omapfb_mmap():
1. rg = omapfb_get_mem_region(ofbi->region);      // Get old region ref
2. start = omapfb_get_region_paddr(ofbi);          // Read from NEW region
3. len = fix->smem_len;                             // Read from NEW region
4. vm_iomap_memory(vma, start, len);               // Map NEW region memory
5. atomic_inc(&rg->map_count);                      // Increment OLD region!

Concurrently, OMAPFB_SETUP_PLANE can:
- Reassign ofbi->region = new_rg
- Update fix->smem_len
- OMAPFB_SETUP_MEM then checks NEW region's map_count (0!) and frees it

This leaves userspace with a mapping to freed physical memory.

The fix is to read all required values (start, len) from the same
region reference (rg) that will have its map_count incremented,
preventing the region from being freed while still mapped.

Cc: stable@vger.kernel.org
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/omap2/omapfb/omapfb-main.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/omap2/omapfb/omapfb-main.c b/drivers/video/fbdev/omap2/omapfb/omapfb-main.c
index 79688c2cc6d68..2b99a58ad6758 100644
--- a/drivers/video/fbdev/omap2/omapfb/omapfb-main.c
+++ b/drivers/video/fbdev/omap2/omapfb/omapfb-main.c
@@ -1099,7 +1099,11 @@ static int omapfb_mmap(struct fb_info *fbi, struct vm_area_struct *vma)
 
 	rg = omapfb_get_mem_region(ofbi->region);
 
-	start = omapfb_get_region_paddr(ofbi);
+	if (ofbi->rotation_type == OMAP_DSS_ROT_VRFB)
+		start = rg->vrfb.paddr[0];
+	else
+		start = rg->paddr;
+
 	len = fix->smem_len;
 
 	DBG("user mmap region start %lx, len %d, off %lx\n", start, len,
@@ -1109,6 +1113,8 @@ static int omapfb_mmap(struct fb_info *fbi, struct vm_area_struct *vma)
 	vma->vm_ops = &mmap_user_ops;
 	vma->vm_private_data = rg;
 
+	atomic_inc(&rg->map_count);
+
 	r = vm_iomap_memory(vma, start, len);
 	if (r)
 		goto error;
@@ -1121,6 +1127,7 @@ static int omapfb_mmap(struct fb_info *fbi, struct vm_area_struct *vma)
 	return 0;
 
 error:
+	atomic_dec(&rg->map_count);
 	omapfb_put_mem_region(rg);
 
 	return r;
-- 
2.53.0



