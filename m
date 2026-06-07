Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83503257855;
	Sun,  7 Jun 2026 10:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828529; cv=none; b=j5i2OOyVfpJMz7/yrV/JBtvPhdNkXTygkXJ4OGjy+dU0TyW+xidTwl6NCkWWIiN66DYG77V7Nqm+JENBzcE3vp7LfG4sAtgpAtkI9L8MlPsXB2u4L0jgQGtfX+W/7IDp40AUZuLMIONsofkfr33JssoMtsks4jm6xbIkq9VcQrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828529; c=relaxed/simple;
	bh=8v2gXg3Y0OXilEAnQFDteqTd7P/8zSXzwUYcprJgDJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dTqmrRq7t0xLqXtXlI/6qwAuTgZbypT1+mchivtp91gfjwTcabOo6zOuWQXuyI10r/cCS3h4L7VfmzPEPGexbsuhHhbTGM342YiM5Ud2pCANFa3M9d3FgrX31YvvmVKwcuuMS4/7b2Gz1WtkwiGah9faD4cfFT3WKaPg/mqF7aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XboMh6ul; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XboMh6ul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF3451F00893;
	Sun,  7 Jun 2026 10:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828528;
	bh=QozIm/jpm9jIoiAu2CgBTGnY6Mccq0xJ1c/rej/Ho08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XboMh6ulUZ1yOV+E2dpMiMJb6w+40EVY0gemwmRvwfu3rRVyjf4xtGObLNBIs9xB4
	 8YDqc7TGc39QjA9ZBXy78rDV+jj6dL6suvQUVYcNWFD6biCiM3zo2JRSXbEhaAf9Px
	 3uNUAeuMU6H4H8aliJnD0fD0aX1g8N3j78EcVm/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.18 170/315] iio: Fix iio_multiply_value use in iio_read_channel_processed_scale
Date: Sun,  7 Jun 2026 11:59:17 +0200
Message-ID: <20260607095733.834694113@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Svyatoslav Ryhel <clamor95@gmail.com>

commit bb21ee31f5753a7972148798fd7dfb841dd33bdb upstream.

The function iio_multiply_value returns IIO_VAL_INT (1) on success or a
negative error number on failure, while iio_read_channel_processed_scale
should return an error code or 0. This creates a situation where the
expected result is treated as an error. Fix this by checking the
iio_multiply_value result separately, instead of passing it as a return
value.

Fixes: 05f958d003c9 ("iio: Improve iio_read_channel_processed_scale() precision")
Signed-off-by: Svyatoslav Ryhel <clamor95@gmail.com>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/inkern.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
index 0df0ab3de270..9ce20cb05a9b 100644
--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -738,7 +738,11 @@ int iio_read_channel_processed_scale(struct iio_channel *chan, int *val,
 		if (ret < 0)
 			return ret;
 
-		return iio_multiply_value(val, scale, ret, pval, pval2);
+		ret = iio_multiply_value(val, scale, ret, pval, pval2);
+		if (ret < 0)
+			return ret;
+
+		return 0;
 	} else {
 		ret = iio_channel_read(chan, val, NULL, IIO_CHAN_INFO_RAW);
 		if (ret < 0)
-- 
2.54.0



