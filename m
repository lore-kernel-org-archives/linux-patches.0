Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4956C50246;
	Sat,  3 Feb 2024 04:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933871; cv=none; b=bpRY6R69IkOosJWQFYwcUD5RIG/6PvTWAGg3X221fEd4A6zjJWa1b/dYpOEpYHiy658CnilW3mXKJXrhNZ9UcPrvmcOEE8CW5mbZevUwUju/VeUx9A5p+2iGHpO+sOfvQM3GcQnKqny7j3uyHiEV3b4P3xQdq30QKDxkpuIMGBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933871; c=relaxed/simple;
	bh=p9wsJgeY2OGll8Tp4y1E9d4FOALjlyyFlCH+ABBbcrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PmOi913PBALlMVQPuQYsIamXx3J99fh2XDjRLH1yxWr1Gdmk163orq8P5Hea/2t68BzswsjmFceuRN2s94SzjvR2eAQYQgR9tsFrMCCKVmiMF6aKLhnIRxAySSvbM64uOeRaM/XYSB4zX/sph8nMsMNm9eZVSZPDaspKM87FtdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QrSewVW8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QrSewVW8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 114DFC433F1;
	Sat,  3 Feb 2024 04:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933871;
	bh=p9wsJgeY2OGll8Tp4y1E9d4FOALjlyyFlCH+ABBbcrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QrSewVW8qBFlY6GSLM51y2X56Rdw/PyVDQ/FoJxlWF6G6jVvh6eyAJfbCJuu6O0oc
	 Q3Cdfx9s/i5ik25CNu0gWUtyH80Nim72ytW2WDnh1lVhRkeKa5VEW9a0DMAEEwVdpf
	 0yK7iC+aG44EbTBzmr2k8qFBTVpkmRrS/n7gFJsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 209/353] drm/msm/dpu: Ratelimit framedone timeout msgs
Date: Fri,  2 Feb 2024 20:05:27 -0800
Message-ID: <20240203035410.318641475@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 5dbb5d27bbea..0dd95b7ff1f9 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -39,6 +39,9 @@
 #define DPU_ERROR_ENC(e, fmt, ...) DPU_ERROR("enc%d " fmt,\
 		(e) ? (e)->base.base.id : -1, ##__VA_ARGS__)
 
+#define DPU_ERROR_ENC_RATELIMITED(e, fmt, ...) DPU_ERROR_RATELIMITED("enc%d " fmt,\
+		(e) ? (e)->base.base.id : -1, ##__VA_ARGS__)
+
 /*
  * Two to anticipate panels that can do cmd/vid dynamic switching
  * plan is to create all possible physical encoder types, and switch between
@@ -2339,7 +2342,7 @@ static void dpu_encoder_frame_done_timeout(struct timer_list *t)
 		return;
 	}
 
-	DPU_ERROR_ENC(dpu_enc, "frame done timeout\n");
+	DPU_ERROR_ENC_RATELIMITED(dpu_enc, "frame done timeout\n");
 
 	event = DPU_ENCODER_FRAME_EVENT_ERROR;
 	trace_dpu_enc_frame_done_timeout(DRMID(drm_enc), event);
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.h b/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.h
index b6f53ca6e962..f5473d4dea92 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.h
@@ -51,6 +51,7 @@
 	} while (0)
 
 #define DPU_ERROR(fmt, ...) pr_err("[dpu error]" fmt, ##__VA_ARGS__)
+#define DPU_ERROR_RATELIMITED(fmt, ...) pr_err_ratelimited("[dpu error]" fmt, ##__VA_ARGS__)
 
 /**
  * ktime_compare_safe - compare two ktime structures
-- 
2.43.0



