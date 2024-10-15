Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1811CFEA9;
	Tue, 15 Oct 2024 12:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993859; cv=none; b=Lr5q0ls5VyfHN7mDcpFxWKlQFBAHydov6u1GhCUlv9zYIp6HzDSvHUX0o14U24doFz0vZcwJNMUNZ5vCx0zI78qhoOF5Rn6EgWLFhoRHx9ebHKSljnqVEkVYUs2ZgZFv+/WYAoKN2l4apXkIk8x2MlJ93aQ+BDWyOh5MHksjwdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993859; c=relaxed/simple;
	bh=XfeQjAvi4vs3Z2iiVCYEYUOPKksJtTMYKeiClRURDac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h3x0pQCKTf75aDlrNbtM9nX5kcnc1CrpFRT6CfKRRl3vAV6XliTteFl9Ta5w34L7GasFhEqsWMxzTSmny+hkPjqqHfYu5jfOIYWOap/usXP9M9OA73RZhwMJTjshHABfUm0lga7pRoI8tCtPu16SiNEQAqFNZsOMHgmxPKU/gQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hwPDwEvI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hwPDwEvI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B076C4CECE;
	Tue, 15 Oct 2024 12:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993859;
	bh=XfeQjAvi4vs3Z2iiVCYEYUOPKksJtTMYKeiClRURDac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hwPDwEvIbtCb7dcQFFM3guB7svd0qN+yBe58qvlRuGRhjbOTcdRQ7Y0lQhFycYr9M
	 kVsvkozyGmXlfZMpBPI+4p6ooqbANlhGoLbcV6LIr4yfO5vAM55m3KDxKJ5YZgdYjo
	 uPL2+GltkTg5QY3bGtZZ/UjXRUFNnsOxOMmfvY+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 537/691] Input: adp5589-keys - fix NULL pointer dereference
Date: Tue, 15 Oct 2024 13:28:05 +0200
Message-ID: <20241015112501.654565520@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 
 static int adp5589_probe(struct i2c_client *client,
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


