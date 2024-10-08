Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695E733981;
	Tue,  8 Oct 2024 12:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389958; cv=none; b=tqYXoXRwK3mPSdwnkrFnX2hBRySJlAo7wPacedIUwuQA6IHnGLV3UXY4ygONp8NzY2HUoPe2ys9jh9uA4dEhCyZ/Kl9I6iYEe92fxL7iT+pgRgT+sNJ4oybqtnBLk4l4/qB18GHs2sU3RGJWRorBisZ9jMrTP5xKPQq8rK+Akew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389958; c=relaxed/simple;
	bh=cOGabxGkDKHjTOKiD7P4SUGiVEWNeTDJlA+uBWGCKN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mQ1rS77X9s7JSEVTAqp385ReULTg1oX+f4H7WkQc3r7Y5oZ3O035W0MVsCrjtz1BP6iYaSLbjYr5onqgVsfB5exhZH5OfMPQsIH0jge1XVe8uvnhe0i6rvX6UZWuojWEUC89uEsdd7wGK/BVgdJ3GI2azCwHSdtA+eN8VcAUtbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xRIMJyKg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xRIMJyKg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4C0C4CEC7;
	Tue,  8 Oct 2024 12:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389958;
	bh=cOGabxGkDKHjTOKiD7P4SUGiVEWNeTDJlA+uBWGCKN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xRIMJyKgiFVy30tvNqxQIf8UC18+g194Yc0YeuEUQgjTeA0fdJksSGT31/s3MRQlU
	 5AR+wN291IOIN55iK60l41iLvES7FVH/pQ9qN2NHFsM7IGFo36hOQIaQf9qrNDi2yb
	 hUzrh/R1xpxcaOuGp5GH5irpcGfy95nT53QmfAys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 147/482] ASoC: codecs: wsa883x: Handle reading version failure
Date: Tue,  8 Oct 2024 14:03:30 +0200
Message-ID: <20241008115654.092597925@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 2fbf16992e5aa14acf0441320033a01a32309ded ]

If reading version and variant from registers fails (which is unlikely
but possible, because it is a read over bus), the driver will proceed
and perform device configuration based on uninitialized stack variables.
Handle it a bit better - bail out without doing any init and failing the
update status Soundwire callback.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/20240710-asoc-wsa88xx-version-v1-2-f1c54966ccde@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wsa883x.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/sound/soc/codecs/wsa883x.c b/sound/soc/codecs/wsa883x.c
index 2169d93989841..1831d4487ba9d 100644
--- a/sound/soc/codecs/wsa883x.c
+++ b/sound/soc/codecs/wsa883x.c
@@ -998,15 +998,19 @@ static const struct reg_sequence reg_init[] = {
 	{WSA883X_GMAMP_SUP1, 0xE2},
 };
 
-static void wsa883x_init(struct wsa883x_priv *wsa883x)
+static int wsa883x_init(struct wsa883x_priv *wsa883x)
 {
 	struct regmap *regmap = wsa883x->regmap;
-	int variant, version;
+	int variant, version, ret;
 
-	regmap_read(regmap, WSA883X_OTP_REG_0, &variant);
+	ret = regmap_read(regmap, WSA883X_OTP_REG_0, &variant);
+	if (ret)
+		return ret;
 	wsa883x->variant = variant & WSA883X_ID_MASK;
 
-	regmap_read(regmap, WSA883X_CHIP_ID0, &version);
+	ret = regmap_read(regmap, WSA883X_CHIP_ID0, &version);
+	if (ret)
+		return ret;
 	wsa883x->version = version;
 
 	switch (wsa883x->variant) {
@@ -1041,6 +1045,8 @@ static void wsa883x_init(struct wsa883x_priv *wsa883x)
 				   WSA883X_DRE_OFFSET_MASK,
 				   wsa883x->comp_offset);
 	}
+
+	return 0;
 }
 
 static int wsa883x_update_status(struct sdw_slave *slave,
@@ -1049,7 +1055,7 @@ static int wsa883x_update_status(struct sdw_slave *slave,
 	struct wsa883x_priv *wsa883x = dev_get_drvdata(&slave->dev);
 
 	if (status == SDW_SLAVE_ATTACHED && slave->dev_num > 0)
-		wsa883x_init(wsa883x);
+		return wsa883x_init(wsa883x);
 
 	return 0;
 }
-- 
2.43.0



