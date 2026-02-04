Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F31B2D5C91;
	Wed,  4 Feb 2026 15:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219242; cv=none; b=qQRX2ep2hzuxCHahraAI/3ndqSR13gKWdRTA2o9f6ny6be1Ue2Opn0kX8PoaAUAepOyvHfLHCzfrix67I2lOjchaYevX91yiVzjQM0lM3+0Uy3XSbeTNrI9yqcG99B2lxvvUVGqqSCF947PBtFT1hB2ywAD8pAN2is95aRRZlms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219242; c=relaxed/simple;
	bh=jSF+VB9aimDAgcZEP21gC3vqo1BeBSFKi3f0nTqI7x8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qy3sD/d9rgffOFu0GMZp+6SDgnFaGNGJwYGMjjLSSmw+dpgNgBhr9xzFfvpydjaCPqnosGpCMelP4MMagZQuf2kAYS8dUSLqZl9uEF+YG/7ttaoo0rZtPUMbsfJ5CjcRlnOXqdvPoCJ7WrUomAHb7Gh6WQBccKSC4TC9bhHwZc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oozAJFm7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oozAJFm7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26AE8C4CEF7;
	Wed,  4 Feb 2026 15:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219242;
	bh=jSF+VB9aimDAgcZEP21gC3vqo1BeBSFKi3f0nTqI7x8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oozAJFm7gqlQ6SUbyzSWJUqNeWFgQEIAzXMf4yGzMADCJ1xyef6no7wZsp5q4xXLo
	 0FmBBSJNbZdneqg7F0+f/lcH/Qw75RW2vsw5Iid+iGNnseMGX1k9K0Zh83LldsaMbh
	 /tFBt8JiM2bKMLKw43flfotvIbFgzZX2gpZJTlOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 110/122] drm/amdgpu/gfx11: adjust KGQ reset sequence
Date: Wed,  4 Feb 2026 15:41:32 +0100
Message-ID: <20260204143855.810843884@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 3eb46fbb601f9a0b4df8eba79252a0a85e983044 upstream.

Kernel gfx queues do not need to be reinitialized or
remapped after a reset.  This fixes queue reset failures
on APUs.

v2: preserve init and remap for MMIO case.

Fixes: b3e9bfd86658 ("drm/amdgpu/gfx11: add ring reset callbacks")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4789
Reviewed-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit b340ff216fdabfe71ba0cdd47e9835a141d08e10)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -6821,11 +6821,12 @@ static int gfx_v11_0_reset_kgq(struct am
 			       struct amdgpu_fence *timedout_fence)
 {
 	struct amdgpu_device *adev = ring->adev;
+	bool use_mmio = false;
 	int r;
 
 	amdgpu_ring_reset_helper_begin(ring, timedout_fence);
 
-	r = amdgpu_mes_reset_legacy_queue(ring->adev, ring, vmid, false);
+	r = amdgpu_mes_reset_legacy_queue(ring->adev, ring, vmid, use_mmio);
 	if (r) {
 
 		dev_warn(adev->dev, "reset via MES failed and try pipe reset %d\n", r);
@@ -6834,16 +6835,18 @@ static int gfx_v11_0_reset_kgq(struct am
 			return r;
 	}
 
-	r = gfx_v11_0_kgq_init_queue(ring, true);
-	if (r) {
-		dev_err(adev->dev, "failed to init kgq\n");
-		return r;
-	}
+	if (use_mmio) {
+		r = gfx_v11_0_kgq_init_queue(ring, true);
+		if (r) {
+			dev_err(adev->dev, "failed to init kgq\n");
+			return r;
+		}
 
-	r = amdgpu_mes_map_legacy_queue(adev, ring);
-	if (r) {
-		dev_err(adev->dev, "failed to remap kgq\n");
-		return r;
+		r = amdgpu_mes_map_legacy_queue(adev, ring);
+		if (r) {
+			dev_err(adev->dev, "failed to remap kgq\n");
+			return r;
+		}
 	}
 
 	return amdgpu_ring_reset_helper_end(ring, timedout_fence);


