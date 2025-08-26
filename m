Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F072352093;
	Tue, 26 Aug 2025 14:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218214; cv=none; b=HepeEBpQW0knEZoG+G6yfM3ABCOBrsMkQWit7FEtezp3uk8T9XU4OGghHclBiKRxVuJq1GY9qg+pDw1ViE+ajtEAAOuvXm8rBiHJEdEe4hcOyLsQP3ot5diAQKnqE+PMt1YzZKqXqxPXqUfu0A7o4mqC39QFzuujadZbjEPms1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218214; c=relaxed/simple;
	bh=VcjITdyAwWcTym+o+Rf44plT14ULnodfuw5/gyPSKy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T9Rcgq/ix+tXvtQU9Ft7+rNYzpRg+4VCkdYrJEXLUQlBgMfTKzBkPbxxDo8xEpuSkQ0afg3t93aY/60IMWmKOWSMOgQLZPr7D8McJyXl9qdg5/HPPRRuLz9f+7Y0d2ErvCWP6oomkA3gFbG+MWQWtqtMjmXe4lENN2766Sp5GIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b1IbMlgR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b1IbMlgR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7C55C4CEF1;
	Tue, 26 Aug 2025 14:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218214;
	bh=VcjITdyAwWcTym+o+Rf44plT14ULnodfuw5/gyPSKy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b1IbMlgRdUBfdp+07MuYECl9rE3jpCEeCD6icm209Sq51jLAp3sSJxTgWbTmqhifo
	 PFcx7ZhBQbKfcgXvLT6ez5EhzK6o2k3g9nyP/yqZvGZiegY2WpvUXyyBjn5c9UsYmB
	 aD1KSejcyv98KcyordBD8wiWtaCApE5KgEIMIHYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 406/523] iio: pressure: bmp280: Use IS_ERR() in bmp280_common_probe()
Date: Tue, 26 Aug 2025 13:10:16 +0200
Message-ID: <20250826110934.474376828@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Salah Triki <salah.triki@gmail.com>

commit 43c0f6456f801181a80b73d95def0e0fd134e1cc upstream.

`devm_gpiod_get_optional()` may return non-NULL error pointer on failure.
Check its return value using `IS_ERR()` and propagate the error if
necessary.

Fixes: df6e71256c84 ("iio: pressure: bmp280: Explicitly mark GPIO optional")
Signed-off-by: Salah Triki <salah.triki@gmail.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250818092740.545379-2-salah.triki@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/pressure/bmp280-core.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/iio/pressure/bmp280-core.c
+++ b/drivers/iio/pressure/bmp280-core.c
@@ -1064,11 +1064,12 @@ int bmp280_common_probe(struct device *d
 
 	/* Bring chip out of reset if there is an assigned GPIO line */
 	gpiod = devm_gpiod_get_optional(dev, "reset", GPIOD_OUT_HIGH);
+	if (IS_ERR(gpiod))
+		return dev_err_probe(dev, PTR_ERR(gpiod), "failed to get reset GPIO\n");
+
 	/* Deassert the signal */
-	if (gpiod) {
-		dev_info(dev, "release reset\n");
-		gpiod_set_value(gpiod, 0);
-	}
+	dev_info(dev, "release reset\n");
+	gpiod_set_value(gpiod, 0);
 
 	data->regmap = regmap;
 	ret = regmap_read(regmap, BMP280_REG_ID, &chip_id);


