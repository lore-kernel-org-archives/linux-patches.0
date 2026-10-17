Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D883BD643;
	Sat, 17 Oct 2026 18:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260464; cv=none; b=OWmwwA98dm9GpoYH2hFuJ9kCGqTeES+WUzB71UWS/MCYF03fU2JxPzkNdK3sCslbHytzl05zsL4tnobyKqMl7zFwxLRs2gIKm8Ft7SZ6z80Ufbp5OIKum+8dvO7KIOgCwajCus2lkjKrjQ9ssJFaEHSqCAPGARS6RFuO6aJ3MS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260464; c=relaxed/simple;
	bh=G5gKoGNhF9aYfOEHNcKgZV6MTJpcMdzeDxX0H2OxpkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GW/T4EnzobM9crVCrPSpOHpo6Z3a2EcKCEz6sueWbWDvblEfE8IY0rfpL++IJ/GK+Q8tGIoDTWLgiJR12SKz2IpintcXlf6g2erEMTFASXRDtqwbJe6Q3xgBA4u0y4PXUoM0+EM0dCh4aEx5pDqTmw2uSWUI4f6nnMw3NKb5gIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=klz+Bulo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="klz+Bulo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A341A1F000C4;
	Sat, 17 Oct 2026 18:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260462;
	bh=NRVxWMLc3LsfcYsGSrhRSMOx9V74LMv+iL4spvgu0pI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=klz+BuloPPwAC3AGKbq/5wW+NhN5hMoGDJH1OQdL46fBKlLeFokneshXKXNl22G3C
	 e78tRwaXoFMnm5njLhIFjwfiMQPTV7DDTCaerZi5tRI8+lclXYtQw5AXj0RZxlLGZA
	 BrpiYMAJOP0g3er3hviTgM/YZfXvd95dvdperDW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Zhang <jie.zhang@oss.qualcomm.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1554/1674] drm/msm: Recover HW before retire hung submit
Date: Sat, 17 Oct 2026 18:03:46 +0200
Message-ID: <20261017160510.988946228@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c2c8138909779..007b8b4e81391 100644
--- a/drivers/gpu/drm/msm/msm_gpu.c
+++ b/drivers/gpu/drm/msm/msm_gpu.c
@@ -418,11 +418,11 @@ static void recover_worker(struct kthread_work *work)
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



