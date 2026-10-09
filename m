Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD613815D5;
	Fri,  9 Oct 2026 14:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557516; cv=none; b=aN3/qnpWuF6Xn3wJPJXPwbMKUTq+6TZn6SCbhPwCNjEMYQL6hFdT6mc/JIe/FAJp+OVTgmpSLI5iv3DsFTQJcnCZ3OvdN9ebF+XD4LFQ1cfFHQtA7XmiLybaSElRvJHiqko9tfGQmoSji2utE18jP8MSb1CHMRj9VDWZKa6AsGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557516; c=relaxed/simple;
	bh=REtSgW2yvze6jn/wgni2sTXN0oEF4HHKcP/6M3MMspM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yrnz3lcInsOiGoJQVFfJVeMeLLD2brb7SBs7YIGUGRQm45hKA8IlbNbOLjI9UmsKBDoUlhf4yRbqs19tWimbl8wTpToUO+9NL6l6Zsjtjl/iQx9tLbLI/zN2SNXuQvjC9n1oBks4yeAMZib+tIJusktde5EZJ/pBMAx7lRTmFLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K25Zezm5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K25Zezm5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA1B1F000FF;
	Fri,  9 Oct 2026 14:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557515;
	bh=AesYTwY8BumvJq1CZDwOmEF3blr6xRSATzRfxoNf+m4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K25Zezm54a9WdOL7zQwIz+VxcNqJJQRtRrpBCfFWjazU5TnsCHNhiheAIhiTabnea
	 qnqx/qFt6SBR4/rEqm1XuTdol/PeEIpQD9UhxOyDcLw/lHtFRg2+QMitTs6IpopnDR
	 tOKl3tATqw4dDSgrC190fd9S+0sDdBfJXo4RvVNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 385/428] iio: adc: rohm-bd79124: Catch regmap errors at measurement start/stop
Date: Fri,  9 Oct 2026 16:12:02 +0200
Message-ID: <20261009140954.652760380@linuxfoundation.org>
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
@@ -381,6 +381,9 @@ static int bd79124_start_measurement(str
 
 	/* See if already started */
 	ret = regmap_read(data->map, BD79124_REG_AUTO_CHANNELS, &val);
+	if (ret)
+		return ret;
+
 	if (val & BIT(chan))
 		return 0;
 
@@ -420,11 +423,16 @@ static int bd79124_stop_measurement(stru
 
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


