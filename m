Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652BA2C1595;
	Sun,  7 Jun 2026 10:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828506; cv=none; b=RfbApf+pnaWNRO/Awmqv5iArOD7LBsBVC3eHHkjdcy7LiiKNbjT/BXrJcJdHlcn1tzgpU7KSQCgG2G0/eiVIYE4Wuf7yn77LxQ2WJvNPXIcQzol8ZqA0nruJoDMr0oRx8okfzCjpOOXXu7uF/JD/4Y+MZS3fY54Nr9sEpOnof8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828506; c=relaxed/simple;
	bh=qhuxHwAjKZBvGf0hHpaa3c8W9W95WSBaNUvPY/WObjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aWxbTrv5PvI/IxYkadSlNoYkFpCk08ByvUQ5ABuEcsLGe7f1rXuznfAn1TKD8LLZWvqRB0uhTPQnJHjBjunj0KtfGruOzP2TebdLbmamMX4vfPdw1nBVlWhazqPYyxvHxlkTdGuzweKAHaE4FtSdUfSJ1R+OyXlUMpXmeqglK34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rGCePoRP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rGCePoRP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 723C41F00893;
	Sun,  7 Jun 2026 10:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828505;
	bh=TH5dmCGQ7huZB02NgR7IR3ga7IViVztpl7JJTNQX4rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rGCePoRPLf97Y4byfmNFMKi/jarqqpbu3HpZlKxOTgdybEOzh68QzXZKgtMFtjTRL
	 aiWNLOTA6z8bHqQFugacHo4Bskw1/s+frcWmOFuXeX92wD/Pncb9Tf65NJXvvkSTiy
	 G6jbLPXEfYnlCR8esFZ/SrPsrrNZrV9xSfu4rRYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 7.0 189/332] iio: gyro: adis16260: fix division by zero in write_raw
Date: Sun,  7 Jun 2026 11:59:18 +0200
Message-ID: <20260607095735.007620001@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

commit 761e8b489e6cf166c574034b70637f8a7eadd0ee upstream.

Add a validation check for the sampling frequency value before using it
as a divisor. A user writing zero to the sampling_frequency sysfs
attribute triggers a division by zero in the kernel.

Fixes: 089a41985c6c ("staging: iio: adis16260 digital gyro driver")
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/gyro/adis16260.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/iio/gyro/adis16260.c
+++ b/drivers/iio/gyro/adis16260.c
@@ -287,6 +287,9 @@ static int adis16260_write_raw(struct ii
 		addr = adis16260_addresses[chan->scan_index][1];
 		return adis_write_reg_16(adis, addr, val);
 	case IIO_CHAN_INFO_SAMP_FREQ:
+		if (val <= 0)
+			return -EINVAL;
+
 		if (spi_get_device_id(adis->spi)->driver_data)
 			t = 256 / val;
 		else


