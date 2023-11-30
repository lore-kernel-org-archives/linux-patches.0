Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973D6482CB;
	Thu, 30 Nov 2023 16:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="btpaznON"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27339C433C7;
	Thu, 30 Nov 2023 16:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361531;
	bh=XS6ovyUWjEExbjZhGhjuWtjZY+zumvmDcOKv5Q0Xo9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=btpaznONFaFAt73FprnhH5VUKYIa/HCcyfd8Ggr8A9i5lLLuavDOzWPlxtJcvjsya
	 rtuGY9JX7twB9XJOpuBt0Td65OsevHxEc33ofa+rNxUYhiRef4PUVpDLcHU1Q/O73/
	 S/Jo2k+Ks8XX2nI1HB6z7TfxuunCF4o7GpaKNnuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Anderson <dianders@chromium.org>,
	Rob Clark <robdclark@chromium.org>,
	Bjorn Andersson <quic_bjorande@quicinc.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Steev Klimaszewski <steev@kali.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>
Subject: [PATCH 6.6 060/112] drm/msm/dpu: Add missing safe_lut_tbl in sc8280xp catalog
Date: Thu, 30 Nov 2023 16:21:47 +0000
Message-ID: <20231130162142.228970318@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Andersson <quic_bjorande@quicinc.com>

commit a33b2431d11b4df137bbcfdd5a5adfa054c2479e upstream.

During USB transfers on the SC8280XP __arm_smmu_tlb_sync() is seen to
typically take 1-2ms to complete. As expected this results in poor
performance, something that has been mitigated by proposing running the
iommu in non-strict mode (boot with iommu.strict=0).

This turns out to be related to the SAFE logic, and programming the QOS
SAFE values in the DPU (per suggestion from Rob and Doug) reduces the
TLB sync time to below 10us, which means significant less time spent
with interrupts disabled and a significant boost in throughput.

Fixes: 4a352c2fc15a ("drm/msm/dpu: Introduce SC8280XP")
Cc: stable@vger.kernel.org
Suggested-by: Doug Anderson <dianders@chromium.org>
Suggested-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Bjorn Andersson <quic_bjorande@quicinc.com>
Tested-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Steev Klimaszewski <steev@kali.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/565094/
Link: https://lore.kernel.org/r/20231030-sc8280xp-dpu-safe-lut-v1-1-6d485d7b428f@quicinc.com
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_8_0_sc8280xp.h |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_8_0_sc8280xp.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_8_0_sc8280xp.h
@@ -419,6 +419,7 @@ static const struct dpu_perf_cfg sc8280x
 	.min_llcc_ib = 0,
 	.min_dram_ib = 800000,
 	.danger_lut_tbl = {0xf, 0xffff, 0x0},
+	.safe_lut_tbl = {0xfe00, 0xfe00, 0xffff},
 	.qos_lut_tbl = {
 		{.nentry = ARRAY_SIZE(sc8180x_qos_linear),
 		.entries = sc8180x_qos_linear


