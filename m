Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F761E493C;
	Thu, 30 Jan 2025 14:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246700; cv=none; b=niHwdIN0toa7BcBKmh5tL6G28gq06JiUHdCVz5YSkhPyExcH1uOCz7m3oFfF+GgRKYc0j/8CNRgvI18vNQc1e1ncZJww7bV/AoH53/J6itIhpe3uNoQfIKTJHHERrxT6XwWowDRFoF31wo7XXGDKzNgsE1UH8foBH8x4vfFb1CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246700; c=relaxed/simple;
	bh=Qe/GBKpBpv3XL0RAYmbptcSPLeu/bqjTIrrKtgzA2ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ekVxijylNgiwrVo1jWcQIeb0CAVp1s/E68O40yjWBUjgsxkkra+VntO89VokCDoEImO/auffjllxeZpdX1rrzQ3F4I/a6tTe8cG+7w0pGEqIiC1Gm0Ol/9h66YhHQ+UqA/TIqtznFC9PCwUBZg53iem4q7j2OxZ+iGzIwsSJZH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EsUAntGc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EsUAntGc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99788C4CEE2;
	Thu, 30 Jan 2025 14:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246700;
	bh=Qe/GBKpBpv3XL0RAYmbptcSPLeu/bqjTIrrKtgzA2ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EsUAntGcHTi+cS6s8t8WFH6Mkc5NMcE9hu3DIk4+WqC/xwryG7GNShq9ufnGY4d59
	 ALurVvIN6Oh7CESTknvmJLm4AVfo7J4fsGJgwLUohLuM9NxHOYezi97ohrfJ6kNlhI
	 o5BrwuVNib2xwhhw1q/ipZm82nAVaL7BF9zL5ObY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 37/91] iio: inkern: call iio_device_put() only on mapped devices
Date: Thu, 30 Jan 2025 15:00:56 +0100
Message-ID: <20250130140135.154603384@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

commit 64f43895b4457532a3cc524ab250b7a30739a1b1 upstream.

In the error path of iio_channel_get_all(), iio_device_put() is called
on all IIO devices, which can cause a refcount imbalance. Fix this error
by calling iio_device_put() only on IIO devices whose refcounts were
previously incremented by iio_device_get().

Fixes: 314be14bb893 ("iio: Rename _st_ functions to loose the bit that meant the staging version.")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Link: https://patch.msgid.link/20241204111342.1246706-1-joe@pf.is.s.u-tokyo.ac.jp
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/inkern.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -466,7 +466,7 @@ struct iio_channel *iio_channel_get_all(
 	return chans;
 
 error_free_chans:
-	for (i = 0; i < nummaps; i++)
+	for (i = 0; i < mapind; i++)
 		iio_device_put(chans[i].indio_dev);
 	kfree(chans);
 error_ret:


