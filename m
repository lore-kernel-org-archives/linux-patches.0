Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24B12139C9;
	Tue, 26 Aug 2025 13:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215493; cv=none; b=FIvxSzD4h9FLlgBbdLzTp6wqjmoSj6w7CIelnvupkDA7N/+lj6vZV9nnEV1LoN9XpkzhAXKjapgJu4LXHwtZ/diLUoTNXbOe3p8JaP5j1PHitEBa8wCSapR9cGYTF7O0/Isqej1LdXZxCTAUq2C19ZWIpIHQ7qsyodJpomgQmzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215493; c=relaxed/simple;
	bh=dF/m9L1DnmuYvQS0GbhFyphxVFBTYKy4IEQImwmItgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gYDy679fkNHTTPTcbCthPy7HOm6+8gd+DES69j6lzB68Sl5kjGgfRLDF0gnaoKdxH/G245Gd5lkkNcG7tLq333onMBVBXG6El5lF8nRpKnj1JE9DPeT3R1z6ZWkwpzBuqTLZzXhsx6MhGnFLN8xTd0DdCIqEiXw0crHQa9Hy91s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oo2xkYkX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oo2xkYkX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37FA1C4CEF1;
	Tue, 26 Aug 2025 13:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215493;
	bh=dF/m9L1DnmuYvQS0GbhFyphxVFBTYKy4IEQImwmItgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oo2xkYkX7wSaS0iw1TdEbi9YIOCZ4CNqa1cd45j7/+0j+bUccZ5fQ+uzmCP4DTn1Q
	 s2Nvo/OXFIgul559DVSfgbQeod2ueL5vH4R/uHkbYAxSYacoTl34WYzHpXEsHkre4X
	 wcO86PYgpSpmaGNNkqgNplXSP9ueD/Gy0ikE8Sj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 027/644] iio: adc: max1363: Reorder mode_list[] entries
Date: Tue, 26 Aug 2025 13:01:58 +0200
Message-ID: <20250826110947.181048115@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <festevam@denx.de>

commit 8d8d7c1dbc46aa07a76acab7336a42ddd900be10 upstream.

The IIO core issues warnings when a scan mask is a subset of a previous
entry in the available_scan_masks array.

On a board using a MAX11601, the following warning is observed:

max1363 1-0064: available_scan_mask 7 subset of 6. Never used

This occurs because the entries in the max11607_mode_list[] array are not
ordered correctly. To fix this, reorder the entries so that no scan mask is
a subset of an earlier one.

While at it, reorder the mode_list[] arrays for other supported chips as
well, to prevent similar warnings on different variants.

Note fixes tag dropped as these were introduced over many commits a long
time back and the side effect until recently was a reduction in sampling
rate due to reading too many channels when only a few were desired.
Now we have a sanity check that reports this error but that is not
where the issue was introduced.

Cc: stable@vger.kernel.org
Signed-off-by: Fabio Estevam <festevam@denx.de>
Acked-by: Matti Vaittinen <mazziesaccount@gmail.com>
Link: https://patch.msgid.link/20250516173900.677821-2-festevam@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/max1363.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/drivers/iio/adc/max1363.c
+++ b/drivers/iio/adc/max1363.c
@@ -534,23 +534,23 @@ static const struct iio_chan_spec max136
 /* Applies to max1236, max1237 */
 static const enum max1363_modes max1236_mode_list[] = {
 	_s0, _s1, _s2, _s3,
-	s0to1, s0to2, s0to3,
+	s0to1, s0to2, s2to3, s0to3,
 	d0m1, d2m3, d1m0, d3m2,
 	d0m1to2m3, d1m0to3m2,
-	s2to3,
 };
 
 /* Applies to max1238, max1239 */
 static const enum max1363_modes max1238_mode_list[] = {
 	_s0, _s1, _s2, _s3, _s4, _s5, _s6, _s7, _s8, _s9, _s10, _s11,
 	s0to1, s0to2, s0to3, s0to4, s0to5, s0to6,
+	s6to7, s6to8, s6to9, s6to10, s6to11,
 	s0to7, s0to8, s0to9, s0to10, s0to11,
 	d0m1, d2m3, d4m5, d6m7, d8m9, d10m11,
 	d1m0, d3m2, d5m4, d7m6, d9m8, d11m10,
-	d0m1to2m3, d0m1to4m5, d0m1to6m7, d0m1to8m9, d0m1to10m11,
-	d1m0to3m2, d1m0to5m4, d1m0to7m6, d1m0to9m8, d1m0to11m10,
-	s6to7, s6to8, s6to9, s6to10, s6to11,
-	d6m7to8m9, d6m7to10m11, d7m6to9m8, d7m6to11m10,
+	d0m1to2m3, d0m1to4m5, d0m1to6m7, d6m7to8m9,
+	d0m1to8m9, d6m7to10m11, d0m1to10m11, d1m0to3m2,
+	d1m0to5m4, d1m0to7m6, d7m6to9m8, d1m0to9m8,
+	d7m6to11m10, d1m0to11m10,
 };
 
 #define MAX1363_12X_CHANS(bits) {				\
@@ -586,16 +586,15 @@ static const struct iio_chan_spec max123
 
 static const enum max1363_modes max11607_mode_list[] = {
 	_s0, _s1, _s2, _s3,
-	s0to1, s0to2, s0to3,
-	s2to3,
+	s0to1, s0to2, s2to3,
+	s0to3,
 	d0m1, d2m3, d1m0, d3m2,
 	d0m1to2m3, d1m0to3m2,
 };
 
 static const enum max1363_modes max11608_mode_list[] = {
 	_s0, _s1, _s2, _s3, _s4, _s5, _s6, _s7,
-	s0to1, s0to2, s0to3, s0to4, s0to5, s0to6, s0to7,
-	s6to7,
+	s0to1, s0to2, s0to3, s0to4, s0to5, s0to6, s6to7, s0to7,
 	d0m1, d2m3, d4m5, d6m7,
 	d1m0, d3m2, d5m4, d7m6,
 	d0m1to2m3, d0m1to4m5, d0m1to6m7,


