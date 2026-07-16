Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0ED9422550;
	Thu, 16 Jul 2026 13:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209054; cv=none; b=od00YYGFApLrfCXFh5+E8zvEcbGVwJRU0Xn8weovHu89PgdUmNfp83N2mocrUMNkFXnSMVlCejhOhe4f/dOlFnv/dX2aW90oPrMYlj55JTH+oErmAbvdKOMz1qaciTWVPctYY09uAXgec6vWDR+w5J8DeFq1XkwsYc6TG/8KA9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209054; c=relaxed/simple;
	bh=bNO1IaexQZpTe5eTLIhavGiJ4eCenQtgEiFs6h5ZUhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ogx9KghaqWuwwBCPtMJQAwYbp/TuuzfIPaLPjLlOFNVaf5zwSqow3W2NdJ8kX/KM2+gwmtZP/d+AqhCE+EsPiEm1LFnVm+sflH2HqNl2BN+9/nKQ7S8ywPdgd0R3MUu3oqvpoL9Xln06aWGVWAZlpKynrZmtE694tjGVQ6JtFKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n/vPBdd3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n/vPBdd3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 601A21F000E9;
	Thu, 16 Jul 2026 13:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209052;
	bh=zZIz9IknVMrtHa39X5N7DeGDTOIjriumEiNvhhXQYcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n/vPBdd3QizMZd277YOB5F2wdfx9bQd49Kxn4j1bmpRuWBzrrTbWFHHH1ZhYcql2s
	 VlXvm8PY27RZR0houpZGEerkbnAnJSUhLt2e2AYShi57AlNKJAmXcqLLGJZyp5bypK
	 gyf3mGJeK7+XRvaDQIDbFZZ/etMYFSxU8PUKSLpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radu Sabau <radu.sabau@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.1 040/518] iio: adc: ad_sigma_delta: fix CS held asserted and state leaks
Date: Thu, 16 Jul 2026 15:25:08 +0200
Message-ID: <20260716133048.656053245@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Radu Sabau <radu.sabau@analog.com>

commit c72da0688575e5ef39c36bb44fed53aa18f8ae65 upstream.

In ad_sigma_delta_single_conversion(), set_mode(AD_SD_MODE_IDLE) and
disable_one() were called from the out: block while keep_cs_asserted
was still true. This caused any SPI transfer issued by those callbacks
to carry cs_change=1, leaving CS permanently asserted after the
conversion. Fix by moving both calls into the out_unlock: block, after
keep_cs_asserted is cleared, matching the pattern already used in
ad_sd_calibrate().

In the error path of ad_sd_buffer_postenable(), if an operation fails
after set_mode(AD_SD_MODE_CONTINUOUS) has already succeeded (e.g.
spi_offload_trigger_enable()), the device is left in continuous
conversion mode with CS physically asserted. Additionally,
bus_locked remaining true after spi_bus_unlock() causes subsequent
SPI operations to call spi_sync_locked() without the bus lock actually
held, allowing concurrent SPI access.

Fix the error path by clearing keep_cs_asserted first, then calling
set_mode(AD_SD_MODE_IDLE) to revert the device mode and deassert CS,
then clearing bus_locked before releasing the bus.

For devices that implement neither set_mode nor disable_one (such as
MAX11205, which has no physical CS pin), no SPI transfer is issued
during cleanup and the cs_change flag has no effect on any physical
line.

Fixes: 132d44dc6966 ("iio: adc: ad_sigma_delta: Check for previous ready signals")
Signed-off-by: Radu Sabau <radu.sabau@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad_sigma_delta.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/iio/adc/ad_sigma_delta.c
+++ b/drivers/iio/adc/ad_sigma_delta.c
@@ -468,11 +468,10 @@ int ad_sigma_delta_single_conversion(str
 out:
 	ad_sd_disable_irq(sigma_delta);
 
-	ad_sigma_delta_set_mode(sigma_delta, AD_SD_MODE_IDLE);
-	ad_sigma_delta_disable_one(sigma_delta, chan->address);
-
 out_unlock:
 	sigma_delta->keep_cs_asserted = false;
+	ad_sigma_delta_set_mode(sigma_delta, AD_SD_MODE_IDLE);
+	ad_sigma_delta_disable_one(sigma_delta, chan->address);
 	sigma_delta->bus_locked = false;
 	spi_bus_unlock(sigma_delta->spi->controller);
 out_release:
@@ -605,6 +604,9 @@ static int ad_sd_buffer_postenable(struc
 	return 0;
 
 err_unlock:
+	sigma_delta->keep_cs_asserted = false;
+	ad_sigma_delta_set_mode(sigma_delta, AD_SD_MODE_IDLE);
+	sigma_delta->bus_locked = false;
 	spi_bus_unlock(sigma_delta->spi->controller);
 	spi_unoptimize_message(&sigma_delta->sample_msg);
 


