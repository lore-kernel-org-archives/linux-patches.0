Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA912F12AC;
	Sat, 12 Sep 2026 19:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242361; cv=none; b=mRovAAQ5AUiwTwi1e7Y0ToS8oaLGodQn5XpHGg+0+5oyOzeqsM4De96Fi3drsQLSgelIefVM10L70d7bW5YNzImmV20CeTJB+X0aj/ek3qiq0+7yBNDoUyq/4GrtsmD2ENv0OrIbRomYX+LAKqEiywWlcQCQUmTOO7+Vy83i6mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242361; c=relaxed/simple;
	bh=D9JjboqdhFn5WV7FCqJ1v5HyJ9p/9kbtc0VbJmKztzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfRmB8uvqB67haKbAGgQ/+BMHHxk5n4srpFowYsCKvwKXqXqtvbvdXrpEb7II18BFsUhXBItM/snSfMH4q47xBUL2WIfRxFR+f5Mzd8k3c4jUjRRJ90hbQx3fcgkk+hukREZXXLZWZSu8PHP2wJiOh0MqtgmlAQo1vTVyQCCfc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GFijDmcr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GFijDmcr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 873AF1F00893;
	Sat, 12 Sep 2026 19:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242360;
	bh=aMLzJeb9YAO7cPOk01KuDFeuwwcTi4t3ZqOwLWgXj00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GFijDmcr8l3ejtgCaBjMM5FXjOUptyAALWxpCTqwFlEE76GaTPpbak8KSUytGHKjJ
	 xq17nbfLItgNBQOo1m4sxLgo4F211X8IGCYaMGhopyCWUXoWT966zZsZWaLRl/Rs1M
	 a5DocTqlR39R1WaLNSL77VzFmhyIITof3Sgk4occ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lothar Rubusch <l.rubusch@gmail.com>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 374/798] crypto: atmel-sha204a - fix heap info leak on I2C transfer failure
Date: Sat, 12 Sep 2026 09:00:02 +0200
Message-ID: <20260912065525.729474062@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Lothar Rubusch <l.rubusch@gmail.com>

[ Upstream commit 72bbf11ba14bd7d5fbf31a1ec42fff608b657f74 ]

The nonblocking RNG path allocates a work_data structure to track the
state of an in-flight asynchronous I2C request. This pointer is stored
in rng->priv and later consumed by the read path once the transaction
completes.

If the underlying I2C transfer fails, the completion callback is invoked
with a non-zero status. In this case, the allocated work_data is not
usable for producing RNG output and must not remain associated with the
hwrng state.

Previously, the failure path only logged a warning but left the pointer
state uncleared, which can result in subsequent read attempts observing
stale state and interpreting it as valid completion data.

Fix this by freeing the pending work_data. The I2C transaction reports
an error. This ensures that failed requests do not leave residual state
behind that could be interpreted as valid RNG data on later reads.
Clearing rng->priv is done at the subsequent call to nonblocking read.

Fixes: da001fb651b0 ("crypto: atmel-i2c - add support for SHA204A random number generator")
Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
Assisted-by: Gemini:1.5 Pro [google]
Reviewed-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/atmel-sha204a.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index 88ff4ce545c3c..6c5fa4b2298e1 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -30,10 +30,14 @@ static void atmel_sha204a_rng_done(struct atmel_i2c_work_data *work_data,
 	struct atmel_i2c_client_priv *i2c_priv = work_data->ctx;
 	struct hwrng *rng = areq;
 
-	if (status)
+	if (status) {
 		dev_warn_ratelimited(&i2c_priv->client->dev,
 				     "i2c transaction failed (%d)\n",
 				     status);
+		kfree(work_data);
+		atomic_dec(&i2c_priv->tfm_count);
+		return;
+	}
 
 	rng->priv = (unsigned long)work_data;
 	atomic_dec(&i2c_priv->tfm_count);
-- 
2.53.0



