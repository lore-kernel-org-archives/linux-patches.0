Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19163517BAF;
	Wed, 30 Sep 2026 17:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789981; cv=none; b=BIA4tBeaDKopu80fdJRzs/EwJqXvJg3SIRnJiQtUjtArKkKPhUtHOVwrOnGdKRU+Y8NhO0uQE7UNH63/4ZW61cOWK1VQ18WhDo1vXYEZxx0uMeeHiBWLSGmAX0OeXtu9XUbcHtrZXGpGu3wnDvW91SnUXBtA5iH8yo96obAbrLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789981; c=relaxed/simple;
	bh=NWuVhOs5QKH/AxuzpY+PPY9TmykV6ZYbjl3Ohcnb1Xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1UDGlj6SffDJAnUoqTU8xp+rfwrZcRxqtbst5rKBMG3XECe+hukurzMhJuwP67nrO4sTlg2NWXPlq7uZ5ztfUBEPIDpCIsbgvOjTdREB6C2MdLoK4lwhpFuYFHZEFMP0Q/SzUU1DPIVqIiK+CzBsLDvad2eLyKKsFWDuxjYGeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WjcPSiFX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WjcPSiFX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00E351F000FF;
	Wed, 30 Sep 2026 17:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789979;
	bh=hhyyIOVovGsj470Lu3f0C3aX7zZXWIu/dplgFyBeVIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WjcPSiFXwuo4Y+MvY+fdwvDS1zw+0/GJRc4x68bhp0iwOi2HtLuCCVx+98CPrwpuJ
	 XMX7KRpziuU7HksWyQcyTTi1nAhA873FnTXch5b6KgukYz9oMB9NoOCs0tOxe8ZGHl
	 /q6S5+QHPrcyqmvkAHKBfPPoJBrf/os7W9Yhl0lA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 667/877] media: imx355: Avoid calling imx355_power_off twice in error path
Date: Wed, 30 Sep 2026 17:26:18 +0200
Message-ID: <20260930152429.059256831@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit ee737bc3ccae7dc713ccaa83ffa46080c6031b3e ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/imx355.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/i2c/imx355.c
+++ b/drivers/media/i2c/imx355.c
@@ -1737,12 +1737,13 @@ static int imx355_probe(struct i2c_clien
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


