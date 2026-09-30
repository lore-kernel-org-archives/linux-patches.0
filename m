Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F1B4DEC26;
	Wed, 30 Sep 2026 18:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792238; cv=none; b=tYqgSJL24b3F5W9baveqYVw1bVBq4NuhULv/JlAgakxl3VuWzaBzKU5FzdHPeigZrMEkR4OX9ckIOLLEHtuOEU0Z5QTt7yHQwwqwzeil7Ms7I9HBk6Ezttb+U25fAIXFgHz0gk3r8MXcQWEjn6kwSqWAYXRU2z6W1X+rXjXB/O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792238; c=relaxed/simple;
	bh=Y4BIBYWX+GAkUqTmTUz9rAS6ivvS9aNFpR//JoiN2ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NaZUtDl1qwVbxAlGnoYqmNjNekKyIGZ4fuwXC1KE4AZFxOv6slqNEekf5/llYKoKOKzzXcKwwSoeDr6+jeQYSNxmLaTYXwyPTMNnqKDtTdqGORNI19GQBa3Yzknuw8SD7+3dam9ZGme88wh/tFrFqAfTs4g/gy8w1PQ1SmfH66A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X6T8/Zhp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X6T8/Zhp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A08D91F0089A;
	Wed, 30 Sep 2026 18:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792237;
	bh=YxR1rON1kc7amMgBi5IYcZO/LLFYg1HDAlc9qlUSYHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X6T8/Zhpr73TAIPxn6v3ml6t+GAJgjMEQAw9eBe1Q4qLEDqatZLJBSH6HYWE1ojgg
	 +/Jr3TGAAWSX8kKFXELifQzE2gPxSUdbnKlyIyAU/qyesin3xuVUzpZR4paUHKpxtV
	 U9NGMlHgIol/S8BMKeYzyN5EtyopEb29P3jjtgr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: [PATCH 5.15 584/752] drm/msm/adreno: fix autosuspend cleanup during teardown
Date: Wed, 30 Sep 2026 17:27:34 +0200
Message-ID: <20260930152410.929547718@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 6fbbf1e152f34ad3913e4a6476680aba672c5068 upstream.

adreno_gpu_init() calls pm_runtime_use_autosuspend(), but
adreno_gpu_cleanup() does not call the matching
pm_runtime_dont_use_autosuspend() during teardown.

If the autosuspend delay is set to a negative value while autosuspend
is enabled, the runtime PM core increments usage_count to prevent
runtime suspend. Without calling pm_runtime_dont_use_autosuspend()
during teardown, this reference is not dropped and usage_count remains
unbalanced.

The documentation for pm_runtime_use_autosuspend() also notes that it
is important to undo it with pm_runtime_dont_use_autosuspend() at
driver exit time, unless runtime PM was initially enabled with
devm_pm_runtime_enable().

Add the missing pm_runtime_dont_use_autosuspend() call to
adreno_gpu_cleanup().

This issue was found by manual code inspection.

Fixes: eeb754746b14 ("drm/msm/gpu: use pm-runtime")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/745110/
Link: https://lore.kernel.org/r/20260808131624.2854412-1-lgs201920130244@gmail.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/adreno/adreno_gpu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
@@ -957,6 +957,8 @@ void adreno_gpu_cleanup(struct adreno_gp
 	for (i = 0; i < ARRAY_SIZE(adreno_gpu->info->fw); i++)
 		release_firmware(adreno_gpu->fw[i]);
 
+	pm_runtime_dont_use_autosuspend(&gpu->pdev->dev);
+
 	if (priv && pm_runtime_enabled(&priv->gpu_pdev->dev))
 		pm_runtime_disable(&priv->gpu_pdev->dev);
 


