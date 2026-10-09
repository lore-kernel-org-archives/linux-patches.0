Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071EA34D3BE;
	Fri,  9 Oct 2026 14:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557519; cv=none; b=maqr9lpN7IZGM/8++PtgumFRXFJ7HhRl492Mv3hnO3Ia5iYp77wy4Un09K2RlUcPFF08dwAiQkylC37M/Wp4hOrhet/5TLp6DzUdua6bT8DYJmkCSirAsz/4oSn8gC7WGzTNjno0ISZBghhaJi4IjOfbZRLgB/7E7/qHDIZeV7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557519; c=relaxed/simple;
	bh=i348Fm+jiNJ++NuRRpH3pW2B42Ojy9vbTNZNyYBgbAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nooy6JxBgMGm5RirI1euplZdf+19uqeQe2c5QII4fHGwkcHjtl3HSsxJXd5tyOv5Na6ruHe7N4im3YNY9fFNYz2EVSL9p7QSn8ZQZe1NwLypOk17y3G/6x9oymAItcqrZAuQsftRMx1LyYkJ3VFxFAhd5CN8WV1oSa+8j96OpLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h9cS0i1B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h9cS0i1B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6607E1F00893;
	Fri,  9 Oct 2026 14:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557517;
	bh=dMRnP5XFtd6EUlBec0yOYkIaXPkGoAj6y9gWmgr4GGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h9cS0i1BlPpBPys3ejJAHs4ERcoOmfR2UDVDOVz0+NPn6R6kUVVSPfkqq3damJDiO
	 JdIQofes/aIwP8ye6cCsBSXrALgBEQ5294sTV4b44RxZV9KFE6DhISNSQnOcoe0o0W
	 fvE8lXnXdwxOSAeIBiTPzT48j6nI1iaBXP0xrKEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 386/428] iio: adc: rohm-bd79124: Fix channel initialization
Date: Fri,  9 Oct 2026 16:12:03 +0200
Message-ID: <20261009140954.675679070@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matti Vaittinen <mazziesaccount@gmail.com>

commit edd56c01d174153bf90160279742ff6f3ad27a93 upstream.

The alarm limit register on BD79124 span to two consecutive registers.
The first register for high-limit containing also hysteresis
configuration. The initialization in driver writes only one 8-bit
register, overwriting the hysteresis and leaving the other limit
register uninitialized.

Fix the limit initialization by using the bd79124_write_int_to_reg(),
which correctly initializes the limit on both of the registers.

Fixes: 3f57a3b9ab74 ("iio: adc: Support ROHM BD79124 ADC")
Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/rohm-bd79124.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/iio/adc/rohm-bd79124.c
+++ b/drivers/iio/adc/rohm-bd79124.c
@@ -927,13 +927,13 @@ static int bd79124_chan_init(struct bd79
 {
 	int ret;
 
-	ret = regmap_write(data->map, BD79124_GET_HIGH_LIMIT_REG(channel),
-			   BD79124_HIGH_LIMIT_MAX);
+	ret = bd79124_write_int_to_reg(data, BD79124_GET_HIGH_LIMIT_REG(channel),
+				       BD79124_HIGH_LIMIT_MAX);
 	if (ret)
 		return ret;
 
-	return regmap_write(data->map, BD79124_GET_LOW_LIMIT_REG(channel),
-			    BD79124_LOW_LIMIT_MIN);
+	return bd79124_write_int_to_reg(data, BD79124_GET_LOW_LIMIT_REG(channel),
+					BD79124_LOW_LIMIT_MIN);
 }
 
 static int bd79124_get_gpio_pins(const struct iio_chan_spec *cs, int num_channels)


