Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C467A5678E5;
	Wed,  9 Sep 2026 14:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962670; cv=none; b=OGFBNUyvTrLNIfoKzelmfTKBw44/wQqtPgraAzv6lnyWpZ+dTW/Tcw2M1SWV8AiLmg621HNu93hGVzPEYVtobKFOGm+kxlZCs8TtA/Jmw1rzAG7KOM8peTK0huXiJCBdRy2UfUc20iaqPsD4Y9MuEesmjthrNH9TnCf2vJaVtSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962670; c=relaxed/simple;
	bh=TrwixPb0KEfmynjcR4EVg4njFJKXc8M31Rvv6yKF1N8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qRMILq1lS3CO+LvToYpx8hnyd+WRb2B+8lsYipjAv/pizmCI2B6AYafEv1c30U624YIpI+c9egt3asSoZZENaua8UvwC7kCVej/mzycDPPBDTqmQnO4n62lCMpDJWLZjNol41peT9Zr+61pQDL6vHW+smQ6dDnN52dazvLoyGgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k+DkTceR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k+DkTceR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D616D1F00A3A;
	Wed,  9 Sep 2026 14:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962668;
	bh=u02uTmtybjxiFAJZJ30S03QPjhDQwhC6Kx+JwnNum2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k+DkTceR6ELvTl62LskXgAS8x1epl3MD3Ag6JPCQ4qayFOx2kvuSliV44s/w7Eg96
	 L+QDlg+C5/tfoPpyKC/aoMcVkxpWDCyqyqBk5aiHsG3ZlVF8cYIEh1sMyjaTTCxQbZ
	 jkXai6GrMP97BHYmr0uCKVqddfo7sY5ketyhIw8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 7.2 370/556] media: imx355: Avoid calling imx355_power_off twice in error path
Date: Wed,  9 Sep 2026 15:40:50 +0200
Message-ID: <20260909134243.701726446@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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
@@ -1822,12 +1822,13 @@ static int imx355_probe(struct i2c_clien
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


