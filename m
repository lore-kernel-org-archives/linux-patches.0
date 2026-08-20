Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC26379EDA;
	Thu, 20 Aug 2026 15:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238346; cv=none; b=sL65SWJGCk8G6/Hgt0OEJ0pSTbascXQSpx/jmuD/5sggm4lICBTupjIW6A8fmqyfk7nXYCX75SrBu/NilO3lcr7eroRtX1SfP+dY8uM13PAgif0UH5Pnm3MtzwZPzJzYk5iwSExc1T7gK+0RhAxWPOGyOYUQ8+mELyqGdVvPjvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238346; c=relaxed/simple;
	bh=1Otbj0c1EFTohMNGSNBaTQ2Jq7CA3cPTDuy2hL/1r7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R85hR4uQrcI7X2tH30wElxDLQzM74tHRmwoBViUzaW5mNWLLyDYy6dmoNK4a0/bpTdKSHjNvYD1VzF51QPbbP7uWMNytqIxdlr8Wwi4v57ID4MSDk1a7W9wPo4pX6TSogbdTFzIeEPKLMFaoqgTKCwAXByzTHNSUevxIcHlOn7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gJXHAbHF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gJXHAbHF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 790F91F00A3A;
	Thu, 20 Aug 2026 15:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238345;
	bh=763AfXMTKBoMF6fKk74LK4o/GbTZqSUnHAUTWFAuhFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gJXHAbHFkQ5ivXR5kf5Lov/rAa/ZiZDE6s43goZDU3MeQNxCOHtyawry/OyWZKBA4
	 sfQeNuMVFHwLgBZCpubF885UcufPhM/Iooz2SBXOjjN+DE6hCLmP6bgvrsaMAtdcQA
	 167z0LlkT9lb1+pz46yDoyqzNRQ69nV8YZzCc61c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Rosca <david.rosca@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 116/228] drm/amdgpu: fix missing check in vm_flush()
Date: Thu, 20 Aug 2026 16:54:18 +0200
Message-ID: <20260820145248.160583409@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 47cd31185090bd1439d4587b835ac22d7ba6f1e3 upstream.

We shouldn't return early if we need to emit spm update.

Reviewed-by: David Rosca <david.rosca@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 54a118f1d7e184fcbb18f83889f48f17a767878a)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -810,6 +810,7 @@ void amdgpu_vm_flush(struct amdgpu_ring
 	mutex_unlock(&id_mgr->lock);
 
 	gds_switch_needed &= !!ring->funcs->emit_gds_switch;
+	spm_update_needed &= !!adev->gfx.rlc.funcs->update_spm_vmid;
 	vm_flush_needed &= !!ring->funcs->emit_vm_flush  &&
 			job->vm_pd_addr != AMDGPU_BO_INVALID_OFFSET;
 	pasid_mapping_needed &= adev->gmc.gmc_funcs->emit_pasid_mapping &&
@@ -821,7 +822,7 @@ void amdgpu_vm_flush(struct amdgpu_ring
 		&job->base.s_fence->scheduled == isolation->spearhead;
 
 	if (!vm_flush_needed && !gds_switch_needed && !need_pipe_sync &&
-	    !cleaner_shader_needed)
+	    !cleaner_shader_needed && !spm_update_needed)
 		return;
 
 	amdgpu_ring_ib_begin(ring);


