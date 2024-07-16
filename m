Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294AA1DDE9;
	Tue, 16 Jul 2024 16:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145764; cv=none; b=JEsukapcsHn1AldNu6Gfhw7LiK6NfCbUaysIoIjVZM5YGuN7xxTjagZ1kTtpWOITU2yxqjCHBpbj9bm2+EBrXPbbmrUNiLZXHfsjRVO2mlNTvVCDRKhwwSF29sEFUDcZAO8rEhvckpFNW0G+BQUTW2PMQZeVeSgddg2BKpbQQiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145764; c=relaxed/simple;
	bh=7rfScPL0nmGSy+Pi/Uz7h9+y0d+CdE8OE4iqEd7aFQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fGK/5XhlypOEWaLcJM9kVnZx3gNtg29BE1rr3CjHk+baCZEYhqeeKS6YEzIKWGlk8B+ZtvF/uFKBBP6kcIzlLooOlZnlDYHicfeQDgPVuRbDssDdLqsOTD7XLEmZIi+Q/OtJjzgDpmOpdnHDKbCcs1EM9iSbtYH2LAdztlA3u+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TJrqM6+0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TJrqM6+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D9EC4AF0B;
	Tue, 16 Jul 2024 16:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145764;
	bh=7rfScPL0nmGSy+Pi/Uz7h9+y0d+CdE8OE4iqEd7aFQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TJrqM6+06hNWHxgW7Dam+b1i8G84YQ4kihU5JDvnp7NbSeix20AagoeOd9hsnPEwi
	 RLNETc6LwGOKxIcnSkdy5Rnh3/1IvoMiqdaC7AshRIs0du70rvXvysRqJDUxHxfEA0
	 u9ulFX4PWkouXC7z/VU+Xwx01D1kS83fMUpkweVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jo=C3=A3o=20Paulo=20Gon=C3=A7alves?= <joao.goncalves@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 076/121] iio: trigger: Fix condition for own trigger
Date: Tue, 16 Jul 2024 17:32:18 +0200
Message-ID: <20240716152754.253088947@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: João Paulo Gonçalves <joao.goncalves@toradex.com>

commit 74cb21576ea5247efbbb7d92f71cafee12159cd9 upstream.

The condition for checking if triggers belong to the same IIO device to
set attached_own_device is currently inverted, causing
iio_trigger_using_own() to return an incorrect value. Fix it by testing
for the correct return value of iio_validate_own_trigger().

Cc: stable@vger.kernel.org
Fixes: 517985ebc531 ("iio: trigger: Add simple trigger_validation helper")
Signed-off-by: João Paulo Gonçalves <joao.goncalves@toradex.com>
Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Reviewed-by: Matti Vaittinen <mazziesaccount@gmail.com>
Link: https://lore.kernel.org/r/20240614143658.3531097-1-jpaulo.silvagoncalves@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-trigger.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/industrialio-trigger.c
+++ b/drivers/iio/industrialio-trigger.c
@@ -322,7 +322,7 @@ int iio_trigger_attach_poll_func(struct
 	 * this is the case if the IIO device and the trigger device share the
 	 * same parent device.
 	 */
-	if (iio_validate_own_trigger(pf->indio_dev, trig))
+	if (!iio_validate_own_trigger(pf->indio_dev, trig))
 		trig->attached_own_device = true;
 
 	return ret;


