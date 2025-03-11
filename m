Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E9A25E83A;
	Tue, 11 Mar 2025 15:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705766; cv=none; b=fyT2FPH7PcZjTR9B/8uvezOu9CSkxPDgahFnzueUh56ApZuKqWknLS3BnG1Bgl/7k4MqWE5X7DliZIKC1FCDtKGU84xAD1Hz0dwHgnJbEeAqLGQj6ETP1vtII188IzWukngcZsb/DTRDOFNh17NT3M6Zlzt6GIzyexmwMJdEbEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705766; c=relaxed/simple;
	bh=DxmCYpsXkH/gzY70bvSd3vWCJoH4KQd1y/Z4SueMg18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FWlaAsX+uNqUR0O+0ohlYB6+iAGdE23RT5FfjKaPs50XZ+MRNGPLoazulef6wEWLaWtrMKThQK9rr5fV3kGUh4n+QLlERaA/LZJ8tVYu27UWqdHRgxVkLicSOeTA5WDlNiugFiOI+A1WXodvvu111EeEaDY01EuEYogOQ5u5lEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y6Zlo2LX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y6Zlo2LX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9658C4CEEC;
	Tue, 11 Mar 2025 15:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705766;
	bh=DxmCYpsXkH/gzY70bvSd3vWCJoH4KQd1y/Z4SueMg18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y6Zlo2LXtUKbtULwV+6PdwfA0JbYcuHggnA8sLezjs8fuY8AsBY6DqmhWgviPBF7x
	 4UZuDQvyFYY953nP+qLs9dHyVLH3DGI6tSg/nDfrBRfzrjf26WEi8IKjgv5AVupke9
	 nuhbt8d0PpLVBCjzYCXKmPVP/P56BHOGKt/DoFxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.4 148/328] crypto: qce - fix goto jump in error path
Date: Tue, 11 Mar 2025 15:58:38 +0100
Message-ID: <20250311145720.789026870@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

commit 5278275c1758a38199b43530adfc50098f4b41c7 upstream.

If qce_check_version() fails, we should jump to err_dma as we already
called qce_dma_request() a couple lines before.

Cc: stable@vger.kernel.org
Fixes: ec8f5d8f6f76 ("crypto: qce - Qualcomm crypto engine driver")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/qce/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -214,7 +214,7 @@ static int qce_crypto_probe(struct platf
 
 	ret = qce_check_version(qce);
 	if (ret)
-		goto err_clks;
+		goto err_dma;
 
 	spin_lock_init(&qce->lock);
 	tasklet_init(&qce->done_tasklet, qce_tasklet_req_done,


