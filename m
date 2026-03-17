Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDCB1ACEDE;
	Tue, 17 Mar 2026 17:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766924; cv=none; b=HVl+l71gR5FHFagJriEYpQBWOoX8T+eMV9xlzBpfOy2hTkQdnR6NRXNsAelyc6JQaphem+/2I8keWWpJjrL1Ih10gOjgQdea0gbNOuYW6pJvZULzXe5GIJdUG+VdLYZkGx6Kpjk1i6VPvOu/VTw9Dvn6O4YiAWZnWJLyB/l7vfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766924; c=relaxed/simple;
	bh=P5CFioy1Ga6Fj11eyUepJg5vH1d/ctq24Ujtt/LXiVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NUfIHZUWxgD9dT0zpKFGNLljLINW560z8zAAJFQikdy1w/sxHs6Ld+FHuG4tLiPqpqHsXA81OYbV+Sulk6wixB/dBrukQdtqfH8mG+c+S/kknqE9b/12FqBhx74p09/a7B37QNxYoeDLBRRfi5AFqrGcGQKw7WExAqoFRxaLONU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lgeBLyR9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lgeBLyR9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB0E1C4CEF7;
	Tue, 17 Mar 2026 17:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766923;
	bh=P5CFioy1Ga6Fj11eyUepJg5vH1d/ctq24Ujtt/LXiVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lgeBLyR9gWibZXG6Wwp0kl8Pn2rpWW8+3s2+7LKkW30oNun4adumi0+0C1tnlSrXo
	 vERMOvBKN7HfbQf9aqQCc4Wu/UyR2LIrdFuq766aa6dhf5BKHrgRYiIkvaP31LNNpH
	 naG3trWRLsCm+RjXMS0/u0PdSTt8Dnta3gWNA5Mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Spencer <spencercw@gmail.com>,
	Vasileios Amoiridis <vassilisamir@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.19 352/378] iio: chemical: bme680: Fix measurement wait duration calculation
Date: Tue, 17 Mar 2026 17:35:09 +0100
Message-ID: <20260317163019.936603711@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -613,7 +613,7 @@ static int bme680_wait_for_eoc(struct bm
 	 * + heater duration
 	 */
 	int wait_eoc_us = ((data->oversampling_temp + data->oversampling_press +
-			   data->oversampling_humid) * 1936) + (477 * 4) +
+			   data->oversampling_humid) * 1963) + (477 * 4) +
 			   (477 * 5) + 1000 + (data->heater_dur * 1000);
 
 	fsleep(wait_eoc_us);


