Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512A13B47FD;
	Mon, 23 Mar 2026 15:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278597; cv=none; b=QKAuQZmsx+vGVH+hm8/6RcisX4B6RONzSK23pwMn10kD5ZjOeGxHip5gObyvPCH8xGeH98AzAEQBgiLaIU+rpJ7xoHEC1albZut3vDFlxBK535YEYEJJDh2u1tnKjhHC8v+XJ3ZfblupZ6sppGX5hDitauh981651uu0XF2e460=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278597; c=relaxed/simple;
	bh=PxyNMrnGPrS+621AOBEnV4UHglGZ8lwYMdSbUE0g+JM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FF5eWXsA11v5+lqGHNuhiNrWPbYb0vNp/rLAyCQpXxeUEPO8GsGeKqIqRSbaKqZ4FOEdmR6r5dzwyaqPHup167nJyI+i8+GM5awQDW1yenW4V20WipNtZWxc5Zjm2r1vunIIcEc4gQ2JwZG3iKEIH/Gx+++2cGpkzBakc9CONHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pvL3IrJG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pvL3IrJG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA720C4CEF7;
	Mon, 23 Mar 2026 15:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278597;
	bh=PxyNMrnGPrS+621AOBEnV4UHglGZ8lwYMdSbUE0g+JM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pvL3IrJG2pqXCu+FweERJdnCJuDn+EqYfExx9HxQB0W+dFj8O1ft/tmzYaJPhNOqp
	 4dT8KwDEiq4/0yZnMS5HL9ilrCoLrRslQbXaNwtACthsNO5oazZX8+cGUoQ0CRUBpP
	 e7zWFlgrA6FmT8yPPkXYyKmnjAg/PX+18GL+83tQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Spencer <spencercw@gmail.com>,
	Vasileios Amoiridis <vassilisamir@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 357/567] iio: chemical: bme680: Fix measurement wait duration calculation
Date: Mon, 23 Mar 2026 14:44:37 +0100
Message-ID: <20260323134542.665844009@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Spencer <spencercw@gmail.com>

commit f55b9510cd9437da3a0efa08b089caeb47595ff1 upstream.

This function refers to the Bosch BME680 API as the source of the
calculation, but one of the constants does not match the Bosch
implementation. This appears to be a simple transposition of two digits,
resulting in a wait time that is too short. This can cause the following
'device measurement cycle incomplete' check to occasionally fail, returning
EBUSY to user space.

Adjust the constant to match the Bosch implementation and resolve the EBUSY
errors.

Fixes: 4241665e6ea0 ("iio: chemical: bme680: Fix sensor data read operation")
Link: https://github.com/boschsensortec/BME68x_SensorAPI/blob/v4.4.8/bme68x.c#L521
Signed-off-by: Chris Spencer <spencercw@gmail.com>
Acked-by: Vasileios Amoiridis <vassilisamir@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/chemical/bme680_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/chemical/bme680_core.c
+++ b/drivers/iio/chemical/bme680_core.c
@@ -550,7 +550,7 @@ static int bme680_wait_for_eoc(struct bm
 	 * + heater duration
 	 */
 	int wait_eoc_us = ((data->oversampling_temp + data->oversampling_press +
-			   data->oversampling_humid) * 1936) + (477 * 4) +
+			   data->oversampling_humid) * 1963) + (477 * 4) +
 			   (477 * 5) + 1000 + (data->heater_dur * 1000);
 
 	usleep_range(wait_eoc_us, wait_eoc_us + 100);


