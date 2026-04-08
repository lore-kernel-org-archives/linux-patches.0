Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947C5351C2E;
	Wed,  8 Apr 2026 18:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673297; cv=none; b=naeXTj+ePPndBJNN5cTpbBuxWSYdW5Kg0JOID9yQylQTflW2Dj26lZtSTCNztx+L5L8I+uZ2/82GyZs36xHkwKzmlTl/mEQa944U798c1irmNZZ5fyLsAIae9slnH7erK2cEHOW0SGmTHnt4dq/6ghD8YnSKXtkJpy3WdP1Vfp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673297; c=relaxed/simple;
	bh=OuTO4H7+HfWKikubpDYOiPIqNGlrAFxtttGgbJiLNxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YvI3PAdtz1g3B4hqH5SldPmiD5s7U1xzPg4PiSQTHXrmuDnU6n/zohkzBtU0BdT99p2sc3qsiFQdbjuY4Rm0Lv6LjNesZeSqKqaZjiZ3/Oly5QcEAHY3kT/QzlI0Z4ALCtZaoXWcz8vVFaEz3ofSAAJrZLu8ZpU2GpRDlNWykWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FaXrNEAl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FaXrNEAl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A77EC19421;
	Wed,  8 Apr 2026 18:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673297;
	bh=OuTO4H7+HfWKikubpDYOiPIqNGlrAFxtttGgbJiLNxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FaXrNEAl8SWcAgNoVnWb6EJh//qg9IDpcNjB7vAVoUDLxwiPqaqZIvqt16IzFiQkx
	 pgyikd3Y+1yUD/MyXvY9j7BycFDeSGEfJilBTLDaRkfEoc7jzN3GRk2NRVLzcGB1q5
	 EuDX/nmb8tosNz0XqUfoM79t4/zyM6Gs5Bnrn4BY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.18 176/277] iio: adc: ti-ads7950: normalize return value of gpio_get
Date: Wed,  8 Apr 2026 20:02:41 +0200
Message-ID: <20260408175940.436965343@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit e2fa075d5ce1963e7cb7b0ac708ba567e5af66db upstream.

The GPIO get callback is expected to return 0 or 1 (or a negative error
code). Ensure that the value returned by ti_ads7950_get() for output
pins is normalized to the [0, 1] range.

Fixes: 86ef402d805d ("gpiolib: sanitize the return value of gpio_chip::get()")
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ti-ads7950.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/ti-ads7950.c
+++ b/drivers/iio/adc/ti-ads7950.c
@@ -433,7 +433,7 @@ static int ti_ads7950_get(struct gpio_ch
 
 	/* If set as output, return the output */
 	if (st->gpio_cmd_settings_bitmask & BIT(offset)) {
-		ret = st->cmd_settings_bitmask & BIT(offset);
+		ret = (st->cmd_settings_bitmask & BIT(offset)) ? 1 : 0;
 		goto out;
 	}
 


