Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C550E481B3;
	Mon, 14 Oct 2024 15:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919509; cv=none; b=n/BjbA5vPKc8qt/U/iSHTZh5F0I/P92allz49KBBMIoyNg0Cd9aiXs3cQ4lqZaZqEa2L15r6qgXJa/cGe1QiKZLEUyjpLPw9Nyne+GQVX5VEcaPxLzhzfOSFX3V9oJtOcWvMzMWGcL+Hbw051zHtmpKyl/7hMXw/PAlVEfRDFXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919509; c=relaxed/simple;
	bh=s+ATs3T/0z1lxWaNDS+fD7eCbpM+01gl0G1kB0kez1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YmL0uB2MpMHZMiLPRsgy0pERg6kYd2rIpKQJINQMlCqUGFN3gIgO3/ydL/6hlM1z4La7PRjXUyFaYzlZjfElGpX/zokMS/glgto5H/D78auzamODhCsStsjWXdQUL9ZsDbOjfy4zijK+TLdGkTK/Iizk3f35Ok4HXcUUFQjpE3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rbA94J9u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rbA94J9u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3657EC4CEC3;
	Mon, 14 Oct 2024 15:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919509;
	bh=s+ATs3T/0z1lxWaNDS+fD7eCbpM+01gl0G1kB0kez1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rbA94J9ufV1CvLVV95ngYsHg931DGw2VsbvjiWTiZa1IhvhYoftNJhurZtEuvzxDb
	 +9wHs9qCBEivnFQ3LPF9K162fOVWf/IqZ2Yzuep+zA9cLlkcpemydbqoKPeTJ2fX2s
	 hGvmARpyEZnm2IAi+3VchvVTEPsxYpnTePWvfR6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 599/798] Input: adp5589-keys - fix NULL pointer dereference
Date: Mon, 14 Oct 2024 16:19:13 +0200
Message-ID: <20241014141241.536021459@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


