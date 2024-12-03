Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF901F75B1;
	Tue,  3 Dec 2024 15:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238577; cv=none; b=opjdpIh8dANQJWc7GT8jSoPYYXpsiQAFYI60nM3aQmODQkqN3fORwg2r2Kp8eq6WdUG+dDOBBOGmscsqsAVmHhb2euo5PK+KG9teELfC+kqGTV3igQJodYmEaKRWjEV4B84Of5vkowwAPJ+9oOQXiwHqvJIYtNsmUVnr/VP5gLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238577; c=relaxed/simple;
	bh=DzJd1Wc6oJPQhltAQ8pIb64iuWbDdHPosU7Qj3cdZj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OnN8PBghEvencWeLA6WwwwP3bSMzSMsbiCf4fIXpwj2oc1f985ffArr2VBj7DP7g4grfpbzSeyQvhC/euOdCch3k+A9Wnsm8LYCpE/xByyZpiWXS6IG3jtWaGMbDc1JJPEBwEiMio83eDmX9bmBi2Gy4w4mcAeACoJfkpAos1E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tvCkLvCT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tvCkLvCT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 253E2C4CECF;
	Tue,  3 Dec 2024 15:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238577;
	bh=DzJd1Wc6oJPQhltAQ8pIb64iuWbDdHPosU7Qj3cdZj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tvCkLvCTZDogw71kfI+79HTQTDwskT4C9lfOlYtYxrsLuNO4Bh403RXaKf0e0xwui
	 Nx/fIikHmaGUanpVFaXPx8pRh4wR6lJzHovn9CmlttOqly4g3qLViCVg8ItAhFMUm0
	 7zDX5vZklujVlrDfm1q/1p1MR5umpTtwtEXJ1dzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 325/817] drm/panthor: Fix OPP refcnt leaks in devfreq initialisation
Date: Tue,  3 Dec 2024 15:38:17 +0100
Message-ID: <20241203144008.503562126@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrián Larumbe <adrian.larumbe@collabora.com>

[ Upstream commit 21c23e4b64e360d74d31b480f0572c2add0e8558 ]

Rearrange lookup of recommended OPP for the Mali GPU device and its refcnt
decremental to make sure no OPP object leaks happen in the error path.

Signed-off-by: Adrián Larumbe <adrian.larumbe@collabora.com>
Fixes: fac9b22df4b1 ("drm/panthor: Add the devfreq logical block")
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241105205458.1318989-2-adrian.larumbe@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_devfreq.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_devfreq.c b/drivers/gpu/drm/panthor/panthor_devfreq.c
index 9d0f891b9b534..ecc7a52bd688e 100644
--- a/drivers/gpu/drm/panthor/panthor_devfreq.c
+++ b/drivers/gpu/drm/panthor/panthor_devfreq.c
@@ -163,13 +163,6 @@ int panthor_devfreq_init(struct panthor_device *ptdev)
 
 	cur_freq = clk_get_rate(ptdev->clks.core);
 
-	opp = devfreq_recommended_opp(dev, &cur_freq, 0);
-	if (IS_ERR(opp))
-		return PTR_ERR(opp);
-
-	panthor_devfreq_profile.initial_freq = cur_freq;
-	ptdev->current_frequency = cur_freq;
-
 	/* Regulator coupling only takes care of synchronizing/balancing voltage
 	 * updates, but the coupled regulator needs to be enabled manually.
 	 *
@@ -200,18 +193,24 @@ int panthor_devfreq_init(struct panthor_device *ptdev)
 		return ret;
 	}
 
+	opp = devfreq_recommended_opp(dev, &cur_freq, 0);
+	if (IS_ERR(opp))
+		return PTR_ERR(opp);
+
+	panthor_devfreq_profile.initial_freq = cur_freq;
+	ptdev->current_frequency = cur_freq;
+
 	/*
 	 * Set the recommend OPP this will enable and configure the regulator
 	 * if any and will avoid a switch off by regulator_late_cleanup()
 	 */
 	ret = dev_pm_opp_set_opp(dev, opp);
+	dev_pm_opp_put(opp);
 	if (ret) {
 		DRM_DEV_ERROR(dev, "Couldn't set recommended OPP\n");
 		return ret;
 	}
 
-	dev_pm_opp_put(opp);
-
 	/* Find the fastest defined rate  */
 	opp = dev_pm_opp_find_freq_floor(dev, &freq);
 	if (IS_ERR(opp))
-- 
2.43.0



