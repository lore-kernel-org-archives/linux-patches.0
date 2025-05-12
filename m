Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05235296FDB;
	Mon, 12 May 2025 18:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073318; cv=none; b=g8YiYYFxgajkLy8jsRJG/LAiP5+tbn28+MLwatc2Lu0emuMte4cArRyM1YIfleETU37KbmltTgQ6wirGdMNf5JCXoZ6Kh1fzVlKt8I/DCYr8yUHtQ7GZ2bZS83eQgX0vZTpSyroY9aqoXzgDdRoH11QpvPzKCv8J2uREJ64Lweg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073318; c=relaxed/simple;
	bh=TRZshkTNDTBiEWrovFnL5y4a1Vd4WIJUwWgMJfQtUdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ezWBCmqBITQa4BU6rRe6o5cpZalvIncAdnHjHnLEGSze2Iltkmz47qYFgA0QIGtH0058126xq/Oy5IOt6Mcij6AXyIU1x0OguAouDOBKXBg+ngi8L3m1Gh6MCCrXF3eB1lW0aXcWP0vTJXSVz9vIWn9j8MJHnXRSRUr4676sbGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c97Mcmlv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c97Mcmlv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E1AC4CEE7;
	Mon, 12 May 2025 18:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073317;
	bh=TRZshkTNDTBiEWrovFnL5y4a1Vd4WIJUwWgMJfQtUdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c97McmlvUgHMjiXlOZS/DOgx4IKq0ov477cIk9QGcNLdB4OJ3kZnmsUU9Qif7M6x/
	 azsMRclJBwkmZdReMBobXUhjgERcCs7tZGt6G9Ekx4+T/snNfPvaHu9+abVZWnGAtJ
	 Zu5KdwNRJ8gZyj43QJkmtU9lbxu8mH/dAYlwFQf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Shahrouzi <gshahrouzi@gmail.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 037/113] staging: iio: adc: ad7816: Correct conditional logic for store mode
Date: Mon, 12 May 2025 19:45:26 +0200
Message-ID: <20250512172029.181538900@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


