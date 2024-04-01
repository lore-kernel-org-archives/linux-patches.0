Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083A71DFF4;
	Mon,  1 Apr 2024 17:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991136; cv=none; b=LHvEZKVBqobBzHm3t3xlPYclVrqIbWRAkceN7NpXgjbYhxO552pmf6bvmO7ZG7VImlGSqoIxcXXgiatFsYTxzNuvLGSoWUxOR1KAVPN73ir5e57vOqZLTNBhB2fNKXqa7XMYSDOxWwDQBeG5JUV5gYnSYIdX12xWa+Bj63c8KTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991136; c=relaxed/simple;
	bh=XAtt1RdGWmQyUf+Dj3W4WjTJGHZS59yOtUB+dFmSo9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RwNe1ofooou88TRJX5UxTwEv8lllvGNyg/sYSxJvKp7LJa6EZin27o7nnelEhUu1jT5tqvbh2hKsbwKqEBJOHWIe/qkQGeZnTqUj+W7DJUT0uK7KGZtP8Ksaat+vVnBymuCrjunx/npdh7xRyzS0xLzLgYuIpI3RAqKLQJXnJmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wkyX8mHs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wkyX8mHs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA78C433F1;
	Mon,  1 Apr 2024 17:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991135;
	bh=XAtt1RdGWmQyUf+Dj3W4WjTJGHZS59yOtUB+dFmSo9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wkyX8mHsgOW8gan3YhqsFJ1q5VIoGExfezZvzKkyOF9pP3AKYkcSmjJkXcpsQAqqN
	 eK+/OxNeb4ggK2WJFwnYyWs9RvVageYKd8wt5Y7c5S6l9PssFfmVcTDlOVBhAm/GoU
	 xV7aDAOcQO6qTxYZU5HKAaXBZwf73Y1AdzMSEKig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andi Shyti <andi.shyti@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 6.1 173/272] i2c: i801: Avoid potential double call to gpiod_remove_lookup_table
Date: Mon,  1 Apr 2024 17:46:03 +0200
Message-ID: <20240401152536.170590319@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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
@@ -1422,7 +1422,6 @@ static void i801_add_mux(struct i801_pri
 		lookup->table[i] = GPIO_LOOKUP(mux_config->gpio_chip,
 					       mux_config->gpios[i], "mux", 0);
 	gpiod_add_lookup_table(lookup);
-	priv->lookup = lookup;
 
 	/*
 	 * Register the mux device, we use PLATFORM_DEVID_NONE here
@@ -1436,7 +1435,10 @@ static void i801_add_mux(struct i801_pri
 				sizeof(struct i2c_mux_gpio_platform_data));
 	if (IS_ERR(priv->mux_pdev)) {
 		gpiod_remove_lookup_table(lookup);
+		devm_kfree(dev, lookup);
 		dev_err(dev, "Failed to register i2c-mux-gpio device\n");
+	} else {
+		priv->lookup = lookup;
 	}
 }
 


