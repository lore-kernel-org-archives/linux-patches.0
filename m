Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C2A44C97;
	Sun,  1 Sep 2024 16:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207688; cv=none; b=jYBi0eoYhwUHPPnkmoj/dRdWOWWIUf5jszzAlNPx5sGEybaa4dvvIRL3Oby9QxxvpjwDLEQwBlQwqKALIPQYRZCXfFnvxMjtQl02/+qza/VTDC9GZzo457K7oWf/z5uGQc4IaorKlztx/kvYm8P3D9jJ/lsTIgI1ElJjlt+PK/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207688; c=relaxed/simple;
	bh=5DLmwOKDQKfIfG1u8ccLyDiipZt/dhcQGuA/6Oml/LY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XCCjC626Dx6vOx2smiY8gF4Xvsdfe/A1nP8P5qJwFsVmqeZ8BErB91xCpFqXklhr3l6/JO/aXTLPnnIbepEUaiG52U6rmishM5epViMN1/u2tXA8RygL/3k73t7FDWyKWnnyBuqk9a8AH6J29a/1uFbkBmbEM5yAFNBq74pzBwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K7649IA9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K7649IA9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A5FC4CEC3;
	Sun,  1 Sep 2024 16:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207688;
	bh=5DLmwOKDQKfIfG1u8ccLyDiipZt/dhcQGuA/6Oml/LY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K7649IA91ynorX7h0igWo71W+f2WzpD2tGVDlI6tkEi/k+pqiIWGwgmiD1/e7ujzn
	 w59LWSlQd1SKU9stoMFm3aS4BpNEIb5Ya+TQ39Ebrife7K/NV2QNH9/hFKUCnujNQa
	 XjPMpIlbSRe5lisnDsdJriue7cMIrRNJLImdd9ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julia Lawall <julia.lawall@inria.fr>,
	Abdulrasaq Lawani <abdulrasaqolawani@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 47/98] fbdev: offb: replace of_node_put with __free(device_node)
Date: Sun,  1 Sep 2024 18:16:17 +0200
Message-ID: <20240901160805.474469928@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 77c0a2f45b3b9..b52c6080abe44 100644
--- a/drivers/video/fbdev/offb.c
+++ b/drivers/video/fbdev/offb.c
@@ -352,7 +352,7 @@ static void offb_init_palette_hacks(struct fb_info *info, struct device_node *dp
 			par->cmap_type = cmap_gxt2000;
 	} else if (dp && !strncmp(name, "vga,Display-", 12)) {
 		/* Look for AVIVO initialized by SLOF */
-		struct device_node *pciparent = of_get_parent(dp);
+		struct device_node *pciparent __free(device_node) = of_get_parent(dp);
 		const u32 *vid, *did;
 		vid = of_get_property(pciparent, "vendor-id", NULL);
 		did = of_get_property(pciparent, "device-id", NULL);
@@ -364,7 +364,6 @@ static void offb_init_palette_hacks(struct fb_info *info, struct device_node *dp
 			if (par->cmap_adr)
 				par->cmap_type = cmap_avivo;
 		}
-		of_node_put(pciparent);
 	} else if (dp && of_device_is_compatible(dp, "qemu,std-vga")) {
 #ifdef __BIG_ENDIAN
 		const __be32 io_of_addr[3] = { 0x01000000, 0x0, 0x0 };
-- 
2.43.0



