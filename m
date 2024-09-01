Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689AC17C;
	Sun,  1 Sep 2024 17:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210206; cv=none; b=R5fTEu6Wd+ZTqEG5V/QmHMP53RwowdSiC6h8U+fIjx8HZCV76hkGVWk2mGsTrmNg+eoTv09vReBhR7o6ts6MsbcIUHfwcCCd+4Dar+trsSW1vJ3h2oCygxlZvi14m0KABEg+tFW/xBr/DzawfXfts8o4j/n7yvd+EiuUS7m3JZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210206; c=relaxed/simple;
	bh=+eR23HIqlZIqADekeVtm4+x/E41IeeKmIDhckyjH29U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kskXQJ2r/0MyjYifQAAligzDkK4XRwqmA0YFIcwE6R0pbEXj9ck9NZ4G3wmUIVaSKKOzPhazjBI5a4/DubQo2Us+AO0KSm3I1P8pHidycfcux1wzCZP+H+EvLiG0Xt4eGQEkMRRQzUgY5KN+5AyYlBEhaEvdu+IyoRHe2dOCOVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OOMLJ4Iy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OOMLJ4Iy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79555C4CEC3;
	Sun,  1 Sep 2024 17:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210206;
	bh=+eR23HIqlZIqADekeVtm4+x/E41IeeKmIDhckyjH29U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OOMLJ4Iy0eSBwUqSC3BFbZBorVSighvYBqY5dh4pJSgg+WI8x8rFBmE73B7xIWBdi
	 Qmc4t2qMq43GGojzAL0IFMTg1F+i5lmBYY9xbFaChJPdUvj214qn2leJOE1QXZhSeW
	 kvOvR5z+QgpyWsYe6eXTGagQRMKeHtQtwJ3+TI0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julia Lawall <julia.lawall@inria.fr>,
	Abdulrasaq Lawani <abdulrasaqolawani@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 103/215] fbdev: offb: replace of_node_put with __free(device_node)
Date: Sun,  1 Sep 2024 18:16:55 +0200
Message-ID: <20240901160827.241975147@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

From: Abdulrasaq Lawani <abdulrasaqolawani@gmail.com>

[ Upstream commit ce4a7ae84a58b9f33aae8d6c769b3c94f3d5ce76 ]

Replaced instance of of_node_put with __free(device_node)
to simplify code and protect against any memory leaks
due to future changes in the control flow.

Suggested-by: Julia Lawall <julia.lawall@inria.fr>
Signed-off-by: Abdulrasaq Lawani <abdulrasaqolawani@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/offb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/offb.c b/drivers/video/fbdev/offb.c
index 4501e848a36f2..766adaf2618c5 100644
--- a/drivers/video/fbdev/offb.c
+++ b/drivers/video/fbdev/offb.c
@@ -354,7 +354,7 @@ static void offb_init_palette_hacks(struct fb_info *info, struct device_node *dp
 			par->cmap_type = cmap_gxt2000;
 	} else if (of_node_name_prefix(dp, "vga,Display-")) {
 		/* Look for AVIVO initialized by SLOF */
-		struct device_node *pciparent = of_get_parent(dp);
+		struct device_node *pciparent __free(device_node) = of_get_parent(dp);
 		const u32 *vid, *did;
 		vid = of_get_property(pciparent, "vendor-id", NULL);
 		did = of_get_property(pciparent, "device-id", NULL);
@@ -366,7 +366,6 @@ static void offb_init_palette_hacks(struct fb_info *info, struct device_node *dp
 			if (par->cmap_adr)
 				par->cmap_type = cmap_avivo;
 		}
-		of_node_put(pciparent);
 	} else if (dp && of_device_is_compatible(dp, "qemu,std-vga")) {
 #ifdef __BIG_ENDIAN
 		const __be32 io_of_addr[3] = { 0x01000000, 0x0, 0x0 };
-- 
2.43.0



