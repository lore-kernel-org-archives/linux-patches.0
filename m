Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C3C2C1595;
	Sun,  7 Jun 2026 10:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828511; cv=none; b=gokO483OoqCc/sTuHDLhsmd1NjkgGn2e62KVre08hhjXlZYo6i0BTxK4mcw6HfJKY4ag7ZS7yTg5nu4a8hPLz4OioAI9KRGPeFXVPjcw5YR/7KcQ0ch/jue9/7p8NYQ7mzm+L9SmkyQ+NMbY0Qx2ykPraIzrAX36TdMvMTRLjbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828511; c=relaxed/simple;
	bh=tp8EdsB44Otf6g4FxRMFkP0fgH3CFJRTpuIgs3LQzFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bM43o8QC0HR91vqpmPujjimka3Zcv29SMRuqeoR27voxfpyHGbVlZR9ymLMswhNu7LG70LKQvlnvrbUNvFmLspBAhTJq4VuC3mtFzv51AnxE49mvtwHSi0RIh9coefJlDz6WmrrHqcPwwQPaYlt8rcQjIMa3ZS5Svp9TLuoXPB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CC7s7G7W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CC7s7G7W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B28A1F00893;
	Sun,  7 Jun 2026 10:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828510;
	bh=MlmY9a1HmuNV5KvtEtaLkvPK5kWdK7Z1Z/Z2IFUKkHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CC7s7G7WPPikdPVvYLJhnc9CK3d5avnW9jmsSaelVS3eqy1Zyho7h6pDGAoDGWlAU
	 N65nk7NhsRYnw92tkJbSwlEb+IfA8wDC1wPzPy/BFmNpNnu5cU6bJ2KbaemvEcBzEm
	 ESHKcoy7xcwCH8NbfMxd32HyjzXSK2cKg3fezodE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Maxwell Doose <m32285159@gmail.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.18 162/315] iio: adc: viperboard: Fix error handling in vprbrd_iio_read_raw
Date: Sun,  7 Jun 2026 11:59:09 +0200
Message-ID: <20260607095733.538212996@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Salah Triki <salah.triki@gmail.com>

commit 422b5bbf333f75fb486855ad0eedc23cf21f3277 upstream.

The driver proceeds to the reception phase even if the preceding
transmission fails.

This uses a goto error label for an early bail out and ensures the mutex is
properly unlocked in case of failure.

Fixes: ffd8a6e7a778 ("iio: adc: Add viperboard adc driver")
Signed-off-by: Salah Triki <salah.triki@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Reviewed-by: Maxwell Doose <m32285159@gmail.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/viperboard_adc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/iio/adc/viperboard_adc.c
+++ b/drivers/iio/adc/viperboard_adc.c
@@ -70,8 +70,10 @@ static int vprbrd_iio_read_raw(struct ii
 			VPRBRD_USB_TYPE_OUT, 0x0000, 0x0000, admsg,
 			sizeof(struct vprbrd_adc_msg), VPRBRD_USB_TIMEOUT_MS);
 		if (ret != sizeof(struct vprbrd_adc_msg)) {
-			dev_err(&iio_dev->dev, "usb send error on adc read\n");
+			mutex_unlock(&vb->lock);
 			error = -EREMOTEIO;
+			dev_err(&iio_dev->dev, "usb send error on adc read\n");
+			goto error;
 		}
 
 		ret = usb_control_msg(vb->usb_dev,


