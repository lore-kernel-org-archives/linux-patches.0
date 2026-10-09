Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610513D8912;
	Fri,  9 Oct 2026 14:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557479; cv=none; b=QX54brDgNnUbx+jb3LfaIvK0KD+RAJVyY8NMh6y4EHHVULXVt86KRlSoZoHlKg/M7BNMaolKRmEd3WfaMV+CH+gNQWrbgmOejrttjRLcNyuaawyBMHS+jMASAZL1NitpF+A2ZfpxqSq6Ysl6jXYh37fREWFivvh+lPgw76C4u7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557479; c=relaxed/simple;
	bh=Rc5IpeRxusjrhtNxgcZOJEp5y2OyJ6R7Kvc06uaRZvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fID6RsRN0HjDH5F3UPgRoVQt1cPcgnDtwGfthrO6zGGnBImM9c2eXC+RcTCz2trBbBRuv4xNv/GFHnoXBkY1u9dLQ7ONBbjp/2RtqRS0iIGO+2zf/rz0Bs2RPZCktopzT8mc9eELbocDDDj1YdmosspG2x0p/4/VJUwq7wbBa+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jRnTgBdw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jRnTgBdw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA8121F000FF;
	Fri,  9 Oct 2026 14:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557478;
	bh=TQgdxxm3q2iS7UF1/oZR17+xD4jqKo2S9qj10XxhSiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jRnTgBdwvvvEhKEZKhV9VM9WI/xDQfyI3Hliwb/dzDiieQqwwsOKF50RmiFnSP/jW
	 fksBHa4Y7U1bGk8WZmAgmndKjsxUXOGJ10qois6o8kE9QJlFHnMhliGOC2LqZW898Z
	 jI+3CtROHV6GUg0tLb6eRBAjXZZwfQdxb36nlIUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 373/428] iio: adc: ad4030: fix invalid oversampling_ratio validation
Date: Fri,  9 Oct 2026 16:11:50 +0200
Message-ID: <20261009140954.378859303@linuxfoundation.org>
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

From: Salah Triki <salah.triki@gmail.com>

commit d615210564205993e8f0e7ccb57cc2e66b7d5706 upstream.

In ad4030_set_avg_frame_len(), the logarithm is calculated before input
validation. Passing zero or negative values leads to an undefined result
from ilog2().

Validate that the input is strictly positive prior to computing its
logarithm.

Fixes: 949abd1ca5a4 ("iio: adc: ad4030: add averaging support")
Assisted-by: LLM
Signed-off-by: Salah Triki <salah.triki@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad4030.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/iio/adc/ad4030.c
+++ b/drivers/iio/adc/ad4030.c
@@ -746,14 +746,21 @@ static int ad4030_set_chan_calibbias(str
 static int ad4030_set_avg_frame_len(struct iio_dev *dev, int avg_val)
 {
 	struct ad4030_state *st = iio_priv(dev);
-	unsigned int avg_log2 = ilog2(avg_val);
 	unsigned int last_avg_idx = ARRAY_SIZE(ad4030_average_modes) - 1;
+	unsigned int avg_log2;
 	int freq_hz;
 	int ret;
 
-	if (avg_val < 0 || avg_val > ad4030_average_modes[last_avg_idx])
+	/* Reject unsupported modes */
+	if (avg_val > ad4030_average_modes[last_avg_idx])
 		return -EINVAL;
 
+	/* Avoid invalid values for logarithm since it's undefined */
+	if (avg_val < 1)
+		return -EINVAL;
+
+	avg_log2 = ilog2(avg_val);
+
 	if (st->offload_trigger) {
 		/*
 		 * The sample averaging and sampling frequency configurations


