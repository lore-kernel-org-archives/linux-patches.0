Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFE21ED4F
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:38:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A34F7C433C9;
	Tue, 25 Jul 2023 11:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285114;
	bh=1B2/ENVi3YqbS/bvTH5rRPZHb3kKVd22BpbzDvr0LRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2JPo1bQjet6WNNyAh6VM1YHXnCpXXDCOwSK68INO3ck/ufW4fQokvwEikGCwoHb9r
	 pYSvky7A8Tccu2DGFZ8CyVX6+y+OiczkqNBJqX9U0bLOEtWFculeZA6TDtTB32q8qs
	 ddTMa56aYA3n+VKkOsKtFRKfbbqGQcuClKh+/Gbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 087/313] fbdev: omapfb: lcd_mipid: Fix an error handling path in mipid_spi_probe()
Date: Tue, 25 Jul 2023 12:44:00 +0200
Message-ID: <20230725104524.722470384@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
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
index a75ae0c9b14c7..d1cd8785d011d 100644
--- a/drivers/video/fbdev/omap/lcd_mipid.c
+++ b/drivers/video/fbdev/omap/lcd_mipid.c
@@ -563,11 +563,15 @@ static int mipid_spi_probe(struct spi_device *spi)
 
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
 
 static int mipid_spi_remove(struct spi_device *spi)
-- 
2.39.2



