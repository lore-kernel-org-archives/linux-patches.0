Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D49C136651;
	Tue, 14 May 2024 10:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683055; cv=none; b=Hh/l1Q0RnmmFPADy29840oKoFjDBvHXwBt1pflLViXL+3MrAH1uhhrh9YktWLHSHL7Y7Vm7snuVecnkyX0TUUAQjTRUBbqzfI8qWhcXl3BG8+ni9ebX6fVJ0mVLBldY5KRgsSEttoYFpwd/tSxraMXqVl99VzhYmucw077SlFls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683055; c=relaxed/simple;
	bh=9vBWJjInKYdDS9ZDz9oio/PLaS/n8QCn/q4+0LyLoSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AtnlJS5rYT46Q4O3ZQuVkQzlHTmgH/xoJu5wWO25/B7UUhvYkWOPFFDpbmDJga2nxRxMguZwOPoXfxQWqvTz1MSwQKVbiIatUk3Z4hvjJdUMPHPY9mATOmGALTaUGTVtGs6frBcIcXA9RhrDIl/5LBhpWHBFZ3gUKxAVsA44J+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A1HcZdEX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A1HcZdEX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450D6C2BD10;
	Tue, 14 May 2024 10:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683055;
	bh=9vBWJjInKYdDS9ZDz9oio/PLaS/n8QCn/q4+0LyLoSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A1HcZdEXy+4Q0zwP+j8g5KaaSUuVwgFeVPKUQCEFz4lOsB18KIPe+w5e9i2L8bJuv
	 +S/aMl3hVvcBEPyMSwsMGfu05L+ZD9LHDGnuBRJzW5M6REka1zA3j66YM3XVYrRIdM
	 B2S4lystQna4AEIkIB+F6oFQ4Gix46NCODTICIaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 159/336] drm/amdgpu: Refine IB schedule error logging
Date: Tue, 14 May 2024 12:16:03 +0200
Message-ID: <20240514101044.606348058@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 4b18a91faf1752f9bd69a4ed3aed2c8f6e5b0528 ]

Downgrade to debug information when IBs are skipped. Also, use dev_* to
identify the device.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
index 71a5cf37b472d..0b8c6581b62c0 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
@@ -300,12 +300,15 @@ static struct dma_fence *amdgpu_job_run(struct drm_sched_job *sched_job)
 		dma_fence_set_error(finished, -ECANCELED);
 
 	if (finished->error < 0) {
-		DRM_INFO("Skip scheduling IBs!\n");
+		dev_dbg(adev->dev, "Skip scheduling IBs in ring(%s)",
+			ring->name);
 	} else {
 		r = amdgpu_ib_schedule(ring, job->num_ibs, job->ibs, job,
 				       &fence);
 		if (r)
-			DRM_ERROR("Error scheduling IBs (%d)\n", r);
+			dev_err(adev->dev,
+				"Error scheduling IBs (%d) in ring(%s)", r,
+				ring->name);
 	}
 
 	job->job_run_counter++;
-- 
2.43.0



