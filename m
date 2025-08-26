Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C090D31CA74;
	Tue, 26 Aug 2025 11:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207278; cv=none; b=IbHPJMo7AasZavAnWzzM92ha3k/2hslXZAyimPdNEggajA/le5A0eQ81cXwMXzZpmTzY7YvDsFEy0PzWLSNkhR0FsGZpBmUUTjC3Jw/LKMcL1psrS+A0sVrDvc/6iBogEevxPImwVD8n8s5vVkPQU+2Jsqxf7V40KW4SzQcbMM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207278; c=relaxed/simple;
	bh=k3vGpgSkgDSIZFDMBKi3qr7fhky9fN5uWsIHn2Fr/Fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U88q990LPchICaYeXZk5/z3Z/2wIvsZWedS9v8+yNXUsV7EkKIFhY6bH9wUSMcLx9Pg6S6Btt04pCAklephNaxp6rj6yyhBlz3UT3tZdhozs/CNm7d0CnPscU3ZNEKPwMV6ZMFD1v5djKOjoexwNsbNTZL41JejCo5zPpv6JUTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hbVbjxZg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hbVbjxZg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F33DC4CEF1;
	Tue, 26 Aug 2025 11:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207277;
	bh=k3vGpgSkgDSIZFDMBKi3qr7fhky9fN5uWsIHn2Fr/Fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hbVbjxZgdZEDTItXiVPpw8ITsHrz49+yT4hsHGH+2uvPbft95x9ylHxgzSfrz8cI2
	 4kr9D/lgZ+1cdDM3Jt1FQd+mlQHmWfy5VQ5T6+QV/TYx0QOgxYrUyNmQKf12gjzOeE
	 1tOhr4WqFhql/q6zQUk+sRm2kb8oYuXEJn8kx1iU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.16 078/457] iio: adc: ad7173: fix calibration channel
Date: Tue, 26 Aug 2025 13:06:02 +0200
Message-ID: <20250826110939.303009623@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

commit 1d9a21ffb43b6fd326ead98f0d0afd6d104b739a upstream.

Fix the channel index values passed to ad_sd_calibrate() in
ad7173_calibrate_all().

ad7173_calibrate_all() expects these values to be that of the CHANNELx
register assigned to the channel, not the datasheet INPUTx number of the
channel. The incorrect values were causing register writes to fail for
some channels because they set the WEN bit that must always be 0 for
register access and set the R/W bit to read instead of write. For other
channels, the channel number was just wrong because the CHANNELx
registers are generally assigned in reverse order and so almost never
match the INPUTx numbers.

Fixes: 031bdc8aee01 ("iio: adc: ad7173: add calibration support")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://patch.msgid.link/20250708-iio-adc-ad7313-fix-calibration-channel-v1-1-e6174e2c7cbf@baylibre.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7173.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/iio/adc/ad7173.c
+++ b/drivers/iio/adc/ad7173.c
@@ -392,13 +392,12 @@ static int ad7173_calibrate_all(struct a
 		if (indio_dev->channels[i].type != IIO_VOLTAGE)
 			continue;
 
-		ret = ad_sd_calibrate(&st->sd, AD7173_MODE_CAL_INT_ZERO, st->channels[i].ain);
+		ret = ad_sd_calibrate(&st->sd, AD7173_MODE_CAL_INT_ZERO, i);
 		if (ret < 0)
 			return ret;
 
 		if (st->info->has_internal_fs_calibration) {
-			ret = ad_sd_calibrate(&st->sd, AD7173_MODE_CAL_INT_FULL,
-					      st->channels[i].ain);
+			ret = ad_sd_calibrate(&st->sd, AD7173_MODE_CAL_INT_FULL, i);
 			if (ret < 0)
 				return ret;
 		}


