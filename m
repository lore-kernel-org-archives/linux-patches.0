Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DB53BB112;
	Fri,  9 Oct 2026 14:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556819; cv=none; b=tNfvG78WUkp7ZSmUuYIyeAwcqaf7cLqoN7wCfcaPqV6HNENC4Qk+/G+LhTLy9gcC1j9jZAUbjYFxG57i+mgx5evKJV6rsbIPUS4MhQXou9cHq7fb0Oi8kBoe4gAPIH6z4Eeomf0FlkbD2Z9cSj0p45CG4/VCrtBJlwRVmKEspFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556819; c=relaxed/simple;
	bh=Xy1ilqFr3Ua1n296CNG3HAbiVfa3MUsCE3QBKjKikVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X6UnfTaa7Hvxj6t1WQGUgP8T9Vcwt0yCR+DymO8PnMPx7LD4SY7GEgU7VGLyZxLGuMw8EzQt3ddRkSFPv5NAKNMkMEtBWRb0zjBHrgqN9TWHgQk8MFZpZjsmgIlvxcxfKD0W++W6heD1jMvWoPgHx2+8ti1LVWWPFxjEaDw+Qik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WRtbTHaH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WRtbTHaH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AC481F000FF;
	Fri,  9 Oct 2026 14:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556818;
	bh=AVPVVWPp5/8HepEi7SNKWmJTB1rLJ3FQ9olknz7ED1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WRtbTHaHfZolpvO6o7j99a+3GaZ2aH6HzAxwpTueFl+wpdfuG5ouC23rwTuaGYddJ
	 bLjQgRdO4DqDrSW2C3HqSYngVD4mAu259JeY5xHUnWRBaCSyzT0tFSrCM6m3fHfMYc
	 8MEp7ulZGe1lbleaE8zeDpIQOUxkXbL3ZazIDIZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Mehdi Djait <mehdi.djait@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 298/403] iio: accel: kionix-kx022a: Prevent memory leak and fix state
Date: Fri,  9 Oct 2026 16:10:59 +0200
Message-ID: <20261009140959.174114550@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matti Vaittinen <mazziesaccount@gmail.com>

commit e65e128b51a37dd1a9056ac3d1705d805a5c8bb0 upstream.

The driver allocates memory for samples at buffer enable path. If regmap
operation fails in the kx022a_fifo_enable() at the buffer enable path, the
allocated memory is never freed. Furthermore, the state information and
previous hardware configuration(s) aren't undone, potentially leaving
WMI interrupts and buffers enabled, or driver state flags wrong.

Free the memory and revert the hardware configuration and state flags on
error path.

Fixes: e7123a4dfcd7 ("iio: accel: kionix-kx022a: Refactor driver and add chip_info structure")
Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Reviewed-by: Mehdi Djait <mehdi.djait@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/kionix-kx022a.c |   28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

--- a/drivers/iio/accel/kionix-kx022a.c
+++ b/drivers/iio/accel/kionix-kx022a.c
@@ -980,26 +980,44 @@ static int kx022a_fifo_enable(struct kx0
 	guard(mutex)(&data->mutex);
 	ret = __kx022a_turn_on_off(data, false);
 	if (ret)
-		return ret;
+		goto err_free_out;
 
 	/* Update watermark to HW */
 	ret = kx022a_fifo_set_wmi(data);
 	if (ret)
-		return ret;
+		goto err_turn_on_out;
 
 	/* Enable buffer */
 	ret = regmap_set_bits(data->regmap, data->chip_info->buf_cntl2,
 			      KX022A_MASK_BUF_EN);
 	if (ret)
-		return ret;
+		goto err_turn_on_out;
 
 	data->state |= KX022A_STATE_FIFO;
 	ret = regmap_set_bits(data->regmap, data->ien_reg,
 			      KX022A_MASK_WMI);
 	if (ret)
-		return ret;
+		goto err_buf_disable_out;
 
-	return __kx022a_turn_on_off(data, true);
+	ret = __kx022a_turn_on_off(data, true);
+	if (ret)
+		goto err_wmi_clear_out;
+
+	return ret;
+
+err_wmi_clear_out:
+	regmap_clear_bits(data->regmap, data->ien_reg,
+			  KX022A_MASK_WMI);
+err_buf_disable_out:
+	regmap_clear_bits(data->regmap, data->chip_info->buf_cntl2,
+			  KX022A_MASK_BUF_EN);
+	data->state &= ~KX022A_STATE_FIFO;
+err_turn_on_out:
+	__kx022a_turn_on_off(data, true);
+err_free_out:
+	kfree(data->fifo_buffer);
+
+	return ret;
 }
 
 static int kx022a_buffer_postenable(struct iio_dev *idev)


