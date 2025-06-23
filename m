Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396AF1F1522;
	Mon, 23 Jun 2025 13:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684428; cv=none; b=IazhIYn1Crvnyke86C4IQJ8r2vdqbZ3y0ViIaloR0SVEe1J8pB8wfnE/2St1vOEtIoRMiV9fraGblLQ88gNJeCb0T6cw/QYrbIQtNHOXhhgplTJ+go2lLOd6Rz3R3Hfp1CZXDhqHR5Y+Dd2sHMXHUwtJviGXUbTQykJ3ETJWWdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684428; c=relaxed/simple;
	bh=ha+Kr6S/lc4yb69e6apK1g5ZbwCNbFzpbjFbRn9gV0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jwebTH0ha4MQ2XHb16akuJN4jH7XqXWv0RsBzOIU9+ccbKkAzfNz2v9uWH9iTkf+9UjrQoHy328SeDjU60Qgvg1U1OlyXEjM1HasHAPFokRZ50ZSD0qCLsAgDxPEonrtH2ua4iSmZEQ9HS6Lz0zOG7BoCkYkf74/iwXGbwJXjfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BEp6z9Kp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BEp6z9Kp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7156DC4CEF0;
	Mon, 23 Jun 2025 13:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684427;
	bh=ha+Kr6S/lc4yb69e6apK1g5ZbwCNbFzpbjFbRn9gV0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BEp6z9Kp58eAa/gATJMfA7Z+z6n6qLzx28m1sD8ojfEved4f476kT/rvLJaRvwLZF
	 OTjnBkZk/pfCcF1hk7rh/lQhflvN4ONTBzcEJ/60RIVnS/D5OYPjUZZAXpgyCXbuvw
	 uxt3pyCJqPohzG9tcujgflnv1eDTVsVozQrVdLys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jo=C3=A3o=20Paulo=20Gon=C3=A7alves?= <jpaulo.silvagoncalves@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.15 028/592] regulator: max20086: Change enable gpio to optional
Date: Mon, 23 Jun 2025 14:59:46 +0200
Message-ID: <20250623130700.904015955@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: João Paulo Gonçalves <jpaulo.silvagoncalves@gmail.com>

commit e8ac7336dd62f0443a675ed80b17f0f0e6846e20 upstream.

The enable pin can be configured as always enabled by the hardware. Make
the enable gpio request optional so the driver doesn't fail to probe
when `enable-gpios` property is not present in the device tree.

Cc: stable@vger.kernel.org
Fixes: bfff546aae50 ("regulator: Add MAX20086-MAX20089 driver")
Signed-off-by: João Paulo Gonçalves <jpaulo.silvagoncalves@gmail.com>
Link: https://patch.msgid.link/20250420-fix-max20086-v1-2-8cc9ee0d5a08@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/max20086-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/regulator/max20086-regulator.c
+++ b/drivers/regulator/max20086-regulator.c
@@ -264,7 +264,7 @@ static int max20086_i2c_probe(struct i2c
 	 * shutdown.
 	 */
 	flags = boot_on ? GPIOD_OUT_HIGH : GPIOD_OUT_LOW;
-	chip->ena_gpiod = devm_gpiod_get(chip->dev, "enable", flags);
+	chip->ena_gpiod = devm_gpiod_get_optional(chip->dev, "enable", flags);
 	if (IS_ERR(chip->ena_gpiod)) {
 		ret = PTR_ERR(chip->ena_gpiod);
 		dev_err(chip->dev, "Failed to get enable GPIO: %d\n", ret);


