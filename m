Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493B72D838E;
	Fri,  9 Oct 2026 14:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557499; cv=none; b=Q/wrWQjKQWfQm+tf5ClCKxfd4yyLEZ3MgJxoLwtsxZiMzy2Qi1NAfb7Qm+XRr7sKa/Zt0MdItz4/w40nNfxo1iweD6jAEItn7GxGculbHx5xQCMgZZWAWsuAR7LrrMu92nd/PhdaBdzqINMpnO3+FF4VCTOzF/Kijhtz2PQ0Yck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557499; c=relaxed/simple;
	bh=TisLoQsH5mthmQR9SLWPY8ZvkQuYmusxtgqQj1FHMqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bdI3uzysH4l4gGlmUdAgpyPjoPTqt/98WTTXB/yUI+nAhU80evGUyXixNh+a9FYhCEk8jTqcKrYicqqeJrZ+T/6F8d3pp+qRxop2YL6ipylkFn1i7f8LhbqokffD2e9KBV+GQZl7mifSBzQzP7UdwwCZDO0U8/lorD/tylRLjDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=duOVZEBb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="duOVZEBb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96E41F000FF;
	Fri,  9 Oct 2026 14:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557498;
	bh=aE4lQaW9QzAJsUcyaKMg4lVspHeUM57JFXt6ek+E2os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=duOVZEBbcGQgshDGpMTHJk6x4AeX8IKk3F0HHGlNj0z72wV6QOSY2UAzTmIkMtO9Y
	 bvSggyVoRmyaSzE6KvvYRRt5nG6tHITseCMRW8d0g4MyKUZvIh5GHy92GVeodiXudL
	 qrCCPcB0TnC1e2VVOfeiVTCJ/DrEUbh2829EEUJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janani Sunil <janani.sunil@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 380/428] iio: adc: adi-axi-adc: Initialize state mutex
Date: Fri,  9 Oct 2026 16:11:57 +0200
Message-ID: <20261009140954.540091566@linuxfoundation.org>
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

From: Janani Sunil <janani.sunil@analog.com>

commit 549b71ce050637dd32678371ad76c445a2f8c9aa upstream.

The AXI ADC register access paths serialize transactions with st->lock,
but probe does not initialize it. Initialize the mutex before registering
the backend.

Fixes: 7ecb8ee5c93b ("iio: adc: adi-axi-adc: support digital interface calibration")
Signed-off-by: Janani Sunil <janani.sunil@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/adi-axi-adc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/iio/adc/adi-axi-adc.c
+++ b/drivers/iio/adc/adi-axi-adc.c
@@ -714,6 +714,10 @@ static int adi_axi_adc_probe(struct plat
 	if (!st)
 		return -ENOMEM;
 
+	ret = devm_mutex_init(dev, &st->lock);
+	if (ret)
+		return ret;
+
 	base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(base))
 		return PTR_ERR(base);


