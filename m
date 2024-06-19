Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F3D143757;
	Wed, 19 Jun 2024 13:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803475; cv=none; b=V1P6ac2VSTsEm9+ijuPQP9VNgTzDB3NKH51MhbRszcbl73hnWYVphZzjA8x80WXF855Rd/8FHE9FAKdqL+EUzoJHGUEJG/ZH4JTaIM0g72iVwYz7Wp+34YYsPou/sDbt4+qW5yGF2xK3EY3uIVfsMv5ZeQ7AE1xx6WkaIagIch0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803475; c=relaxed/simple;
	bh=lVB4RAhzyTlsEE1H9ka52rCWoKrXIiO4p/dPbokpR0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qywzT1vNSJtpaRMc9dPGYpQuPILpimldeCYAF3rAYVy6TVoVIA5yAEi2aIIZhCpZpa4aMbgglMXlRvyQDTZE3SVSG9GSjDgXCT6D5Xy5XsesdwjR91GltJ6ui5tIPrOwu9TELzY3lmiOi5Zz0679/pmB8jN+aOhDjxRKr2wdhzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DFC52DX8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DFC52DX8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE50C32786;
	Wed, 19 Jun 2024 13:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803474;
	bh=lVB4RAhzyTlsEE1H9ka52rCWoKrXIiO4p/dPbokpR0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DFC52DX8wawOiHis/8EMRitEmqs9ZjnMzCK8FqyKiacL7czXYE5RvX0H1A978I0YG
	 lYuMjDqAWLzQda/9mHvTH05J4MR0yMUQb//hTiuRBw4ee0KrKVPdkZn6LmjM9f3jTv
	 3VLCH1mAYeNDtl53z2Xrk+h7orXqOGItxuPGuAYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.9 248/281] iio: adc: axi-adc: make sure AXI clock is enabled
Date: Wed, 19 Jun 2024 14:56:47 +0200
Message-ID: <20240619125619.505827749@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sa <nuno.sa@analog.com>

commit 80721776c5af6f6dce7d84ba8df063957aa425a2 upstream.

We can only access the IP core registers if the bus clock is enabled. As
such we need to get and enable it and not rely on anyone else to do it.

Note this clock is a very fundamental one that is typically enabled
pretty early during boot. Independently of that, we should really rely on
it to be enabled.

Fixes: ef04070692a2 ("iio: adc: adi-axi-adc: add support for AXI ADC IP core")
Signed-off-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20240426-ad9467-new-features-v2-4-6361fc3ba1cc@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/adi-axi-adc.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/iio/adc/adi-axi-adc.c
+++ b/drivers/iio/adc/adi-axi-adc.c
@@ -175,6 +175,7 @@ static int adi_axi_adc_probe(struct plat
 	struct adi_axi_adc_state *st;
 	void __iomem *base;
 	unsigned int ver;
+	struct clk *clk;
 	int ret;
 
 	st = devm_kzalloc(&pdev->dev, sizeof(*st), GFP_KERNEL);
@@ -195,6 +196,10 @@ static int adi_axi_adc_probe(struct plat
 	if (!expected_ver)
 		return -ENODEV;
 
+	clk = devm_clk_get_enabled(&pdev->dev, NULL);
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
+
 	/*
 	 * Force disable the core. Up to the frontend to enable us. And we can
 	 * still read/write registers...


