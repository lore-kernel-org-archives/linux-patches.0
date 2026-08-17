Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B4F446BEA;
	Mon, 17 Aug 2026 15:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979388; cv=none; b=BmOt4q/OgXRrRXF1gC+rdc6UxLqb6NDCh36SWpGyeZwJk/fE/YPBcjJ14LIaWrCVps70ZiW6Q3kTacgG2dTU3psbgVbcMQVZlXirQybRLFy/CPEUIG/eDEczO5Wk8k/QzjF+a/EiME8syJOgdehvagQRx5xltA/BeKobHHEcirs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979388; c=relaxed/simple;
	bh=a/v5yn7/ubaSMz4X7qFo0Y7J9AEBpD+tufY2YDFcGVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UKiYtRdg02uBaKODRJBuXbCpQ7xcuIJ4696a6+8q/EwigaS8UbLJXUkYTOO8jio78MIJmRZSH+Iz7nNQ1s1HD3STMe3+a0JQMKHoG9mUSV06gVDycUzfCGIDamjJmCBDJoqm1vCbBJZY/O7gUuTlfi1vnBDTi6jCAAWkuyCt6Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gbj+QS2S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gbj+QS2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29CEC1F000E9;
	Mon, 17 Aug 2026 15:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979386;
	bh=9e/a4FpofakWLzOAZy5B5VDRD848Av9xgdc0jY8Uy4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gbj+QS2SMFEiyBi2BKnadxRqXtCV+jqPdND73uZ8lS4o2qROCrlDcu7ZYZEEjrYcn
	 GOrLNQuq57QkqbvLnWO4BusfK0lwY1eUk5Rzb+6KJNB9Ll48Wffx85LFEygHFCXthJ
	 vMUJgAVDH3rVVoy//OsC2OIHfhWYWexRZlxiL4N0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Yemike Abhilash Chandra <y-abhilashchandra@ti.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 209/609] media: ti: vpe: unwind v4l2 device registration on probe error
Date: Mon, 17 Aug 2026 15:28:25 +0200
Message-ID: <20260817132551.086926032@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

commit e0f1c9a90ef665f2587c274a8fed59f2dfc575a6 upstream.

If the vpe_top resource is missing, vpe_probe() returns -ENODEV after
v4l2_device_register() has succeeded. Probe failures do not call the
driver's remove callback, so the v4l2 device remains registered on that
error path.

Route that failure through the existing v4l2_device_unregister() unwind
label, matching the other errors after v4l2_device_register().

Fixes: 4d59c7d45585 ("media: ti-vpe: vpe: Add missing null pointer checks")
Cc: stable@vger.kernel.org
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: Yemike Abhilash Chandra <y-abhilashchandra@ti.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/ti/vpe/vpe.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/platform/ti/vpe/vpe.c
+++ b/drivers/media/platform/ti/vpe/vpe.c
@@ -2545,7 +2545,8 @@ static int vpe_probe(struct platform_dev
 						"vpe_top");
 	if (!dev->res) {
 		dev_err(&pdev->dev, "missing 'vpe_top' resources data\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto v4l2_dev_unreg;
 	}
 
 	/*


