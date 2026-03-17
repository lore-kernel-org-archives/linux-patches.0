Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D8DE21D5B0;
	Tue, 17 Mar 2026 17:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768387; cv=none; b=Jl3TP0+izO0JhUwUo9hTO4s+WJ7Hgc6bbjrvxPeytJ12aXQJ9vIwaYo/IEl2lNlJ24dFWAWDmgZaGHMZWU/TGyI9DoyWh59l1/gyiKeXWFHmAo47EJMajwQ47d23QE7f0MI/dILtuyNsR7AIDPm5hMPJevtNSriHr2TtD6wvLQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768387; c=relaxed/simple;
	bh=eBn/8sPEMDcXbAueFSvu0M+npfXGguH2LD6QNslPUMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l1r/+V9LOW31EbrTBxgYhCbwciIMzKkeLO6cqbvai2Oos77REKvsZYwI8SZirrCL3K1aJU+cx27aoyxxviT7gcXIVbkNnvEHrKpc21w0vArmMmybQPNB/CT6mQAp2XlEM6PWJNKUkerxT0mM8XfNIq5wxiKY1X5+s5f6cn35bC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=04laU49c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="04laU49c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E0FC4CEF7;
	Tue, 17 Mar 2026 17:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768387;
	bh=eBn/8sPEMDcXbAueFSvu0M+npfXGguH2LD6QNslPUMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=04laU49cl9Dh7zhKpt0mFh49OKUmZ66HQuWaO/xCkLVNFr1Hb67tUK9QTHNUlrKW7
	 Ig4t8tt1CMx433jkfWAYWDENHHVUCo27t5LpUcEj4689XbPF04vQOqrzxzMp/Tw5Ri
	 UnjP56tw4zbHBhMzfZL4RLyihsbtZpnBcOkV+GS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Spencer <spencercw@gmail.com>,
	Vasileios Amoiridis <vassilisamir@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.18 298/333] iio: chemical: bme680: Fix measurement wait duration calculation
Date: Tue, 17 Mar 2026 17:35:27 +0100
Message-ID: <20260317163010.445279964@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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


