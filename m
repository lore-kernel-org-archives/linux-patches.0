Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861288F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:09:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A358C433C9;
	Sun, 16 Jul 2023 20:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538141;
	bh=HM7I7J9gI7XI2PQoDXi6SvCYdi0+HgYTc5gaRylWJfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=myXP4t0sbpHkcKAiGqEoUIUoygI5taJCOghTEnXL0kRdgxHtInnVLDBwdfDGP1Hpr
	 v+3RrAuikt0qF8nH4QeQx+katGeXwX4mFgsOkLkULrdKQcRHXcpC37iv69ktRhmZ5o
	 FHoOA2CRZgL3kLcXZkwoDd6aDFYOdQdlhbW6rEbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 344/800] fbdev: omapfb: lcd_mipid: Fix an error handling path in mipid_spi_probe()
Date: Sun, 16 Jul 2023 21:43:17 +0200
Message-ID: <20230716194957.071584013@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 79a3908d1ea6c35157a6d907b1a9d8ec06015e7a ]

If 'mipid_detect()' fails, we must free 'md' to avoid a memory leak.

Fixes: 66d2f99d0bb5 ("omapfb: add support for MIPI-DCS compatible LCDs")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/omap/lcd_mipid.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/omap/lcd_mipid.c b/drivers/video/fbdev/omap/lcd_mipid.c
index e4a7f0b824ff4..a0fc4570403b8 100644
--- a/drivers/video/fbdev/omap/lcd_mipid.c
+++ b/drivers/video/fbdev/omap/lcd_mipid.c
@@ -571,11 +571,15 @@ static int mipid_spi_probe(struct spi_device *spi)
 
 	r = mipid_detect(md);
 	if (r < 0)
-		return r;
+		goto free_md;
 
 	omapfb_register_panel(&md->panel);
 
 	return 0;
+
+free_md:
+	kfree(md);
+	return r;
 }
 
 static void mipid_spi_remove(struct spi_device *spi)
-- 
2.39.2



