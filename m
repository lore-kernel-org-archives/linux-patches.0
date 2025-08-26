Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1893C30F55C;
	Tue, 26 Aug 2025 11:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207748; cv=none; b=ZiBx1K6SU1Tv5tDrWD8sETZf9JMaJtD+wpuYTsNTBuegbonCGIFJbmC4uSm7VnFvBe9rUmjfDEfnH1ZKY1S33jn9U13Uqn27ctFgZvk6WEelmNsZ0Yqob+G1yPEJJEpOJ+DTkiISzxkJzQ5Qmwr4ER4tyN+nethV7zbPxwsb4Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207748; c=relaxed/simple;
	bh=3Y4tSHO90pFpJ04qAMElXA++ObEcTvhyfGblepnp30c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IRndIK+knrrnI8m+woPolEn5gZ349fVAjuYEvHVokkx2sPcLzcsxbIvVVBpCYZlNe2spjLnygP2YwUnNGBs+sv3AgZDPJwJHX389qzn8fNTErbQCE8DPLSGUF0S8EX8T0C0k+pEFFqNEokNH3hVy027sNUVQJnCxQESz8kBACD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UCUcNFPg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UCUcNFPg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C101C4CEF1;
	Tue, 26 Aug 2025 11:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207748;
	bh=3Y4tSHO90pFpJ04qAMElXA++ObEcTvhyfGblepnp30c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UCUcNFPg3htRfnaNAbkRC3OvQkHuJUVuy6uaWGuQSXjzKjeL+M/nk8ae+Z15ad8yQ
	 y7Cq3ECH9VBYNDLDVpr8Nxx65SpPRm5eO0ZhuH/gfGTlinVAgFwYzTb5TUNd6kCab9
	 nRsv15UDN3DXp8Pf/uPnBir5rB12sMB/j9Zen3uA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.16 301/457] iio: pressure: bmp280: Use IS_ERR() in bmp280_common_probe()
Date: Tue, 26 Aug 2025 13:09:45 +0200
Message-ID: <20250826110944.811497046@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3216,11 +3216,12 @@ int bmp280_common_probe(struct device *d
 
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
 


