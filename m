Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD39134D3BE;
	Fri,  9 Oct 2026 14:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557521; cv=none; b=lmRRcLQTunwfW3ffe161hvCD20IfYHiNRL4JOaZsICtNsoxx+VnW9F412rEoKyIdwZmJ0PgHtdxBb5BS1CdCTdfiJaFRnDZ26duMXGe1mt8LEheAJNFZ7kSdYXjTpJ+DUvlaXJljEYgB23Lq+iXxT33RL+cG9YMgScFB/LQjdcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557521; c=relaxed/simple;
	bh=xf4B8FNEd89OTeDT+KgEe6dGlQOQgT6yOXf5BgKpeGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CsR8+yrk2DyS9hPBv1jq5RjtBfKWRdPEUWEAtcjBsl8OrG6Dl2iMxqD5C1Yfw9lXa1CObIuHM0/ZaOGV9D9Qv07Izu3Qk4w4cKy9x2f5oqsBj6WJXj/yKtI9vYidEHWS3hCRQhokXTN6Nl+Ny6Rvg/VMXALMlAqZNGwoK8BoPJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=osC6jTDj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="osC6jTDj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378551F000FF;
	Fri,  9 Oct 2026 14:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557520;
	bh=HajUC7lhYw6r5RD+xHWgpjjATl4No2SdRW/xvGRpEGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=osC6jTDjicW/bI9EB2CGOTvsMZZ3e+jINrFZCFaxYWGecTRUReu6wgcBqvxQuP4qs
	 BZzsOE5l8AEbUdibG8bkMStk0khhj5WXNeK700asEag367No1lLJWz/MwRCJHOZi59
	 R/Ez2wPdYb0mMo+eGyl7F5QP3vw2TEry+vajOpuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 387/428] iio: adc: rohm-bd79124: Fix GPIO mask check
Date: Fri,  9 Oct 2026 16:12:04 +0200
Message-ID: <20261009140954.698293807@linuxfoundation.org>
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

commit d081c116a16489f7808d35fcf1ee9d4b9869d204 upstream.

The ROHM BD79124 has pins which can be configured as GPOs or as ADC
inputs. The bd79124gpo_set_multiple() is intended to ensure that a pin
which is requested to be toggled, is indeed configured as a GPO.

The check uses XOR, causing it to fail if mask is not exactly same as
GPO configuration. Eg, if not all GPOs are asked to be toggled at once.

Fix this by checking that mask does not contain pins that are not
configured as GPO, allowing some of the pins which are configured as
GPO to be untouched.

Fixes: 3f57a3b9ab74 ("iio: adc: Support ROHM BD79124 ADC")
Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/rohm-bd79124.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/rohm-bd79124.c
+++ b/drivers/iio/adc/rohm-bd79124.c
@@ -200,7 +200,7 @@ static int bd79124gpo_set_multiple(struc
 	if (ret)
 		return ret;
 
-	if (all_gpos ^ *mask) {
+	if (*mask & ~all_gpos) {
 		dev_dbg(data->dev, "Invalid mux config. Can't set value.\n");
 
 		return -EINVAL;


