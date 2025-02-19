Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50471DE891;
	Wed, 19 Feb 2025 09:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957209; cv=none; b=PnFU45lnG4gHViRh5yl5Fc91Aw30kqDrC8fTt7aOR2/TDaE4TxyRjbeJvqbhoCpz4sAcY7JxPDD2PXWJdqJtTjLW2JjDcI+Z7RyjLmXUAtFYd/7f+n5Lj7V62NQ/ss14ALdhooNHUzO0yQ+er143YQ7VItEsg4EoilUFIwGQM60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957209; c=relaxed/simple;
	bh=x7j+6qrtjHubkOoY0Iz02Ooxx8lxLu2u/ueXaNggzik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QVB2mwAvFwb60ysynMC42ZeTlvo40tOU+W/3V7wnIo3SoiiKewpwTsBWLdDI+opR0EZHBcMYKPpy1uV10BJpiqTG8H/fIbhuUe9UYdnFmp4+yrlUHahMzxInSGkjFhUJZuW+cbNnHMh3pweQbZs23G35zB/1l8tYefA7t0lf/LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EzsbETWp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EzsbETWp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C7BCC4CED1;
	Wed, 19 Feb 2025 09:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957209;
	bh=x7j+6qrtjHubkOoY0Iz02Ooxx8lxLu2u/ueXaNggzik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EzsbETWpJ7uUyhI94marXLcU2LO+Sj3sgDJv/mfnao7U6LoBMjtUNvXgaTKU8boDE
	 yyyTGSbhHtZo5mlrDNi5Fc7VRYrlyo/MkqPT20012Ci1Y1Z+C4Fpv9EHAYYxMJcsY/
	 3beto33mtRnk7ie6eHXqMO2kBpI3jCAkMs9ugEqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 419/578] crypto: qce - unregister previously registered algos in error path
Date: Wed, 19 Feb 2025 09:27:03 +0100
Message-ID: <20250219082709.501654028@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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
@@ -48,16 +48,19 @@ static void qce_unregister_algs(struct q
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


