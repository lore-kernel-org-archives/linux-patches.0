Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C05F7C0BF;
	Mon,  8 Apr 2024 13:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583238; cv=none; b=CLZC2avnqWwfQB8EgtfG9kMGbNvr9G0Jc4G1lb9HGX1nXR0XKpfridY6htFVzmvkpUI/hxOcM/M9yM3ILiPw4Yi+PxGX38ahnM/fcFBkjUKFYpL8dToCo58Rwob0y5CbNUtLlUTvXABmLkfkfmXgSknYhm+kX2wZZOISi/oWWZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583238; c=relaxed/simple;
	bh=i0efmPvNIo4nAJDzUl9FkZ3W6LcZzmDkYxxkgeC+ALY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E1NNPE2tCNYSbKp8xrZheumnhe4IZZBx84x3A0XZMufl1FL6PmIzfEAzuVMyHO6IwV13nXxzaHVS6RoDL2VdkMnxrr5oOQQAmphHEgTZRgJlFMvKPLdIvxHGRfayoGzdyFXTwnCM0Ps3pnCn1v7DMMwbi6Wpa11zn257iIyRkC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UWYyqwr/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UWYyqwr/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B09BC433F1;
	Mon,  8 Apr 2024 13:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583238;
	bh=i0efmPvNIo4nAJDzUl9FkZ3W6LcZzmDkYxxkgeC+ALY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UWYyqwr/5Jf3fS1W0d8vT7JZhNY5jN/N4Goah5mVd4Hq6ToaMB+ySSkXBe0BGO3OV
	 7Sg+cRrq1C7MO+XWooOZnMyIekruNmR1BXjT1oWYaDmIIW20DN4g74xMRz8JevCvu6
	 Jgq1DxXcFLrOaeKMwo67O9ejDso6OQtkQBwqdcrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Hewitt <christianshewitt@gmail.com>,
	Steven Price <steven.price@arm.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 155/273] drm/panfrost: fix power transition timeout warnings
Date: Mon,  8 Apr 2024 14:57:10 +0200
Message-ID: <20240408125314.090765395@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Hewitt <christianshewitt@gmail.com>

[ Upstream commit 2bd02f5a0bac4bb13e0da18652dc75ba0e4958ec ]

Increase the timeout value to prevent system logs on Amlogic boards flooding
with power transition warnings:

[   13.047638] panfrost ffe40000.gpu: shader power transition timeout
[   13.048674] panfrost ffe40000.gpu: l2 power transition timeout
[   13.937324] panfrost ffe40000.gpu: shader power transition timeout
[   13.938351] panfrost ffe40000.gpu: l2 power transition timeout
...
[39829.506904] panfrost ffe40000.gpu: shader power transition timeout
[39829.507938] panfrost ffe40000.gpu: l2 power transition timeout
[39949.508369] panfrost ffe40000.gpu: shader power transition timeout
[39949.509405] panfrost ffe40000.gpu: l2 power transition timeout

The 2000 value has been found through trial and error testing with devices
using G52 and G31 GPUs.

Fixes: 22aa1a209018 ("drm/panfrost: Really power off GPU cores in panfrost_gpu_power_off()")
Signed-off-by: Christian Hewitt <christianshewitt@gmail.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240322164525.2617508-1-christianshewitt@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_gpu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_gpu.c b/drivers/gpu/drm/panfrost/panfrost_gpu.c
index 9063ce2546422..fd8e44992184f 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gpu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gpu.c
@@ -441,19 +441,19 @@ void panfrost_gpu_power_off(struct panfrost_device *pfdev)
 
 	gpu_write(pfdev, SHADER_PWROFF_LO, pfdev->features.shader_present);
 	ret = readl_relaxed_poll_timeout(pfdev->iomem + SHADER_PWRTRANS_LO,
-					 val, !val, 1, 1000);
+					 val, !val, 1, 2000);
 	if (ret)
 		dev_err(pfdev->dev, "shader power transition timeout");
 
 	gpu_write(pfdev, TILER_PWROFF_LO, pfdev->features.tiler_present);
 	ret = readl_relaxed_poll_timeout(pfdev->iomem + TILER_PWRTRANS_LO,
-					 val, !val, 1, 1000);
+					 val, !val, 1, 2000);
 	if (ret)
 		dev_err(pfdev->dev, "tiler power transition timeout");
 
 	gpu_write(pfdev, L2_PWROFF_LO, pfdev->features.l2_present);
 	ret = readl_poll_timeout(pfdev->iomem + L2_PWRTRANS_LO,
-				 val, !val, 0, 1000);
+				 val, !val, 0, 2000);
 	if (ret)
 		dev_err(pfdev->dev, "l2 power transition timeout");
 }
-- 
2.43.0



