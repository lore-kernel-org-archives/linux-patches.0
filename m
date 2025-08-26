Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7AC63376BD;
	Tue, 26 Aug 2025 11:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207750; cv=none; b=rPS6NIE738MJAa9lYMsE6ND/N69CnJmGI6NZ4Gya8wOJ2sCr8J1bHTSwxWhy/tG4UMZowXtGRqqOTG8XInhCaaTE5nqyPxjG5uw8foCoU1M/MVliBQ44ziysXcw+PI5xyEYhufLdt5LI7BAqN1KUB5wekaOIogT++3jjzH2XP4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207750; c=relaxed/simple;
	bh=4Cf7UGTJdl9qvLzcBRBy8I6ta7jLtfIiB3DDRFbLF/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fY9F3f5P49g/MeVwPWjrgO5jkK3/ZEdiAyiVvzrVTl+GYaj9SJHTr2rbYhKlHz7yuyGpVZwAHsWlo/nGo0EcfZ2CaWkI6e6RhcNs8+4bOqHQBTGcr7YBvrnJfUwUTmeDeQtBteOQVNYjBl4STCc9RyuZ4pzxrH0xmho9OIlrlg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c2VAJZBC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c2VAJZBC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46BA6C4CEF1;
	Tue, 26 Aug 2025 11:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207750;
	bh=4Cf7UGTJdl9qvLzcBRBy8I6ta7jLtfIiB3DDRFbLF/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c2VAJZBCZcUtxIxA4xbv+eazr5l32vlY98OOjxUEQbK2FmAbfB4V+CAc6QHg3TURo
	 zb6CkYC75GGsWpRpZc+P8mj+rBJiOaXQ82ZWZO+h3XD0Ql/RpcngJSwmwWX/HNAQNj
	 5Ww77HRMGmO9XayynoZBzTAOFGQJMMxP7PbkNIq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.16 302/457] iio: adc: rzg2l_adc: Set driver data before enabling runtime PM
Date: Tue, 26 Aug 2025 13:09:46 +0200
Message-ID: <20250826110944.837287059@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

commit c69e13965f26b8058f538ea8bdbd2d7718cf1fbe upstream.

When stress-testing the system by repeatedly unbinding and binding the ADC
device in a loop, and the ADC is a supplier for another device (e.g., a
thermal hardware block that reads temperature through the ADC), it may
happen that the ADC device is runtime-resumed immediately after runtime PM
is enabled, triggered by its consumer. At this point, since drvdata is not
yet set and the driver's runtime PM callbacks rely on it, a crash can
occur. To avoid this, set drvdata just after it was allocated.

Fixes: 89ee8174e8c8 ("iio: adc: rzg2l_adc: Simplify the runtime PM code")
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Link: https://patch.msgid.link/20250810123328.800104-3-claudiu.beznea.uj@bp.renesas.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/rzg2l_adc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/adc/rzg2l_adc.c
+++ b/drivers/iio/adc/rzg2l_adc.c
@@ -428,6 +428,8 @@ static int rzg2l_adc_probe(struct platfo
 	if (!indio_dev)
 		return -ENOMEM;
 
+	platform_set_drvdata(pdev, indio_dev);
+
 	adc = iio_priv(indio_dev);
 
 	adc->hw_params = device_get_match_data(dev);
@@ -460,8 +462,6 @@ static int rzg2l_adc_probe(struct platfo
 	if (ret)
 		return ret;
 
-	platform_set_drvdata(pdev, indio_dev);
-
 	ret = rzg2l_adc_hw_init(dev, adc);
 	if (ret)
 		return dev_err_probe(&pdev->dev, ret,


