Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DEA42F2909;
	Mon, 22 Sep 2025 19:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570300; cv=none; b=uss3R3gs6+j0JexCut1IHcYkZylB/pjP6G9NpEUwvtiOh7SDAxJNu5tKtXz265GXzFkcdbT1tYCWloPX5akIZp3XxfiGCRwGQX3Hkq+rWe3TMDYgNFNnrCFruyhIvnG0po+soG5EbkJUuPuADW8Ntcmsficl5kWSYkPYYvbMtOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570300; c=relaxed/simple;
	bh=zdroLY2p9wIMbaC6UhhvvrPBFDaxPfW/96yhjjv0Uvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IFYAxketOPAJgLowT+w9s4++kGISj+E4rYo4UFFREm3GWPy3Nu5b4F1aTXU+J0uOfIR3xd8oJv8f0OdJ277gUZUBTK8KNTd+1KPfdBveVXfSnRCg7x7jmQbUAlkyo72liyi46EaAlQLY3hh2l/b1ghQ77QpE24uSOvC1SaM1upY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=idvpmZdX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="idvpmZdX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5E2C4CEF0;
	Mon, 22 Sep 2025 19:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570299;
	bh=zdroLY2p9wIMbaC6UhhvvrPBFDaxPfW/96yhjjv0Uvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=idvpmZdXVwOtVgeX+A9bY6c3NjeBHWurYfyE/HwoQquTxWsY7io62oAaM5YRkyPRr
	 S9DgDFls+rG6p6iGdpYRCjMmP5emo6p5fbIivTCj4tnEopTpc1ypezNAt9B8iMfbgC
	 TynnXMcs9yj33MW4uMCurP2AZGUkTvoqUCb9jRlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	David Perry <david.perry@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.16 095/149] drm/amdgpu: suspend KFD and KGD user queues for S0ix
Date: Mon, 22 Sep 2025 21:29:55 +0200
Message-ID: <20250922192415.282501328@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

commit 9272bb34b066993f5f468b219b4a26ba3f2b25a1 upstream.

We need to make sure the user queues are preempted so
GFX can enter gfxoff.

Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Tested-by: David Perry <david.perry@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit f8b367e6fa1716cab7cc232b9e3dff29187fc99d)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5055,7 +5055,7 @@ int amdgpu_device_suspend(struct drm_dev
 	adev->in_suspend = true;
 
 	if (amdgpu_sriov_vf(adev)) {
-		if (!adev->in_s0ix && !adev->in_runpm)
+		if (!adev->in_runpm)
 			amdgpu_amdkfd_suspend_process(adev);
 		amdgpu_virt_fini_data_exchange(adev);
 		r = amdgpu_virt_request_full_gpu(adev, false);
@@ -5075,10 +5075,8 @@ int amdgpu_device_suspend(struct drm_dev
 
 	amdgpu_device_ip_suspend_phase1(adev);
 
-	if (!adev->in_s0ix) {
-		amdgpu_amdkfd_suspend(adev, !amdgpu_sriov_vf(adev) && !adev->in_runpm);
-		amdgpu_userq_suspend(adev);
-	}
+	amdgpu_amdkfd_suspend(adev, !amdgpu_sriov_vf(adev) && !adev->in_runpm);
+	amdgpu_userq_suspend(adev);
 
 	r = amdgpu_device_evict_resources(adev);
 	if (r)
@@ -5141,15 +5139,13 @@ int amdgpu_device_resume(struct drm_devi
 		goto exit;
 	}
 
-	if (!adev->in_s0ix) {
-		r = amdgpu_amdkfd_resume(adev, !amdgpu_sriov_vf(adev) && !adev->in_runpm);
-		if (r)
-			goto exit;
+	r = amdgpu_amdkfd_resume(adev, !amdgpu_sriov_vf(adev) && !adev->in_runpm);
+	if (r)
+		goto exit;
 
-		r = amdgpu_userq_resume(adev);
-		if (r)
-			goto exit;
-	}
+	r = amdgpu_userq_resume(adev);
+	if (r)
+		goto exit;
 
 	r = amdgpu_device_ip_late_init(adev);
 	if (r)
@@ -5162,7 +5158,7 @@ exit:
 		amdgpu_virt_init_data_exchange(adev);
 		amdgpu_virt_release_full_gpu(adev, true);
 
-		if (!adev->in_s0ix && !r && !adev->in_runpm)
+		if (!r && !adev->in_runpm)
 			r = amdgpu_amdkfd_resume_process(adev);
 	}
 


