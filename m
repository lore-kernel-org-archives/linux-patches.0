Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC07B3C9893;
	Fri,  9 Oct 2026 14:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555766; cv=none; b=NVhDtE1mB74/0kTXNcJO0jOx27Oz8kHhk5HVHX37m1tgKTdwX74ukDjTcqt/EV+7yLNTqry+pmcSOEEA87PsdATzN33TJktgMFVwn0x0HSzV3ff2FYafc2yZy1O7nYcxxbrBpQ0e4yVNyTONQz6lkxNBatua6zoCIZvWthwMFpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555766; c=relaxed/simple;
	bh=Wkar1EZAeijBTGNRIcPOeqZ8AhmE3b1pDcX2oDdJr5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQaZBBZAPnZlQ8JYXWroApsCubsIXPBulBLzsGgqubd3VCwjjkjen6nmju6pUxbok1IpuG7+GYEpEB4V9N+fXQyPoGBmgsEaa+TvOxzmrUL5GiaNY8vy2qbXXc3p1jhq86RyajoFT5es/cl9q2xkH0oDlAmfh56wJgEteBhB76Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZR7fsoou; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZR7fsoou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F0FD1F000FF;
	Fri,  9 Oct 2026 14:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555765;
	bh=4OdOr51pBB3IzXojzFIB2pw42bqxmlxFj6gmTCeTkO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZR7fsoout/lB+QzizPjvUNXA0CK+pZhV2+EBKdJrcJiimTj1JAv3+c9TQTMNgd4a8
	 HAEY5hUurLv8fJgahYNwal3RKj0Uox84lFen2eeH4fngiACG7ikWPgVHFGeAf6Czzt
	 r86Rkk30D5nfiBioKdEVFTeXcZ+S6DRVqMzXgF2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 066/428] iio: dac: rohm-bd79703: Do not allow writing SCALE
Date: Fri,  9 Oct 2026 16:06:43 +0200
Message-ID: <20261009140947.597316138@linuxfoundation.org>
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

[ Upstream commit 55671fbc3d12ae1f381842433567fcb7ff96a298 ]

The BD79703 has adds IIO_CHAN_INFO_SCALE in the info_mask_shared_by_type
so users can read the scale, which depends on the used reference
voltage. This, however, enables users to try writing the scale as well.
This isn't really supported but the bd79703_write_raw() does not check
the mask, and if written scale values pass the validation, the driver
will proceed writing the DAC value when users writes the scale.

Prevent the unsupported scale setting and return an error.

Fixes: af6aca656a85 ("iio: dac: Support ROHM BD79703 DAC")
Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/rohm-bd79703.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iio/dac/rohm-bd79703.c b/drivers/iio/dac/rohm-bd79703.c
index e91090e4a66d9..68e66e7286d86 100644
--- a/drivers/iio/dac/rohm-bd79703.c
+++ b/drivers/iio/dac/rohm-bd79703.c
@@ -73,6 +73,9 @@ static int bd79703_write_raw(struct iio_dev *idev,
 {
 	struct bd79703_data *data = iio_priv(idev);
 
+	if (mask != IIO_CHAN_INFO_RAW)
+		return -EINVAL;
+
 	if (val < 0 || val >= 1 << BD79703_DAC_BITS)
 		return -EINVAL;
 
-- 
2.53.0



