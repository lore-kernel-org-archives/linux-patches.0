Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437A33D961;
	Mon,  1 Apr 2024 16:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988779; cv=none; b=Rdl380pEUhzk1QFMqyjgl3tLdJ1vyzfyR+9Ju3UwEGTCP2YkKh7Q7pgS+beSUDmSimV3s7ZttvRQF0UA/WTqoJNdo71cjJN2E3eXrdrjtnUUnoaReh47yI5/OWiO3fV7/Lf46n1KmxW2j3naswzu8o7wnRh88fW+4Q4HsGK43EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988779; c=relaxed/simple;
	bh=ps4jrpTjeGLL/icB7VsgbyyKKoIR/fENQ6T8hKBULTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ll9yyDuUd6yln51Z5nu0PXF2hh1yvw2XP8wRKywhGzTJQaYJ5RRnjj/DgrwNqQv1zKDM/1H++dV07IrRS5BTrz3gNNHTdEuh4sKw3SqGs94JW0PFlxgsWSwkqIQK1cNmT4pIN2WdzD9iB/5UNa75fwMF+POtYlUEhBA0+o+KBds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=StuCD2rq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="StuCD2rq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A80DEC43390;
	Mon,  1 Apr 2024 16:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988779;
	bh=ps4jrpTjeGLL/icB7VsgbyyKKoIR/fENQ6T8hKBULTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=StuCD2rqbJI2htTDW/LFKbMq2fJH9xPXCcxF6qYwginKobx9+jBkMJVUnfORz1Gtl
	 gTiyJMLkmMCOZwC4raHsuf/B2w/Zy/63xnLaYLpazb6S11h/Dzqlro1F3vr2NEYWez
	 Uif9Qg/98E616hZtXiFqW5CvUH4mT5NtE7jgDasc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andi Shyti <andi.shyti@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 6.7 285/432] i2c: i801: Avoid potential double call to gpiod_remove_lookup_table
Date: Mon,  1 Apr 2024 17:44:32 +0200
Message-ID: <20240401152601.673792496@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1414,7 +1414,6 @@ static void i801_add_mux(struct i801_pri
 		lookup->table[i] = GPIO_LOOKUP(mux_config->gpio_chip,
 					       mux_config->gpios[i], "mux", 0);
 	gpiod_add_lookup_table(lookup);
-	priv->lookup = lookup;
 
 	/*
 	 * Register the mux device, we use PLATFORM_DEVID_NONE here
@@ -1428,7 +1427,10 @@ static void i801_add_mux(struct i801_pri
 				sizeof(struct i2c_mux_gpio_platform_data));
 	if (IS_ERR(priv->mux_pdev)) {
 		gpiod_remove_lookup_table(lookup);
+		devm_kfree(dev, lookup);
 		dev_err(dev, "Failed to register i2c-mux-gpio device\n");
+	} else {
+		priv->lookup = lookup;
 	}
 }
 


