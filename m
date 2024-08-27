Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64071C68A6;
	Tue, 27 Aug 2024 14:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770600; cv=none; b=E4qlBm/xDL+cpvtjrfT/TqXE4fZpheNDRL9nVZZkfwcggh4/kb0Z/Wek5rlAlJg0606O5QF8bSEi4z1YDcqpZFDoIcP9IHxwM9Gp0vI3QvGYDeOuJmyA9K4QUpmU6x9gMWxIk6Rv6SCJB6nqfyLY02UA4pRgO60ZBW7vS9N5mZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770600; c=relaxed/simple;
	bh=gUd9ayelm0oUEE//Sm6H1uWT66+kwp2JbBAGcYIuVgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KOG3hK3upjV634iKi7FvTzPYAQMjKN6hy9MWtHSTW3ioevcY9a9n1uLDGTpXFRoUFEtbDqxLur+cTsemiugjbNaiXEkPNqG8/p16YHGvBjoOYwMnLy3FK66bnnt7SUlEpFVhi0h5thsgS0/NTKBnWxKUwWG4ykJbjKLt7tuaR5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MtMn9Z1/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MtMn9Z1/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF4BC4FE02;
	Tue, 27 Aug 2024 14:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770600;
	bh=gUd9ayelm0oUEE//Sm6H1uWT66+kwp2JbBAGcYIuVgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MtMn9Z1/ayQZB01MBkWjr05CdmtjVAKksKfMtS4v1uD+fcR/GtwhrNIqtBkHnb3qk
	 lzc+0FJj9ktp+w0awR5hnoeDh8A+2Bl0f1T2tGG8h/FWSnxQiw/EjOumqhgXxZN5qP
	 6R5D7vcfVrX5XQsIfbFVkQ6qttX2H1GpcituWG+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 277/341] drm/msm/dpu: dont play tricks with debug macros
Date: Tue, 27 Aug 2024 16:38:28 +0200
Message-ID: <20240827143853.940100457@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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
index f5473d4dea92f..8cb3cf842c52c 100644
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



