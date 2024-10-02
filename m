Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB551CFEB3;
	Wed,  2 Oct 2024 14:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878888; cv=none; b=Q1hzevlohIswqaUo3F0/vRBPytuo0uhANEndg3moPVud/ulslKtl1XxfQdX0IJNOmnMAhgx2I3VcoqaBEEuo4WhR2Ie1tCezyCESnPs/PoUp9jO3SGHPVFew8f+gq3lhkveq7Jk8VyDSFkLoLiZtAem130QsbBog0AHX3Ro6erE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878888; c=relaxed/simple;
	bh=jB+LR2fGKcLrzUgEo/xrQqzn26qMtImwoIhAVRERY1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tgi2p+Na2r6R4Q27REGUXAO6C4lRhk3lG9YE+g86W4c4rGbLfFZcu26OcVjIbRMu+32cASl3kDcJWJRtb8AvnLywmX6TQ0W0byh6Ajq8S9ovqPHNBFeJv2TY9c1hM5azjv/hjAnYFAzbHb75PyNnu1YX7u0jZ1Yky8Xs2gnjUMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qa8rwwNa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qa8rwwNa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D41C4CEC5;
	Wed,  2 Oct 2024 14:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878887;
	bh=jB+LR2fGKcLrzUgEo/xrQqzn26qMtImwoIhAVRERY1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qa8rwwNak1007VORzwodoI8MG4nKiaORJGMqymT+Qf2KrJODw5kvcgncM2ZKrzQ91
	 qsv3FafRe/OOCGwZQEldPYtQRxIJw+7V0C9CWLxXBDj3TMRcgqmS5IJUZEZ7j9ES9a
	 lOTntantQO7+A2GjEpBOoy15724h1kCLkBXOJqEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Guoqing Jiang <guoqing.jiang@canonical.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.10 566/634] hwrng: mtk - Use devm_pm_runtime_enable
Date: Wed,  2 Oct 2024 15:01:06 +0200
Message-ID: <20241002125833.456631791@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guoqing Jiang <guoqing.jiang@canonical.com>

commit 78cb66caa6ab5385ac2090f1aae5f3c19e08f522 upstream.

Replace pm_runtime_enable with the devres-enabled version which
can trigger pm_runtime_disable.

Otherwise, the below appears during reload driver.

mtk_rng 1020f000.rng: Unbalanced pm_runtime_enable!

Fixes: 81d2b34508c6 ("hwrng: mtk - add runtime PM support")
Cc: <stable@vger.kernel.org>
Suggested-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Guoqing Jiang <guoqing.jiang@canonical.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/hw_random/mtk-rng.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/hw_random/mtk-rng.c
+++ b/drivers/char/hw_random/mtk-rng.c
@@ -142,7 +142,7 @@ static int mtk_rng_probe(struct platform
 	dev_set_drvdata(&pdev->dev, priv);
 	pm_runtime_set_autosuspend_delay(&pdev->dev, RNG_AUTOSUSPEND_TIMEOUT);
 	pm_runtime_use_autosuspend(&pdev->dev);
-	pm_runtime_enable(&pdev->dev);
+	devm_pm_runtime_enable(&pdev->dev);
 
 	dev_info(&pdev->dev, "registered RNG driver\n");
 


