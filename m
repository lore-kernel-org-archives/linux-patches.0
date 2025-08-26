Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A721134AB0D;
	Tue, 26 Aug 2025 14:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218291; cv=none; b=E+QatoE3j2nprGaiCa7OL55E/pIPItI+iXegGUldXl8+fPFwHPQEyc75aEpcxPD0b9ibRgN0r47NEPYAZMXERXclWcdP5XN/xaZDU3IqOcRXtU36uo8mjdyD2/9DDJB3wDB9cyZI8jDpaJx3wthZ33X7i2FqcxI7x6o1rLc6NAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218291; c=relaxed/simple;
	bh=qVULVW4R3vYnjxqrmzb8uBNjdaOzMDoQga9BrH3lCMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XmFxkhpIEdauzcpociatWi5JuSr3Pppsfa61JE9M0ddoDPnCQDqaoOZOeOfLLYFvkAB0A14eyGPql21IUxit/TD0w/nyAwMMVBgnxT0FxcXgPsk0SQf4tnX+J+cYgWszRO9Z2HM/RatwYXbzeNMIhrrMhXVWeFBY0b6hMuPgHwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SScz1uwO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SScz1uwO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB6DC4CEF1;
	Tue, 26 Aug 2025 14:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218291;
	bh=qVULVW4R3vYnjxqrmzb8uBNjdaOzMDoQga9BrH3lCMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SScz1uwOcMJDj1OCgAcuptzWt2CPG8rgaOkf+wl+6U/iGqB6bMTk14QXsaPx5p9XN
	 X4YOXsjCZgMmgUmCLvUp4uh/WhLhEX3M2YeeZihKjkAgAzr4JQq6IAYCNJkgSmL2gg
	 4rEIdKHaigGR7yLC/dtBppph9fG3xhL6BMqTgVjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 465/523] iio: adc: ad_sigma_delta: change to buffer predisable
Date: Tue, 26 Aug 2025 13:11:15 +0200
Message-ID: <20250826110935.914681291@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit 66d4374d97f85516b5a22418c5e798aed2606dec ]

Change the buffer disable callback from postdisable to predisable.
This balances the existing posteanble callback. Using postdisable
with posteanble can be problematic, for example, if update_scan_mode
fails, it would call postdisable without ever having called posteanble,
so the drivers using this would be in an unexpected state when
postdisable was called.

Fixes: af3008485ea0 ("iio:adc: Add common code for ADI Sigma Delta devices")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://patch.msgid.link/20250703-iio-adc-ad_sigma_delta-buffer-predisable-v1-1-f2ab85138f1f@baylibre.com
Cc: <stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad_sigma_delta.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/adc/ad_sigma_delta.c
+++ b/drivers/iio/adc/ad_sigma_delta.c
@@ -371,7 +371,7 @@ err_unlock:
 	return ret;
 }
 
-static int ad_sd_buffer_postdisable(struct iio_dev *indio_dev)
+static int ad_sd_buffer_predisable(struct iio_dev *indio_dev)
 {
 	struct ad_sigma_delta *sigma_delta = iio_device_get_drvdata(indio_dev);
 
@@ -432,7 +432,7 @@ static irqreturn_t ad_sd_trigger_handler
 
 static const struct iio_buffer_setup_ops ad_sd_buffer_setup_ops = {
 	.postenable = &ad_sd_buffer_postenable,
-	.postdisable = &ad_sd_buffer_postdisable,
+	.predisable = &ad_sd_buffer_predisable,
 	.validate_scan_mask = &iio_validate_scan_mask_onehot,
 };
 


