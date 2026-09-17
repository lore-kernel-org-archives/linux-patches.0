Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AEBC5A0AAB;
	Thu, 17 Sep 2026 16:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661225; cv=none; b=sPbH4VQy7gQCERr6M6Gi51RcM/WGWrq/Lz0CKCET6Ke3tLSMIq9kZ7r1jj3K2TfUy/SxIdsV1t+kJf7XK2bWYaKk76SW+HMlvZRt6yRc7OE6emXMeXLjMIJTFBdGi7FYom60A3fRgCO6ed89L2qLUek+5qVzDy4ZBdLU2LaA27g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661225; c=relaxed/simple;
	bh=Gasha3zqhP71z7fEqZ6qBGvuI+jq2IXlr/vC6fK9SHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dAppcinmejWl3tNkepbpk1f5YwyxOhB/qBNov7268eLtl8jlqPGgLDSAdeajl3rBBfmhwFjV/gz6lx1rkGZJMLPffr1z8Z5K6Dmld0d59Ewm35B0NC6EQ5ezojBzNtY/42szqiHlVKGUU+xeKSj6cu+nVLzmLDZEDpcGLuO4j14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iKErGESW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iKErGESW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423FC1F000FF;
	Thu, 17 Sep 2026 16:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661223;
	bh=NHD3Km3rI+cqGpHOL4sL1LzTAyrbstPojK7h4IUKOb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iKErGESWxHJId2u9LSvnNfDFnbIykAjQd5ygH/Qd8VljOyHS4mWyVlSl34PhKouGP
	 EJULeqfDu7zJR1ALQ9Xm4bA+Kipu3/tahXFKKSfVCjjE6IUTNcVJNlkYcmLc5n1+Ek
	 lzz0hZkxBAHdvsfCz9yZEl9auDo/k6qX286w2+Fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0075/1250] crypto: omap - add omap_des_unregister_algs helper
Date: Thu, 17 Sep 2026 15:57:50 +0100
Message-ID: <20260917151553.989274075@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 149ebd77710bf..16d5c617d5ee8 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -938,6 +938,20 @@ static int omap_des_get_pdev(struct omap_des_dev *dd,
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
@@ -1043,11 +1057,7 @@ static int omap_des_probe(struct platform_device *pdev)
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
@@ -1067,16 +1077,12 @@ static int omap_des_probe(struct platform_device *pdev)
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
 
 	cancel_work_sync(&dd->done_task);
 	omap_des_dma_cleanup(dd);
-- 
2.53.0



