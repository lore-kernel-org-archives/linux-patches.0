Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C757314A4F0;
	Fri,  6 Dec 2024 14:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496264; cv=none; b=XBYRmF6eDsNBvwX/sJOXSKHV0lacmT05PRJ+MFk3FQYbIvL5zI8s9BUhStQjU0NxRFnxkaiE78N75Ip3dRnb5CqJ+rXQ2ymOnaw9mbBB/fd8z/i5PPcUVVt4uGAQL5tGgUMXhR4i3qBqlj9WsRtK3gdXwyBDSigo05MduYm7VRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496264; c=relaxed/simple;
	bh=RYXB7ytvTbdGieYKPdfTX4pDHXdMfe/ZFGPFUkhktN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kz0a+UpVLinWF0OAQBASKqj0q7I+WEQCfXuXmgvHBSgA7GV3rvq50XzZoZZFC7aszNdZNEMh6+yrHpoXHwjVQzE4ybZwy1tM3DXECJpyOyk4TQX/i5Jb3YVC5HXkJ02S81GuFLSVPEW70eFjGPz6+TIMKnUO2eerLzGx762MhjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0B6plYO7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0B6plYO7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244FAC4CED1;
	Fri,  6 Dec 2024 14:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496264;
	bh=RYXB7ytvTbdGieYKPdfTX4pDHXdMfe/ZFGPFUkhktN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0B6plYO74ugPMQA/iQINqKW37w0RZQJhG3ayhlKnG7QslekmXGSiMCyc+GKEcF4MU
	 VJ0Fj4Fjr6MVBd07kgV1w30/aAt9gXdURXu5yD0HRVs7jr1KlP7B9ycu8+tFRRDFKa
	 PCmNh7po3sHL75D61Om08YcQF01tzVp2wyIn4w3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalle Niemi <kaleposti@gmail.com>,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 101/146] iio: accel: kx022a: Fix raw read format
Date: Fri,  6 Dec 2024 15:37:12 +0100
Message-ID: <20241206143531.547284241@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matti Vaittinen <mazziesaccount@gmail.com>

commit b7d2bc99b3bdc03fff9b416dd830632346d83530 upstream.

The KX022A provides the accelerometer data in two subsequent registers.
The registers are laid out so that the value obtained via bulk-read of
these registers can be interpreted as signed 16-bit little endian value.
The read value is converted to cpu_endianes and stored into 32bit integer.
The le16_to_cpu() casts value to unsigned 16-bit value, and when this is
assigned to 32-bit integer the resulting value will always be positive.

This has not been a problem to users (at least not all users) of the sysfs
interface, who know the data format based on the scan info and who have
converted the read value back to 16-bit signed value. This isn't
compliant with the ABI however.

This, however, will be a problem for those who use the in-kernel
interfaces, especially the iio_read_channel_processed_scale().

The iio_read_channel_processed_scale() performs multiplications to the
returned (always positive) raw value, which will cause strange results
when the data from the sensor has been negative.

Fix the read_raw format by casting the result of the le_to_cpu() to
signed 16-bit value before assigning it to the integer. This will make
the negative readings to be correctly reported as negative.

This fix will be visible to users by changing values returned via sysfs
to appear in correct (negative) format.

Reported-by: Kalle Niemi <kaleposti@gmail.com>
Fixes: 7c1d1677b322 ("iio: accel: Support Kionix/ROHM KX022A accelerometer")
Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Tested-by: Kalle Niemi <kaleposti@gmail.com>
Cc: <Stable@vger.kernel.org>
Link: https://patch.msgid.link/ZyIxm_zamZfIGrnB@mva-rohm
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/kionix-kx022a.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/accel/kionix-kx022a.c
+++ b/drivers/iio/accel/kionix-kx022a.c
@@ -594,7 +594,7 @@ static int kx022a_get_axis(struct kx022a
 	if (ret)
 		return ret;
 
-	*val = le16_to_cpu(data->buffer[0]);
+	*val = (s16)le16_to_cpu(data->buffer[0]);
 
 	return IIO_VAL_INT;
 }


