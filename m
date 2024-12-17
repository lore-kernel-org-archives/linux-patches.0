Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E7614A4E7;
	Tue, 17 Dec 2024 17:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456444; cv=none; b=dkA0eHk24EvdoMUjaRWSAjbtqjxArcdqbNjXBTxE2LPcA21wP4FzC5ltdUHCh+iBLttmd41emUgujALDRYnhVx0Xayd0nyxjC7oSnhAsuGWf/Rxx5MKuFblxBBvIsZPo4tq4FdEYlxtGC5TsD7yBC6xgdwT3EYyq7QotF+H/JyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456444; c=relaxed/simple;
	bh=ugmH94tfe8ACc9KvlmfwlJYd86ZAVotaR0sYuq1JSGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TUPLQcbKTtgbD2P+jXDOkfap5ym3a2ypxpdPV4UNhOgrATJ1Cs+6h41d4utb3Wg5p0CIKR7fbQyilgHV7Vr8YHikguil/8KGz5Hq45041VPcM0e6hQhGMAM3UJHseQMT3u83d+RCW2RrBZQFlfcjxUwHyP+b06WA333OLKRw1w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ee2oSYEM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ee2oSYEM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE73C4CED3;
	Tue, 17 Dec 2024 17:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456444;
	bh=ugmH94tfe8ACc9KvlmfwlJYd86ZAVotaR0sYuq1JSGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ee2oSYEMUcbdUJJX2/JHi2wihQyugmoHISXehYzkWq9E5Rat+5e1x1p/4LJtVeilU
	 S98BPxOdMzBoH0GLgsTGLqGbipdPvYcc6iGhckOFRQrjIkvwaGso0Gi4WVKDaaj8mp
	 ekS7xuc9HHLIGzxZNA+Qvp64V6aZ2GBqGpFWkowc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 063/172] drm/amdgpu: fix when the cleaner shader is emitted
Date: Tue, 17 Dec 2024 18:06:59 +0100
Message-ID: <20241217170548.891968749@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

commit f4df208177d02f1c90f3644da3a2453080b8c24f upstream.

Emitting the cleaner shader must come after the check if a VM switch is
necessary or not.

Otherwise we will emit the cleaner shader every time and not just when it is
necessary because we switched between applications.

This can otherwise crash on gang submit and probably decreases performance
quite a bit.

v2: squash in fix from Srini (Alex)

Signed-off-by: Christian König <christian.koenig@amd.com>
Fixes: ee7a846ea27b ("drm/amdgpu: Emit cleaner shader at end of IB submission")
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
index 8d9bf7a0857f..ddd7f05e4db9 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -674,12 +674,8 @@ int amdgpu_vm_flush(struct amdgpu_ring *ring, struct amdgpu_job *job,
 	pasid_mapping_needed &= adev->gmc.gmc_funcs->emit_pasid_mapping &&
 		ring->funcs->emit_wreg;
 
-	if (adev->gfx.enable_cleaner_shader &&
-	    ring->funcs->emit_cleaner_shader &&
-	    job->enforce_isolation)
-		ring->funcs->emit_cleaner_shader(ring);
-
-	if (!vm_flush_needed && !gds_switch_needed && !need_pipe_sync)
+	if (!vm_flush_needed && !gds_switch_needed && !need_pipe_sync &&
+	    !(job->enforce_isolation && !job->vmid))
 		return 0;
 
 	amdgpu_ring_ib_begin(ring);
@@ -690,6 +686,11 @@ int amdgpu_vm_flush(struct amdgpu_ring *ring, struct amdgpu_job *job,
 	if (need_pipe_sync)
 		amdgpu_ring_emit_pipeline_sync(ring);
 
+	if (adev->gfx.enable_cleaner_shader &&
+	    ring->funcs->emit_cleaner_shader &&
+	    job->enforce_isolation)
+		ring->funcs->emit_cleaner_shader(ring);
+
 	if (vm_flush_needed) {
 		trace_amdgpu_vm_flush(ring, job->vmid, job->vm_pd_addr);
 		amdgpu_ring_emit_vm_flush(ring, job->vmid, job->vm_pd_addr);
-- 
2.47.1



