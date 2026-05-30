Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDDC43AA195;
	Sat, 30 May 2026 16:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160162; cv=none; b=cWgl8N2zQS9faPZh8WCJ0onOegQzitJJjeVzsmbT9ysUc/wdkl3HHQeGCQUWINrK+km9HdMbV//cpxXdQBlcMUOYU9q6sM8vshOiJCA06fc6eNge2dnUaN9khoohmLWnVSFiOISIQMt4KdvxorP8ndhRDl6KHvsKa+ezc0K0mh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160162; c=relaxed/simple;
	bh=/LsldEiB5uiw0LMhaBQ1V+gFvFswn3SMsowjQVEvD5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jjaiulrdOGQzUEZQ2hCjUua/ItFQYCuqk9g3ya09649ojjYS34q20aM0eRG83eVldcPip/VH833B/cZsLbDP0lw8YfsD02PeI2/N3sVNwDsNb6ueKseJSGdiZPBeRCVieF1lM5oefNMWbZjrK0ASanOHw/d8EeRdtlgDHeyf9sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MQTmOU0h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MQTmOU0h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DCDC1F00893;
	Sat, 30 May 2026 16:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160161;
	bh=k12+4HLVEBhFcMmvshn0As8Hr9kF4APQUaxpHaNMOPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MQTmOU0hODeD+Ry92HD4ZD8HpN1c/7CqOQtI/EKxl6Fo3P+K8XqfYDVAu5/CHo8up
	 8f4JNDGLjjc/n0xAa1AbBColr/rUoXkklvfpVzdkqsu4ldyy8VP+CYOTFu7DkWInab
	 W/0QuBFDWmR6cH1Z+l3eUsXsjTkto7L4zugeD8k0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 261/969] crypto: atmel-sha204a - Fix potential UAF and memory leak in remove path
Date: Sat, 30 May 2026 17:56:25 +0200
Message-ID: <20260530160307.689263501@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -126,10 +126,8 @@ static void atmel_sha204a_remove(struct
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


