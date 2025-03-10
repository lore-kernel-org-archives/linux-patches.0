Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F077227EA0;
	Mon, 10 Mar 2025 17:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629499; cv=none; b=hRpQ77+OuZt+TJ824tfA4ckryZd3+JUvjHgNU9nmFVqpmREzEtAGKpLh4P04+p3ugsWMRFDmuA+qaMqI71akBWmupHl+ANnV0V0/Gl29CZtvDelcV7sx6OfX8CB1IiuHyt86sIYYqtpIPENJDbgWzo30ZEmPdkBcjcZ/YKUHHLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629499; c=relaxed/simple;
	bh=gBbbQBZR8DBFYNzAmFLpO48E9x3C5vBvBuW8ku23BHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V+Olr/mfRBetfj9+PlvpxTn762WXiM3Su8sMcKiNbUdOzjf4X2N37DCcdAj6u0S8d3I3xsfaoQMtPhW122cxnU56B88KcCGAHW+io3GmlMMDI/5/O7u7SD01asyInpckvU+Vul1w8heq3z3i1MZKXHnzk2UNc+oNokFJfB7sbFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RJ49pPBP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RJ49pPBP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB87C4CEE5;
	Mon, 10 Mar 2025 17:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629499;
	bh=gBbbQBZR8DBFYNzAmFLpO48E9x3C5vBvBuW8ku23BHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RJ49pPBP/rpEembFzpkhZbaYRDUbg0NBISXVy/UwSbsOmfKohHsrUR2Fs5Hbwt0pJ
	 V+3LvE2Dn8WKvKomdzTHPQhW/eB0hXPiPrJSyYt1Ozxtn7aLqvm5OXbLYr4HYz3/vJ
	 7aA2Z9JqCjGHTDNu76CjSBXSYPd2C3PANR9Rhe94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.15 314/620] crypto: qce - unregister previously registered algos in error path
Date: Mon, 10 Mar 2025 18:02:40 +0100
Message-ID: <20250310170558.011817295@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


