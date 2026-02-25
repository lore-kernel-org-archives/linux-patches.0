Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E741E2834;
	Wed, 25 Feb 2026 01:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983039; cv=none; b=MqZ+GFzK34wBIq8xHI+mgITvyBKIVMwEUDNFNj+BHJCR1KDdPSyUcEM8zOdX+x0if6ewMh6zIfuDI2hEh2rbFZY7trRGF4nmeudzdbjyKcYKEcxsoSWec59tb5db8sCmxH33Y6PGXGr8F0IQ7C+7IDRSTB6N/sES3zzIOTdkzLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983039; c=relaxed/simple;
	bh=06QwWxKQuhS2vfEQxgTJkthzRE4wV1ANduRihOqjXCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CEPTguec3NXUyUFoduiLwXyysPixR2h1mV/VS/Z6wpwfoXCY2e82G1Z+mmiH93XL2r/9U6cgpGtQ0+OCbePiCOcgpPiZEiNxukrXzXYmwKsQmcHltYzGy4sTIi9JYnRyE32VTrEtKIlI93o8UJSQNqzft8Oc/sWhKZ0beqBbxl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E8Cxg7d8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E8Cxg7d8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A913C19423;
	Wed, 25 Feb 2026 01:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983039;
	bh=06QwWxKQuhS2vfEQxgTJkthzRE4wV1ANduRihOqjXCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E8Cxg7d8IrN2t49DHHb7VIkA7zT38Z5+s5J1yh3bo9WlIzqI3U9L0ZtH52MNe/fzz
	 HCvex5KkqY5mgZ5uqiQ3MNYujTtRIPqK54B/2v4UV7eaBgJ8KGnTLuQ7DAEBdwip9w
	 QeRzcMpLbf4+8/73LMFhJWt1w/y+MUUSvAnbePsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 202/781] drm/amdgpu: dont attach the tlb fence for SI
Date: Tue, 24 Feb 2026 17:15:11 -0800
Message-ID: <20260225012404.620340700@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 820b3d376e8a102c6aeab737ec6edebbbb710e04 ]

SI hardware doesn't support pasids, user mode queues, or
KIQ/MES so there is no need for this.  Doing so results in
a segfault as these callbacks are non-existent for SI.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4744
Fixes: f3854e04b708 ("drm/amdgpu: attach tlb fence to the PTs update")
Reviewed-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
index a67285118c37b..c362d4dfb5bbb 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -1069,7 +1069,9 @@ amdgpu_vm_tlb_flush(struct amdgpu_vm_update_params *params,
 	}
 
 	/* Prepare a TLB flush fence to be attached to PTs */
-	if (!params->unlocked) {
+	if (!params->unlocked &&
+	    /* SI doesn't support pasid or KIQ/MES */
+	    params->adev->family > AMDGPU_FAMILY_SI) {
 		amdgpu_vm_tlb_fence_create(params->adev, vm, fence);
 
 		/* Makes sure no PD/PT is freed before the flush */
-- 
2.51.0



