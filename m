Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E702C57268F;
	Wed,  9 Sep 2026 14:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963859; cv=none; b=PZ7dcT4JBdFwrUlRFB64NqFjiwOuXnuhIFDlZLPxYRLrNOAmAFWbiGVo1DF9dhvlw/HJm/WsVb3sjwerhaQeNWYTKegoZ9KNs8a0pnGmri8972bJBVmvOBP5m+xXWoA3B0d8pk9sqxXa7tMB4X2m9hLRUGX0rYcwlBNUZxzpyek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963859; c=relaxed/simple;
	bh=gu7xhN69uINKd/LNCl+wGklZEK2Owaet473pzWwmwcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tARnV8w5mBGqdrd+HPMVlmE1ACzEfDEV9RqfupXNgAo7DYJboZi93s9+OMKVq9VpCNCyKjImTn0TDndzgU+GOq4VbZQ443/rh+KPLkNEq2LLqUyIyFSmCacHkhDemsvEFIufocaaQpk3hploteVI4Bt4kgAbM20VTvQd816nov4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UqJpPIib; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UqJpPIib"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A541F00A3A;
	Wed,  9 Sep 2026 14:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963857;
	bh=mbYeuG4P8+a8Do+pQ+Vp/SuenLbmWX4IUZ3q18YHJKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UqJpPIibjRWzXBLOLH9GLY0oMaYXNIwnQe+6S4INiVtON+zUoL5BSc/dkACvve63C
	 W8m3DxWPsWeWi+96pFH5YATkU0aRoFC+p6b1GrHUf1+RC6gftPk1XDVLMjdC1Zt9h8
	 wo01PG3N7U/5MHcxZCzNJkeQx5ZRqR/C5mvBbNOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 220/583] iio: srf04: fix pm_runtime handling on probe error path
Date: Wed,  9 Sep 2026 15:38:25 +0200
Message-ID: <20260909134245.775026192@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Cong Nguyen <congnt264@gmail.com>

commit a40b2e7a17f26e38ab054363c9c7cde149588357 upstream.

When pm_runtime_set_active() fails during probe, the driver logs the
error and unregisters the IIO device, but then falls through and still
calls pm_runtime_enable() before returning the error.

Since probe returns an error, srf04_remove() is never called, so
runtime PM is left enabled without a matching pm_runtime_disable().
This leaks the enable and triggers an "Unbalanced pm_runtime_enable!"
warning on a subsequent bind of the device.

Return the error right after unregistering the IIO device so that
runtime PM is not enabled on the failure path.

Fixes: 2251157b335b ("iio: srf04: add power management feature")
Cc: stable@vger.kernel.org
Signed-off-by: Cong Nguyen <congnt264@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/proximity/srf04.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/proximity/srf04.c
+++ b/drivers/iio/proximity/srf04.c
@@ -331,6 +331,7 @@ static int srf04_probe(struct platform_d
 		if (ret) {
 			dev_err(data->dev, "pm_runtime_set_active: %d\n", ret);
 			iio_device_unregister(indio_dev);
+			return ret;
 		}
 
 		pm_runtime_enable(data->dev);


