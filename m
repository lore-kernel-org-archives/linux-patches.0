Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883153D8129;
	Mon,  4 May 2026 14:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904754; cv=none; b=pByrMQ2T8CZazW0yJMG02uLm5m7F7fRkgrPwA+iEBtBSadKnT66Qg1fBhLujWpMEaMAD7cJRagMSCRZUaGyjBHSZwELWXPj3MMode5CtFLdn7kThEn0Duh6O9ugU1eohACh3tQm/ByxWnf2ToHbV8BPUr7j1SdpfpcZa83SDTo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904754; c=relaxed/simple;
	bh=VsyRoVHRsrVm/wcdC1s4vy5voxS9sVVhpssp/wtnCPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e7Pb07yEESBscaXuD0/ZUpVit9BifazcWo4zMkPeC7XeEcWacn8Pi5p2CuqAT4F0no/l3sCuNjaouUxY7f1s8hzEojX6Tv/wIROtkqTt4LGQok1zvytSSTPnB55t52z2cdwx3Smsx1xneuIpkLDz4rrj40ifKgQT4XMNu08hvwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L//II8tS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L//II8tS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207FAC2BCB8;
	Mon,  4 May 2026 14:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904754;
	bh=VsyRoVHRsrVm/wcdC1s4vy5voxS9sVVhpssp/wtnCPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L//II8tSg351X2MfEdqoGn/5P+0JkvA6vjy/cP0VzVvBbGadQRsCLZmab2P9fA+Oy
	 rYHXbjeJE11TInqBS1PxofJ0jpMX9QeJszAQfOiccVY4taW6n/rs5LzDAoJpN3lOqO
	 Kux02yduQ4jAmQWBJzKiWcVSrP0jjgU8Zhg1w+Dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 161/215] crypto: atmel-sha204a - Fix potential UAF and memory leak in remove path
Date: Mon,  4 May 2026 15:53:00 +0200
Message-ID: <20260504135136.057207986@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


