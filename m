Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E1534A79D;
	Sat, 12 Sep 2026 07:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198882; cv=none; b=HEHnKIWJUU091qEo5cldo82dY2OcxMhrwFSUo9lzigfxmiilgO2l8MbsGnTzinUAJ44zDDPmGDOxHd/ZCr6R4ezFmEmICumWC0XtIYYlyVKbWqvwVhDfJKPg1TI4nlobW7YSPeGpuos16T8O31ZUEN9x3Qv80D8UKqG/YuMhD7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198882; c=relaxed/simple;
	bh=kkZa8Uz+nxdraQhr4SrV1btgIcfCTElfDRt2j+2ysXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WFvONXazKWptG1Xa43kEkFH4dfmYCEligCwast4RS98haG2i92h0qKVUdS+xs7ONY4enaauN2QxUEGiDIr0ADytekKdjm2eUxzR635h4+t/gpnjqBue1LwAscLf7RT67nzMKD6iqaRU+a+wTU7/fNVis7Q6uuPzQqptJWfwMhUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xYu75rJV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xYu75rJV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46DDE1F00893;
	Sat, 12 Sep 2026 07:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198879;
	bh=AqjuDO8dShIeIZdO83lmbZdL/7EEz2Diq4WdYimKXac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xYu75rJVcIk7n7NuYDqnHOX0LJLGKx8eYeoFn+andoMXM6zTxYWBx67gu9qz6sucs
	 Gbq1Gzxh4nLnh5U3H3S/AVEt5JrSfYfxDFfWXjYhYaiTCM3JjBAcSfxdzYE5iS8W63
	 Uqe2sWsQvoQf68W0QneYgyc0eIahSoURqlI45NTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0472/1815] drm/msm/adreno: fix use after free on error path in a6xx_gpu_init()
Date: Sat, 12 Sep 2026 08:37:02 +0200
Message-ID: <20260912065659.967683423@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit b8a9c9c5787bed1243e5364c89ca66c26b4e4d83 ]

The a6xx_destroy() function frees "a6xx_gpu" and so "adreno_gpu" points
to freed memory.  Preserve the error code before freeing the memory to
avoid a use after free.

Fixes: d158886cba08 ("drm/msm/adreno: Trust the SSoT UBWC config")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/732275/
Message-ID: <aiqNktNfXiaPhje3@stanley.mountain>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index 8b3bb2fd433ba..a44380316aaa9 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -2770,8 +2770,9 @@ static struct msm_gpu *a6xx_gpu_init(struct drm_device *dev)
 
 	adreno_gpu->ubwc_config = qcom_ubwc_config_get_data();
 	if (IS_ERR(adreno_gpu->ubwc_config)) {
+		ret = PTR_ERR(adreno_gpu->ubwc_config);
 		a6xx_destroy(&(a6xx_gpu->base.base));
-		return ERR_CAST(adreno_gpu->ubwc_config);
+		return ERR_PTR(ret);
 	}
 
 	/* Set up the preemption specific bits and pieces for each ringbuffer */
-- 
2.53.0



