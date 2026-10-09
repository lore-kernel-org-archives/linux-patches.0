Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FDF54E8DEE;
	Fri,  9 Oct 2026 14:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557482; cv=none; b=U+heq4TrHjZk+4b6SDj9C++mC5O9LUxDMyldiz97gnMDEWWwp2VuXQ+pZsn8vuDy33cyDth1dTLGcCHN2DIsg7CLxg5lt3t3CKSku69UZXxrPnEnXpuHiBajPYnYACYOHuI3q9Y78MpLS3d+J+2+ykK0PCB+KoJT/1j61HwyxJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557482; c=relaxed/simple;
	bh=un5UnDPicMBqyTXriiIPvgW9+zBOI45Y/fXIo8gvpWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cVoTOfpi+5tYw1WDMTDUfN4iepCPu6Z53pkSp2bsKoPLSTC/My+AvsEpxp+qq58X4f+QEP5WWAPvec+NJECt2bToaGPU61OU6HHPQ9nlhJHkHSDua257/1/XB8WPqQw+MJHhu7d4rAIH37WSh/GO6it8DArzTHeRe2RjcaGu+kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BmdKbZGy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BmdKbZGy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ED791F000FF;
	Fri,  9 Oct 2026 14:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557481;
	bh=jDoSC+XZV2sZpKyegw+KtnmG16rjPvvADkufxCG5HX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BmdKbZGyPulu/UBowqmj+SXyTTtl/aztE6dczry3ALFPj3RYJrazjVpvZs8o3oUlu
	 FCidDyE9HUMd/POYOuyVHPB6+yWgOawWsJzqmNw+LOXykruMi4XWDQhkH0VoeaReGt
	 qBBQCwfnMHWfFdCC385cMYUEhLwydcA98gMxFVe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcelo Schmitt <marcelo.schmitt@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 374/428] iio: adc: ad7173: Fix digital filter configuration
Date: Fri,  9 Oct 2026 16:11:51 +0200
Message-ID: <20261009140954.402108066@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcelo Schmitt <marcelo.schmitt@analog.com>

commit 9ec6ecc95dda6d91fa6f671cd972dd4bfc05ba38 upstream.

Filter enable and filter type selection masks were swapped on data
preparation for filter configuration register write. Use the correct masks
to set each property of post filter configuration.

Fixes: ff06b39be1a1 ("iio: adc: ad7173: support changing filter type")
Signed-off-by: Marcelo Schmitt <marcelo.schmitt@analog.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7173.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/adc/ad7173.c
+++ b/drivers/iio/adc/ad7173.c
@@ -775,9 +775,9 @@ static int ad7173_load_config(struct ad7
 
 	return ad_sd_write_reg(&st->sd, AD7173_REG_FILTER(free_cfg_slot), 2,
 			       FIELD_PREP(AD7173_FILTER_SINC3_MAP, 0) |
-			       FIELD_PREP(AD7173_FILTER_ENHFILT_MASK,
-					  post_filter_enable) |
 			       FIELD_PREP(AD7173_FILTER_ENHFILTEN,
+					  post_filter_enable) |
+			       FIELD_PREP(AD7173_FILTER_ENHFILT_MASK,
 					  post_filter_select) |
 			       FIELD_PREP(AD7173_FILTER_ORDER, 0) |
 			       FIELD_PREP(AD7173_FILTER_ODR_MASK,


