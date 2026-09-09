Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CDC4FDE6C;
	Wed,  9 Sep 2026 14:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962469; cv=none; b=kHJdMwTxaZATVGEVi+X1vzjCZWZ9VbGq7FZ6E/DvJ/wxYhit2udPvyoKY1n6J4DSzStF8mofSZ9g23kJ4j3Y2bQglO2g7xuywmOhwpPKFAaXbxkCKP9yuBGJx8p/5GQGJamebRJLZTj9IMF1Hc8GCE+GLegl/UKo57xMVsIx4qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962469; c=relaxed/simple;
	bh=S5zycFBvfPKU00sp7G6+bM8ut0U7hrI2d6XtqUVVwDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UPhOymhX7l+slwVzUBgYrNjriVtmYMwH5RLovSl8C2F9jaEGrh8MpGRmacUwrME7+yva6HhoO0Ttt74+y2F0kteMRDG5u7wBg5+BSoAKuaEJsZY4ADQvmoUxxDl4tZRPsLvI7vND3FYFOFo+cN3VZDjjVTebOaqC3Iycg4vPveo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jvX+7bQZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jvX+7bQZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 793EE1F00A3D;
	Wed,  9 Sep 2026 14:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962468;
	bh=sQMGX1FmlkZM4ssipZOzVPY1OdDpY0UpbYi3fm6/asw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jvX+7bQZ37NYxD1m1JMmaDVotAR7+zaZbrKT0vs7VzXHIROs56r1xLhXuYY1XUyk1
	 41HDKwztVGDpbLkLJG2hqzeCJMp/oRAeobCcft/qBkB4V1vbUBBZ4+vFui6vp1bm3R
	 E7VDShibUaG+kGWqTzzNR17A6h7UYqBhLnpFtSYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 259/556] iio: adc: ad4080: configure backend data size
Date: Wed,  9 Sep 2026 15:38:59 +0200
Message-ID: <20260909134239.639544115@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

commit d39afd249d1ef5cb03b6f1dc22a68e6385de413d upstream.

The AXI backend needs to know the ADC word width in order to pack the
sample data correctly on the bus. During channel setup, program the
backend packet format via iio_backend_data_size_set() using the channel
resolution, so the data is transferred according to the device's
realbits.

The backend packet format field defaults to 20-bit packing, so the
20-bit parts (AD4080/AD4081/AD4082, AD4880) were unaffected. The 16-bit
(AD4083/AD4084/AD4085, AD4884) and 14-bit (AD4086/AD4087/AD4088) parts,
however, were left packing data at the wrong width, producing corrupt
buffered captures.

Fixes: 6c3e7265734b ("iio: adc: ad4080: add support for AD4084")
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad4080.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/iio/adc/ad4080.c
+++ b/drivers/iio/adc/ad4080.c
@@ -697,6 +697,11 @@ static int ad4080_setup_channel(struct a
 	if (ret)
 		return ret;
 
+	ret = iio_backend_data_size_set(st->back[ch],
+					st->info->channels[0].scan_type.realbits);
+	if (ret)
+		return ret;
+
 	if (!st->lvds_cnv_en)
 		return 0;
 


