Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F40A14282
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GuHIK5Z0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD3AC433C8;
	Mon, 23 Oct 2023 11:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059417;
	bh=ccF55vvnzD55J2g/XN0nlOJuiErgZtgKPwTIc6E+dYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GuHIK5Z02RyFhdtoC869PDaUJlkzfUYHBQ0eFPUEir+h1rcC+yXhJClxh9ctGc3cq
	 z3HgNz5VhW02nKzjt9vdPHoffadW+nXwgrIoZODwStU8mutOIAqUayXCOtwPwI4WQc
	 YTPiv8eJok2ZdBT67iKeL/3tgHRr05gkkb9H6hW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.5 170/241] mtd: physmap-core: Restore map_rom fallback
Date: Mon, 23 Oct 2023 12:55:56 +0200
Message-ID: <20231023104838.025477710@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
 


