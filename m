Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA9A30EF8B;
	Wed, 25 Feb 2026 06:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002709; cv=none; b=DDwCPGo73AUhUtyqv+MQ59zePx04x1tB6+vXjwCANLibC6uvC8OuywayzvHRcbpuuJr1wQZ3JQuTnSbEG6uKZcre9CirNqqG2FP+OM38y5u9WJzTdS9f7lU3RRFUopXx7TdECl6CM7qOq22hAcbqu2E9aoQYnZBqovBcreyWbn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002709; c=relaxed/simple;
	bh=LAV+s3U/SAmy7B3aLhLGjWefP8aPiH84iOMSfp0oAxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MrvRHpZw+U+bbexJY2ilUxt0+vMhOkJyGtnV+qOgv7NPA/f0CTIsi0ObK+HZXaRQjR5Pb9HXSXcuNpNomJfHfsW+NfVC4BKmVL8etmmSM11P6X8mP72Y1Kt+iTjV0Ti54gkIOburLck6nCvTbOd0GPxEVrzqmmOaXEJsnUGQcYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vmH1unlL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vmH1unlL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13E7BC116D0;
	Wed, 25 Feb 2026 06:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002709;
	bh=LAV+s3U/SAmy7B3aLhLGjWefP8aPiH84iOMSfp0oAxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vmH1unlL1dp8sVzYkJsHuKhY+ES2ncM/bQkO/3iNkR/phJ5zcBgtFAjq9oT1kCa5+
	 ZQB07U70TppFtncRqOGQs8AwwZ5dGR+xWiArLHHtJDUWcjNcWmEGALnuqmFAoGY2LF
	 2iGJYBiaWIJyKX4JaLeSk7BGZfuTJL0Py4GsKehY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petre Rodan <petre.rodan@subdimension.ro>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 469/641] iio: pressure: mprls0025pa: fix interrupt flag
Date: Tue, 24 Feb 2026 17:23:15 -0800
Message-ID: <20260225012359.876896947@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Petre Rodan <petre.rodan@subdimension.ro>

[ Upstream commit fff3f1a7d805684e4701a70bfaeba39622b59dbc ]

Interrupt falling/rising flags should only be defined in the device tree.

Fixes: 713337d9143e ("iio: pressure: Honeywell mprls0025pa pressure sensor")
Signed-off-by: Petre Rodan <petre.rodan@subdimension.ro>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/pressure/mprls0025pa.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/pressure/mprls0025pa.c b/drivers/iio/pressure/mprls0025pa.c
index 2336f2760eaeb..4b23f87a822b1 100644
--- a/drivers/iio/pressure/mprls0025pa.c
+++ b/drivers/iio/pressure/mprls0025pa.c
@@ -418,10 +418,8 @@ int mpr_common_probe(struct device *dev, const struct mpr_ops *ops, int irq)
 	data->offset = div_s64_rem(offset, NANO, &data->offset2);
 
 	if (data->irq > 0) {
-		ret = devm_request_irq(dev, data->irq, mpr_eoc_handler,
-				       IRQF_TRIGGER_RISING,
-				       dev_name(dev),
-				       data);
+		ret = devm_request_irq(dev, data->irq, mpr_eoc_handler, 0,
+				       dev_name(dev), data);
 		if (ret)
 			return dev_err_probe(dev, ret,
 					  "request irq %d failed\n", data->irq);
-- 
2.51.0



