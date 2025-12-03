Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9EDC32E692;
	Wed,  3 Dec 2025 15:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777049; cv=none; b=dlw6EbpkVRsuu83TxOMzihFSw36lVsOU6yeg2EnA+RBQoyv5dNyEdilClhQuiZDSYSO81xfSlIuF1evPtMi1EjFSOnXFQRxIJlqoT5/+bZCUAhwdUWGKrcMJe90B9yCaSV2OWKvAH6XqZqglvIU3JSuqBDx23gdn8IZHhNxGPz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777049; c=relaxed/simple;
	bh=T1RAPbXc8NDWwUv19/TcjkK9ek+GMMiI6YYsRxkPvN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KXdk2+rV3xYUzVdODrRQgiwymIxulzUKY6i5Oc9PNEJm4cepoKj9so4QciwpiUQZUK6DWEG0mhvJLqZYZXKDKpM1ZysfpJm6GKL1X4T+jrujq9vDO9tVlthi1/qe5sL0E3AxnNuDBj6oVVIfhgLc74dDRykYbKEgYrHnysDTJCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rTyOdenj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rTyOdenj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01A83C4CEF5;
	Wed,  3 Dec 2025 15:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777048;
	bh=T1RAPbXc8NDWwUv19/TcjkK9ek+GMMiI6YYsRxkPvN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rTyOdenjEknS9nOvXgtRaVYLhhWDMXH6ZA5+Skgi1+/B48Al8//0uVZ/y9uDdSwkX
	 qsWZaL7sUuCZsAzRA7cQlxvsVQpyt4ojeEYe9k3Z4Bsocjt8nfi/hrXgWzNSD7DRGC
	 QBtYZ8/rTbqW4kjgFp/cowIqaUXqnpqdH6f6BMXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcelo Schmitt <marcelo.schmitt@analog.com>,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.17 065/146] iio: adc: ad4030: Fix _scale value for common-mode channels
Date: Wed,  3 Dec 2025 16:27:23 +0100
Message-ID: <20251203152348.846935015@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcelo Schmitt <marcelo.schmitt@analog.com>

commit ffc74ad539136ae9e16f7b5f2e4582e88018cd49 upstream.

Previously, the driver always used the amount of precision bits of
differential input channels to provide the scale to mV. Though,
differential and common-mode voltage channels have different amount of
precision bits and the correct number of precision bits must be considered
to get to a proper mV scale factor for each one. Use channel specific
number of precision bits to provide the correct scale value for each
channel.

Fixes: de67f28abe58 ("iio: adc: ad4030: check scan_type for error")
Fixes: 949abd1ca5a4 ("iio: adc: ad4030: add averaging support")
Signed-off-by: Marcelo Schmitt <marcelo.schmitt@analog.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad4030.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/ad4030.c
+++ b/drivers/iio/adc/ad4030.c
@@ -385,7 +385,7 @@ static int ad4030_get_chan_scale(struct
 	struct ad4030_state *st = iio_priv(indio_dev);
 	const struct iio_scan_type *scan_type;
 
-	scan_type = iio_get_current_scan_type(indio_dev, st->chip->channels);
+	scan_type = iio_get_current_scan_type(indio_dev, chan);
 	if (IS_ERR(scan_type))
 		return PTR_ERR(scan_type);
 


