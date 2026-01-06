Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04878224B04;
	Tue,  6 Jan 2026 17:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720602; cv=none; b=iej0VcnyLAqI2BceFritg0g+QKc/4iRVivdahMBIm45kcIT/Xjm4by1TtKdUs99rhuhVuSA+gPsIh3C06713Uk3lXfquj+UFlKkDvwkHQopUE8nOT9dzc2x7Ivret1EgoYKKZfszuyWQO4NwGOH7sor18yrF0NLWV8pACcqTmXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720602; c=relaxed/simple;
	bh=b4QIQ3iNDPJN6pPW9IHEZe+SyRHFBpE7A63Eynjso/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OwH63BtnvDKzI865wfogniZTNEGXELXo20z6Fo46wW92JU9mnqdy9w52tvqx98DxCawLOP08wQiDAyM2C1UFlbQEUwWSnuTLq/l5c6G2rt5970wqoUDteSum1AxXIQ+brLRfpJm+LB7gM27x1JBOSlBr81zfISVbQMhiffOySXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HW5vzzQQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HW5vzzQQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B22C116C6;
	Tue,  6 Jan 2026 17:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720601;
	bh=b4QIQ3iNDPJN6pPW9IHEZe+SyRHFBpE7A63Eynjso/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HW5vzzQQR7nOT4xCD5cYgJWcvKhXMssiH7gvOGAP5PE6lzeQZX7du6kNqU0z+VQSh
	 WgBY1NSYU2y+CegzPBvAvdhTaXNyywE6o6fxW+cvORtOuHFefDj9Rf9iY2jIrZCH3a
	 47gANQYIaq2NXnYtztyD+TkItT8x3CvPwyz9lXnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 287/567] hwmon: (max6697) fix regmap leak on probe failure
Date: Tue,  6 Jan 2026 18:01:09 +0100
Message-ID: <20260106170501.950136568@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 02f0ad8e8de8cf5344f8f0fa26d9529b8339da47 upstream.

The i2c regmap allocated during probe is never freed.

Switch to using the device managed allocator so that the regmap is
released on probe failures (e.g. probe deferral) and on driver unbind.

Fixes: 3a2a8cc3fe24 ("hwmon: (max6697) Convert to use regmap")
Cc: stable@vger.kernel.org	# 6.12
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20251127134351.1585-1-johan@kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/max6697.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/max6697.c
+++ b/drivers/hwmon/max6697.c
@@ -548,7 +548,7 @@ static int max6697_probe(struct i2c_clie
 	struct regmap *regmap;
 	int err;
 
-	regmap = regmap_init_i2c(client, &max6697_regmap_config);
+	regmap = devm_regmap_init_i2c(client, &max6697_regmap_config);
 	if (IS_ERR(regmap))
 		return PTR_ERR(regmap);
 


