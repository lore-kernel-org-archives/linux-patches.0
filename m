Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DAF42B9C7;
	Sun,  1 Sep 2024 16:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208883; cv=none; b=nK6XcexQzYfIvPpP6mRusfyzzR+M0L70WHHJ8SfLtbZD6LZPHMiPX+QTRQ3yY0vNvz0UWm/c8milo8qtASXu7gjLhA5LARpvhT8uaMK4K7uUYNRD1QVYf6aLzEF/9VTyQrC2UlE2vPeMB6A0novPmVi91snKy9xIRss8w+fJ3M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208883; c=relaxed/simple;
	bh=2gHaTqrQ85LQDG6wnG8s7Ush25NZzPg/OIeRtgFtn7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l16Z7CDZDNhAGO73cQ8yqlqHrJmY6GSsZQayJ9KrRi78HSDgGHTj1SvSXeJXbH9AyIAoicQ5fvTRWqRmX2gCcPsTTXzv20MKyhsCqvsGZEduj67mXjJ8rQ4Qw0iesIntcxzmGZuSe10pS/l9vhZo0B7FhUbSze10GD2CFxzBA6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=STYKd3Tr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="STYKd3Tr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6CDC4CEC3;
	Sun,  1 Sep 2024 16:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208883;
	bh=2gHaTqrQ85LQDG6wnG8s7Ush25NZzPg/OIeRtgFtn7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=STYKd3TrnwCMDP/IKm2jXyYfgnKx8Tx3YjVkE5Pl4FkKF+TEddKml2SdVMTtXpqO/
	 ImPYs+I8HvuvM7QywB3MWJX5B7mKy7PL+tt8KakqRvKLaj5HMYvLLeAbQ9ZzKeG/Xb
	 UhX11o0o4VtjWZkvsmVca3zRibXPgpKiXj8p0fJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julia Lawall <julia.lawall@inria.fr>,
	Abdulrasaq Lawani <abdulrasaqolawani@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 069/134] fbdev: offb: replace of_node_put with __free(device_node)
Date: Sun,  1 Sep 2024 18:16:55 +0200
Message-ID: <20240901160812.697636134@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index fbc6eafb63c77..fcff3601b05cc 100644
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



