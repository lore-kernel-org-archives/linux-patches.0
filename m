Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021B81292EC;
	Tue, 23 Jan 2024 00:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970995; cv=none; b=a97+kVr62jaGH8unsLaygRB6fEUsQANrxWsg/3oAnwUvWafE9r4NHo4B1Ju4UMRfxh9124KqHHsAKCWemmwdnSV8UaBuzai36y2GchZo/egFGWTN58WnQRiMCR5qMblypukEQ2+bnJLKt0hu8QjkgQ6X6XGq566ABrvU6ZFgyro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970995; c=relaxed/simple;
	bh=SW0rnjlcUyIFEVw1O+GJvUrDBODrFDgTMDYd8DrVCTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nx8J9D+Ksw6zWeuGuzw0v0AIcxD3XxF6HAFqjqckT3bHFxFuWsBQ6bz9rIVkbrVF1/jLw7Xkzs8gcu7yA1pRe//n27MvzbDc79oRLxtJ1mr00z99DWeezAJiBlR1iGysrTQEJoxaQxoD7b6sfLAcFBdRqEWoxYiS0aPfCMG115A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0qfk78f/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0qfk78f/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0471C43390;
	Tue, 23 Jan 2024 00:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970994;
	bh=SW0rnjlcUyIFEVw1O+GJvUrDBODrFDgTMDYd8DrVCTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0qfk78f/V3tYcycfTMe8mqjK0D+2ZWCevBUpyI0OK9y26tXteNnfLXus0BuxVA1hT
	 K5MOCO/5Al7OMOUIKnDjLGuwDqpmQ6ScmC0m32Go/6r45k84hWPrTNpwqzo7xWofYg
	 OhJuuCl5LkCG55L256/yotqiB1kvt56p4Sia7Fr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 158/417] drm/panfrost: Really power off GPU cores in panfrost_gpu_power_off()
Date: Mon, 22 Jan 2024 15:55:26 -0800
Message-ID: <20240122235757.320392474@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6452e4e900dd..c08715f033c5 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gpu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gpu.c
@@ -313,28 +313,38 @@ static void panfrost_gpu_init_features(struct panfrost_device *pfdev)
 		 pfdev->features.shader_present, pfdev->features.l2_present);
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
@@ -359,9 +369,27 @@ void panfrost_gpu_power_on(struct panfrost_device *pfdev)
 
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



