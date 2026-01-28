Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E053064B3;
	Wed, 28 Jan 2026 15:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615685; cv=none; b=anhT0ZRuBoOPssE0DzDelyvG+2vwH8/QrArGH6zX4Ta054LD+Yr7ihMGbf0I6+ONIPrpoT9Q+APamiuR4SoDTq2LqSEjJ/T65JLlrZI6PduqfO9vmZJB6a8zlU7W47/IIxBp+ZfyvcPJ5SdbqDBhOeoo522Fx7Emn8L9U8cIRSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615685; c=relaxed/simple;
	bh=Bi8UooIjpO4O/7ykGq9wly7n40m4N3M+VmWklMoszSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jKsUJYBrT+YJtZG+Kpu3gWDks8+s+7ulGRCzYNvfLv8ne9jTHpbpLCJLI71BLX/anO1H+Urx3c0xhaYa03Z7p79eKETR6kcjuznE6Y2HlUwLkCzQGt+AklPvd/gpYfdQRtZlI8pruhciR/SswjzTtcHw5N5TBTfQ7bS5RgtuNeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HwfrJMEV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HwfrJMEV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E50BC4CEF1;
	Wed, 28 Jan 2026 15:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615685;
	bh=Bi8UooIjpO4O/7ykGq9wly7n40m4N3M+VmWklMoszSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HwfrJMEVWHDhOfVi7rMuA+lNFb3O4cXqIoN87RyHeeLTzzF2zc4q+jox3nbvkMeW4
	 Bg0GpDNqY4EJiczz5SkmOx5bpF0STzbbIv1WORH8AIbXmUdJlUkUAXUwXMJTwycUEj
	 Vzok6g+BQlJe445FGVc60zyjRsRPXlN2SdjZ6MfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Andy Shevchenko <andy@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 083/227] iio: adc: ad7606: Fix incorrect type for error return variable
Date: Wed, 28 Jan 2026 16:22:08 +0100
Message-ID: <20260128145347.327690898@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit c5512e016817a150fd6de97fbb3e74aa799ea3c1 ]

The variable ret is declared as unsigned int but is used to store return
values from functions returning int, which may be negative error codes.

Change ret from unsigned int to int.

Fixes: 849cebf8dc67 ("iio: adc: ad7606: Add iio-backend support")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7606_par.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ad7606_par.c b/drivers/iio/adc/ad7606_par.c
index 634852c4bbd2c..b81e707ab40c5 100644
--- a/drivers/iio/adc/ad7606_par.c
+++ b/drivers/iio/adc/ad7606_par.c
@@ -43,7 +43,8 @@ static int ad7606_par_bus_setup_iio_backend(struct device *dev,
 					    struct iio_dev *indio_dev)
 {
 	struct ad7606_state *st = iio_priv(indio_dev);
-	unsigned int ret, c;
+	unsigned int c;
+	int ret;
 	struct iio_backend_data_fmt data = {
 		.sign_extend = true,
 		.enable = true,
-- 
2.51.0



