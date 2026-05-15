Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9674DA55F;
	Fri, 15 May 2026 16:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862609; cv=none; b=YHAsV43GiONRUUJ5WWgdOG6aYiKFSnG/gn/3stpyeg7Xr18D4+HpEsYvqCIumnJsAdBTsDm8EgA0cMzb67mPfJEQFiF1nYD+Bdy8wqSl/X8kOz3h+coIKmUfbvu+CGfYIcDiuUfAGutOR5nqPtZA7O+qYUDHnqqQbf0QRlziGBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862609; c=relaxed/simple;
	bh=8NIukIbmClbUKJ5pOHgRUhE9L0XX8zLbkzlB9b7v5xc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X2x/3P3SCQfp5C0PQ9hjvay2Atiwjwx59WGH8c9f+TQY7lXT4hfsLk/21u5eNbuZ9U9SpSE9Wrp977MnFRhThWHAUOkS9iWqreTe8v2wdFrH+r3F76Ur0fqYVF4dtU29MB21ox3+nIaPDJGIY68EycwZR/H69J1Vc+ypSk663KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UbtP3La4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UbtP3La4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8DE5C2BCB0;
	Fri, 15 May 2026 16:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862609;
	bh=8NIukIbmClbUKJ5pOHgRUhE9L0XX8zLbkzlB9b7v5xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UbtP3La4RnyOc186//kLE+1DMqV67DRajku33PY/OWaNG9Qa7Oh4mCb1rJ5WGF84H
	 WfvTgI0j0oVT+BXFyaNcPhX+dJNPEMNKPHGfFH8GVXUIFNt9oayRWpo35yGgcdyLYO
	 olwvfx+PTdChJVhbpAVaBdz7KbxusuzSnstIzVj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 087/201] spi: fsl-espi: fix controller deregistration
Date: Fri, 15 May 2026 17:48:25 +0200
Message-ID: <20260515154700.416052158@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit e506a700a7ad229f5c8f01f4b8350119cccb4158 upstream.

Make sure to deregister the controller before disabling runtime PM
(which can leave the controller disabled) to allow SPI device drivers to
do I/O during deregistration.

Fixes: e9abb4db8d10 ("spi: fsl-espi: add runtime PM")
Cc: stable@vger.kernel.org	# 4.3
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260409120419.388546-14-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-fsl-espi.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-fsl-espi.c
+++ b/drivers/spi/spi-fsl-espi.c
@@ -718,7 +718,7 @@ static int fsl_espi_probe(struct device
 	pm_runtime_enable(dev);
 	pm_runtime_get_sync(dev);
 
-	ret = devm_spi_register_controller(dev, host);
+	ret = spi_register_controller(host);
 	if (ret < 0)
 		goto err_pm;
 
@@ -782,7 +782,15 @@ static int of_fsl_espi_probe(struct plat
 
 static void of_fsl_espi_remove(struct platform_device *dev)
 {
+	struct spi_controller *host = platform_get_drvdata(dev);
+
+	spi_controller_get(host);
+
+	spi_unregister_controller(host);
+
 	pm_runtime_disable(&dev->dev);
+
+	spi_controller_put(host);
 }
 
 #ifdef CONFIG_PM_SLEEP


