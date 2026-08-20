Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A0E2417DE;
	Thu, 20 Aug 2026 15:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238098; cv=none; b=CcL9fZxWn8urciyxU1S2y9/hLqABAguo+1wY+LXxuUWnX8RnihiLHR6tSRpgL/xY037zPGcyrk5PaeUM5r4f4U0Jyw2ZKxD+LOUJinITZ/Q9pAPSAlvTlSPdgymUEGAXY5Au23tQ41SFvbFgdCC5vPZBD+JJJFWabr1NW3SFUIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238098; c=relaxed/simple;
	bh=7AtWUvVk64RY47KQ/nrnewS7dCuCwEMfUG8uVZ4sggE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U1idKc6qMWgipiYYkOYWxaEceY8FEzGTv1xzTQyPn36pt0lGFVdE8oI3GN49RFiY5o9cOCSvvmrJ8amAOpzSKoVqZ2+DQnEVRI3kEjlYVLCNa1Nh6Y8eG7T7LOuviXpoX2sfvIbnMK5WFocefrVY8S15xsS1iyUf9Uf0axxDfRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zyaqOlf7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zyaqOlf7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 387B91F000E9;
	Thu, 20 Aug 2026 15:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238096;
	bh=QXPyZytessncsXkaSRCbSqoHtteI2Eq/NTFH3P41zig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zyaqOlf7MSWw8rRPh4kb+d47rBhOH6zbDspoRwU0Hsz9p9Qt47k84UKOJuIJk/eiA
	 b7hRm5FP+XOeVQDBSiIKlu6E3dByCfhTDGLGStARDIfQ9cFcGHR/KuiYFCqF4lRk01
	 S9F03VHuNChsIDjEWnXttImV2vkgZopti9zoXSt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 032/228] drm/amdgpu: Use virtual alloc during coredump
Date: Thu, 20 Aug 2026 16:52:54 +0200
Message-ID: <20260820145245.436189655@linuxfoundation.org>
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

From: Lijo Lazar <lijo.lazar@amd.com>

commit b88a5a43c070df46939de419663d4679b90caf2f upstream.

The number of rings with outstanding fences can be large, requiring a
bigger allocation. Such allocations don't need to be physically
contiguous, so use kvzalloc/kvcalloc which fall back to vmalloc when
contiguous memory isn't available. This also matches the existing
kvfree used to free these allocations.

Also guard the allocation with ring_count to avoid passing 0 size to
allocation routines.

Fixes: eea85914d15b ("drm/amdgpu: save ring content before resetting the device")
Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 74d48bd6b7e12eba65de0507475b059966685ad1)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_dev_coredump.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_dev_coredump.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_dev_coredump.c
@@ -513,7 +513,7 @@ void amdgpu_coredump(struct amdgpu_devic
 	if (job && job->pasid)
 		size += sizeof(struct amdgpu_coredump_ib_info) * job->num_ibs;
 
-	coredump = kzalloc(size, GFP_NOWAIT);
+	coredump = kvzalloc(size, GFP_NOWAIT);
 	if (!coredump)
 		return;
 
@@ -556,8 +556,12 @@ void amdgpu_coredump(struct amdgpu_devic
 		total_ring_size += ring->ring_size;
 		ring_count++;
 	}
-	coredump->rings_dw = kzalloc(total_ring_size, GFP_NOWAIT);
-	coredump->rings = kcalloc(ring_count, sizeof(struct amdgpu_coredump_ring), GFP_NOWAIT);
+	if (ring_count) {
+		coredump->rings_dw = kvzalloc(total_ring_size, GFP_NOWAIT);
+		coredump->rings = kvcalloc(ring_count,
+					   sizeof(struct amdgpu_coredump_ring),
+					   GFP_NOWAIT);
+	}
 	if (coredump->rings && coredump->rings_dw) {
 		for (i = 0, off = 0, idx = 0; i < adev->num_rings && idx < ring_count; i++) {
 			ring = adev->rings[i];


