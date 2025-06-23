Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11E0B676;
	Mon, 23 Jun 2025 21:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715122; cv=none; b=B/ScI1svgmG4tD0N/wwLN7Zalu/OWBt6eCqRMomglLp5LKI/rLyW65fkDAau/0cUDxrrPakkTbiZHH/KyvPi11EUm3u9YBTROA1Q4dd58xdm0f7C4Mq2aMOhlJCvlOLpM30y4b3OHP9VIgbG0lPyF82sB+kW/YbCQE7nOBscVf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715122; c=relaxed/simple;
	bh=Z4QnY2OfqE9vTkT0ecP35VYB2/gpTzPyUI4s9Fp27Ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ATHwxdUrPHSwv8whSjz6ni8BZnNSLAe/zSvplNWkmK+ttgK1th8ajDPbwf05nyUi4lN/e1KQ9mNt/SFqH5xNEUOll6oCqJykVg6sni+oHHbpmDQ88kEcZvYTNlh/uqun68rQVaBiKAiueEJw+TY+UO2lAHKLdKUTHM2DPmHYlpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t7+1rPwf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t7+1rPwf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4803DC4CEEA;
	Mon, 23 Jun 2025 21:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715122;
	bh=Z4QnY2OfqE9vTkT0ecP35VYB2/gpTzPyUI4s9Fp27Ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t7+1rPwfBlX0fXQ/EOFc3R7jfw3ybWipfZNWZIOTzAZSPQKfLo9pg286gPG5sqf25
	 gCdn1NW5tuurA6RLWzPxkggJeqbuGc4eQuyM9CiFz6KJ2Vphx/LxKbJ6X79ii9aypc
	 Jx/Ckx9/J3nJlBpEbLpvRm/eoUwWpV51nbn4jVAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 164/414] iio: adc: ad7944: mask high bits on direct read
Date: Mon, 23 Jun 2025 15:05:01 +0200
Message-ID: <20250623130646.135410398@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

commit 7cdfbc0113d087348b8e65dd79276d0f57b89a10 upstream.

Apply a mask to the raw value received over the SPI bus for unsigned
direct reads. As we found recently, SPI controllers may not set unused
bits to 0 when reading with bits_per_word != {8,16,32}. The ad7944 uses
bits_per_word of 14 and 18, so we need to mask the value to be sure we
returning the correct value to userspace during a direct read.

Fixes: d1efcf8871db ("iio: adc: ad7944: add driver for AD7944/AD7985/AD7986")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://patch.msgid.link/20250505-iio-adc-ad7944-max-high-bits-on-direct-read-v1-1-b173facceefe@baylibre.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7944.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/adc/ad7944.c
+++ b/drivers/iio/adc/ad7944.c
@@ -290,6 +290,8 @@ static int ad7944_single_conversion(stru
 
 	if (chan->scan_type.sign == 's')
 		*val = sign_extend32(*val, chan->scan_type.realbits - 1);
+	else
+		*val &= GENMASK(chan->scan_type.realbits - 1, 0);
 
 	return IIO_VAL_INT;
 }


