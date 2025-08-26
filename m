Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D99353359;
	Tue, 26 Aug 2025 14:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217026; cv=none; b=ofkT5pMDoAasIgbGHLpN5WLK6FGhAg6msehNd+hWNK2n4ZV1D48NEZ9DWt72/RXxkux0HQb0Zyk1yRwVBlpSe7gauF2/xMG0tZDOkZfFhgNivBKxERCW6XHdLp66kHaL9JD88FB+ZrM0FdEr7TQ8I0s2Eqts3UyGfG6YXSUEpXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217026; c=relaxed/simple;
	bh=fFFJTyT1RPJjV03veMhSHKHU6w/aNkZxZR2AxhiY1eU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=czywYOI7MLbtgSILFoHG3vbFJbqmUj8K8TCB+wFIwvQ7+ywNC/lXrUPpg8N1LvOys3ozsbP4bfUkSeoJAmi7TMaBuvUMGDhdsovgYRzBiyUd9GO+deRAQCGvBG45KK97a7sZpLOkm8ifo7/7p9BE/6jG0Rz7/8cqzG7ebZUbKHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rOlhqArK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rOlhqArK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55BBAC4CEF1;
	Tue, 26 Aug 2025 14:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217026;
	bh=fFFJTyT1RPJjV03veMhSHKHU6w/aNkZxZR2AxhiY1eU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rOlhqArKOkmp8b2J9+S3wv3rOmYW2/VER7Uma6AQmBfz9dv25ifsmVQum0TQ90nOH
	 UiBdpWfOGyfJJqXHO7sU70C81fQTUkMCqfFDenyNA/0r33DNERD+BOdlp6kGu52C6u
	 E5+J6iz2aTDqORT3Un71G4weGNDbrzgjMeLSmSVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 604/644] iio: adc: ad_sigma_delta: change to buffer predisable
Date: Tue, 26 Aug 2025 13:11:35 +0200
Message-ID: <20250826111001.516811903@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


