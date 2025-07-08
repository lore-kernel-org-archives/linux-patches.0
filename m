Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E835BE46;
	Tue,  8 Jul 2025 16:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993578; cv=none; b=sCk8eFMd5oMySroY53UdKNymSAHT36c1//cPmyeRdrxpflx3x9zMQHFyCrszpXGfMvSgdUp31IEIVnr86pW986TKlHQn/Z3V+wjbItWEjDmW5GkpcO4hchd7bOGoRLoWXuYI2vrjQbpsv+eRDogb35GL8mLfJu0Gd6iwil/OvSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993578; c=relaxed/simple;
	bh=rJIwN/nKO4eZTnFCRR1MpbNMpyCvPsomTs2iURrdYy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a/tG7GPjDiwzCdzPiQtWW2cqA/BdPRSXx0wLDF0QkvRxNQMmdUrW+UMIHDFnQ4OzWi9aqLuxH4utZ4Rbf6O9Do3G2EjPRq+hDN9rizc3iDQa/eofDG/nGxx6OK2apruc7hFI1SsB+PrpZtqUF1l7Eoj2CzR2zuWQhSatdNpoc4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ER3aQTHd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ER3aQTHd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F120CC4CEED;
	Tue,  8 Jul 2025 16:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993578;
	bh=rJIwN/nKO4eZTnFCRR1MpbNMpyCvPsomTs2iURrdYy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ER3aQTHdtryWUrNp511lq++sjRBRRxvdo3Ng0p0ZpEIWt9E7eeQp4cf8zfRXK36rD
	 oSkx5EUBtgyBGwPfoOHHnGTr8ZHzda4IYDDLs/bR9Bi4W7ZviPBGYbSxcMfLFdG3SV
	 vJosE/pDLmqNPO2baN5WuWuJc1xLWxO6a28pxCeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 122/178] drm/msm: Fix a fence leak in submit error path
Date: Tue,  8 Jul 2025 18:22:39 +0200
Message-ID: <20250708162239.782454270@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 5d319f75ccf7f0927425a7545aa1a22b3eedc189 ]

In error paths, we could unref the submit without calling
drm_sched_entity_push_job(), so msm_job_free() will never get
called.  Since drm_sched_job_cleanup() will NULL out the
s_fence, we can use that to detect this case.

Signed-off-by: Rob Clark <robdclark@chromium.org>
Patchwork: https://patchwork.freedesktop.org/patch/653584/
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gem_submit.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/msm/msm_gem_submit.c b/drivers/gpu/drm/msm/msm_gem_submit.c
index 3e9aa2cc38ef9..b2aeaecaa39b3 100644
--- a/drivers/gpu/drm/msm/msm_gem_submit.c
+++ b/drivers/gpu/drm/msm/msm_gem_submit.c
@@ -85,6 +85,15 @@ void __msm_gem_submit_destroy(struct kref *kref)
 			container_of(kref, struct msm_gem_submit, ref);
 	unsigned i;
 
+	/*
+	 * In error paths, we could unref the submit without calling
+	 * drm_sched_entity_push_job(), so msm_job_free() will never
+	 * get called.  Since drm_sched_job_cleanup() will NULL out
+	 * s_fence, we can use that to detect this case.
+	 */
+	if (submit->base.s_fence)
+		drm_sched_job_cleanup(&submit->base);
+
 	if (submit->fence_id) {
 		spin_lock(&submit->queue->idr_lock);
 		idr_remove(&submit->queue->fence_idr, submit->fence_id);
-- 
2.39.5



