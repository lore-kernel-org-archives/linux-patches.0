Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE889101C0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:54:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF2CC433EF;
	Mon, 15 May 2023 17:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173293;
	bh=BG3VbXaaP09v2r5gAoMl/EaB3F5K05BetpdD9xNbNyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dj19aXXzM9S98uf4cYmQbB5AaX94HG9iVnsuJHnAU/QDlU+7S/t2+cVd7OOZMlkdk
	 l/WR9crYRc+2yO94WDvi6Ys1uKkKOrBkHdd+u/mIhMTgEsmZKOQSScYwf4odAR8GJt
	 ImaRcxrnQcQWH6Vq/nLYyY8MNcRUgPtJGZ7JjXQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Marek <jonathan@marek.ca>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 048/282] drm/msm: fix unbalanced pm_runtime_enable in adreno_gpu_{init, cleanup}
Date: Mon, 15 May 2023 18:27:06 +0200
Message-Id: <20230515161723.699648622@linuxfoundation.org>
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

From: Jonathan Marek <jonathan@marek.ca>

[ Upstream commit 17e822f7591fb66162aca07685dc0b01468e5480 ]

adreno_gpu_init calls pm_runtime_enable, so adreno_gpu_cleanup needs to
call pm_runtime_disable.

Signed-off-by: Jonathan Marek <jonathan@marek.ca>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Stable-dep-of: db7662d076c9 ("drm/msm/adreno: drop bogus pm_runtime_set_active()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/adreno_gpu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/msm/adreno/adreno_gpu.c b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
index 3802ad38c519c..0d9404d2afe4e 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
@@ -908,11 +908,14 @@ int adreno_gpu_init(struct drm_device *drm, struct platform_device *pdev,
 void adreno_gpu_cleanup(struct adreno_gpu *adreno_gpu)
 {
 	struct msm_gpu *gpu = &adreno_gpu->base;
+	struct msm_drm_private *priv = gpu->dev->dev_private;
 	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(adreno_gpu->info->fw); i++)
 		release_firmware(adreno_gpu->fw[i]);
 
+	pm_runtime_disable(&priv->gpu_pdev->dev);
+
 	icc_put(gpu->icc_path);
 
 	msm_gpu_cleanup(&adreno_gpu->base);
-- 
2.39.2



