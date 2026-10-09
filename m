Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6AE02C0F6D;
	Fri,  9 Oct 2026 14:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557547; cv=none; b=E+xWM69gfejldpvXAawkGU7/SmbjEETO2iYZbbUhzhJFxqv7vs5C6yTg8hgQAmc6O4D22oq3jVJoj66x1bG+gxMzM9uZaEb3SvigWzm/5TDHLJLNX8znCZcuusMzKpaReApYD0MMJgSeiq7phArJLoukKgJDDXsGFfDCkxqkc84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557547; c=relaxed/simple;
	bh=ZxQuyTEGJU7oyOoSbS3czlGbWM2dMqzzHsT09kLq4qA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jeAUC/4UP66ag05TWRDkcYHVH4zZ1t8tsPBM/NB3ruXqpH6WnNTd9kH6ujawXfMc+RQqsX4raBaNpF9KBnctZYbdR/9UC1b2n6PN1ut/ezQDPO4k7V8q33+m4AowqqTKZmd84rwlmDlRbk+x91GtmEH9WHqHwXmmQ3GKDS5SXJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sYjNFCV/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sYjNFCV/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 211961F000FF;
	Fri,  9 Oct 2026 14:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557546;
	bh=wKJ3T5ihdyQXvpDXlYZJp5q5G/7CI9SCNZSlhWKPQ18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sYjNFCV/kR53iumUVzlVc9EndJJ5ZWEcpCBLJpreGJ93y9Aodjy+gYTe74Gw8hzo5
	 pFcyfrl8Om/TBqwSE1hLa8KFAPgFXSL6Fm4GUNVlGzndw8nJhkwJwm91KF+LuIfx/P
	 /7ouLKso1LsvT4WfhOrzVmjnLKuNFRYpLzeWR388=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 391/428] iio: adc: sun4i-gpadc-iio: clean up on thermal zone registration failure
Date: Fri,  9 Oct 2026 16:12:08 +0200
Message-ID: <20261009140954.792587777@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

commit 2cdc7ef31827db4fbc6283750420639569e1f0e9 upstream.

If devm_thermal_of_zone_register() fails, probe returns without
unregistering the IIO map array or disabling runtime PM.

Jump to err_map to release them.

Fixes: b0a242894f11 ("iio: adc: sun4i-gpadc-iio: register in the thermal after registering in pm")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/sun4i-gpadc-iio.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/iio/adc/sun4i-gpadc-iio.c
+++ b/drivers/iio/adc/sun4i-gpadc-iio.c
@@ -638,10 +638,10 @@ static int sun4i_gpadc_probe(struct plat
 		 * thermal because no thermal DT node is found.
 		 */
 		if (IS_ERR(info->tzd) && PTR_ERR(info->tzd) != -ENODEV) {
-			dev_err(&pdev->dev,
-				"could not register thermal sensor: %ld\n",
-				PTR_ERR(info->tzd));
-			return PTR_ERR(info->tzd);
+			ret = dev_err_probe(&pdev->dev,
+					    PTR_ERR(info->tzd),
+					    "could not register thermal sensor\n");
+			goto err_map;
 		}
 	}
 


