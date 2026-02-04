Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD942DBF75;
	Wed,  4 Feb 2026 15:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219249; cv=none; b=LvhdsJuhD2Jr/8XuVou3czV+78KusVZPMwvG5Y3ilG8RK/Xr/mxEwUxyIGvT4Os8wYgGvP7U9t3guYsSMXmvkCzRYJ8vtsSoxV2CtcJTTZzZc1VMLEDxymKhVSunZR2Ei7w9dAFtRB993xmTz+D69mNJ5xkoiaFqW4FcmLxhEiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219249; c=relaxed/simple;
	bh=G72Npa8tZEWy3UthssYqi1JErU2CWWC7B3NvXsEW71g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U5iLwRjFcXnTLDDzdSMqZEn+iPAzrI4TMMPLnOLa7hTFRlTN7F9NE940Vh0/mCqNgPT6UddbRZgeFWJujziGt0Hdz6jp3JsBYWHxRkCFyhug98saEserjL6YgWXZeK5sF2vS4M4xst16vUwDcYAuE2uWqTVexDp4F12uwr0E7t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u1HnbfSx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u1HnbfSx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0BA3C116C6;
	Wed,  4 Feb 2026 15:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219249;
	bh=G72Npa8tZEWy3UthssYqi1JErU2CWWC7B3NvXsEW71g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u1HnbfSxzvYAVYluCm4pp9Lb3yShruvtneIvoKz+aZXG0XbFppn7gsqfcrAefktpg
	 x2G6W52tFTFXUXezUYjHO27erU8Wu9p7PO8xwCC0pvQbwKjq7VaBoN03InEh//jUwg
	 2EYH48ma5oTI4qDqNilsWx4xkGyczQSeK5lLXC84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 112/122] drm/amdgpu/gfx12: adjust KGQ reset sequence
Date: Wed,  4 Feb 2026 15:41:34 +0100
Message-ID: <20260204143855.883049930@linuxfoundation.org>
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

commit dfd64f6e8cd7b59238cdaf8af7a55711f13a89db upstream.

Kernel gfx queues do not need to be reinitialized or
remapped after a reset.  Align with gfx11.

v2: preserve init and remap for MMIO case.

Reviewed-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 0a6d6ed694d72b66b0ed7a483d5effa01acd3951)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
@@ -5296,11 +5296,12 @@ static int gfx_v12_0_reset_kgq(struct am
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
 		r = gfx_v12_reset_gfx_pipe(ring);
@@ -5308,16 +5309,18 @@ static int gfx_v12_0_reset_kgq(struct am
 			return r;
 	}
 
-	r = gfx_v12_0_kgq_init_queue(ring, true);
-	if (r) {
-		dev_err(adev->dev, "failed to init kgq\n");
-		return r;
-	}
+	if (use_mmio) {
+		r = gfx_v12_0_kgq_init_queue(ring, true);
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


