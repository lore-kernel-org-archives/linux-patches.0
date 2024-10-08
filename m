Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD661DA60C;
	Tue,  8 Oct 2024 12:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390837; cv=none; b=PpL7noNoFEZwDHvdZ2wAqve/3la1XVL0/AclWbgYq/Q4gByVsJAme7TSYqVEyIukSUUrrZBLTyzusChwzdht4YVK4rf9NrjcWNHRYwAEyHOuZ+3eoiPKX4N3q6DCrtI/N2wrIhj4x4d1jaDMr4M4F6UfWM4fAbsNNZfAXzp19oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390837; c=relaxed/simple;
	bh=XlV7Lb2irJH9K/dEZCSsCIH79uDb/V4rW170ctuBVZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I/g1TqOtZGu8Iif4MNB2rbAuI2oha2dNq4fEmG10oa3f/4HgKRen9L8w1ghh5dTNDVLe+jLGoqb/0u6n7RSntuQe6Rc9gMi4Pr6ZZ/+kEE/vCklhrVm845XK8SLXnAfXBf2eCAw2yO9yKbdKLEut5NHxugVStOqBpAiW5kT2CxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ylAZ8E4b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ylAZ8E4b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02DFFC4CEC7;
	Tue,  8 Oct 2024 12:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390837;
	bh=XlV7Lb2irJH9K/dEZCSsCIH79uDb/V4rW170ctuBVZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ylAZ8E4bGkv6CRsysoIJddxhsw0Z/rFf4AQX2h1TDCtVsvXhUaYS6GqJ7ZuMT9+uh
	 VB2D6AEb6s+zeRurdXmvPEXr0bySPZSOXsOXr0tOGjwYwIYWQZ0VY3+JW6EXC95UaS
	 zoNjszAiTpEjylptLMKA9aN/jy/ZpbuJAY1Oi6Yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.10 409/482] Input: adp5589-keys - fix NULL pointer dereference
Date: Tue,  8 Oct 2024 14:07:52 +0200
Message-ID: <20241008115704.503645665@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sa <nuno.sa@analog.com>

commit fb5cc65f973661241e4a2b7390b429aa7b330c69 upstream.

We register a devm action to call adp5589_clear_config() and then pass
the i2c client as argument so that we can call i2c_get_clientdata() in
order to get our device object. However, i2c_set_clientdata() is only
being set at the end of the probe function which means that we'll get a
NULL pointer dereference in case the probe function fails early.

Fixes: 30df385e35a4 ("Input: adp5589-keys - use devm_add_action_or_reset() for register clear")
Signed-off-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20241001-b4-dev-adp5589-fw-conversion-v1-1-fca0149dfc47@analog.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/keyboard/adp5589-keys.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/input/keyboard/adp5589-keys.c
+++ b/drivers/input/keyboard/adp5589-keys.c
@@ -936,10 +936,9 @@ static int adp5589_keypad_add(struct adp
 
 static void adp5589_clear_config(void *data)
 {
-	struct i2c_client *client = data;
-	struct adp5589_kpad *kpad = i2c_get_clientdata(client);
+	struct adp5589_kpad *kpad = data;
 
-	adp5589_write(client, kpad->var->reg(ADP5589_GENERAL_CFG), 0);
+	adp5589_write(kpad->client, kpad->var->reg(ADP5589_GENERAL_CFG), 0);
 }
 
 static int adp5589_probe(struct i2c_client *client)
@@ -983,7 +982,7 @@ static int adp5589_probe(struct i2c_clie
 	}
 
 	error = devm_add_action_or_reset(&client->dev, adp5589_clear_config,
-					 client);
+					 kpad);
 	if (error)
 		return error;
 
@@ -1010,8 +1009,6 @@ static int adp5589_probe(struct i2c_clie
 	if (error)
 		return error;
 
-	i2c_set_clientdata(client, kpad);
-
 	dev_info(&client->dev, "Rev.%d keypad, irq %d\n", revid, client->irq);
 	return 0;
 }


