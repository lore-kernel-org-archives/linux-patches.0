Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACF826B091;
	Thu, 13 Feb 2025 15:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459862; cv=none; b=jWl2xTP9GjRgs6MBGU4chlr5Ro66QrpPDCTGvBqug+0/2nYJgqU1/7YDtU0diUaQffq1vMOOMo5gJ1E+R258R5uJo8i4ouZZTSczB+K8cDKrhas5jq6Rvp7KhFIcf/weXjVRw5LhjPDvlZYNM51cnfGNj8I+BuvrOpkNySzjTNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459862; c=relaxed/simple;
	bh=h88dX2z6UceqFhs9p6tPKKd7eqrQHa9iti/mZf4Tnwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=arEojJNmL6e3cWpaeC1KrQDh3ghmLuhBiTQGjuR9P2i8GCALRUsnc4OSQb2gi9t6BSupCrWDvmAX1GXLaROzFYxW9TVsXPA5pctkX9xp0/jUMVLvjNUJeA0sjGSHg1LlP/hqLCG3m1cdUNSCoqRG0hFvgtDWNu9lFTMTkSDBJNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JQLCE2dR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JQLCE2dR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9AEC4CED1;
	Thu, 13 Feb 2025 15:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459862;
	bh=h88dX2z6UceqFhs9p6tPKKd7eqrQHa9iti/mZf4Tnwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JQLCE2dR+MHz2AVMvUxNMJF88ViaPu3LzqtOfRSSuR7Ser62fr8gUYbQq4k8YsZHU
	 TyhsqmfJFjkCQHJ9Pwm7A8lzdeCkENGXzytLReBJpiBa1TGTwujDwpZ/WNxXh8Nlfc
	 pCxvHQS0P/SHiCiBL2MK+5+UG6ih35Qrmsrs4SHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.13 386/443] crypto: qce - unregister previously registered algos in error path
Date: Thu, 13 Feb 2025 15:29:11 +0100
Message-ID: <20250213142455.505379425@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


