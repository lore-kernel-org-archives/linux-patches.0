Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5ACF125BF
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MY5uwiS8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405CEC433C8;
	Mon, 23 Oct 2023 11:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060362;
	bh=8GumJjW4J3X87KKWs4CwsX8+L04VFPwAMzh3B27mHJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MY5uwiS8J0mhhM7PpRXIma/cjXDSrUBlSEfFkJqQsz/R1RjXb0Tj8lrSKZPsNs6LN
	 79lVAluXHyOC1MK6uSjUCm4P8j7LiDwLITJwdecgGLulixUkd0489ulHZunpd8/4Q+
	 Bt1aauIFvGOZfR70ONSmSnu6HDMD1YxQbo8A/DTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.1 147/196] mtd: physmap-core: Restore map_rom fallback
Date: Mon, 23 Oct 2023 12:56:52 +0200
Message-ID: <20231023104832.636689454@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 6792b7fce610bcd1cf3e07af3607fe7e2c38c1d8 upstream.

When the exact mapping type driver was not available, the old
physmap_of_core driver fell back to mapping the region as ROM.
Unfortunately this feature was lost when the DT and pdata cases were
merged.  Revive this useful feature.

Fixes: 642b1e8dbed7bbbf ("mtd: maps: Merge physmap_of.c into physmap-core.c")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/550e8c8c1da4c4baeb3d71ff79b14a18d4194f9e.1693407371.git.geert+renesas@glider.be
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/maps/physmap-core.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/mtd/maps/physmap-core.c
+++ b/drivers/mtd/maps/physmap-core.c
@@ -552,6 +552,17 @@ static int physmap_flash_probe(struct pl
 		if (info->probe_type) {
 			info->mtds[i] = do_map_probe(info->probe_type,
 						     &info->maps[i]);
+
+			/* Fall back to mapping region as ROM */
+			if (!info->mtds[i] && IS_ENABLED(CONFIG_MTD_ROM) &&
+			    strcmp(info->probe_type, "map_rom")) {
+				dev_warn(&dev->dev,
+					 "map_probe() failed for type %s\n",
+					 info->probe_type);
+
+				info->mtds[i] = do_map_probe("map_rom",
+							     &info->maps[i]);
+			}
 		} else {
 			int j;
 


