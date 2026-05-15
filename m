Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8BA53EFFA0;
	Fri, 15 May 2026 16:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860908; cv=none; b=Uywe0BujlKyaJUiarnSl9DHx1LIjFicnEzNhchQEPbPlVXXko5elZ5sD9877mZhV5zW3/FSvLsgRvk6AmKhtbn+UEAlMh3RpFyOeHXviQB0f9HLN40GcUHX7Z8R6O17erv6fp5dxk4hihwB6iTApvaXakkPdRjJBeZk34jYWpKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860908; c=relaxed/simple;
	bh=k6yquhkTCRqLYMoUd1+qGCvyWJych0q68fAZChdaqMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hnBmvaMbCnMAmZNmiMhgGQorWe38a0I9Jn98xCXW4MjyOgUUjcNEtNByqINvTPNuKc7hTnS5BneKw5mDuFBzycZU52ZHp83ro+fUdTt0FLFycIwcxMkbTGTyIpYDnr0py2eZZLaTNVUnE3aT5/4SqJ4cS36R7T+OPLO94lxLcYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kzwE/scV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kzwE/scV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F0E5C2BCC9;
	Fri, 15 May 2026 16:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860908;
	bh=k6yquhkTCRqLYMoUd1+qGCvyWJych0q68fAZChdaqMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kzwE/scVgRtHh5SiGTeFZTuBohUvVzD3cjUGTQfIRJC0FAnx5bsSYz2Fe/4mRIlfD
	 wpsnED9znB8Cyw4DlbZtlTcqAJmi6l7v/WmGuUSpFCESsYYFHFi0FX47Tk+rNH9Ybm
	 ktzfAwG2MHFT9v5WFUOvDfA+B+ur0VtRp66IHnqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 126/474] crypto: atmel-sha204a - Fix potential UAF and memory leak in remove path
Date: Fri, 15 May 2026 17:43:55 +0200
Message-ID: <20260515154717.759977893@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -125,10 +125,8 @@ static void atmel_sha204a_remove(struct
 {
 	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
 
-	if (atomic_read(&i2c_priv->tfm_count)) {
-		dev_emerg(&client->dev, "Device is busy, will remove it anyhow\n");
-		return;
-	}
+	devm_hwrng_unregister(&client->dev, &i2c_priv->hwrng);
+	atmel_i2c_flush_queue();
 
 	kfree((void *)i2c_priv->hwrng.priv);
 }


