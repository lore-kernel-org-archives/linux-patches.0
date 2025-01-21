Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE661F5614;
	Tue, 21 Jan 2025 18:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482944; cv=none; b=Dzffod7zb9tM40HwKxYqA/hWtpB1HuojvXiOBVOceqKtmLF1QI3jukjoZl0/cINwSKdc0wTszv+c/9CKdBAGehSo9mYwvbDxa+jFpr/zYkCo00pU2S4BfhHQ3oxKFeydEorDQNT6Z80xDiWZo7i9u0FW8fUji74GNucv72FNyVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482944; c=relaxed/simple;
	bh=Cj1+s0406oGT38aYwYNILtoQsuGahFBCRdA+jMKMyzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V4BPWCnfy3Wrn75quT9EOlUTexT9LomS6Q7GJr7w85v469jLGpsDKcx/TdGqmdWAZUVm6RXFpkuAelJdDYq05QSwMNVOwlX77g/O8YZ+DP8XSNy/WMIsQANyY5p758kbdPVbdpxmZOQEbaLStdY7PQk8rqMnmWe+N7ZqZXa7wG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o7tgDtJ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o7tgDtJ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00DF9C4CEDF;
	Tue, 21 Jan 2025 18:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482944;
	bh=Cj1+s0406oGT38aYwYNILtoQsuGahFBCRdA+jMKMyzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o7tgDtJ1XyRstdwDNOjKfN/24abn9enU5QqDjfoTrkWomkSyTOMb+SNA/I+Nvy3rX
	 h4wEOFDhgJvcwKv3Iz/beutRcmrR0UjZa6wnDKxDPCq7kz5CSAX429ROV7nVfTHSUA
	 9dTx7dIr2ExglL4QAA/ALFOAPg5HNCuw7MqDf03s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 062/127] iio: adc: ad7124: Disable all channels at probe time
Date: Tue, 21 Jan 2025 18:52:14 +0100
Message-ID: <20250121174532.058483592@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

commit 4be339af334c283a1a1af3cb28e7e448a0aa8a7c upstream.

When during a measurement two channels are enabled, two measurements are
done that are reported sequencially in the DATA register. As the code
triggered by reading one of the sysfs properties expects that only one
channel is enabled it only reads the first data set which might or might
not belong to the intended channel.

To prevent this situation disable all channels during probe. This fixes
a problem in practise because the reset default for channel 0 is
enabled. So all measurements before the first measurement on channel 0
(which disables channel 0 at the end) might report wrong values.

Fixes: 7b8d045e497a ("iio: adc: ad7124: allow more than 8 channels")
Reviewed-by: Nuno Sa <nuno.sa@analog.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://patch.msgid.link/20241104101905.845737-2-u.kleine-koenig@baylibre.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7124.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/iio/adc/ad7124.c
+++ b/drivers/iio/adc/ad7124.c
@@ -856,6 +856,9 @@ static int ad7124_setup(struct ad7124_st
 		 * set all channels to this default value.
 		 */
 		ad7124_set_channel_odr(st, i, 10);
+
+		/* Disable all channels to prevent unintended conversions. */
+		ad_sd_write_reg(&st->sd, AD7124_CHANNEL(i), 2, 0);
 	}
 
 	return ret;


