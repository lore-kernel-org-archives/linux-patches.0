Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E3741C69;
	Tue, 11 Nov 2025 01:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823854; cv=none; b=tj0SICarrpUYaqXt41FkEzJo6UEAkri1dHuWhZ5K8ngLn6RNH4vTiUZyYPDCGOdPShJ4rAgKIWkdwriVJ9pX7EHIdt9KMczG11Y/TSB8v2OB1y+Ckh9PVIy/zJtX89O8jPoyhY4fnFaSMvHUuY1LDw5iWzlbHEg1djj05KHL9Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823854; c=relaxed/simple;
	bh=f04XJFjspASzS2qrNzjo2WOziXpkwI1Yj61yMHG0+GM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pbnBFJ3SXXBqO/AAbBB91uXj1enjuFM92rPUmlobG/4vW1987+RvxrPYTURA9Z2GdFGlBeRpLn6VdMrFB/sM9GOaiXkhGoNh2DR0hhiyZBvj+GVtU9fa4sYm0Zj3UhtJXoBKntO1IvaF/FIAtVYsoRjTXhpVrknn4bHW+c0V8EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=viZ0BBwp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="viZ0BBwp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97D1C116B1;
	Tue, 11 Nov 2025 01:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823854;
	bh=f04XJFjspASzS2qrNzjo2WOziXpkwI1Yj61yMHG0+GM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=viZ0BBwpH+KIZ0thqeeyQPwVRpSaBMmyFXTGJqvUoP08mLcz1MOf1XfGFv2ljXCDi
	 Fh9Mt2JTiqlGylQkosJ97l1ZyxMsTPaoURl0znmkkxzbc7YkqEjIdrFEpP4lzxTrzZ
	 mlEiB/p0AxKjcuKEyf2l07TonVBywCoipVd3A90Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 385/849] drm/msm: Use of_reserved_mem_region_to_resource() for "memory-region"
Date: Tue, 11 Nov 2025 09:39:15 +0900
Message-ID: <20251111004545.738865577@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring (Arm) <robh@kernel.org>

[ Upstream commit fb53e8f09fc1e1a343fd08ea4f353f81613975d7 ]

Use the newly added of_reserved_mem_region_to_resource() function to
handle "memory-region" properties.

The original code did not set 'zap_available' to false if
of_address_to_resource() failed which seems like an oversight.

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/662275/
Link: https://lore.kernel.org/r/20250703183442.2073717-1-robh@kernel.org
[DB: dropped part related to VRAM, no longer applicable]
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/adreno_gpu.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/adreno_gpu.c b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
index f1230465bf0d0..8c6336b007dc0 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
@@ -10,7 +10,7 @@
 #include <linux/interconnect.h>
 #include <linux/firmware/qcom/qcom_scm.h>
 #include <linux/kernel.h>
-#include <linux/of_address.h>
+#include <linux/of_reserved_mem.h>
 #include <linux/pm_opp.h>
 #include <linux/slab.h>
 #include <linux/soc/qcom/mdt_loader.h>
@@ -33,7 +33,7 @@ static int zap_shader_load_mdt(struct msm_gpu *gpu, const char *fwname,
 	struct device *dev = &gpu->pdev->dev;
 	const struct firmware *fw;
 	const char *signed_fwname = NULL;
-	struct device_node *np, *mem_np;
+	struct device_node *np;
 	struct resource r;
 	phys_addr_t mem_phys;
 	ssize_t mem_size;
@@ -51,18 +51,11 @@ static int zap_shader_load_mdt(struct msm_gpu *gpu, const char *fwname,
 		return -ENODEV;
 	}
 
-	mem_np = of_parse_phandle(np, "memory-region", 0);
-	of_node_put(np);
-	if (!mem_np) {
+	ret = of_reserved_mem_region_to_resource(np, 0, &r);
+	if (ret) {
 		zap_available = false;
-		return -EINVAL;
-	}
-
-	ret = of_address_to_resource(mem_np, 0, &r);
-	of_node_put(mem_np);
-	if (ret)
 		return ret;
-
+	}
 	mem_phys = r.start;
 
 	/*
-- 
2.51.0



