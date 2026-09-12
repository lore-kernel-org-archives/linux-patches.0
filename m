Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3A8282F1B;
	Sat, 12 Sep 2026 07:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199067; cv=none; b=BysvL4iROS0sTXgsB4TOWlCINyNamRE3TZoDP/EqUuoSoMcm3/hOIm/j/GWTE6BiV2NrZ11oDzbddzYSKWrfyQhFPjBqSQhBmLY69a+0PH7zHRineOtGZqk3X/0S5wEpIj0ZEPRUFHqhadPxZY27PnXZazXy9wdUVW5yBSIiRAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199067; c=relaxed/simple;
	bh=V+fbCm8qOnfS4cZw8HQ2F9MCi2O00mtA7XRZhl+ibDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fhuPqGFz1DkBrHKT+66w+QWDROyVnm+BJQaZOAj7hCQWkMdTX040SSC+76dHE3kcJ4za0T5vURuOrofCgs6MHfXlERMBQNX2O92a6FZpBufmH/uchvBYHPWx++FhOQifgsP3/6fw2WAGpF2/hGAQQ0yMDFmxASWZCj5vQbOLNbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PmwkF2D3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PmwkF2D3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E10E1F000FF;
	Sat, 12 Sep 2026 07:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199065;
	bh=iqH5SBGZYKfd7D1bDLODhdXzWfVFntxqt40H5kPIYzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PmwkF2D3O/tEHtsC0ySvuLGhOnUrCAGCidXlUBOZqb4NUQKNQ6o+Izm4/xsjl3qpi
	 otmjG3uGMht34u5cBEYgphrbmWIB0BR73ETpcpo7TGiZKoTpJKJlLMIY+0+gtKsQAL
	 EGaIQGgudl0y8TfIRwHrAds/7NfYgxsA2n7gokrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0510/1815] mtd: mtdswap: Avoid freeing registered blktrans device twice
Date: Sat, 12 Sep 2026 08:37:40 +0200
Message-ID: <20260912065700.862182409@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 779aa4c66a96bf43d2d62982ea1a9096a9128d87 ]

In mtdswap_add_mtd(), debugfs setup failure after successful blktrans
registration can free mbd_dev twice.

add_mtd_blktrans_dev() initializes the blktrans device reference and
publishes the disk. Once that succeeds, del_mtd_blktrans_dev() tears the
disk down and drops the blktrans reference; when that reference reaches
zero, blktrans_dev_release() frees the mtd_blktrans_dev.

The debugfs failure path called del_mtd_blktrans_dev(mbd_dev), then fell
through the common cleanup label and called kfree(mbd_dev) again. Clear
the local pointer after deregistration so the common cleanup can still
release the mtdswap state without freeing the blktrans object twice.

This issue was found by a static analysis checker and confirmed by
manual source review.

Fixes: e8e3edb95ce6 ("mtd: create per-device and module-scope debugfs entries")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdswap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/mtdswap.c b/drivers/mtd/mtdswap.c
index f33f753f0a9fd..92e38ece89317 100644
--- a/drivers/mtd/mtdswap.c
+++ b/drivers/mtd/mtdswap.c
@@ -1452,6 +1452,7 @@ static void mtdswap_add_mtd(struct mtd_blktrans_ops *tr, struct mtd_info *mtd)
 
 debugfs_failed:
 	del_mtd_blktrans_dev(mbd_dev);
+	mbd_dev = NULL;
 
 cleanup:
 	mtdswap_cleanup(d);
-- 
2.53.0



