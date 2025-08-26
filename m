Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD602BEFF0;
	Tue, 26 Aug 2025 11:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207433; cv=none; b=ZA/K43ltid5ZgwL8L+Z5XDluihCHGaWFofBWKXWUh7Yr4cQ9uuWonDJ5RC0t0iZLosSwsPz4Qojclg5nbMpaPl6abwzTooaVv9oiGkK2PCfQ8cuI7LfT5aXHAJF383gQe3gCOeih7WCEAjglw/oJHdP1mBD3R8ub/B3BDkoxFYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207433; c=relaxed/simple;
	bh=GysSvYB/ElYF40AIJvyp3ID1xNkbuO2n/K/U4MHFUss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EX7z2LvyOWh4CzFN+WXu0Zek4nCfZhJsff7vfDjbKeEcbDIjPxrvRpE9HKD/CIiLXfso9Q4AYRDpfBbi2a9iiCNMW85l+RehShEM8OHIAyX/OM/6Te3fhK+r7GrmbACixtWAXVfybIefNah+Y6ZXdgDTXy06VaSLKZdaXdCftOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OGq8Admk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OGq8Admk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83B93C4CEF4;
	Tue, 26 Aug 2025 11:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207432;
	bh=GysSvYB/ElYF40AIJvyp3ID1xNkbuO2n/K/U4MHFUss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OGq8AdmkiJX2Uqd8dIrSLUVnC/TAb6WFPhO+QJZMgG8/mFsCuZLIlLKNo2Dz7Sq0L
	 sOfEtVbR7wn5kJnNHwwFHyslFcYiR13Y87m10mVlAVIyVs9rTbPIvnwn/scfVXAvkv
	 jlLHZgizWUNog8IAEyZMSUjvS8YIqcD8uu7IsWM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YuanShang <YuanShang.Mao@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.16 178/457] drm/amdgpu: Retain job->vm in amdgpu_job_prepare_job
Date: Tue, 26 Aug 2025 13:07:42 +0200
Message-ID: <20250826110941.775796519@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: YuanShang <YuanShang.Mao@amd.com>

commit c00d8b79fd2167c6ac65e096619535acdf8678d5 upstream.

The field job->vm is used in function amdgpu_job_run to get the page
table re-generation counter and decide whether the job should be skipped.

Specifically, function amdgpu_vm_generation checks if the VM is valid for this job to use.
For instance, if a gfx job depends on a cancelled sdma job from entity vm->delayed,
then the gfx job should be skipped.

Fixes: 26c95e838e63 ("drm/amdgpu: set the VM pointer to NULL in amdgpu_job_prepare")
Signed-off-by: YuanShang <YuanShang.Mao@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ed76936c6b10b547c6df4ca75412331e9ef6d339)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
@@ -387,13 +387,6 @@ amdgpu_job_prepare_job(struct drm_sched_
 			dev_err(ring->adev->dev, "Error getting VM ID (%d)\n", r);
 			goto error;
 		}
-		/*
-		 * The VM structure might be released after the VMID is
-		 * assigned, we had multiple problems with people trying to use
-		 * the VM pointer so better set it to NULL.
-		 */
-		if (!fence)
-			job->vm = NULL;
 		return fence;
 	}
 


