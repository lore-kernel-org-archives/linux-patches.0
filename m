Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFA21CDA26;
	Tue, 27 Aug 2024 15:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772584; cv=none; b=go9YuxJmV8ZvoSo2KPyjpCwoXiSvmcZZD1o1UfUgeRJkWCkLjUbfyfzIha2Rxmj6tqLL4zEQbnQV55diRmjq7fCAG3ErqD0saVTyozyyOcH1Dx1R5wGI0j/nLNx18lulgy1b7EDoEck0snYVE2oKrv1lcdX+1YLJGee+CoQr4Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772584; c=relaxed/simple;
	bh=NmyjO1XW4FBWJwW1PBr3JPA89ihOVdjaEopQq9z9BDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yu4Y+dJ8zaNo4MZdSzdlyAVkmJF8xXXc+GVS9MbwYz3+FBBnlTkhnPM4Z/5YqZ9RoAnzPezdFFSyygkMy57OMpgmJxRc77lCqBLBLTpIFGy7OmnD8ojLIt61fCSwvQYQZQmABSXEpkyOi/uz65t5Hh+9F3hf9LlsqjgjLSeFNTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qMcma7IJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qMcma7IJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A862BC6107E;
	Tue, 27 Aug 2024 15:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772584;
	bh=NmyjO1XW4FBWJwW1PBr3JPA89ihOVdjaEopQq9z9BDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qMcma7IJiIWB2EdgFI+Zx+BAeXIFinOp/bSGbxTspFb17gYhvdyqg5JM//M6x3Onz
	 h53c+jlytA2mQ2DDt1zZtPcf7/USGBGq1D2lEIyDCfS67nJjzxK+TYLdGgo6iGujWe
	 Qbt0OqaZmFMfGFc/MrT6iDxAWrew3URNMfFr0rF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 258/321] drm/msm/dpu: dont play tricks with debug macros
Date: Tue, 27 Aug 2024 16:39:26 +0200
Message-ID: <20240827143848.065214062@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit df24373435f5899a2a98b7d377479c8d4376613b ]

DPU debugging macros need to be converted to a proper drm_debug_*
macros, however this is a going an intrusive patch, not suitable for a
fix. Wire DPU_DEBUG and DPU_DEBUG_DRIVER to always use DRM_DEBUG_DRIVER
to make sure that DPU debugging messages always end up in the drm debug
messages and are controlled via the usual drm.debug mask.

I don't think that it is a good idea for a generic DPU_DEBUG macro to be
tied to DRM_UT_KMS. It is used to report a debug message from driver, so by
default it should go to the DRM_UT_DRIVER channel. While refactoring
debug macros later on we might end up with particular messages going to
ATOMIC or KMS, but DRIVER should be the default.

Fixes: 25fdd5933e4c ("drm/msm: Add SDM845 DPU support")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/606932/
Link: https://lore.kernel.org/r/20240802-dpu-fix-wb-v2-2-7eac9eb8e895@linaro.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.h | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.h b/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.h
index bb35aa5f5709f..41e44a77c2beb 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.h
@@ -31,24 +31,14 @@
  * @fmt: Pointer to format string
  */
 #define DPU_DEBUG(fmt, ...)                                                \
-	do {                                                               \
-		if (drm_debug_enabled(DRM_UT_KMS))                         \
-			DRM_DEBUG(fmt, ##__VA_ARGS__); \
-		else                                                       \
-			pr_debug(fmt, ##__VA_ARGS__);                      \
-	} while (0)
+	DRM_DEBUG_DRIVER(fmt, ##__VA_ARGS__)
 
 /**
  * DPU_DEBUG_DRIVER - macro for hardware driver logging
  * @fmt: Pointer to format string
  */
 #define DPU_DEBUG_DRIVER(fmt, ...)                                         \
-	do {                                                               \
-		if (drm_debug_enabled(DRM_UT_DRIVER))                      \
-			DRM_ERROR(fmt, ##__VA_ARGS__); \
-		else                                                       \
-			pr_debug(fmt, ##__VA_ARGS__);                      \
-	} while (0)
+	DRM_DEBUG_DRIVER(fmt, ##__VA_ARGS__)
 
 #define DPU_ERROR(fmt, ...) pr_err("[dpu error]" fmt, ##__VA_ARGS__)
 #define DPU_ERROR_RATELIMITED(fmt, ...) pr_err_ratelimited("[dpu error]" fmt, ##__VA_ARGS__)
-- 
2.43.0



