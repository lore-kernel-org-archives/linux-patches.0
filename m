Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4BC4E80DF;
	Fri,  9 Oct 2026 14:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556909; cv=none; b=RbRUlmxlUZkj/PVO0+6Et79wKWD8tiYimPJvfr9MAPfG58cvrNvPnxD6StAQK+QLrdkO9UGy2UciyVOtGOEgGohmO+BpLiZVZBiSqX7GsHgpMQojFd1ycOzS14TJCysQRGH2V67dvlqVjmezH5kjEdgSLry4taN5PmHgOX9A+Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556909; c=relaxed/simple;
	bh=8jCWxxevl6TNx/GBzh254+xaFIhyOhWyt19JKPTiMp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TTHorEnfJebskBWogAOx3lf5dTBN8sRnFtV6xxl6K3FGDBAsUhsN5Mkgr77Zbs3+3mLM35Fqbi8HYj2MLuxhCM6W9oMwBZNcLKmQuPlHZ2hZHB5thiR5Z/et9KaE6TjSlxTq6gIFFYNmXu+WkvVOqFkUANQtESoSGgTIdnugOM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=km7gl5LV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="km7gl5LV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E281F000FF;
	Fri,  9 Oct 2026 14:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556908;
	bh=SLhAY4lIxff6GGO5hfxyPUtuzekQDQ8LPIhk9hIYSF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=km7gl5LVhNz2jIpCCM4B1+aPz8FCKt0jtNnxBGwS7TSwD3FNGah3CC0Jq3D8U5q4l
	 Ktw0D6jVcwXOkt1TvEFbRGG1IHN54PYN0T38lP1Xfnuh/jNrb2kZp/j2K85nzBDLIG
	 s/OyquhrrTSjqz0pzfR/7PFL1PF7zuRm45gve30c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 312/403] iio: adc: rohm-bd79124: Fix GPIO mask check
Date: Fri,  9 Oct 2026 16:11:13 +0200
Message-ID: <20261009140959.516896368@linuxfoundation.org>
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

commit d081c116a16489f7808d35fcf1ee9d4b9869d204 upstream.

The ROHM BD79124 has pins which can be configured as GPOs or as ADC
inputs. The bd79124gpo_set_multiple() is intended to ensure that a pin
which is requested to be toggled, is indeed configured as a GPO.

The check uses XOR, causing it to fail if mask is not exactly same as
GPO configuration. Eg, if not all GPOs are asked to be toggled at once.

Fix this by checking that mask does not contain pins that are not
configured as GPO, allowing some of the pins which are configured as
GPO to be untouched.

Fixes: 3f57a3b9ab74 ("iio: adc: Support ROHM BD79124 ADC")
Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/rohm-bd79124.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/rohm-bd79124.c
+++ b/drivers/iio/adc/rohm-bd79124.c
@@ -222,7 +222,7 @@ static int bd79124gpo_set_multiple(struc
 	if (ret)
 		return ret;
 
-	if (all_gpos ^ *mask) {
+	if (*mask & ~all_gpos) {
 		dev_dbg(data->dev, "Invalid mux config. Can't set value.\n");
 
 		return -EINVAL;


