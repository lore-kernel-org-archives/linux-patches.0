Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05CE338C42B;
	Sat, 12 Sep 2026 10:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207516; cv=none; b=AkUgLvg7LbMpl3gHMGGuLqJi1sBV9FPegNy3W7LoEwwbChFFVVxjJKWqd2SwTbNReDAZKqUZCK7UM3Fw5rVsYADJ/DWOsF/ao6H24JuIy/xndx8Cj6X4FUyuEfno+/bZM00eqFEEICv3YjiGGs4qprVnUqUBXl3/X9I05D1qCb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207516; c=relaxed/simple;
	bh=MraEElwL8atJkB0N0OmXXaRToaPRPi4BxWuIcVNJwkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ucjOPvF3O5EKxFH7PcQ/KkAoA+HXmmECjNhRJmFilmKwlisF0ihJpzGf0cxzvM5u+Dt9UIY/mDJcWkg3dsG9e4HjwalcPP5ZwmZQ7iB7f3ufyZae45XdC3p+1O6g5xAkU1a479xiPRlYKUND3WJ8S9j2aWAmimM9dnBs8fypZ7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eisWAKWz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eisWAKWz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E5E1F000FF;
	Sat, 12 Sep 2026 10:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207514;
	bh=eaJ8Uopuf1bQM9+wNr819yDket7THEeJGAGqZ+FL2Ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eisWAKWzULiY5SWvhBlu3dNZOBbDffxu078pswHRpA/+Jy+eOlCzJg3H81WNYv+zS
	 KHSTUYrM9kWH2CtjdZx3YK33u0CvykuHNUscQsJEWxCH66N7oUMiUEM2tKepz0PdfF
	 Jk3aNd6OPAYz/OIiVLHDUPOrjgp2ZGLJtOzA/Qac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Zhang <jie.zhang@oss.qualcomm.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0429/1518] drm/msm: Recover HW before retire hung submit
Date: Sat, 12 Sep 2026 08:43:18 +0200
Message-ID: <20260912065633.155777132@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jie Zhang <jie.zhang@oss.qualcomm.com>

[ Upstream commit b303e1d52811de7d1bcf793560754d4df68d4a1c ]

During recovery, it is not safe to retire the hung submit before we
recover the GPU. Retiring the submit triggers BO free and that can
result in GPU pagefaults since the GPU may be actively accessing those
BOs.

To fix this, retire the submits after gpu recovery is complete in
recover_worker().

Fixes: 1a370be9ac51 ("drm/msm: restart queued submits after hang")
Signed-off-by: Jie Zhang <jie.zhang@oss.qualcomm.com>
Signed-off-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Acked-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/730655/
Message-ID: <20260605-assorted-fixes-june-v1-2-2caa04f7287c@oss.qualcomm.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gpu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_gpu.c b/drivers/gpu/drm/msm/msm_gpu.c
index a4377ee84c723..c78f5738bfdeb 100644
--- a/drivers/gpu/drm/msm/msm_gpu.c
+++ b/drivers/gpu/drm/msm/msm_gpu.c
@@ -548,11 +548,11 @@ static void recover_worker(struct kthread_work *work)
 		msm_update_fence(ring->fctx, fence);
 	}
 
+	gpu->funcs->recover(gpu);
+
 	/* retire completed submits, plus the one that hung: */
 	retire_submits(gpu);
 
-	gpu->funcs->recover(gpu);
-
 	/*
 	 * Replay all remaining submits starting with highest priority
 	 * ring
-- 
2.53.0



