Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA3E19F424;
	Tue, 17 Jun 2025 16:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178715; cv=none; b=s3r+H/XzMIiiiX0ikVgvizh/vPtGxA7EBr/aQhHibGirYO4e0FvdcpEbZxVeKNafvm76F8gZFagfI2WxUH9kocZJ1PUXB2YZAb+TLF3/27TXHL8okWuMKxOGiH562cl/u6D1QOklsdwweQGEp/8AiWdCvct8lAKy85Q21xsNp2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178715; c=relaxed/simple;
	bh=W0InUr67uCZqLzOq9VqysbWJAfFLZNuZSmmL+DlzqWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FCE3OwVAbq7rKNKYAZw+UkgcSS2I7/bSQ71oMu7MYYr6FKnIjVxJU/bU61KxypaqC/bT5e790qw8IwOhmMGkMZrhFEwcO6WJ5zisuu8Po4XxuH6ugtnuIufVdww4rpxkno2TYdGyQgFmDM/FyCKxKudGn4GWbqlJjPZ+Muvty8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ogAXvnnJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ogAXvnnJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD30BC4CEE3;
	Tue, 17 Jun 2025 16:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178715;
	bh=W0InUr67uCZqLzOq9VqysbWJAfFLZNuZSmmL+DlzqWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ogAXvnnJL/IfjukQPAX4canm+7RX2pozFgS+wsT/zYkxjyWy1JxrPm652S0FyBoZ7
	 FZ49BL9qERnkMLCGN7owL0l693SRqvFimo2x4w9/SrVoBoP4RJ6zY3SsAovhT1H4an
	 zJdMear+N+e6SllQkt0Nym1NoqWsvfWpquVYrnfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 531/780] iio: adc: ad4851: fix ad4858 chan pointer handling
Date: Tue, 17 Jun 2025 17:23:59 +0200
Message-ID: <20250617152513.136377636@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

[ Upstream commit 499a8cee812588905cc940837e69918c1649a19e ]

The pointer returned from ad4851_parse_channels_common() is incremented
internally as each channel is populated. In ad4858_parse_channels(),
the same pointer was further incremented while setting ext_scan_type
fields for each channel. This resulted in indio_dev->channels being set
to a pointer past the end of the allocated array, potentially causing
memory corruption or undefined behavior.

Fix this by iterating over the channels using an explicit index instead
of incrementing the pointer. This preserves the original base pointer
and ensures all channel metadata is set correctly.

Fixes: 6250803fe2ec ("iio: adc: ad4851: add ad485x driver")
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://patch.msgid.link/20250509101657.6742-1-antoniu.miclaus@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad4851.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/iio/adc/ad4851.c b/drivers/iio/adc/ad4851.c
index 98ebc853db796..f1d2e2896f2a2 100644
--- a/drivers/iio/adc/ad4851.c
+++ b/drivers/iio/adc/ad4851.c
@@ -1034,7 +1034,7 @@ static int ad4858_parse_channels(struct iio_dev *indio_dev)
 	struct device *dev = &st->spi->dev;
 	struct iio_chan_spec *ad4851_channels;
 	const struct iio_chan_spec ad4851_chan = AD4858_IIO_CHANNEL;
-	int ret;
+	int ret, i = 0;
 
 	ret = ad4851_parse_channels_common(indio_dev, &ad4851_channels,
 					   ad4851_chan);
@@ -1042,15 +1042,15 @@ static int ad4858_parse_channels(struct iio_dev *indio_dev)
 		return ret;
 
 	device_for_each_child_node_scoped(dev, child) {
-		ad4851_channels->has_ext_scan_type = 1;
+		ad4851_channels[i].has_ext_scan_type = 1;
 		if (fwnode_property_read_bool(child, "bipolar")) {
-			ad4851_channels->ext_scan_type = ad4851_scan_type_20_b;
-			ad4851_channels->num_ext_scan_type = ARRAY_SIZE(ad4851_scan_type_20_b);
+			ad4851_channels[i].ext_scan_type = ad4851_scan_type_20_b;
+			ad4851_channels[i].num_ext_scan_type = ARRAY_SIZE(ad4851_scan_type_20_b);
 		} else {
-			ad4851_channels->ext_scan_type = ad4851_scan_type_20_u;
-			ad4851_channels->num_ext_scan_type = ARRAY_SIZE(ad4851_scan_type_20_u);
+			ad4851_channels[i].ext_scan_type = ad4851_scan_type_20_u;
+			ad4851_channels[i].num_ext_scan_type = ARRAY_SIZE(ad4851_scan_type_20_u);
 		}
-		ad4851_channels++;
+		i++;
 	}
 
 	indio_dev->channels = ad4851_channels;
-- 
2.39.5



