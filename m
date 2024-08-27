Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69AE31BA88C;
	Tue, 27 Aug 2024 14:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770795; cv=none; b=cySOgyPMesN5Df/eRIBfHsIiQww9Q7tkfMXQPWMRK8dg9H5UR2ducY4p8vstfKZJ76Mf1cS89K4jJRjDp8VbogDAXnvN6/koobigtccy/BFKc6gMbOT5EFD7js+dWNo+JpuYDlxrG7LHvPwyGxKsTiRD8FS6VznMoxCPxlP1GY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770795; c=relaxed/simple;
	bh=xdlhbcpGfW5BSkYEMOv1skEkKqU1hgGm7B1bn18J2cE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k16Nrv4/KQjuQtQAdhpnRtN20HdGAqCXwskMU2dH2iqACa8Yjl+lGvkZMuggXCHsXojREra7aCjm+muwPeTt96k8jA1jcZwpqPYh5d39e/663hUGNXDCGjCa8IGdAjZ26uaOnxBNhdSYL8L1FBiCHse7+hyGCbLUQaUdCdq4P/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p41GJlri; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p41GJlri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCCB5C4AF1C;
	Tue, 27 Aug 2024 14:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770795;
	bh=xdlhbcpGfW5BSkYEMOv1skEkKqU1hgGm7B1bn18J2cE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p41GJlriEFvtoO3QnE8wMw7rB2Z5NJcWagI+kEotTEAjP6ZMzO7S4qhwI4YcrLfKp
	 FO6fudq2WzKqGqBAPIcAovoH8OJu8aobE4+yRAfsrW6BWyKcJseazI7pC1ixdTJNJj
	 OTYxZL1gPIfQK6tcNuqf9WNpNoQbsklZs9CheX0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boyuan Zhang <boyuan.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.6 337/341] drm/amdgpu/vcn: not pause dpg for unified queue
Date: Tue, 27 Aug 2024 16:39:28 +0200
Message-ID: <20240827143856.218261387@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boyuan Zhang <boyuan.zhang@amd.com>

commit 7d75ef3736a025db441be652c8cc8e84044a215f upstream.

For unified queue, DPG pause for encoding is done inside VCN firmware,
so there is no need to pause dpg based on ring type in kernel.

For VCN3 and below, pausing DPG for encoding in kernel is still needed.

v2: add more comments
v3: update commit message

Signed-off-by: Boyuan Zhang <boyuan.zhang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Ruijing Dong <ruijing.dong@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
@@ -372,7 +372,9 @@ static void amdgpu_vcn_idle_work_handler
 		for (i = 0; i < adev->vcn.num_enc_rings; ++i)
 			fence[j] += amdgpu_fence_count_emitted(&adev->vcn.inst[j].ring_enc[i]);
 
-		if (adev->pg_flags & AMD_PG_SUPPORT_VCN_DPG)	{
+		/* Only set DPG pause for VCN3 or below, VCN4 and above will be handled by FW */
+		if (adev->pg_flags & AMD_PG_SUPPORT_VCN_DPG &&
+		    !adev->vcn.using_unified_queue) {
 			struct dpg_pause_state new_state;
 
 			if (fence[j] ||
@@ -418,7 +420,9 @@ void amdgpu_vcn_ring_begin_use(struct am
 	amdgpu_device_ip_set_powergating_state(adev, AMD_IP_BLOCK_TYPE_VCN,
 	       AMD_PG_STATE_UNGATE);
 
-	if (adev->pg_flags & AMD_PG_SUPPORT_VCN_DPG)	{
+	/* Only set DPG pause for VCN3 or below, VCN4 and above will be handled by FW */
+	if (adev->pg_flags & AMD_PG_SUPPORT_VCN_DPG &&
+	    !adev->vcn.using_unified_queue) {
 		struct dpg_pause_state new_state;
 
 		if (ring->funcs->type == AMDGPU_RING_TYPE_VCN_ENC) {
@@ -444,8 +448,12 @@ void amdgpu_vcn_ring_begin_use(struct am
 
 void amdgpu_vcn_ring_end_use(struct amdgpu_ring *ring)
 {
+	struct amdgpu_device *adev = ring->adev;
+
+	/* Only set DPG pause for VCN3 or below, VCN4 and above will be handled by FW */
 	if (ring->adev->pg_flags & AMD_PG_SUPPORT_VCN_DPG &&
-		ring->funcs->type == AMDGPU_RING_TYPE_VCN_ENC)
+	    ring->funcs->type == AMDGPU_RING_TYPE_VCN_ENC &&
+	    !adev->vcn.using_unified_queue)
 		atomic_dec(&ring->adev->vcn.inst[ring->me].dpg_enc_submission_cnt);
 
 	atomic_dec(&ring->adev->vcn.total_submission_cnt);


