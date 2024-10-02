Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9681D0940;
	Wed,  2 Oct 2024 14:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880577; cv=none; b=dA+ZJu6SqQGVGXXwvIkJQs+wpol0jMf98xDog2oBbxDQF0E98QuFDdZ+zVG3LXDCAQ1udlPrFhz5CWo7eVftn6kq6/vMkkvvQkiTXtkU3IN6KSijyuSS5Umf0QviRjUxxkg4iCFv4fX8mu38DgxMze4CZSXRlyzbsmZsenqULD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880577; c=relaxed/simple;
	bh=W7wy2HMo1scUK37UCAIHNCFf62qlMj+/CpYApjIh/HI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UtQuwRHXSqNN728c4ERrvgsQQDoWzIX2zqvQ12nJy/zBOR50dOnvZxmEdE6mGj5DDHjjf8uvSOzgOSyp4GmofZYVwYcu4aKfvbaPWtTXceRHh6dgEKHVhpOxd7le4oIZi2lLf42uwQmeN7m/poMqgmCIYOBwa5q00UMZjLRH4ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NdcD9k8E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NdcD9k8E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC52FC4CEC2;
	Wed,  2 Oct 2024 14:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880577;
	bh=W7wy2HMo1scUK37UCAIHNCFf62qlMj+/CpYApjIh/HI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NdcD9k8EdmWHnWxcTp2AQUTjbrTpvc/73ApOBFPpU0kXoloWx6bhattU9adtfBLhD
	 0C6b3cBISgwM01+eKWB++rRWA1kEFW5+Khd49F6mFoGfy+R42N9BDpAvlx4pT34oQM
	 MZ/1U/LqkB1jLU5Rp6Or2WWM5s6ivhs4QQTR152w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Guoqing Jiang <guoqing.jiang@canonical.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 466/538] hwrng: mtk - Use devm_pm_runtime_enable
Date: Wed,  2 Oct 2024 15:01:45 +0200
Message-ID: <20241002125810.838033142@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


