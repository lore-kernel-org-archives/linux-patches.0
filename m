Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C5D3B3BF2;
	Wed, 30 Sep 2026 18:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793943; cv=none; b=Lncb8LtF24nnArYuD3ar3rkdsl7kuK3ZUndwefPxvlUEOi1Ss+M3j+zS1glszrF7KA7EL7D+w5HK3REbLDcWLkqAYbvumQTdKKASor8i8jfJ3jh2wxrC0BZaDtYk6a2BqQe3znxWaPUlMzIeACeFR1W5hGWXniApcsHsBuzp3Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793943; c=relaxed/simple;
	bh=kQj5nk1QOq3gztqBZzTp3mgsVtGKkcMmOtRsa+botrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LrpjDX5bFgIkhUElIbEsrFRc/j7mgAfPnCA6v3DQhVkWpwxTbkm382HimFwBVosKbKtVM7rUc3eH8GCVcdKPWFQdxMxwIZ9v+AP2yX3qQ2/A33zFZwy1+JfoFufFKnGGOKNRTHS5xjPt3QXoPCVqLQF3lS8ocMbztq07ehCjPX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W72FiFR7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W72FiFR7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06CB1F000FF;
	Wed, 30 Sep 2026 18:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793941;
	bh=Lpl80kAB5r15dAAnXLN8S/lqbDMEPMeZqid8DWIJjK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W72FiFR7LAKofeMPuPQFd0D6hdTAkbXqSHyiHERLVVIT1H3b0bHznq7EajVzkbDrg
	 bCtjWki03Mz2vuITS7doLQpu7iWPZa6LB+4T+3nhp6bszxlAaNcgtnCfPUC0l58zJ8
	 bpBqShoAC+e9N+e2F8F09lamd2GLMBTi6UNxA5PI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0035/1193] crypto: omap - add omap_des_unregister_algs helper
Date: Wed, 30 Sep 2026 17:11:59 +0200
Message-ID: <20260930152435.064929183@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 089dd45eaedd7..c5e7064be9c55 100644
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
 static int omap_des_remove(struct platform_device *pdev)
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



