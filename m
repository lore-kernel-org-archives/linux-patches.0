Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F581DF732;
	Tue,  8 Oct 2024 13:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393951; cv=none; b=EIEqPcxJj6awpimwCBGIrr4kHVJ2zu9X5OTZIyvBEPB5JouRrK10bSch53+/3pMDjacBd4zFOt25+8HO5HAeqOtRn/kzqubWSLQCswDWiC0J33cUKHMR36yutoFS97AgIrpgyJ7mGiOfthmaI6yk2170aqInaBTJK6ROmLu3suk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393951; c=relaxed/simple;
	bh=3ndpXPgqeQsxyud0YFRSgwZ4AWdr3q1oMXTQgd3AEKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ECsHs5qWKpPcEG6pv6OU/AwF4a77BXn8cZnW1H/y4E6k/PdD8FpEoRVMtr59EBAv+08Mkku/mJSRNJ8BWnthYcx+oF0s1+3q+nKrLPdzkpj1Ij+MtmnXmwgQi6ZqpvxUeUXblUphA7V5adszQ+eoATbySSm0UIPHIXIkt3//2HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x8qIkfhx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x8qIkfhx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B3BFC4CEC7;
	Tue,  8 Oct 2024 13:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393950;
	bh=3ndpXPgqeQsxyud0YFRSgwZ4AWdr3q1oMXTQgd3AEKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x8qIkfhxAmVbFCsnrD2GTDmCRs2uE0yjuvokmboA9kSdJdET8IDKDVUmxB3Ds74ax
	 GyHzIIkqZGLcL4gtYsXH2xe5/BeV5YpvPy06WAFR7ZiGQf0XXHc34HLDJ9ZmTgTZZE
	 98lJN1EjR/BLdFGaRFyjS/yHRjSsjhtI2PIrOngA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 303/386] Input: adp5589-keys - fix NULL pointer dereference
Date: Tue,  8 Oct 2024 14:09:08 +0200
Message-ID: <20241008115641.311371858@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


