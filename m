Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902223451DA;
	Sat, 17 Oct 2026 16:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253612; cv=none; b=mJ0LXU6C+IMqC63S6KB0aTUm7NHrNujdXPALzCVQUm4L1A9PO0Y07YAmhshKCWpXg7IkqMrype6bibRqBLpRQF/vzRHCQGHm7yiz+YhZdgilYecc3VecmhcQBBCjRYbxhgURxAh/DTUvZrk7/5ug0M1xoQov00a7VT1tyJLYCkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253612; c=relaxed/simple;
	bh=H66vhADbBDmH/UUS8GYU5JZuNj4hDl2dDp30ixwsLGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NeCiVefXuorTRSwd/+IjnVyDv3QAsrh2K9qq3pV/n8S1M4g5LoTuC61/xK8Ow1ZeynP/uHqNzaLgqLfff7MyY7m+q0qjv5J3FREJtWEkYWF3RvVCE41FmVg7QxLz/uTQwFx68kmXAVUQOU7CtkIe0RiL8GXahCTREwzH7afmaMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PnLLTF3o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PnLLTF3o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C79601F000C5;
	Sat, 17 Oct 2026 16:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253610;
	bh=fata6QCrQLwhM26dquBzttj241sXlRjYbnOLjpR6fjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PnLLTF3ogxUgxWL3+5/bZ9ef+TH8+nR5vEasxo3ZhoJmaSQ4H9eJRYdd95aMpHxmY
	 sRq3P01sS/kTXyYWe+zfzymcr3L8soLK8kaijNixHAVvRzn6hmaQKkdYCcTgOaFlck
	 9BqWlOspQsAON1PAjCIYdkH8fiU00b9jSmdjp4B4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Zhang <jie.zhang@oss.qualcomm.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 175/869] drm/msm: Recover HW before retire hung submit
Date: Sat, 17 Oct 2026 17:50:16 +0200
Message-ID: <20261017160041.540257547@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a274b84664237..ffb91e45aefde 100644
--- a/drivers/gpu/drm/msm/msm_gpu.c
+++ b/drivers/gpu/drm/msm/msm_gpu.c
@@ -422,11 +422,11 @@ static void recover_worker(struct kthread_work *work)
 	}
 
 	if (msm_gpu_active(gpu)) {
+		gpu->funcs->recover(gpu);
+
 		/* retire completed submits, plus the one that hung: */
 		retire_submits(gpu);
 
-		gpu->funcs->recover(gpu);
-
 		/*
 		 * Replay all remaining submits starting with highest priority
 		 * ring
-- 
2.53.0



