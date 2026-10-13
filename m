Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D71344DBD;
	Tue, 13 Oct 2026 12:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895726; cv=none; b=a7AIhqv9nmf6jOU/Z4B2C610PsL9wwgbyv0uCIic7nDHAS1qhBLN9KLxJMyJqC6EYXeeNpDfYUQK9k4Ln2BkaCfNOWpkDzqbhUthcDX64E6ky/r7dNHZs30fQErFhvwAYtqHb8EWcQHIVCHT8jzj7ES4214Biu37+25pfU+Z/2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895726; c=relaxed/simple;
	bh=OmnyZPoevVWOmHSp1KR/BX+xxuWgLSDIQCqE2+er6d4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amN9ZRva//6g1QcIH5Wf/u/yyVfd97aYeODkyCi9l/7DPWX/3JHLhR9WPmLZcb/YvOq9duSRJC1RLc6X08D0tJ+J4h6mlkO2nxSpQscAme6zvEfNYUMqBH9vj5L56c4fuBGyUtcQlZkP+8gzyeBxLWE+JiMetcRaAqGcWxFIivY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zwJhVDEu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zwJhVDEu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3494A1F000FF;
	Tue, 13 Oct 2026 12:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895725;
	bh=kg2Ul8z96ElzIOh4y2Ex3rOAp1e4My5PmsQQi6vm0Qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zwJhVDEuJRUYicuF8ryGnWXy7jsKmMKdq8f+jP6DUC4MPZZjzM0/Edz2/h7TmZ40T
	 ysEPHd/4sN2DTb20VB39ai44Hl7GmrqLL3w/GXUV2kbuR4ZIjrptdHEiA5wxrz/UCB
	 3zmFBi0+7WnYyx7SksfMVMOfjVWwmmJ8pJRc8K+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Mehdi Djait <mehdi.djait@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 328/497] iio: accel: kionix-kx022a: Prevent memory leak and fix state
Date: Tue, 13 Oct 2026 13:38:15 +0200
Message-ID: <20261013112915.689295075@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matti Vaittinen <mazziesaccount@gmail.com>

[ Upstream commit e65e128b51a37dd1a9056ac3d1705d805a5c8bb0 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/kionix-kx022a.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/accel/kionix-kx022a.c b/drivers/iio/accel/kionix-kx022a.c
index 1e4ba5602dbf4..b1d48369fa216 100644
--- a/drivers/iio/accel/kionix-kx022a.c
+++ b/drivers/iio/accel/kionix-kx022a.c
@@ -958,26 +958,44 @@ static int kx022a_fifo_enable(struct kx022a_data *data)
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
-- 
2.53.0



