Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91D21AF0A9;
	Tue, 15 Oct 2024 13:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997741; cv=none; b=ay1tNYLwjTI+E5Ww8tUuJ2GfrU6HmoCTsVFH1kk4FrX0kNUI8jxGeBt949XPogq++RwxtYfsb+lqLOyVpY2if8geo3IosMtZUCGf007DHoVDhmIUyN77XcrlEmm/4j4GKxY2ll2fX+7SzcZJpNxkYgKUVq49SB1ZgRjMqHrgbw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997741; c=relaxed/simple;
	bh=fS10qwJii/BbylfOb3dlsa38qNeEp/IWRJ12+ZKgc3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q5jx0IS2pZDlPhUNiloJuUMt/h2R8ZJCfh8hphY5fEj+/HVrevR26b/JtFgmWhrUPVSniRQiiUp3o1DUMbJNSeFRn9tABchDF4OVbdg8Xg1iQcAl78K2k7O0Z7QFuEffJfF8Nha0XPakFnAArgrJZja5caAg05E0I54Ulno3EHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HuKU2NPW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HuKU2NPW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12C96C4CEC6;
	Tue, 15 Oct 2024 13:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997741;
	bh=fS10qwJii/BbylfOb3dlsa38qNeEp/IWRJ12+ZKgc3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HuKU2NPWqTFv31JxmJNp6OBCWAzMSB64vqrWzcO+1q7BkjgF0QyIlxSUqjadU2xe2
	 4fPixe7TrXk0ifB+EVG0TA6089qGT2WVweY4ikqt4jVuWV92sadZi7VuOIt9dZysFG
	 KJB3bWPPK8tbU9FT5mn2FXluYy8T/KZ4SX2B1UU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Guoqing Jiang <guoqing.jiang@canonical.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.10 241/518] hwrng: mtk - Use devm_pm_runtime_enable
Date: Tue, 15 Oct 2024 14:42:25 +0200
Message-ID: <20241015123926.294623475@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 


