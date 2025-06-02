Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC4A22FDEC;
	Mon,  2 Jun 2025 14:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874543; cv=none; b=WuxvJUQUx/l51RGEsvoIZDJbWqxuExqqInsnKwFgVzV2jyr8PYV2GvbrW0NdtPz9NlXrwu1Q6C1Y4ovpR/Z27Od6lCZxsFq4dOUW2IZmUkYsjh6ZTs5I1nqRYyBUOugNxgSLz+goXuIky0EIXzoT1/WEAo1PawoWd0ca2GB22QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874543; c=relaxed/simple;
	bh=yhbrd7GjwhlkHryTgQEZJthI34Sv6sMU6ZMh1hwlV7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eBqWi/4+GfB/GMJ1EhCTq/bLQ+8d6TdvA7omt0lgE3tAP6w6AU0/+PsfAr6QjmhL0aH0eOTX/QpKWO6uT2xkDBWFqIqUI4zvHnNiE3ZlrYUADQTZRRaNrslrisp5hbEnveEV6y7vtYHS64+jE67ILgYEXzY4OABPe8wnXVZ8afo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e+ALKnCW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e+ALKnCW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3570C4CEEB;
	Mon,  2 Jun 2025 14:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874543;
	bh=yhbrd7GjwhlkHryTgQEZJthI34Sv6sMU6ZMh1hwlV7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e+ALKnCWUGkwZX6CekIJIV51/EU1ST+0xlQngcYae6azMHQ4zbasFP/zvSAK2RH47
	 AeOg6p1CsaShPy2pT7i+iIlqcZEIxGclrwReJiQeZby15icvbthoYRBnxTyTv/EyS+
	 cKPrNLXoEwpzOdQk6z5ehB3qCgwnfYfkWF6nIpzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Shahrouzi <gshahrouzi@gmail.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 040/204] staging: iio: adc: ad7816: Correct conditional logic for store mode
Date: Mon,  2 Jun 2025 15:46:13 +0200
Message-ID: <20250602134257.253261844@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


