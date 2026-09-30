Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7583150C2B7;
	Wed, 30 Sep 2026 15:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783655; cv=none; b=jgSCI2o/paTOr4J+3/MLzLff0d7IQl+PjpzZQDF2QtmfU3dpV0i42EdADkQXaF3biQHIlAhW66xllHEuN4iYlXQySpzETwRdv9/OYXfjd60BaGi/Rtgi4Bz9XnR5pAkc8WjdnTuIAN/9KYoqqkLZSvxlJ8BApeQaRpKouUsb4ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783655; c=relaxed/simple;
	bh=0cgBNmlh0KwZfVX7BDi0zk8GCRpudsbCdVgTXcNVP40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bjxCYo0ie1M4fjqJG/emU8Oq6TTLGcssFpk7b0RP0AZ9Izo3vmyc9QBpCwnzcnhK602cR8sudT1Zt6r7cbFY/A51HXvdI7fbVJpg2Xx/F1wesZHC3oJwWE1cYuiv8QgFvvEBQolDgNwjSWDmdwmCQpR/COtxFMLF7tQ349bjzh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y2oXimwM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y2oXimwM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 621AB1F000FF;
	Wed, 30 Sep 2026 15:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783650;
	bh=GrDue96dZpRD/Eg0IaDZXrzzsJnefdo+BXIzDMomiqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y2oXimwModwUseBQeAVjDHqZIecz+nfcz8D7YW39CAuGitMnZOTEPJOrnmGG2EQ8e
	 2m7Ms0w/BNzUoxFfnX5vBB1poJS6h5O3lLX2R/e4yp12X9lvwpPvYf8Xa6NcuA/ArF
	 1KIfbc3Hn/NDrNLg5QXk0HQ0gpN8M9nDG3iwHUEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: [PATCH 5.10 474/595] drm/msm/adreno: fix autosuspend cleanup during teardown
Date: Wed, 30 Sep 2026 17:26:07 +0200
Message-ID: <20260930152357.877526082@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -959,6 +959,8 @@ void adreno_gpu_cleanup(struct adreno_gp
 	for (i = 0; i < ARRAY_SIZE(adreno_gpu->info->fw); i++)
 		release_firmware(adreno_gpu->fw[i]);
 
+	pm_runtime_dont_use_autosuspend(&gpu->pdev->dev);
+
 	if (priv && pm_runtime_enabled(&priv->gpu_pdev->dev))
 		pm_runtime_disable(&priv->gpu_pdev->dev);
 


