Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34CF022094;
	Tue, 14 May 2024 11:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686399; cv=none; b=TnF0V57iITiXww/nXLlwlt3WzkwPBEDr1RhjOvJMYTDbVWicbuBqwgxSjtE9wcIT42d/lcuC/IWLAF3iU+OOua30Z3U+WE/MM7w228yUetqwSlD4BHTh2MRqoDpZnHMZ76b+ThmwpVmNXMbzKGw4Y6PVWmXYkGogzhqUzCt/neA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686399; c=relaxed/simple;
	bh=6Q8NINPQYgjnqceIgXFkdIlVVqozOiRYDlbYePg3mAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s3LnedpKC2Y3IgY9V1QaWSvrPZDMY5awKnmeN4xkPWhBB+IV0juBKUmkwHW0HSpYPZp49n4LHcJk8oSHpHFEZnpvu5bAFdSdrzUJVWJeNejdkmHp1IXwXZH7xKbxWkMAErAJG2tBGcvPWAjAKtEstZJGMFjrNuGSvdZ6HEeP9u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uTmLK3PE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uTmLK3PE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66373C2BD10;
	Tue, 14 May 2024 11:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686398;
	bh=6Q8NINPQYgjnqceIgXFkdIlVVqozOiRYDlbYePg3mAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uTmLK3PEj6FRLi49/WOSO8qgsYbSjDB5KW5Jx6ZTab63+CJ0xwf3GpG84NvlfnTPp
	 uU6XhTNOoYICEUC/KnBeuzW4znNzgKpf2cdbAi1igmUFvqSR5AH6+k4AZVAELFE/vB
	 I3fHmgZ3hOe/2C+pP6IqVTyHFPdWkzvhTWUaw54g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 125/236] drm/amdgpu: Refine IB schedule error logging
Date: Tue, 14 May 2024 12:18:07 +0200
Message-ID: <20240514101025.118026434@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3bf0e893c07df..f34bc9bb7045a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
@@ -301,12 +301,15 @@ static struct dma_fence *amdgpu_job_run(struct drm_sched_job *sched_job)
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



