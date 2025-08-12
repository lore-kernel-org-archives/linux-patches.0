Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385C5221FAC;
	Tue, 12 Aug 2025 17:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020945; cv=none; b=hSJ59bGw9moT38HaEEFOnRxV5KtkEkseZg+DiZ+PqaHnrsA4KM30VsPb8dV64HsW2dDRBxkM/G4vOJy6z0tWJnBfGX5edbN+TB5JF+eEkSFeLBl0MjqYcgOnlZsYNM0zGRwyJlNSxNKFdH9yI2cUQr2wZWikN377t//qAds8NoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020945; c=relaxed/simple;
	bh=HtOBLVDwRSMynLZOcKIZQDwYlhNjJKtsMi9SsFWGCng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q7ULHlk94HAt4Hc7i2wJmq8IerP9Dq5h572tyxwDx8CzXiqlOKeh8NgO6cYFcVoA67YPiQojoNNyP6wgseb+hJQRrg0Yz8RDqRtJSRQSXc3bitDGf1+hG4yISnVwn1aYpLgKNb2Kxzvsb2l79viGYDhk5ob8759LKMAfX7EBEq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CGEyTkh9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CGEyTkh9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95547C4CEF0;
	Tue, 12 Aug 2025 17:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020945;
	bh=HtOBLVDwRSMynLZOcKIZQDwYlhNjJKtsMi9SsFWGCng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CGEyTkh9dCRSOLhRO8P9SeH9GISZttDQeLSgqf+szhqihJ/djQ0B8EDL/emC08aOX
	 Hg7TRT+CDONY3t2b9UsmQt3Z8wP/Q/8AqUxg962jsuqBec07EzGD0wpsU2dxLsyqsE
	 jfa51Y5Au/bNayHoADt0GQ2zl79MIMOTpocXqqlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 166/253] hwrng: mtk - handle devm_pm_runtime_enable errors
Date: Tue, 12 Aug 2025 19:29:14 +0200
Message-ID: <20250812172955.781337751@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>

[ Upstream commit 522a242a18adc5c63a24836715dbeec4dc3faee1 ]

Although unlikely, devm_pm_runtime_enable() call might fail, so handle
the return value.

Fixes: 78cb66caa6ab ("hwrng: mtk - Use devm_pm_runtime_enable")
Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/mtk-rng.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/mtk-rng.c b/drivers/char/hw_random/mtk-rng.c
index 3e00506543b6..72269d0f2a4e 100644
--- a/drivers/char/hw_random/mtk-rng.c
+++ b/drivers/char/hw_random/mtk-rng.c
@@ -142,7 +142,9 @@ static int mtk_rng_probe(struct platform_device *pdev)
 	dev_set_drvdata(&pdev->dev, priv);
 	pm_runtime_set_autosuspend_delay(&pdev->dev, RNG_AUTOSUSPEND_TIMEOUT);
 	pm_runtime_use_autosuspend(&pdev->dev);
-	devm_pm_runtime_enable(&pdev->dev);
+	ret = devm_pm_runtime_enable(&pdev->dev);
+	if (ret)
+		return ret;
 
 	dev_info(&pdev->dev, "registered RNG driver\n");
 
-- 
2.39.5



