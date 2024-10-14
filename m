Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8831955896;
	Mon, 14 Oct 2024 15:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918581; cv=none; b=ffdPiZEQQuD9V3cUYyHkpo+w/4hJ7/sEoYUm5ydLPynyarkpWzhCpoZ1JAjsd5SclB+zOldnq+XHGAZ/3OI1+sLnDMjxwjHnf16h0b3TBVbG14T4C1+365HWmHd6zAvvLvwYQMdRsPsOpDtrL6VHq4LQBE/vJvunWZgsHnHmnj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918581; c=relaxed/simple;
	bh=SDQFFjulr0vcMqXK1vicEjMuqIomb1p3weouvGTf5Ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XYHkczQeTzNT0062321Z/b0z3SoR8dxg8//wagphhkp7Rf2V/uWAwQHSmYR1ISgEzUfHJUJQPQXijyb9v1POs7XJEiT4CWN1UexxXhm8g/cRVQgyZ5tXiHCE9TEVToz+cP9MmDQQ5MOyWK3WkmKVL+9vwqZgjnCJkJ3IFJqu+Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qIxD2M55; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qIxD2M55"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0FA5C4CEC3;
	Mon, 14 Oct 2024 15:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918581;
	bh=SDQFFjulr0vcMqXK1vicEjMuqIomb1p3weouvGTf5Ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qIxD2M55ZWzdlTlCfHbCkSxW0P9cRTViwKPgVIR/YoFD3D78UqMzCHRzCcjr4/RkE
	 Yf94PguoR7rPhgy2zTWLVpLYfdMS0kYphUGT1eb3GntylwbLg4QUbShpk4kdpV47jj
	 jc3jcDTHOlcz4HcoyAPUCXlr5st+9ivm9RJntacM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Guoqing Jiang <guoqing.jiang@canonical.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 331/798] hwrng: mtk - Use devm_pm_runtime_enable
Date: Mon, 14 Oct 2024 16:14:45 +0200
Message-ID: <20241014141230.955212879@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


