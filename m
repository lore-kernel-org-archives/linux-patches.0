Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E55341ABD;
	Tue, 26 Aug 2025 13:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214331; cv=none; b=P/Y/+te44b6viQAp7Z/nJhhMUBO2wPM1OVLw65RBPpZwVeLuVrzcfQXjBqe/ab6ZuW3RbdrRXpnTAuzL66sR1xNeWR8jRKk28SN91+qLa+R9Nar8W5rq8Z1maP585lnyy/mdOfbppgMwtF9HBXHkaMQQkMBEc5dDT2efG5VHaPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214331; c=relaxed/simple;
	bh=NQteYOWwb5VoEX/w5FEjIjE6mcKYdbEkghGG/6c38SU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T1+gR0s6hIbJ6txU4hfvHVf2DEjvaTTy9nGaeoWp587tkv1sRjQiRQWVn+kYJcsiUSWsuWhdNGYGOZirqdso298cCLFnSYkbp/+Mpugz0aPDwMrogEr87KhxtjlSChbBFwFRWQGO8mEP86WhxaBiM2ZuoarJ+Lxa72JiP+7fTzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sLt2qWMI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sLt2qWMI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C288C113CF;
	Tue, 26 Aug 2025 13:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214331;
	bh=NQteYOWwb5VoEX/w5FEjIjE6mcKYdbEkghGG/6c38SU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sLt2qWMIHmQr9EZr/GjgBcy3+JF2sG/8X9FtkrskHOe1Vm94mnixAve4vsHOqFPnM
	 HSr8T6vP+XreyxxfdCdjz0D+OMxRxNzp82voB1e8+UlYVlXdYZAasVLR6/kqSTZVa4
	 TWAfdnqO06q7ok2QlwN62QtJv+RH7upIKYBJgoCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 081/482] iio: adc: ad_sigma_delta: dont overallocate scan buffer
Date: Tue, 26 Aug 2025 13:05:34 +0200
Message-ID: <20250826110932.833452360@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit 5a2f15c5a8e017d0951e6dc62aa7b5b634f56881 ]

Fix overallocating the size of the scan buffer by converting bits to
bytes. The size is meant to be in bytes, so scanbits needs to be
divided by 8.

Signed-off-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://patch.msgid.link/20250701-iio-adc-ad7173-add-spi-offload-support-v3-1-42abb83e3dac@baylibre.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad_sigma_delta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ad_sigma_delta.c b/drivers/iio/adc/ad_sigma_delta.c
index 533667eefe41..71e775a10a91 100644
--- a/drivers/iio/adc/ad_sigma_delta.c
+++ b/drivers/iio/adc/ad_sigma_delta.c
@@ -378,7 +378,7 @@ static int ad_sd_buffer_postenable(struct iio_dev *indio_dev)
 			return ret;
 	}
 
-	samples_buf_size = ALIGN(slot * indio_dev->channels[0].scan_type.storagebits, 8);
+	samples_buf_size = ALIGN(slot * indio_dev->channels[0].scan_type.storagebits / 8, 8);
 	samples_buf_size += sizeof(int64_t);
 	samples_buf = devm_krealloc(&sigma_delta->spi->dev, sigma_delta->samples_buf,
 				    samples_buf_size, GFP_KERNEL);
-- 
2.39.5



