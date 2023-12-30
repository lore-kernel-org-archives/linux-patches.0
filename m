Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 046BA8BFB;
	Sat, 30 Dec 2023 12:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VgTgGELE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D288C433C7;
	Sat, 30 Dec 2023 12:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937854;
	bh=rCf7e1g5z0PduMVI2gjLn+cN3lzXvBoHXf8BzvI8ULo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VgTgGELERyil8NRm1TfQj5w8etNhYdGbu3+KkN4LCuOiw9Y4sM8T8eYQEVPnouEY/
	 jW/fzgW7/4HzQDQ8ldWMHU4W/2oipS8280zbrXkM0HCaiemRnxsFIxSBvuUK9zxQbc
	 51smiHu2q1WlsZAHf7qfSe+KGEHV5JGVMx/ZWimk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Jagath Jog J <jagathjog1996@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 089/156] iio: kx022a: Fix acceleration value scaling
Date: Sat, 30 Dec 2023 11:59:03 +0000
Message-ID: <20231230115815.264796458@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matti Vaittinen <mazziesaccount@gmail.com>

commit 92bfa4ab1b79be95c4f52d13f5386390f0a513c2 upstream.

The IIO ABI mandates acceleration values from accelerometer to be
emitted in m/s^2. The KX022A was emitting values in micro m/s^2.

Fix driver to report the correct scale values.

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Reported-by: Jagath Jog J <jagathjog1996@gmail.com>
Fixes: 7c1d1677b322 ("iio: accel: Support Kionix/ROHM KX022A accelerometer")
Tested-by: Jagath Jog J <jagathjog1996@gmail.com>
Link: https://lore.kernel.org/r/ZTEt7NqfDHPOkm8j@dc78bmyyyyyyyyyyyyydt-3.rev.dnainternet.fi
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/kionix-kx022a.c |   37 ++++++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 11 deletions(-)

--- a/drivers/iio/accel/kionix-kx022a.c
+++ b/drivers/iio/accel/kionix-kx022a.c
@@ -273,17 +273,17 @@ static const unsigned int kx022a_odrs[]
  *	(range / 2^bits) * g = (range / 2^bits) * 9.80665 m/s^2
  *	=> KX022A uses 16 bit (HiRes mode - assume the low 8 bits are zeroed
  *	in low-power mode(?) )
- *	=> +/-2G  => 4 / 2^16 * 9,80665 * 10^6 (to scale to micro)
- *	=> +/-2G  - 598.550415
- *	   +/-4G  - 1197.10083
- *	   +/-8G  - 2394.20166
- *	   +/-16G - 4788.40332
+ *	=> +/-2G  => 4 / 2^16 * 9,80665
+ *	=> +/-2G  - 0.000598550415
+ *	   +/-4G  - 0.00119710083
+ *	   +/-8G  - 0.00239420166
+ *	   +/-16G - 0.00478840332
  */
 static const int kx022a_scale_table[][2] = {
-	{ 598, 550415 },
-	{ 1197, 100830 },
-	{ 2394, 201660 },
-	{ 4788, 403320 },
+	{ 0, 598550 },
+	{ 0, 1197101 },
+	{ 0, 2394202 },
+	{ 0, 4788403 },
 };
 
 static int kx022a_read_avail(struct iio_dev *indio_dev,
@@ -302,7 +302,7 @@ static int kx022a_read_avail(struct iio_
 		*vals = (const int *)kx022a_scale_table;
 		*length = ARRAY_SIZE(kx022a_scale_table) *
 			  ARRAY_SIZE(kx022a_scale_table[0]);
-		*type = IIO_VAL_INT_PLUS_MICRO;
+		*type = IIO_VAL_INT_PLUS_NANO;
 		return IIO_AVAIL_LIST;
 	default:
 		return -EINVAL;
@@ -366,6 +366,20 @@ static int kx022a_turn_on_unlock(struct
 	return ret;
 }
 
+static int kx022a_write_raw_get_fmt(struct iio_dev *idev,
+				    struct iio_chan_spec const *chan,
+				    long mask)
+{
+	switch (mask) {
+	case IIO_CHAN_INFO_SCALE:
+		return IIO_VAL_INT_PLUS_NANO;
+	case IIO_CHAN_INFO_SAMP_FREQ:
+		return IIO_VAL_INT_PLUS_MICRO;
+	default:
+		return -EINVAL;
+	}
+}
+
 static int kx022a_write_raw(struct iio_dev *idev,
 			    struct iio_chan_spec const *chan,
 			    int val, int val2, long mask)
@@ -510,7 +524,7 @@ static int kx022a_read_raw(struct iio_de
 
 		kx022a_reg2scale(regval, val, val2);
 
-		return IIO_VAL_INT_PLUS_MICRO;
+		return IIO_VAL_INT_PLUS_NANO;
 	}
 
 	return -EINVAL;
@@ -712,6 +726,7 @@ static int kx022a_fifo_flush(struct iio_
 static const struct iio_info kx022a_info = {
 	.read_raw = &kx022a_read_raw,
 	.write_raw = &kx022a_write_raw,
+	.write_raw_get_fmt = &kx022a_write_raw_get_fmt,
 	.read_avail = &kx022a_read_avail,
 
 	.validate_trigger	= iio_validate_own_trigger,


