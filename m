Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC80582B8F;
	Wed,  9 Sep 2026 14:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964061; cv=none; b=sQF1x/nKuwlkGvQO87lFUInpFAE/veeJ7+4005y30W3ls5a3ZM5co6DWRKnf9j3mI6CJdJBOKN6WJhl83hKZkf8dnVUl/PjEXzO2mZW9VxAGN4ELbQto9ZuG0wf6AfEENwBr8jJ2nIVTLEFKf8f2g8VH5oIQV/ICEXowM+bUYIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964061; c=relaxed/simple;
	bh=JckCGjqDQ42F+DNpPhxWP4sH/glyyRSyLN2L4C1Oyt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iWMRs2gnwytEfYncrJc1EklAqgoFdRZaG0Q0LwkK9yeNNcDc3loCiOl1OX6GrsQXESlemaMcKcK4/YADA71ecTWg2w5AeTZXfWlLSJgWlTjrmCS36olGyKORivMxSCwHGKxAiOIALq454QEn09W3e/zw80+kXKMDQxjTX8aJ490=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=km2u96Pb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="km2u96Pb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 171011F00A3E;
	Wed,  9 Sep 2026 14:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964059;
	bh=xBINoRonRv1w7uuWrC5robD6nnqZePHavm0J0WtWvQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=km2u96PbHkdlr0V1A0Mr0fkr0hQtNzDRjU+2j5zGxF++85strqqliVwedk0ZXcGcL
	 gQZo6mXDxyB9FgMPV/k7TOFEXqJ0KqpMxpd3tmTF+sFtsOuDRgV1UCKGJGYc1QF+/U
	 56Yigu44tUNzY2YD+bw9ntYROP3B4s4+P+CQt9MU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 6.18 293/583] media: imx355: Avoid calling imx355_power_off twice in error path
Date: Wed,  9 Sep 2026 15:39:38 +0200
Message-ID: <20260909134248.186999044@linuxfoundation.org>
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

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

commit ee737bc3ccae7dc713ccaa83ffa46080c6031b3e upstream.

If v4l2_async_register_subdev_sensor failed, then the sensor had
already been powered down by pm_runtime_idle, but the error path
then also explicitly called imx355_power_off as well. That left
an imbalance in the regulator and clock calls.

Call pm_runtime_idle only after v4l2_async_register_subdev_sensor
succeeds to avoid this.

Fixes: efa5fe19c0a9 ("media: imx355: Enable runtime PM before registering async sub-device")
Cc: stable@vger.kernel.org
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/imx355.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/i2c/imx355.c
+++ b/drivers/media/i2c/imx355.c
@@ -1736,12 +1736,13 @@ static int imx355_probe(struct i2c_clien
 	 */
 	pm_runtime_set_active(imx355->dev);
 	pm_runtime_enable(imx355->dev);
-	pm_runtime_idle(imx355->dev);
 
 	ret = v4l2_async_register_subdev_sensor(&imx355->sd);
 	if (ret < 0)
 		goto error_media_entity_runtime_pm;
 
+	pm_runtime_idle(imx355->dev);
+
 	return 0;
 
 error_media_entity_runtime_pm:


