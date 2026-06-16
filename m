Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B217E43E4BF;
	Tue, 16 Jun 2026 16:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628667; cv=none; b=YB9EN/dLw0svlBgomm0yNXFW+5zKY4YguulTDUbW+VW5uOhTbyKV4qSRYjVqjsRXmfz3bawJcXd1LqwCIwqLaMP1seqTTbbqKASAv6OUPRqGKwVTCJq52LZZ0bD4hBiC/f8Y9xU/JAC9wEoBlSlBBHmOX4JWfkYfMI7z+Jn5k+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628667; c=relaxed/simple;
	bh=7NMf/UUYg25hzllMsHgnUKmva5bL8vgODH29FXLhq48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rtyHDQzVMpqcESevM8HCzfsT7SDYC3qI6Dc+ZFO2pyN7xzxjYNKJIzI0keAXUb9V7I1iLQCX/nmSGmsVEFDsPRqiNuYvBzs3jeYrQRUaQPhjetDhpwV5VfTVDTT4A7hKQzL+0JzugHf1+wgU1j9t4y7wteALSIA2kG7A6JfWIT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tWIqY1cz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tWIqY1cz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B265D1F00A3D;
	Tue, 16 Jun 2026 16:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628666;
	bh=Hq7oMt7d/8ifNX2wmEBElA6L0A+bklcLYAbGp1mHMZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tWIqY1czVTpTM5CINIh6v2Ft69C++Bsk1fPCEcY3tqsYskPEEaig8byrinUZKCF+R
	 Li/ZGlJN2Hl2xfKXaLDm1MdkqJQ9J1G8YAAxGtM8y0B9nBuAplSO06vRsoVw2hhjHB
	 4sr9ViPKK7LWXO03hiJPNICHTx6J+ncrokQd5UKc=
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
Subject: [PATCH 6.6 112/452] iio: adc: viperboard: Fix error handling in vprbrd_iio_read_raw
Date: Tue, 16 Jun 2026 20:25:39 +0530
Message-ID: <20260616145123.620961098@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


