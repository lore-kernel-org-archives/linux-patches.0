Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8A04FD7A9;
	Thu, 17 Sep 2026 17:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667320; cv=none; b=XtPB2IO0+H6DIwZMhcEvkyM+4nqPkx+29enV+RSM2q7QBwIzC/xZkniUOmUcHLmJqCZ32z6rLdTGeHEfJ94UBoQ4Co+hwQqRCXyCeoONJtEFw2bBV4iQkwe6RhRdZLNtim0JhtzqNGAN6vq+CQniggOjAv2oyzpfgzP/aP7gZUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667320; c=relaxed/simple;
	bh=5fRJU8hsm/H7mLmIFgXheCx3IdtfWF6RJmkfvE2HNQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LI0SXZvV6MWxTmKRobMF2l3oomX40x/GDW2z0yH/RYDvdMHrTUEKwHy/Hn1CjEn47etvRDcvpxr31rHGBQTLB8emo+Q7iIZvuyEVViD24f43uH6N8cuO5vpkS3H55LoyThz+7X5hjwHf26hD5PzAkKhWNKMxNT3j6mS+xJokZeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1U0Bq30F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1U0Bq30F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D51321F000FF;
	Thu, 17 Sep 2026 17:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667319;
	bh=xjdCwjvExyVJN2qsd9FVhSvq5hrFz64MBK8JFGIXifA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1U0Bq30F7zuFNeWP/enNVRzmTcPWid2eABy8LOdXGGPWTBNtC+kztgE1JdufamvfV
	 GFmMBYZZqfVq5bYS2IZqqI0q0qOq64YZgrvncJNnB1C2gTZCyD6NZDeeqymZX9wJ3N
	 EzL/N2OQV0cv09giEjZq6xwKeYmqbid41gwnIDco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0054/1102] crypto: omap - add omap_des_unregister_algs helper
Date: Thu, 17 Sep 2026 15:59:57 +0100
Message-ID: <20260917151540.806764855@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit 9ab1392b1163daab674484d6ddacf16f0ad4c040 ]

Add a new helper omap_des_unregister_algs() and replace two for loops in
omap_des_probe() and omap_des_remove(), which also ensure ->registered
is reset to 0.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/omap-des.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index 209d3dc03a9bc..d2c016eafd46b 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -946,6 +946,20 @@ static int omap_des_get_pdev(struct omap_des_dev *dd,
 	return 0;
 }
 
+static void omap_des_unregister_algs(const struct omap_des_pdata *pdata)
+{
+	struct omap_des_algs_info *alg_info;
+	int i;
+
+	for (i = pdata->algs_info_size - 1; i >= 0; i--) {
+		alg_info = &pdata->algs_info[i];
+
+		crypto_engine_unregister_skciphers(alg_info->algs_list,
+						   alg_info->registered);
+		alg_info->registered = 0;
+	}
+}
+
 static int omap_des_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -1051,11 +1065,7 @@ static int omap_des_probe(struct platform_device *pdev)
 	return 0;
 
 err_algs:
-	for (i = dd->pdata->algs_info_size - 1; i >= 0; i--)
-		for (j = dd->pdata->algs_info[i].registered - 1; j >= 0; j--)
-			crypto_engine_unregister_skcipher(
-					&dd->pdata->algs_info[i].algs_list[j]);
-
+	omap_des_unregister_algs(dd->pdata);
 err_engine:
 	if (dd->engine)
 		crypto_engine_exit(dd->engine);
@@ -1075,16 +1085,12 @@ static int omap_des_probe(struct platform_device *pdev)
 static void omap_des_remove(struct platform_device *pdev)
 {
 	struct omap_des_dev *dd = platform_get_drvdata(pdev);
-	int i, j;
 
 	spin_lock_bh(&list_lock);
 	list_del(&dd->list);
 	spin_unlock_bh(&list_lock);
 
-	for (i = dd->pdata->algs_info_size - 1; i >= 0; i--)
-		for (j = dd->pdata->algs_info[i].registered - 1; j >= 0; j--)
-			crypto_engine_unregister_skcipher(
-					&dd->pdata->algs_info[i].algs_list[j]);
+	omap_des_unregister_algs(dd->pdata);
 
 	tasklet_kill(&dd->done_task);
 	omap_des_dma_cleanup(dd);
-- 
2.53.0



