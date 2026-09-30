Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003623E1681;
	Wed, 30 Sep 2026 19:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796492; cv=none; b=KmdH1FzE1EIOkcTjDCqYVb8HHtGuoqkOCBjv8KT4yg/SUQfSfBNl3NOsuWflf0npoJGHYgO+1WtFj7b7L9YOMFwm1wrFWDMXSQtKM1Q+P7Hu9Pdpt8QAEB4zqY0tEuHAhdO8uC/ECTE4xRyB4165cP7YstkTGdDHyPC7AlHL8E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796492; c=relaxed/simple;
	bh=GN2r5g7z+qg+i1laBgut2RjURNNdbjQ7De5s3ODGO0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qTr2g04pe0fkL/n4t00KM0WYy9Q4NTl3LfXX9B6XN57NI83P7Uyughx6c+xPrtbB5KLRloU3UjeGmdDfse1jo4skMhz3+9BhKMy4A1ioLjzBLNyG1RQcsJqrBiVFovn+7H9nTM/zvxTTmyI6vBPdTp+wYeWyKVZNmNhDAnl9Sbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FM1glDuy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FM1glDuy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5531F000FF;
	Wed, 30 Sep 2026 19:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796490;
	bh=pE8DS+AES9AP5vT1ugtY2p0NaqVaVd6TvLYEwKTwQpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FM1glDuy/YcpkQvxKuLNvi1unWkRUVciPN8eDmnEutD+sfTp9qd8bC74I4KmFdJ/L
	 QVXe/fW6RPvNNs5h0vO8gFC02QYtyf91sCEm60x7GrbmVTOGdO1NaLJcrDKPT0dHee
	 CoQGGF5OerDnV1Ol9gXxsG701qYM8C5u0526IJ1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: [PATCH 6.6 0931/1193] drm/msm/adreno: fix autosuspend cleanup during teardown
Date: Wed, 30 Sep 2026 17:26:55 +0200
Message-ID: <20260930152454.925919191@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1125,6 +1125,8 @@ void adreno_gpu_cleanup(struct adreno_gp
 	for (i = 0; i < ARRAY_SIZE(adreno_gpu->info->fw); i++)
 		release_firmware(adreno_gpu->fw[i]);
 
+	pm_runtime_dont_use_autosuspend(&gpu->pdev->dev);
+
 	if (priv && pm_runtime_enabled(&priv->gpu_pdev->dev))
 		pm_runtime_disable(&priv->gpu_pdev->dev);
 


