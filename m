Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E49101C0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:54:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C49DC433EF;
	Mon, 15 May 2023 17:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173296;
	bh=oxbkovJ8M6W6IRNG7/pcCKJfZDqZDmvLaKOoWW1VSoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iSBd6VaEUhsIUNdCcFElGTwwGVLeZCXvyPs4/CpN94fuf2K2m+/+vpNv5BW1Mu6gW
	 t4UpfXK1V3w14NE9Xd8Tk1mZS0i077IikLdXG9xwz5RZXq3ofmvPlclbc0iYaDppc9
	 9S6L0W5ZuRvzQW+0EOri878DXUexU55I51bfsLms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 049/282] drm/msm/adreno: Defer enabling runpm until hw_init()
Date: Mon, 15 May 2023 18:27:07 +0200
Message-Id: <20230515161723.728461669@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 4b18299b33655fa9672b774b6df774dc03d6aee8 ]

To avoid preventing the display from coming up before the rootfs is
mounted, without resorting to packing fw in the initrd, the GPU has
this limbo state where the device is probed, but we aren't ready to
start sending commands to it.  This is particularly problematic for
a6xx, since the GMU (which requires fw to be loaded) is the one that
is controlling the power/clk/icc votes.

So defer enabling runpm until we are ready to call gpu->hw_init(),
as that is a point where we know we have all the needed fw and are
ready to start sending commands to the coproc's.

Signed-off-by: Rob Clark <robdclark@chromium.org>
Patchwork: https://patchwork.freedesktop.org/patch/489337/
Link: https://lore.kernel.org/r/20220613182036.2567963-1-robdclark@gmail.com
Stable-dep-of: db7662d076c9 ("drm/msm/adreno: drop bogus pm_runtime_set_active()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/adreno_device.c | 6 ++++++
 drivers/gpu/drm/msm/adreno/adreno_gpu.c    | 1 -
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/adreno_device.c b/drivers/gpu/drm/msm/adreno/adreno_device.c
index 0888e0df660dd..6ad9d2de07ed6 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_device.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_device.c
@@ -233,6 +233,12 @@ struct msm_gpu *adreno_load_gpu(struct drm_device *dev)
 	if (ret)
 		return NULL;
 
+	/*
+	 * Now that we have firmware loaded, and are ready to begin
+	 * booting the gpu, go ahead and enable runpm:
+	 */
+	pm_runtime_enable(&pdev->dev);
+
 	/* Make sure pm runtime is active and reset any previous errors */
 	pm_runtime_set_active(&pdev->dev);
 
diff --git a/drivers/gpu/drm/msm/adreno/adreno_gpu.c b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
index 0d9404d2afe4e..b472cbe6adff6 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
@@ -899,7 +899,6 @@ int adreno_gpu_init(struct drm_device *drm, struct platform_device *pdev,
 	pm_runtime_set_autosuspend_delay(&pdev->dev,
 		adreno_gpu->info->inactive_period);
 	pm_runtime_use_autosuspend(&pdev->dev);
-	pm_runtime_enable(&pdev->dev);
 
 	return msm_gpu_init(drm, pdev, &adreno_gpu->base, &funcs->base,
 			adreno_gpu->info->name, &adreno_gpu_config);
-- 
2.39.2



