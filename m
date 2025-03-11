Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E942E25B69D;
	Tue, 11 Mar 2025 15:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707032; cv=none; b=AaJxsqlmWLT3Qkzwz/wNI9lvElMxRfJ0dnbOvfnafcjL6f/+vBjiOgMnsye4jIr/Tu5CBHpHJ2ElsAKGWLYLA00bzbTindOPRPqlws2ecR44wo7vgVz71sUI7iUXM+fFBpxhqJol6RiqLMf05g999I1Jpr/wGDqJxGCTJjiUCu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707032; c=relaxed/simple;
	bh=5kyjepotPYcLicoiFFZXPTaG7m7vFQjS8jzOn2Iw7As=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eWl1s2soR9jXw1yJtJ8pFVpFlEArjw4lMdmvbjSOebaQANnLxsMlN4bQ/FNAMNR2w85Q7TTOp3o3+PkV18u2esxqld5qdvb8alfXH3NfDwXTDMrGfqhaukekiaxSJsQxkMeRVtA7I2pvgI9090Fc/T7u+hMFW0eH5XyUUs+tGf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HVR+y+MC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HVR+y+MC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 736CDC4CEE9;
	Tue, 11 Mar 2025 15:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707031;
	bh=5kyjepotPYcLicoiFFZXPTaG7m7vFQjS8jzOn2Iw7As=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HVR+y+MCXgaqeGFTs8zmhvEOybk1GcpjmEKB2eSzJ7+hxgk0v4+/yNvtobquXFLsI
	 22iDxPDrgytuKzohL3DEtGnNEH7gVOLzYmltpaM8KVfGCMWativsIXWIBF1ACeZw0/
	 sSBTTiOO9hEi+xixU67+QdaurVaHlN6Q9MDUN6bQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.10 209/462] crypto: qce - unregister previously registered algos in error path
Date: Tue, 11 Mar 2025 15:57:55 +0100
Message-ID: <20250311145806.619497073@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -45,16 +45,19 @@ static void qce_unregister_algs(struct q
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


