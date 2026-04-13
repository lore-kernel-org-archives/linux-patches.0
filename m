Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90452E11B9;
	Mon, 13 Apr 2026 16:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097569; cv=none; b=lfvkprYZ0ETRHQ6uA1wtm5jSNjx6kKLWroxxoajE+uicoftPP9E0YmUUp9vVP86bP42VnemHy4pvQcKZLP06rtG6qkpRSFRYpBDHFKZ5u7wr7MrvXEOQghWNYnnJmUNNmYAae3pPujX9fbJ36jv3d6WGeVr1Ng58ujZRPqeACeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097569; c=relaxed/simple;
	bh=jdBPvSE2tzNwAlsAXKGFpyhmlM+DQ90wcjTKiDkRDbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TuVfathlDDWftRIQJK8LNqfLmdS27h6fU9se9qLLE99ZTl4sMXMfJiDqXCYE6tL9H5WvRtoRZ4yPLw0DkXboSwbhKJw090faVdzILGB8nvUa07QjQrGL23Z6EsPGCTCavtcgvDsTLKqYoRLV/DqPQnVhQwuI4OlKJ1Lzv2Nj0F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YPNYYwop; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YPNYYwop"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F3CEC2BCAF;
	Mon, 13 Apr 2026 16:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097568;
	bh=jdBPvSE2tzNwAlsAXKGFpyhmlM+DQ90wcjTKiDkRDbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YPNYYwopnPx0jX/bSpSkh/NZJaJTYHnzEbf/7SudsWFUz+OPp+wobYvkIy8U4Sf3o
	 MJJgNg0FJtVxXuhlY6L+TatkL/HxfjF4TfhajRA+lsKmQuxwNGoRUm8MGY7dgM9Ape
	 Zi2wjMUil1WASxd3DI+O8iU0um6gn+kdOUZ2WCis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Spencer <spencercw@gmail.com>,
	Vasileios Amoiridis <vassilisamir@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 186/570] iio: chemical: bme680: Fix measurement wait duration calculation
Date: Mon, 13 Apr 2026 17:55:17 +0200
Message-ID: <20260413155837.426124125@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -548,7 +548,7 @@ static int bme680_wait_for_eoc(struct bm
 	 * + heater duration
 	 */
 	int wait_eoc_us = ((data->oversampling_temp + data->oversampling_press +
-			   data->oversampling_humid) * 1936) + (477 * 4) +
+			   data->oversampling_humid) * 1963) + (477 * 4) +
 			   (477 * 5) + 1000 + (data->heater_dur * 1000);
 
 	usleep_range(wait_eoc_us, wait_eoc_us + 100);


