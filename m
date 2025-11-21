Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A66F346FB8;
	Fri, 21 Nov 2025 13:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731985; cv=none; b=qbQ5cQCv0hp4IOhR9/MoF4Pyavjh/ZNiVywSfJFFvtCS9FapWpxst8a4gG9w60f78kdnSWqItwd3eBVJCrVwkKcySAsN1WRjRT05W0fLNKsQXtKrZ7hWVJ+bbnAJJ0suXZCj4kYRX0ti1ey6cmJnEd5IyrsqsfHidpvGaA+8puI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731985; c=relaxed/simple;
	bh=dXC4bjubCXaFhu71+yKpbGuHVAtRah5vN4PEKyyjDV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gRJdynvPoGwvLJ352aByjxygBJM4tymeH+zytKSaqnmrUKYyYMqL/7eQYuG/9ZVzGuD4ypr0S0hvTPvatX3vXThw5OnShXy7BKfaS6Wv+eKGbd4hlLM+zeB0KAAKR2mHtanWK/F95kG1eLzs3RAzb2FGzscuhMKlGLf7Cusk6Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f3ifBvUp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f3ifBvUp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75BA8C4CEF1;
	Fri, 21 Nov 2025 13:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731984;
	bh=dXC4bjubCXaFhu71+yKpbGuHVAtRah5vN4PEKyyjDV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f3ifBvUpYKiBmbDnRunHQNO70L5kNo7pCZWnpnk39ENWr3H9HRrZuAAh9Qq4oKsHY
	 sBlnKKol/2pCwH+2yZpXpczrUnZ6JzpmnLEstSdxxgKb1NZWf7tqpvtNMGCAYfZ2UM
	 CzQLhNk51ykWClIkJq93VpwwPdvwuMDZhX1I2BSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 149/185] drm/amdgpu: disable peer-to-peer access for DCC-enabled GC12 VRAM surfaces
Date: Fri, 21 Nov 2025 14:12:56 +0100
Message-ID: <20251121130149.255982330@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaly Prosyak <vitaly.prosyak@amd.com>

commit 22a36e660d014925114feb09a2680bb3c2d1e279 upstream.

Certain multi-GPU configurations (especially GFX12) may hit
data corruption when a DCC-compressed VRAM surface is shared across GPUs
using peer-to-peer (P2P) DMA transfers.

Such surfaces rely on device-local metadata and cannot be safely accessed
through a remote GPU’s page tables. Attempting to import a DCC-enabled
surface through P2P leads to incorrect rendering or GPU faults.

This change disables P2P for DCC-enabled VRAM buffers that are contiguous
and allocated on GFX12+ hardware.  In these cases, the importer falls back
to the standard system-memory path, avoiding invalid access to compressed
surfaces.

Future work could consider optional migration (VRAM→System→VRAM) if a
performance regression is observed when `attach->peer2peer = false`.

Tested on:
 - Dual RX 9700 XT (Navi4x) setup
 - GNOME and Wayland compositor scenarios
 - Confirmed no corruption after disabling P2P under these conditions
v2: Remove check TTM_PL_VRAM & TTM_PL_FLAG_CONTIGUOUS.
v3: simplify for upsteam and fix ip version check (Alex)

Suggested-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 9dff2bb709e6fbd97e263fd12bf12802d2b5a0cf)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
@@ -81,6 +81,18 @@ static int amdgpu_dma_buf_attach(struct
 	struct amdgpu_bo *bo = gem_to_amdgpu_bo(obj);
 	struct amdgpu_device *adev = amdgpu_ttm_adev(bo->tbo.bdev);
 
+	/*
+	 * Disable peer-to-peer access for DCC-enabled VRAM surfaces on GFX12+.
+	 * Such buffers cannot be safely accessed over P2P due to device-local
+	 * compression metadata. Fallback to system-memory path instead.
+	 * Device supports GFX12 (GC 12.x or newer)
+	 * BO was created with the AMDGPU_GEM_CREATE_GFX12_DCC flag
+	 *
+	 */
+	if (amdgpu_ip_version(adev, GC_HWIP, 0) >= IP_VERSION(12, 0, 0) &&
+	    bo->flags & AMDGPU_GEM_CREATE_GFX12_DCC)
+		attach->peer2peer = false;
+
 	if (!amdgpu_dmabuf_is_xgmi_accessible(attach_adev, bo) &&
 	    pci_p2pdma_distance(adev->pdev, attach->dev, false) < 0)
 		attach->peer2peer = false;


