Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637082DF3C9;
	Tue, 17 Jun 2025 15:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174865; cv=none; b=iGqqr7wrVzMceaFRMuNGQU+b4LD5wf1zWKj+4Op8zSjtPQipv6o1TLRTIY4wIug2Q0+eKJ76vQRxIqSQYhAKMVGmE+DypDQsbkTfT4chs9g++KfiScniPRpdAcDcyBJOJVfidpbhyW2TvOMv1wQNMAXmHVFf3+1WpWR7WkBs1Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174865; c=relaxed/simple;
	bh=jGWxR/SbUVqyWkKBiQfuCFy54rbOTnK7/kl3zsxHmgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=usyplanoTACPPlrY74vAI0L4iKlWvdsRBtVGJrh/xE+4qhGaJAAI3e4Sueu7GCnid+a8KBnjxvyFIOr3Et8XTksWLq94T29vs8oyRdpGSKtrb7N/xD+cWiWeAZbYxXui4l8vtikJWjhN+KlmQzvn/MkkdQYXJj7pBaWYevJ5Uuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SsbqXHfQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SsbqXHfQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A2DC4CEE3;
	Tue, 17 Jun 2025 15:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174865;
	bh=jGWxR/SbUVqyWkKBiQfuCFy54rbOTnK7/kl3zsxHmgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SsbqXHfQaQ9dqumqWzoQi7ZKFHvv9wFM+F7Q7uByqngNi+Igrcw58r6LVg1exRKJK
	 QBZ5I7P970dsd0/ivPBKpunAOwrH8lGPPlsSm8xuGduJRwlVTruvWLsgqPJyyJxiZG
	 DDoaSrPry24BMEtmnDFNUuKHjX+i49TTkOQV5Fg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 028/780] crypto: sun8i-ce - undo runtime PM changes during driver removal
Date: Tue, 17 Jun 2025 17:15:36 +0200
Message-ID: <20250617152452.650065760@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>

[ Upstream commit 9334f427576e6d361a409959b52246b0aa10476f ]

The pm_runtime_use_autosuspend() call must be undone with
pm_runtime_dont_use_autosuspend() at driver exit, but this is not
currently handled in the driver.

To fix this issue and at the same time simplify error handling, switch
to devm_pm_runtime_enable(). It will call both pm_runtime_disable() and
pm_runtime_dont_use_autosuspend() during driver removal.

Fixes: 06f751b61329 ("crypto: allwinner - Add sun8i-ce Crypto Engine")
Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c   | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
index ec1ffda9ea32e..658f520cee0ca 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
@@ -832,13 +832,12 @@ static int sun8i_ce_pm_init(struct sun8i_ce_dev *ce)
 	err = pm_runtime_set_suspended(ce->dev);
 	if (err)
 		return err;
-	pm_runtime_enable(ce->dev);
-	return err;
-}
 
-static void sun8i_ce_pm_exit(struct sun8i_ce_dev *ce)
-{
-	pm_runtime_disable(ce->dev);
+	err = devm_pm_runtime_enable(ce->dev);
+	if (err)
+		return err;
+
+	return 0;
 }
 
 static int sun8i_ce_get_clks(struct sun8i_ce_dev *ce)
@@ -1041,7 +1040,7 @@ static int sun8i_ce_probe(struct platform_device *pdev)
 			       "sun8i-ce-ns", ce);
 	if (err) {
 		dev_err(ce->dev, "Cannot request CryptoEngine Non-secure IRQ (err=%d)\n", err);
-		goto error_irq;
+		goto error_pm;
 	}
 
 	err = sun8i_ce_register_algs(ce);
@@ -1082,8 +1081,6 @@ static int sun8i_ce_probe(struct platform_device *pdev)
 	return 0;
 error_alg:
 	sun8i_ce_unregister_algs(ce);
-error_irq:
-	sun8i_ce_pm_exit(ce);
 error_pm:
 	sun8i_ce_free_chanlist(ce, MAXFLOW - 1);
 	return err;
@@ -1104,8 +1101,6 @@ static void sun8i_ce_remove(struct platform_device *pdev)
 #endif
 
 	sun8i_ce_free_chanlist(ce, MAXFLOW - 1);
-
-	sun8i_ce_pm_exit(ce);
 }
 
 static const struct of_device_id sun8i_ce_crypto_of_match_table[] = {
-- 
2.39.5



