Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEE629AB;
	Wed, 21 Feb 2024 13:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521537; cv=none; b=LIFiVR6L8p07FuWXHXYQ56LdbSnIh6WLLdsIuhyBpoKLCIQSCBJGLTF32x8VBoAb4F+55eNveEbo1LCOldsdErRpyVjyDrXykjdXlvRiY/NkSBddkAoLvRaCpc3M51fkoHAd6sBn9eTc5g5T0qvPxKHkPt7fBMpLuG1RbuIN7SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521537; c=relaxed/simple;
	bh=+R4bM7YDBJ5RSUVeTFpxm1pFj4PWAbVCFQHbZVAWpvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gw6j6UB/eXByP7prnRsTgeTJE4oUofzxldmdcOTwgEaOC55ylCTkZApctno0aF7cwOySdJKYuypn39l3/AOWqcSFS3kLkbm5kx9t/5yH9FQojMAqJBpUGA3JDhNzQ+NP/4JNYdqSqRrjCs8aMu9EvoskLvZ9+ozxaRudnOuZLKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GtmO/rs4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GtmO/rs4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD6CC433C7;
	Wed, 21 Feb 2024 13:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521536;
	bh=+R4bM7YDBJ5RSUVeTFpxm1pFj4PWAbVCFQHbZVAWpvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GtmO/rs4ABlBW9jIaUUFJFcSH8w6oA/u+vzcWwB85LSiQC8fXTMBSLquoPwiVYrM0
	 LlN2wjBcz2PgVGIkDj6qZc68RJp3Rfio+MHtTXsZ4qFz/AgxydaIHaVkJhdCZf5CQj
	 xG0zWpUuOplHIulugH6dglMgdA6qdBeVB1tShihQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 110/202] drm/msm/dpu: Ratelimit framedone timeout msgs
Date: Wed, 21 Feb 2024 14:06:51 +0100
Message-ID: <20240221125935.301604579@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 2b72e50c62de60ad2d6bcd86aa38d4ccbdd633f2 ]

When we start getting these, we get a *lot*.  So ratelimit it to not
flood dmesg.

Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Marijn Suijten <marijn.suijten@somainline.org>
Patchwork: https://patchwork.freedesktop.org/patch/571584/
Link: https://lore.kernel.org/r/20231211182000.218088-1-robdclark@gmail.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c | 5 ++++-
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.h     | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
index 19e2753ffe07..a411cfe76998 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -53,6 +53,9 @@
 		(p) ? ((p)->hw_pp ? (p)->hw_pp->idx - PINGPONG_0 : -1) : -1, \
 		##__VA_ARGS__)
 
+#define DPU_ERROR_ENC_RATELIMITED(e, fmt, ...) DPU_ERROR_RATELIMITED("enc%d " fmt,\
+		(e) ? (e)->base.base.id : -1, ##__VA_ARGS__)
+
 /*
  * Two to anticipate panels that can do cmd/vid dynamic switching
  * plan is to create all possible physical encoder types, and switch between
@@ -2326,7 +2329,7 @@ static void dpu_encoder_frame_done_timeout(struct timer_list *t)
 		return;
 	}
 
-	DPU_ERROR_ENC(dpu_enc, "frame done timeout\n");
+	DPU_ERROR_ENC_RATELIMITED(dpu_enc, "frame done timeout\n");
 
 	event = DPU_ENCODER_FRAME_EVENT_ERROR;
 	trace_dpu_enc_frame_done_timeout(DRMID(drm_enc), event);
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.h b/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.h
index 66d466628e2b..56ae888e18fc 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.h
@@ -61,6 +61,7 @@
 	} while (0)
 
 #define DPU_ERROR(fmt, ...) pr_err("[dpu error]" fmt, ##__VA_ARGS__)
+#define DPU_ERROR_RATELIMITED(fmt, ...) pr_err_ratelimited("[dpu error]" fmt, ##__VA_ARGS__)
 
 /**
  * ktime_compare_safe - compare two ktime structures
-- 
2.43.0



