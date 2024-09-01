Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2E718132A;
	Sun,  1 Sep 2024 16:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209567; cv=none; b=gNiydjuLy0CLvV/wAzGXiGwSkZ3Ttz0VzI9Wfg8s4LgYxfCnLFeMOSvIJA2zY9qIf+z4DnfbNXb7NoTwllkPjcgEhTVIfhYuJL2MTWWTaP1XVnmHgstG2GBiTjA7F9YHl6xcI8kZb49Ilo+8SyMO3Oh6SIpGnOCvS7H1YfYFWKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209567; c=relaxed/simple;
	bh=X8HNeRxA+Igz2PfPXE+B7HKQzfPkYArTVNwXTNT08VI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lIlqejaJzkY2EojMpDDyRuwVyTRqKDT/b6jLO71C49O8hs8CrUtcPmy0ccHELOFuSKE4RD4Ln1U/D4zcrfvNKnbqNhgKoEUWKFCFmXbTQv7b+tA8Z5DuH/iYgdwooCTcb/hytE8QfltVGZdHEz37Qdc77U98SBoQf1LtvNghux4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xlHhbzxB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xlHhbzxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59DE4C4CEC3;
	Sun,  1 Sep 2024 16:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209566;
	bh=X8HNeRxA+Igz2PfPXE+B7HKQzfPkYArTVNwXTNT08VI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xlHhbzxBEy8k/Vz8JhinmE2fDtxaTHAOkK3epa9wC4HkwkR78iCd50JTjZwC8O1sS
	 558GkWUSGNEGksFrTHe0TeJcHAKZZCIxOIWrJYR4eSFX9Gq0Br6Gj3+SYz2y330/Qw
	 7JAFwJB5vsqHUN2KGJ9z2j7/mAwGOU8XMa4GdYxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julia Lawall <julia.lawall@inria.fr>,
	Abdulrasaq Lawani <abdulrasaqolawani@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 077/151] fbdev: offb: replace of_node_put with __free(device_node)
Date: Sun,  1 Sep 2024 18:17:17 +0200
Message-ID: <20240901160817.010844858@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



