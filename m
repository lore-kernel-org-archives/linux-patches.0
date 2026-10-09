Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B2E47141D;
	Fri,  9 Oct 2026 14:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556892; cv=none; b=n2uK65A/GOyFR5n8PqXIDSW+xrT2fuyGfDm1OKssf/Avq7QCfx/4fTBRfbMtNyglP+ovD6ot8k8G3ZKzlG4ttbjRdz0kaI9gFUC0szgKuEqLFMad8XZqxDK3/k5KBmeDib7sbxOTW1XAh1l0GDaXrLYmGLJ/8BgSEY+f7FaNPyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556892; c=relaxed/simple;
	bh=ma9YYdgRJ6QqeSIyFQ2WH/zLgTPYwZ2fb/BC36Dja2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OfB25s8I8+0FhIv7rpMdlqIPB527eG9fiNmr5X4MGGJoEl5c6IU918dW+0cjbvaqCzxmd/k9Gxkvqn+rsfA9aheIZjuxwCprnf2QFUlXHzZJh0ABpW+0Up/tzHgmi/D46Ca5xvnXtXQLf5wQKwKKESC6bLW1PBLwHFYPqa3AMZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XVSMf9IA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XVSMf9IA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 737521F000FF;
	Fri,  9 Oct 2026 14:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556891;
	bh=++GwKV2EJiCyLpDddc+vC6nNck3T1iswRm7v+t6Nb8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XVSMf9IATNgV6JCvurq4ZnlZg1UR7aIL+UoAi6lROjD1H39c6thjb8l/GL+U5qj20
	 lpj91gEXsEMvB3mhRfvo91bxi5BUzW+dOYlYwBwv9qqfpO4+JpJjINn/ek8Pp4Y00k
	 PtUe91GumacjhXevkptrCsLpCfbbor9SBBz9TFtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 310/403] iio: adc: rohm-bd79124: Catch regmap errors at measurement start/stop
Date: Fri,  9 Oct 2026 16:11:11 +0200
Message-ID: <20261009140959.466665932@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Matti Vaittinen <mazziesaccount@gmail.com>

commit 196cc715dce3576a54065f5cb07185c75778f9a8 upstream.

The bd79124_start_measurement() and bd79124_stop_measurement() ignore
errors from the regmap reads, causing potential use of uninitialized
stack variable when deciding whether the measurement is already
started/stopped. The bd79124_stop_measurement() may also ignore failure
to clear the sequencer state bits, which may make the hardware to ignore
the setting and leave hardware and driver states out of sync.

Check the return value and bail-out if error is detected.

Fixes: 3f57a3b9ab74 ("iio: adc: Support ROHM BD79124 ADC")
Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/rohm-bd79124.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/iio/adc/rohm-bd79124.c
+++ b/drivers/iio/adc/rohm-bd79124.c
@@ -403,6 +403,9 @@ static int bd79124_start_measurement(str
 
 	/* See if already started */
 	ret = regmap_read(data->map, BD79124_REG_AUTO_CHANNELS, &val);
+	if (ret)
+		return ret;
+
 	if (val & BIT(chan))
 		return 0;
 
@@ -442,11 +445,16 @@ static int bd79124_stop_measurement(stru
 
 	/* See if already stopped */
 	ret = regmap_read(data->map, BD79124_REG_AUTO_CHANNELS, &enabled_chans);
+	if (ret)
+		return ret;
+
 	if (!(enabled_chans & BIT(chan)))
 		return 0;
 
 	ret = regmap_clear_bits(data->map, BD79124_REG_SEQ_CFG,
 				BD79124_MSK_SEQ_START);
+	if (ret)
+		return ret;
 
 	/* Clear the channel from the measured channels */
 	enabled_chans &= ~BIT(chan);


