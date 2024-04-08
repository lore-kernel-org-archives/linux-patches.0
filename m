Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A116D62148;
	Mon,  8 Apr 2024 13:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582369; cv=none; b=iud2csFYetM9RQa3nbPJ/uVeLH+5anJ0aDEdhBynr6qQQcmfVevEVq4x4WjBY1MEgC20Bz0VoyZtrWQPWfX4EPGfwQtuoOoX+JSBnB1uxH7Oj7Rt1BA/dRKq51sS59uLmTj3auLU6zxQh/x3tEFxFmdD+JmRB3hKUSx+VwR1ozg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582369; c=relaxed/simple;
	bh=oTwLBR8aEsWqgmf3NTA+K7Vqbo5muT+r96GEYn78J3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RwVuJy+7lC7Otk30y7MHx2Psf9sEKPp1zWl6w7b4AeAhyI9w5KTCFjxAToStubc6iPKOtXLLv8K66TmoU5g42Wgj1T9pzByq+UdSC3UqB2cx0V0sjioQXsD8p7ftn7o+ZDaqhKXFpgaow7eTmrvyn1YhqliHUAOR/H+rtk0Ksag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vwduV6cd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vwduV6cd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A3BAC43390;
	Mon,  8 Apr 2024 13:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582369;
	bh=oTwLBR8aEsWqgmf3NTA+K7Vqbo5muT+r96GEYn78J3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vwduV6cdvv9QpvkcyuhFTySGVTQ5cDmdU1EWPnIYBE/hVhQ4LuxbdYYND5Mq/w2FZ
	 2IRw52n4M+dPqs4BVYHnna813zbCesBUikNG+iAf/cs1JwAiomVH5Kb8bOELFgVUku
	 4fB3/6Ys/43jxc/hI7gp1rVLAbXSFwU/1XQZpSBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andi Shyti <andi.shyti@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 5.15 136/690] i2c: i801: Avoid potential double call to gpiod_remove_lookup_table
Date: Mon,  8 Apr 2024 14:50:02 +0200
Message-ID: <20240408125404.450770732@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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
@@ -1416,7 +1416,6 @@ static int i801_add_mux(struct i801_priv
 				    mux_config->gpios[i], "mux", 0);
 	}
 	gpiod_add_lookup_table(lookup);
-	priv->lookup = lookup;
 
 	/*
 	 * Register the mux device, we use PLATFORM_DEVID_NONE here
@@ -1430,7 +1429,10 @@ static int i801_add_mux(struct i801_priv
 				sizeof(struct i2c_mux_gpio_platform_data));
 	if (IS_ERR(priv->mux_pdev)) {
 		gpiod_remove_lookup_table(lookup);
+		devm_kfree(dev, lookup);
 		dev_err(dev, "Failed to register i2c-mux-gpio device\n");
+	} else {
+		priv->lookup = lookup;
 	}
 
 	return PTR_ERR_OR_ZERO(priv->mux_pdev);


