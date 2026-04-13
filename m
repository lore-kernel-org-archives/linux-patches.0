Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85982223DCE;
	Mon, 13 Apr 2026 16:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098897; cv=none; b=YG1JsAHA6axN2OIIXY7jPNz09ucTxVwGofuPfjASdFE749JZSo2ON0UjgFi33pKoCP5y8livEtZZIW7f9Ti3l4tXWeM+rvl1EeqS8gzAuQXfJOky2hrwRV0N9MAehAd5UMMjz4HiZiiJwA28p/WwBiR8hVWZXitc+QUhbmsfVU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098897; c=relaxed/simple;
	bh=f/S5vZ+1AHFL1VjpK+PZXO1hnrdaUSazPl/zny4GbVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=afGWC8tOz7OJYt/BxRmqZpylLlFGXIxV9kQ6wH1sjjyxAhyKpxr7goUmxiAJl6lyZG4yqbwf8x4GOKjqbXoFUgdT38KvGN7q7FQrTZnY6mil/88txSHmZLL/NrwTUcrE9gXALOl1pKoiXRu847Yn/0rNDbCebBeFTunAs8KPeP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oO+fFU5m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oO+fFU5m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AEBAC2BCAF;
	Mon, 13 Apr 2026 16:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098897;
	bh=f/S5vZ+1AHFL1VjpK+PZXO1hnrdaUSazPl/zny4GbVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oO+fFU5mbGOT6s5LlSpOvcDdp1zpeefKIUP+mRMlVaGTqn0TUD0XqMO4PRdHFxk7R
	 OS/OtiNp4I9bpM3yyHnqMpDEL4fKxeYh0QDDbyMt6YXa4CqAVFN8kzF1YqOuOHHE6/
	 DKh9URftYffIpccB3DGbfZFLd4AYFnnS12fXlkGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Spencer <spencercw@gmail.com>,
	Vasileios Amoiridis <vassilisamir@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 131/491] iio: chemical: bme680: Fix measurement wait duration calculation
Date: Mon, 13 Apr 2026 17:56:16 +0200
Message-ID: <20260413155823.946704262@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


