Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7373C1F8ACA;
	Tue, 21 Jan 2025 18:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482924; cv=none; b=M3A9T76D6wdaVvHxKVqTx524OWti2p5Yn24PjaY/30rRG9xp6wniRKmmyJ6iwfvJ5CkH1Xy6mFcvXAzBu0h/lvmL8lDuZw2VR9DkXPGl8L5w/cO59eju3V6Ajsy2dRLoLiAcm3K+dGczPxSwdZaoi9kHDE9+RatILgg7WoqFmqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482924; c=relaxed/simple;
	bh=Qb+mF06w6ECn7VRVZb3A39Hf7hqTJ/j6wC7WMYqNP0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dq8Ui+S+hksn1catn2KPoJyHltkX18eGwp8fTnyKrHJMQfb/e467cAYA7/vD8NL8ZWOikl6MBad0BejzTrURqrKx14VJVf0NtG3bITfD96DxK57Hxq2rRWFik6xgWlNGVxkUsbW9K6avSajB0sMYTTaQOfXhlLxHOS7QnMGW7yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CdaJ5Zuc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CdaJ5Zuc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E0EC4CEDF;
	Tue, 21 Jan 2025 18:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482924;
	bh=Qb+mF06w6ECn7VRVZb3A39Hf7hqTJ/j6wC7WMYqNP0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CdaJ5Zuc9xV0tJ9+YSzH2SSXn4Lk+3fhSu6GcCGbFQQXVVKXhclrXwuDyeN0CaRvW
	 TYHBNmNRpzhUPK5pCyNIpXFUbpy/J4+T42ZwV0UA4qGMcSQ5r9vtn50GB6mfJdaxSv
	 mwcyBvuq77y26Ogj39Cx9U9lAjK3PudKfuJexIv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 055/127] iio: light: vcnl4035: fix information leak in triggered buffer
Date: Tue, 21 Jan 2025 18:52:07 +0100
Message-ID: <20250121174531.788765048@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 47b43e53c0a0edf5578d5d12f5fc71c019649279 upstream.

The 'buffer' local array is used to push data to userspace from a
triggered buffer, but it does not set an initial value for the single
data element, which is an u16 aligned to 8 bytes. That leaves at least
4 bytes uninitialized even after writing an integer value with
regmap_read().

Initialize the array to zero before using it to avoid pushing
uninitialized information to userspace.

Cc: stable@vger.kernel.org
Fixes: ec90b52c07c0 ("iio: light: vcnl4035: Fix buffer alignment in iio_push_to_buffers_with_timestamp()")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20241125-iio_memset_scan_holes-v1-6-0cb6e98d895c@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/vcnl4035.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/light/vcnl4035.c
+++ b/drivers/iio/light/vcnl4035.c
@@ -105,7 +105,7 @@ static irqreturn_t vcnl4035_trigger_cons
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct vcnl4035_data *data = iio_priv(indio_dev);
 	/* Ensure naturally aligned timestamp */
-	u8 buffer[ALIGN(sizeof(u16), sizeof(s64)) + sizeof(s64)]  __aligned(8);
+	u8 buffer[ALIGN(sizeof(u16), sizeof(s64)) + sizeof(s64)]  __aligned(8) = { };
 	int ret;
 
 	ret = regmap_read(data->regmap, VCNL4035_ALS_DATA, (int *)buffer);


