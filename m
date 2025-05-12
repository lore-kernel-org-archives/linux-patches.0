Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA9778F52;
	Mon, 12 May 2025 17:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071050; cv=none; b=BZUyt3kOz5qkchilNcureMEDfrCFfaZnLKEpGEK/OKvcLxYd/0zK2mJlrenPFRgC6Z8BR+/f87Purjw4a5oukMITJypCTSYXko6fCl+OJFtMuIVaVUZVTngzQOwHnFsEWu4tcdH6sglLFezafVUhVv04htaqIcxPWi+klTWsmvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071050; c=relaxed/simple;
	bh=znNDP6ptm+p2YJ0l/glPPUWwu+rNSrEUHv4bjq7G+oU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BjGH6e8+iumFzlQ96xBYCCf7yP6mQI5beyJPN2ia0ev2U/pJ6SBXRZzwkSGm8tYmfgcWjlJ2bKx5NZSmnZScHNvs5JoMMIwMgtXLQtt1tOdYS//7LiVE0IRG7SMt+sJKjAbzbGNeWFJW2UmATaeJOGONNpELHEqt4yMXAhD3AgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CG7KdeiR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CG7KdeiR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C65F9C4CEE9;
	Mon, 12 May 2025 17:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071050;
	bh=znNDP6ptm+p2YJ0l/glPPUWwu+rNSrEUHv4bjq7G+oU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CG7KdeiRaf2UCHBF/0efedRMzxK97Oq+T3eynj2zO/ggI4OfzDDf77NFgkM3Q98U7
	 fHjw31D2/RGe6Npx6eEEvtenzFEdst7Jj539h80mkic84MuNichJN3Tn9LNV9SupPZ
	 5S7ovZqebsc1kdwSAl5LHsu3W3JW+EVrVtRMcXfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Shahrouzi <gshahrouzi@gmail.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 20/54] staging: iio: adc: ad7816: Correct conditional logic for store mode
Date: Mon, 12 May 2025 19:29:32 +0200
Message-ID: <20250512172016.463104792@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172015.643809034@linuxfoundation.org>
References: <20250512172015.643809034@linuxfoundation.org>
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

From: Gabriel Shahrouzi <gshahrouzi@gmail.com>

commit 2e922956277187655ed9bedf7b5c28906e51708f upstream.

The mode setting logic in ad7816_store_mode was reversed due to
incorrect handling of the strcmp return value. strcmp returns 0 on
match, so the `if (strcmp(buf, "full"))` block executed when the
input was not "full".

This resulted in "full" setting the mode to AD7816_PD (power-down) and
other inputs setting it to AD7816_FULL.

Fix this by checking it against 0 to correctly check for "full" and
"power-down", mapping them to AD7816_FULL and AD7816_PD respectively.

Fixes: 7924425db04a ("staging: iio: adc: new driver for AD7816 devices")
Cc: stable@vger.kernel.org
Signed-off-by: Gabriel Shahrouzi <gshahrouzi@gmail.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/stable/20250414152920.467505-1-gshahrouzi%40gmail.com
Link: https://patch.msgid.link/20250414154050.469482-1-gshahrouzi@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/iio/adc/ad7816.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/iio/adc/ad7816.c
+++ b/drivers/staging/iio/adc/ad7816.c
@@ -136,7 +136,7 @@ static ssize_t ad7816_store_mode(struct
 	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
 	struct ad7816_chip_info *chip = iio_priv(indio_dev);
 
-	if (strcmp(buf, "full")) {
+	if (strcmp(buf, "full") == 0) {
 		gpiod_set_value(chip->rdwr_pin, 1);
 		chip->mode = AD7816_FULL;
 	} else {


