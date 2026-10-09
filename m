Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353504EF131;
	Fri,  9 Oct 2026 14:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556932; cv=none; b=GTB1QxVjSMGqdKqUSsEmakfhcdzOPjyT/xR7E/BMRdsjFJPiQY+G6O3bk1YB2rn7ra4HK8jEnwHeo/xKw3m/sG8Rhy0TrgGLNQgHCuLRNdKhi7MZr6lhBP7Ru9BW9nUn7Azfh7fizBTssQuFAewJDshwsfZ/HAT7ZeEtXezOkX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556932; c=relaxed/simple;
	bh=Ovp2pzkv9elwVw269bHODoNk/oN3xytzbqw2aq1yhZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U1HxXRjGkhF8RnR06DPCY71XBuBMji+51sG3DfFisZdb+X6hw4Mj9WDDV5/9MqqqNmH/V1uUD0Jg3ENrg+7euckrF1omh39EMxAzB8wFJMwxyy9IgKS23u8f5z0rI59dVwpeD3sTA2BKgo+znNIOKcHnYBIF4lhSfGoxNE3/bIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FpgppWEV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FpgppWEV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9302F1F000FF;
	Fri,  9 Oct 2026 14:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556931;
	bh=ZYnudBleefTqqXoMawYR0bkhVFa3tXSX+0dne4NdRlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FpgppWEVBw2G/BTrW2RGwWsuV3GgjEdVym/kBIh7qoPErLKgCWSh5pIiRUO8iiO4s
	 iBkR/vWQyZVcZmW7z/Vi0QvjeYk5waMzaXhKVg0G77LbR9/IfeN+ZfrYbmy/xI/8q2
	 VX1aDQWJJ4YEfSEafGCbvVL1mV6k4DEQL3Kue7Wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 316/403] iio: adc: sun4i-gpadc-iio: clean up on thermal zone registration failure
Date: Fri,  9 Oct 2026 16:11:17 +0200
Message-ID: <20261009140959.614156244@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


