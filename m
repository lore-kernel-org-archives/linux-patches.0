Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0F34E781A;
	Fri,  9 Oct 2026 14:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557468; cv=none; b=h6H+tvTTSWct+I+4S4NT150jfMYOZvu52fUJPhxMJpCQhzVVNrUL3Jy7/83SPEfpdkT/1DWHwY7DFXkm1v9dSKRrubrzqTKejaVo+DkzjHX67BObrQEuIVfh9a+XwI3sImnosn/LAKPYg7+GKckLPDMFoFgL9P5PnB3NTgXn3w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557468; c=relaxed/simple;
	bh=OuFTAONR8Pn6KfGZXXBggxDqsd/nPPXrgUoqxEpJqEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JT41aicVXrk8LWDYgROyN2Q0PAIGmMyWlT+54NnY1VTdLCF15kwmOUr0WP01XFHNW39LDyOlEOZVbmoenYTsso+nmuZ06CG3ZNHbPSx+3TyLCCeWrSRsuo8z3wm6gK4ghaojIfSx9kF7sZR3pTWUiOELDPTOWP0Tq58K/GnjaNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SlamOzYX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SlamOzYX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE541F000FF;
	Fri,  9 Oct 2026 14:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557466;
	bh=64Nl62JIeL5XoWNNsPBYdY0BT0jiLHVkCYjJPbWyAfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SlamOzYXypQ2YqH+56M3QWqUWcKlfN0KRAwjb4qMuoqR/BTOviF/n4Zi6srFIXavH
	 xpLzAdT+8CJPGser8ZSySraPhJ3pKNuGZB2ZL97qcU5d0Ud0e+6xjcsgwsG2VymDf5
	 BzoDbm1nQNf9ae9iVvBx/G0EZa3lS2FDYSwEfogQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Mehdi Djait <mehdi.djait@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 370/428] iio: accel: kionix-kx022a: Prevent memory leak and fix state
Date: Fri,  9 Oct 2026 16:11:47 +0200
Message-ID: <20261009140954.311812965@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


