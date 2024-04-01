Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83A81C0DE7;
	Mon,  1 Apr 2024 16:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990183; cv=none; b=AETPTQfFca1Ov08dgzLDTkTyMBEUvlIDunDDXM4UzzIQBNWX0a/vfenXXHwYlmH9HdqPb0/m7Jgyy3OBBSLCOS/4Wv7Xb1anIrnuDXrGS6MQ7ZOzr3rj0Oims4QOh42TGNsIfKG8IyhydJBZg3NzTIYmoSGzZUhcbatoz7dAoy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990183; c=relaxed/simple;
	bh=IAbDnKXk8x1C78LW8K6mRKEKIccBsiZ0nXPTUwKmS1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pk03roW0lPyeM8soXfXrWNQduP6XmaF+QoaSkseLeMRYKnO2OonGpNHKL0E50nr3l5CFELS/ed+I90w62P0mC3WQ52N6F1UjsZxEElQXdSOSNsU7m+vM33vK6WJBPI4ZxXi29mMxmpKTc44tEcq3ZkAcdsYZZMcn4M7zLnzv+7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y45pnZUZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y45pnZUZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 408C9C433F1;
	Mon,  1 Apr 2024 16:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990183;
	bh=IAbDnKXk8x1C78LW8K6mRKEKIccBsiZ0nXPTUwKmS1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y45pnZUZXyDwjsXhv1KTkY/RSiFTIcze3lo/oW/UDFA4RtCeq4GBcEwzcfloaxhcD
	 RQm8NYFt8Nr0nZGNQzc+HvlOL7K3MbRVP69rGb52U+hdKCbct6Wc+DhwzUB9UsTypm
	 nPLjKu4cYzibBA7hw8n2BLjcL6dRb0Doy7O34L1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andi Shyti <andi.shyti@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 6.6 244/396] i2c: i801: Avoid potential double call to gpiod_remove_lookup_table
Date: Mon,  1 Apr 2024 17:44:53 +0200
Message-ID: <20240401152555.187870975@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

From: Heiner Kallweit <hkallweit1@gmail.com>

commit ceb013b2d9a2946035de5e1827624edc85ae9484 upstream.

If registering the platform device fails, the lookup table is
removed in the error path. On module removal we would try to
remove the lookup table again. Fix this by setting priv->lookup
only if registering the platform device was successful.
In addition free the memory allocated for the lookup table in
the error path.

Fixes: d308dfbf62ef ("i2c: mux/i801: Switch to use descriptor passing")
Cc: stable@vger.kernel.org
Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-i801.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -1417,7 +1417,6 @@ static void i801_add_mux(struct i801_pri
 		lookup->table[i] = GPIO_LOOKUP(mux_config->gpio_chip,
 					       mux_config->gpios[i], "mux", 0);
 	gpiod_add_lookup_table(lookup);
-	priv->lookup = lookup;
 
 	/*
 	 * Register the mux device, we use PLATFORM_DEVID_NONE here
@@ -1431,7 +1430,10 @@ static void i801_add_mux(struct i801_pri
 				sizeof(struct i2c_mux_gpio_platform_data));
 	if (IS_ERR(priv->mux_pdev)) {
 		gpiod_remove_lookup_table(lookup);
+		devm_kfree(dev, lookup);
 		dev_err(dev, "Failed to register i2c-mux-gpio device\n");
+	} else {
+		priv->lookup = lookup;
 	}
 }
 


