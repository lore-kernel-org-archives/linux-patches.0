Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F56196C82;
	Thu,  6 Jun 2024 14:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682914; cv=none; b=Zdskf8tbWq8qvhN8NHCMweRZ2nXxTMLNfV06CW1dS1vlrd6hbkKanfhzWdDqr8nao0yDs49HdxRNQOPODFVZVwpUWNBXdh5ZetQftzdMPJ5Y8PCJUDnyutN+g5lrKHedgwdcpJGskychJchLf7QDV/CHoordwGu+N59SgE3erFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682914; c=relaxed/simple;
	bh=YtQOr2nupnuhUP9xqQKBxyc/TaNZt49Q8vDbSSgBMyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C7Qgvf7YKMq4T1etwMr5fi7+8QD/Z+I1iMU2GCVDAdFoSSRS2rOzLED/w5aopkfOcMw/mandr54K6P+mpGmFmCpMQ7eeRNN5Zx4YSSJgmVrBVWtoLhpB2RINr8mdDAe2Y6nlca1Xhl3lUYxT3eq4urYcdsnRHDpuV15JI66FxVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qkHy23EI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qkHy23EI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 705A2C2BD10;
	Thu,  6 Jun 2024 14:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682914;
	bh=YtQOr2nupnuhUP9xqQKBxyc/TaNZt49Q8vDbSSgBMyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qkHy23EIwW9gldy0rnXJ+AC+atrRjPCtUKe5qK8PbSgnx2mo0JNfKYe1HZ3vG0gz0
	 dypSF5h1zGyubQYbjim64+FylTtK/YJaXrpS2U1EsdEC/zwpiV0YPiaKUp73HQS26D
	 8yCHpX8ATmhAqxUiO+n+xiQWRh0Enmo3pJ4joQQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Moysan <olivier.moysan@foss.st.com>,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 045/374] iio: adc: stm32: Fixing err code to not indicate success
Date: Thu,  6 Jun 2024 16:00:24 +0200
Message-ID: <20240606131653.318027961@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 3735ca0b072656c3aa2cedc617a5e639b583a472 ]

This path would result in returning 0 / success on an error path.

Cc: Olivier Moysan <olivier.moysan@foss.st.com>
Fixes: 95bc818404b2 ("iio: adc: stm32-adc: add support of generic channels binding")
Reviewed-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Link: https://lore.kernel.org/r/20240330185305.1319844-4-jic23@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/stm32-adc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/adc/stm32-adc.c b/drivers/iio/adc/stm32-adc.c
index b5d3c9cea5c4e..283c207571064 100644
--- a/drivers/iio/adc/stm32-adc.c
+++ b/drivers/iio/adc/stm32-adc.c
@@ -2234,6 +2234,7 @@ static int stm32_adc_generic_chan_init(struct iio_dev *indio_dev,
 			if (vin[0] != val || vin[1] >= adc_info->max_channels) {
 				dev_err(&indio_dev->dev, "Invalid channel in%d-in%d\n",
 					vin[0], vin[1]);
+				ret = -EINVAL;
 				goto err;
 			}
 		} else if (ret != -EINVAL) {
-- 
2.43.0



