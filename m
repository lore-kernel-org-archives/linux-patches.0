Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA713B19DE;
	Fri,  9 Oct 2026 14:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556878; cv=none; b=eMNf5c9sj7SrlnDM6LYZ6eA/3L35ycXF9QMMhrmsoCW91fqShGp6yb4/k2Texse1D9GbqutYh1BDvedegJa6gkYpEbuF/XuC3jc/5X2gBvYU1hAVY72DsU1dzEfraTisUjkTn5aM6Si5uIol1wgm46lIMYOnkPf/zbzxogNJb+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556878; c=relaxed/simple;
	bh=YbzPzBszdrhpkfDj8bTlgvIjDlV4aYZ0Wwyve4gj4yA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AP2T3+YNqCjbCS+Pny9D2aVlDiC9FirG+WL0LVTkfQyALtv0r5Id/KMZ9MwaDjNxTStWKQMSv937AbQt3FpHVux6ONx3CuqactLgKFsuWoG5Oe+AqFPONiTqaeOlVuwTrtbJrRwpp5GLBI/zIfPaTPQOjQVEBHDaWhxLsKEbXnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XsPZqx2H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XsPZqx2H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D8EE1F000FF;
	Fri,  9 Oct 2026 14:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556877;
	bh=2TRwsx+RwUPy/XbPcx3AleP0gOH0qbTybjmPUhfWruI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XsPZqx2HLUMwEACOnvP2TLVG2mouuJGjVeINziWmEdOyPr49LWTFPPjiBysR1EXOJ
	 G7lEKNEqAewb6VgQ/1Bo37xYdX+oV65phfyF7jHMkVp5ZIXuazCPCSkzqqsOc04/uP
	 T6fnGvwVbwJbmWnF/v5wBeudDVP15hNilTVVJTGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladyslav Ivashchenko <cactucatu4eckuu@gmail.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 307/403] iio: adc: axp288: Add TS bias override for Haier HV103H
Date: Fri,  9 Oct 2026 16:11:08 +0200
Message-ID: <20261009140959.395181419@linuxfoundation.org>
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

From: Vladyslav Ivashchenko <cactucatu4eckuu@gmail.com>

commit 0f300db7b7315b2c7ea0e2d4437b88de162d191f upstream.

The Haier HV103H firmware configures the AXP288 TS pin bias
current to 60 uA. This causes the battery temperature reading to
cross the charging temperature threshold under load, incorrectly
stopping battery charging.

Setting the TS bias current to 80 uA fixes the temperature
measurement and prevents charging from being incorrectly disabled.

Add a DMI quirk to use the 80 uA TS bias current on the Haier
HV103H.

Fixes: 9bcf15f75cac ("iio: adc: axp288: Fix TS-pin handling")
Fixes: 048058399f19 ("iio: adc: axp288: Override TS pin bias current for some models") # Add necessary infrastructure
Signed-off-by: Vladyslav Ivashchenko <cactucatu4eckuu@gmail.com>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/axp288_adc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/iio/adc/axp288_adc.c
+++ b/drivers/iio/adc/axp288_adc.c
@@ -207,6 +207,14 @@ static const struct dmi_system_id axp288
 		},
 		.driver_data = (void *)(uintptr_t)AXP288_ADC_TS_BIAS_80UA,
 	},
+	{
+		/* Haier HV103H */
+		.matches = {
+		  DMI_MATCH(DMI_SYS_VENDOR, "Haier"),
+		  DMI_MATCH(DMI_PRODUCT_NAME, "HV103H"),
+		},
+		.driver_data = (void *)(uintptr_t)AXP288_ADC_TS_BIAS_80UA,
+	},
 	{ }
 };
 


