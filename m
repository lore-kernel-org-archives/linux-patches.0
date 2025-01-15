Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68657156644;
	Wed, 15 Jan 2025 10:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938477; cv=none; b=EbdN0s1+K5loy/s/6vNpYTA5yC5beVoOeLBFBXzqxUA8PrWhihCwCRmffMC6ROgPqhX6ZmsAiB2NzPWiW6uGwqg2N2gdJ8hDzCLDGh8Pv+R9QuUjFiUz8+yooOyyQZGBFCtFZP9yzBrdoedIxdA2LRuyNyA4BUik0gspid6o/CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938477; c=relaxed/simple;
	bh=HFAaK+PXb+1Pwq6Py9hK+bz6GPv88H8PARuyaAbfxbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ypr0+mKFzPY+CwwVATJFQ6l1BOK1pqQcwUmdNuYINRmBToDUSKFveyPvpjg/kxGaGXWERKWj/eTODRSriZtSa8vtVbLWbZeOlKtIeZu9zGVJpAiHrNiQ/91GxCoJpiQIZTGjZ2CiGsYjGLCfwoHNAVfGJsIk2BBu/FAzic250X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C6BqbxmR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C6BqbxmR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA81C4CEDF;
	Wed, 15 Jan 2025 10:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938477;
	bh=HFAaK+PXb+1Pwq6Py9hK+bz6GPv88H8PARuyaAbfxbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C6BqbxmRKSlYt/X04cm1B6B0IerdTixbnOwI9+bxU2inJP9XkL+qHv22a7NVZCac0
	 lBoOIP/pK9B+24gVSvlWkbE4gko/zK3qPg/P33s8azotX4IEIV3JNxYdAr2vXmNrsM
	 njsGCLmAazJzcSZ3dpmVlmRiU/GyzuOpf/HBcHr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 165/189] iio: adc: ti-ads1119: fix sample size in scan struct for triggered buffer
Date: Wed, 15 Jan 2025 11:37:41 +0100
Message-ID: <20250115103612.987452990@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 54d394905c92b9ecc65c1f9b2692c8e10716d8e1 upstream.

This device returns signed, 16-bit samples as stated in its datasheet
(see 8.5.2 Data Format). That is in line with the scan_type definition
for the IIO_VOLTAGE channel, but 'unsigned int' is being used to read
and push the data to userspace.

Given that the size of that type depends on the architecture (at least
2 bytes to store values up to 65535, but its actual size is often 4
bytes), use the 's16' type to provide the same structure in all cases.

Fixes: a9306887eba4 ("iio: adc: ti-ads1119: Add driver")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://patch.msgid.link/20241202-ti-ads1119_s16_chan-v1-1-fafe3136dc90@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ti-ads1119.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ti-ads1119.c b/drivers/iio/adc/ti-ads1119.c
index 2615a275acb3..c268e27eec12 100644
--- a/drivers/iio/adc/ti-ads1119.c
+++ b/drivers/iio/adc/ti-ads1119.c
@@ -500,7 +500,7 @@ static irqreturn_t ads1119_trigger_handler(int irq, void *private)
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct ads1119_state *st = iio_priv(indio_dev);
 	struct {
-		unsigned int sample;
+		s16 sample;
 		s64 timestamp __aligned(8);
 	} scan;
 	unsigned int index;
-- 
2.48.0



