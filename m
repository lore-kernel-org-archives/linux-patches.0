Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A95131748;
	Tue, 23 Jan 2024 00:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969439; cv=none; b=DtdIte/eSzB3Rz4ku4imZ+gb9wka6OfCNv4XLuAHwhbrO1c8EgAxErKqtSi1DpLY0M9oj34PMK2XufJk4uxR1HEUSLls2WWcFlv+W5bGE44sl9kxlLqJqKZkG25zH2yjPjuYst6ry3tC4dXKx8qIU2P5/DVkyBvD5I+/HxitHic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969439; c=relaxed/simple;
	bh=9MXyfSARIrWx8404jhzPyGOro3j++YpyN3SLg0h0y0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f7a4n0QgFDgZ60PBRrHLt31MII+mlsmkS0RAENEVkV8HJPw5OwWSUEIMeqHN+elnpwL7gR3Y2zVopCU6OQi203v+qhJQ8QnbJWaMlZ+H9rCWvzcdyU/YwmILmZq4cEMv6wweikF44+vsJokmnoYPxgsOanPkms7jq2Zb1y+Ut7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BBfw4rqM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BBfw4rqM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E2A4C433F1;
	Tue, 23 Jan 2024 00:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969438;
	bh=9MXyfSARIrWx8404jhzPyGOro3j++YpyN3SLg0h0y0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BBfw4rqMRWT6x/wJt1cy2RZClhrXl7cuPKaL6lyjXNBymgQMEgHZKHqf2miqWM7eM
	 wkTSf7Efh5iiWfQcHo03yymHEv4566Py2bs7GDXtV/toDpJdyJG8VBMGTZ1E8M0RJ6
	 H8ggPq3UgGJLdQ1YN5NwAxI/rVfoHnR4S5UWWwOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 246/641] drm/panfrost: Really power off GPU cores in panfrost_gpu_power_off()
Date: Mon, 22 Jan 2024 15:52:30 -0800
Message-ID: <20240122235825.620198035@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 22aa1a209018dc2eca78745f7666db63637cd5dc ]

The layout of the registers {TILER,SHADER,L2}_PWROFF_LO, used to request
powering off cores, is the same as the {TILER,SHADER,L2}_PWRON_LO ones:
this means that in order to request poweroff of cores, we are supposed
to write a bitmask of cores that should be powered off!
This means that the panfrost_gpu_power_off() function has always been
doing nothing.

Fix powering off the GPU by writing a bitmask of the cores to poweroff
to the relevant PWROFF_LO registers and then check that the transition
(from ON to OFF) has finished by polling the relevant PWRTRANS_LO
registers.

While at it, in order to avoid code duplication, move the core mask
logic from panfrost_gpu_power_on() to a new panfrost_get_core_mask()
function, used in both poweron and poweroff.

Fixes: f3ba91228e8e ("drm/panfrost: Add initial panfrost driver")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231102141507.73481-1-angelogioacchino.delregno@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_gpu.c | 64 ++++++++++++++++++-------
 1 file changed, 46 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_gpu.c b/drivers/gpu/drm/panfrost/panfrost_gpu.c
index f0be7e19b13e..97f097ee5c1d 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gpu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gpu.c
@@ -362,28 +362,38 @@ unsigned long long panfrost_cycle_counter_read(struct panfrost_device *pfdev)
 	return ((u64)hi << 32) | lo;
 }
 
+static u64 panfrost_get_core_mask(struct panfrost_device *pfdev)
+{
+	u64 core_mask;
+
+	if (pfdev->features.l2_present == 1)
+		return U64_MAX;
+
+	/*
+	 * Only support one core group now.
+	 * ~(l2_present - 1) unsets all bits in l2_present except
+	 * the bottom bit. (l2_present - 2) has all the bits in
+	 * the first core group set. AND them together to generate
+	 * a mask of cores in the first core group.
+	 */
+	core_mask = ~(pfdev->features.l2_present - 1) &
+		     (pfdev->features.l2_present - 2);
+	dev_info_once(pfdev->dev, "using only 1st core group (%lu cores from %lu)\n",
+		      hweight64(core_mask),
+		      hweight64(pfdev->features.shader_present));
+
+	return core_mask;
+}
+
 void panfrost_gpu_power_on(struct panfrost_device *pfdev)
 {
 	int ret;
 	u32 val;
-	u64 core_mask = U64_MAX;
+	u64 core_mask;
 
 	panfrost_gpu_init_quirks(pfdev);
+	core_mask = panfrost_get_core_mask(pfdev);
 
-	if (pfdev->features.l2_present != 1) {
-		/*
-		 * Only support one core group now.
-		 * ~(l2_present - 1) unsets all bits in l2_present except
-		 * the bottom bit. (l2_present - 2) has all the bits in
-		 * the first core group set. AND them together to generate
-		 * a mask of cores in the first core group.
-		 */
-		core_mask = ~(pfdev->features.l2_present - 1) &
-			     (pfdev->features.l2_present - 2);
-		dev_info_once(pfdev->dev, "using only 1st core group (%lu cores from %lu)\n",
-			      hweight64(core_mask),
-			      hweight64(pfdev->features.shader_present));
-	}
 	gpu_write(pfdev, L2_PWRON_LO, pfdev->features.l2_present & core_mask);
 	ret = readl_relaxed_poll_timeout(pfdev->iomem + L2_READY_LO,
 		val, val == (pfdev->features.l2_present & core_mask),
@@ -408,9 +418,27 @@ void panfrost_gpu_power_on(struct panfrost_device *pfdev)
 
 void panfrost_gpu_power_off(struct panfrost_device *pfdev)
 {
-	gpu_write(pfdev, TILER_PWROFF_LO, 0);
-	gpu_write(pfdev, SHADER_PWROFF_LO, 0);
-	gpu_write(pfdev, L2_PWROFF_LO, 0);
+	u64 core_mask = panfrost_get_core_mask(pfdev);
+	int ret;
+	u32 val;
+
+	gpu_write(pfdev, SHADER_PWROFF_LO, pfdev->features.shader_present & core_mask);
+	ret = readl_relaxed_poll_timeout(pfdev->iomem + SHADER_PWRTRANS_LO,
+					 val, !val, 1, 1000);
+	if (ret)
+		dev_err(pfdev->dev, "shader power transition timeout");
+
+	gpu_write(pfdev, TILER_PWROFF_LO, pfdev->features.tiler_present);
+	ret = readl_relaxed_poll_timeout(pfdev->iomem + TILER_PWRTRANS_LO,
+					 val, !val, 1, 1000);
+	if (ret)
+		dev_err(pfdev->dev, "tiler power transition timeout");
+
+	gpu_write(pfdev, L2_PWROFF_LO, pfdev->features.l2_present & core_mask);
+	ret = readl_poll_timeout(pfdev->iomem + L2_PWRTRANS_LO,
+				 val, !val, 0, 1000);
+	if (ret)
+		dev_err(pfdev->dev, "l2 power transition timeout");
 }
 
 int panfrost_gpu_init(struct panfrost_device *pfdev)
-- 
2.43.0



