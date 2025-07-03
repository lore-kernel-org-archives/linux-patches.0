Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CAC82B9A6;
	Thu,  3 Jul 2025 15:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555028; cv=none; b=N43yrm+P8s5SLhZXoKTJEgG0xPvj0DjTvAtn8b6GlvL7bCgVIcT8nlWMsREipCQpnhjMgHHQGus4PYHsQ7o14zI2XwTKP70DYfXD2CX53owe/Ngbib0wveWOqrqR+x83D2GdMkU39fxqryoLez9XFsnFEdyZES258SqcCj/XxAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555028; c=relaxed/simple;
	bh=yG18Dr5taKJKxPVplmBf14jWrWBiZOIYwW4XWTNP2GY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jrg5Ouxys+vR3Z+CraGRm3gnBUJourhUCvPqU8eungsfDwfeIQL/UOGSNoo+9A2BBfAv2T+FlXJ8ix9votT+GJSS3ZTTu8aB5OEdrkcZJrQMZimyM/Lczxkk9Pyvb4J4OPqdROwYlzjlTHFN4UBD7kuBzwemGXNx7YJNpCQv/L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aVxyR7+Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aVxyR7+Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5590AC4CEE3;
	Thu,  3 Jul 2025 15:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555027;
	bh=yG18Dr5taKJKxPVplmBf14jWrWBiZOIYwW4XWTNP2GY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aVxyR7+Y5MAS7pIsCKmrtqDClULwsrJ4zAxZ1huEFfIBB9S2v0OZO5rK8L86TOoW3
	 wUPkbXQ3N6p8V/I7iF6r83AxCGcHBU/pDb7fxOdAIeGvxGt2BQP50w1DUAb8JNKqz1
	 9pJJyQOv0B/e5SnEYMTc/HLr+EtqA6/E/nYN4wO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shaoyun Liu <shaoyun.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.15 126/263] drm/amdgpu/mes: add compatibility checks for set_hw_resource_1
Date: Thu,  3 Jul 2025 16:40:46 +0200
Message-ID: <20250703144009.408780724@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 99579c55c3d6132a5236926652c0a72a526b809d upstream.

Seems some older MES firmware versions do not properly support
this packet.  Add back some the compatibility checks.

v2: switch to fw version check (Shaoyun)

Fixes: f81cd793119e ("drm/amd/amdgpu: Fix MES init sequence")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4295
Cc: Shaoyun Liu <shaoyun.liu@amd.com>
Reviewed-by: shaoyun.liu <shaoyun.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 0180e0a5dd5c6ff118043ee42dbbbddaf881f283)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c |   10 ++++++----
 drivers/gpu/drm/amd/amdgpu/mes_v12_0.c |    3 ++-
 2 files changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
@@ -1649,10 +1649,12 @@ static int mes_v11_0_hw_init(struct amdg
 	if (r)
 		goto failure;
 
-	r = mes_v11_0_set_hw_resources_1(&adev->mes);
-	if (r) {
-		DRM_ERROR("failed mes_v11_0_set_hw_resources_1, r=%d\n", r);
-		goto failure;
+	if ((adev->mes.sched_version & AMDGPU_MES_VERSION_MASK) >= 0x50) {
+		r = mes_v11_0_set_hw_resources_1(&adev->mes);
+		if (r) {
+			DRM_ERROR("failed mes_v11_0_set_hw_resources_1, r=%d\n", r);
+			goto failure;
+		}
 	}
 
 	r = mes_v11_0_query_sched_status(&adev->mes);
--- a/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
@@ -1761,7 +1761,8 @@ static int mes_v12_0_hw_init(struct amdg
 	if (r)
 		goto failure;
 
-	mes_v12_0_set_hw_resources_1(&adev->mes, AMDGPU_MES_SCHED_PIPE);
+	if ((adev->mes.sched_version & AMDGPU_MES_VERSION_MASK) >= 0x4b)
+		mes_v12_0_set_hw_resources_1(&adev->mes, AMDGPU_MES_SCHED_PIPE);
 
 	mes_v12_0_init_aggregated_doorbell(&adev->mes);
 


