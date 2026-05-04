Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08EDF3DEAED;
	Mon,  4 May 2026 14:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903519; cv=none; b=WTn5DAB15t7fLuINBP/Ankz+6GRVrqsUelUBidK5uBocThH59E04aQR9mbqLwZXtBKyIeaPKdkin9IxuucjO3xvJg5O+i4XfXgEFLe2v3RvvjcSHoyH9Rga+Qn4xqyN6Rs01ysKPuKGap9zCgU8k4xdE0WzBIli2sp3xSONcVkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903519; c=relaxed/simple;
	bh=7trNfyD70CuJx484GCYfG1OH2o3+J3sV290ddleRuyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qKeD2N/xOhHCxVPoEDC2oDHKiOED4pXwDSurpkua9NKgpXC15ZZxob0M0W4yPj9o9l0l9c5s6bXluW9kGf5WqDJ+jDET9pHusgH3NQN9GQs2CE6VWHQft3vpCbguv488SbhhrACkyvF5ov4rzSb1GL4ETb0zQlsaDCkv1m14lX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sK3++jTE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sK3++jTE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 932EEC2BCB8;
	Mon,  4 May 2026 14:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903518;
	bh=7trNfyD70CuJx484GCYfG1OH2o3+J3sV290ddleRuyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sK3++jTEmEax0fc85gC+HnuuO57kX1P7NXH4+cv8l/5EAQH645VMdHjuNxZrjzn5r
	 21b4w4MER40Bi9QEu/MxoDL8gAyxUfzAcik1MZeveuUjG2gPJ+VfgCNEyVsQHbGa73
	 ryJu6lrZSVZDeTRlVJ8mX64GNDsjUJCg1co9fQwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.0 265/307] crypto: atmel-sha204a - Fix potential UAF and memory leak in remove path
Date: Mon,  4 May 2026 15:52:30 +0200
Message-ID: <20260504135152.782439077@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit bab1adf3b87e4bfac92c4f5963c63db434d561c1 upstream.

Unregister the hwrng to prevent new ->read() calls and flush the Atmel
I2C workqueue before teardown to prevent a potential UAF if a queued
callback runs while the device is being removed.

Drop the early return to ensure sysfs entries are removed and
->hwrng.priv is freed, preventing a memory leak.

Fixes: da001fb651b0 ("crypto: atmel-i2c - add support for SHA204A random number generator")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/atmel-sha204a.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -194,10 +194,8 @@ static void atmel_sha204a_remove(struct
 {
 	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
 
-	if (atomic_read(&i2c_priv->tfm_count)) {
-		dev_emerg(&client->dev, "Device is busy, will remove it anyhow\n");
-		return;
-	}
+	devm_hwrng_unregister(&client->dev, &i2c_priv->hwrng);
+	atmel_i2c_flush_queue();
 
 	sysfs_remove_group(&client->dev.kobj, &atmel_sha204a_groups);
 


