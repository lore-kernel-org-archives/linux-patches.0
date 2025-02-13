Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16EA15E5D4;
	Thu, 13 Feb 2025 15:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460811; cv=none; b=EvmFIyQiPSE1UGOkr9zBwMbyGdmeKfaVFj1jB8MnMHtUuXIw7/uDVLMPfynADAQUxJcmf5Pm1W3YRnhSlGvzr2euSjpQtR0wcUGhNOGrwyi1SLTJsLbCrSowrlAsPM1YRYmumKuQX1tGINTBoLbOWs6OMQq8gszis4d6aWFfuxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460811; c=relaxed/simple;
	bh=/0Bohcv8/ryTZyxL5BMA1918G9urMYo87KcsTFOWWUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qHKMtQOg58d/PtpN0YlT54UCEBkYYNYICqwaqAyFt6rsaQEKYnvowNQavIRRTduFFBXDB/8DeZ933YZgFTbIFK6/az+Nqpm7lVjQrdZV3eu60Zoo+PqQ5MFHF8H80eO8YYmPD98IWw9FBFZicrvewmqoAyL5g8PrZKIJpRI0P2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q7RUnSVM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q7RUnSVM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE69C4CED1;
	Thu, 13 Feb 2025 15:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460811;
	bh=/0Bohcv8/ryTZyxL5BMA1918G9urMYo87KcsTFOWWUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q7RUnSVMkBV/5FZV7ZQPgPOHvEdcja4/A5TGz4TWf5achktD6cXjbcyZTPrvIH2ZK
	 j86zh0XkiL3PQCfjd2iqGnEl4ZdpHptpH4Mejh07C3wJ16A4q8D2oftnygNN63+nNk
	 DYH4u719HbBwj6lTw3R2uaBIfs8Wd71NhEXEp2Fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 220/273] crypto: qce - unregister previously registered algos in error path
Date: Thu, 13 Feb 2025 15:29:52 +0100
Message-ID: <20250213142416.007296946@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

commit e80cf84b608725303113d6fe98bb727bf7b7a40d upstream.

If we encounter an error when registering alorithms with the crypto
framework, we just bail out and don't unregister the ones we
successfully registered in prior iterations of the loop.

Add code that goes back over the algos and unregisters them before
returning an error from qce_register_algs().

Cc: stable@vger.kernel.org
Fixes: ec8f5d8f6f76 ("crypto: qce - Qualcomm crypto engine driver")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/qce/core.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -51,16 +51,19 @@ static void qce_unregister_algs(struct q
 static int qce_register_algs(struct qce_device *qce)
 {
 	const struct qce_algo_ops *ops;
-	int i, ret = -ENODEV;
+	int i, j, ret = -ENODEV;
 
 	for (i = 0; i < ARRAY_SIZE(qce_ops); i++) {
 		ops = qce_ops[i];
 		ret = ops->register_algs(qce);
-		if (ret)
-			break;
+		if (ret) {
+			for (j = i - 1; j >= 0; j--)
+				ops->unregister_algs(qce);
+			return ret;
+		}
 	}
 
-	return ret;
+	return 0;
 }
 
 static int qce_handle_request(struct crypto_async_request *async_req)


