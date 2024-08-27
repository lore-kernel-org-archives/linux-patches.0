Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8CA1A072D;
	Tue, 27 Aug 2024 15:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772714; cv=none; b=s7D7wZXUqB8rbbDqsc/rCQH6aYOWNd7gGfH8oYcaFnnrCVaBFNRgdbStbZ51qFMVRL7/wqJxXgGq9Bc/XA39aE7zR5TEFC425CPPFjNXhw64ryEj83LvZQEKKvnbPE5isT+2ftB0UN7XRWjlBjSaw2X1MoZsyc2iquxKzXc+6DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772714; c=relaxed/simple;
	bh=4YN+fB7sCx+pTF3HPzrU8Jc4/dnRPLxsd1UKdjvz510=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EzZJ1LEXwjQgaiyLBuTYRXBp/kTn2bJGcCbY3NLoD8L+aATSWeiV92xVWZOWB+b0nAsp9YdukX1IZr2gTEjMcWbvqehymWXFa5WdM0Ol8H2Nte1mqRr0ADoZPOMU2WvQNYtNDF7I440K87Tu+kOinAymFO6gEi5K0EAsV3SK/5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OW2BqkWk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OW2BqkWk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44FFC4DDF1;
	Tue, 27 Aug 2024 15:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772714;
	bh=4YN+fB7sCx+pTF3HPzrU8Jc4/dnRPLxsd1UKdjvz510=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OW2BqkWkcN6m6Dcf9YihSKoywn280ev2caN63o3LTEsthnXxUEuyVKwvWNI42oRc5
	 L3WQ0SjXwOh+aheVamCC3GcGflE/XSUypMtevsZdrl2EqMIBs5lSsIdLeV8+gUIiOS
	 gMPBoWMQz5jrJ4yv8DD7bWcCsHj2m8YexjF1MeGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boyuan Zhang <boyuan.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.1 297/321] drm/amdgpu/vcn: not pause dpg for unified queue
Date: Tue, 27 Aug 2024 16:40:05 +0200
Message-ID: <20240827143849.562784696@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -472,7 +472,9 @@ static void amdgpu_vcn_idle_work_handler
 			fence[j] += amdgpu_fence_count_emitted(&adev->vcn.inst[j].ring_enc[i]);
 		}
 
-		if (adev->pg_flags & AMD_PG_SUPPORT_VCN_DPG)	{
+		/* Only set DPG pause for VCN3 or below, VCN4 and above will be handled by FW */
+		if (adev->pg_flags & AMD_PG_SUPPORT_VCN_DPG &&
+		    !adev->vcn.using_unified_queue) {
 			struct dpg_pause_state new_state;
 
 			if (fence[j] ||
@@ -518,7 +520,9 @@ void amdgpu_vcn_ring_begin_use(struct am
 	amdgpu_device_ip_set_powergating_state(adev, AMD_IP_BLOCK_TYPE_VCN,
 	       AMD_PG_STATE_UNGATE);
 
-	if (adev->pg_flags & AMD_PG_SUPPORT_VCN_DPG)	{
+	/* Only set DPG pause for VCN3 or below, VCN4 and above will be handled by FW */
+	if (adev->pg_flags & AMD_PG_SUPPORT_VCN_DPG &&
+	    !adev->vcn.using_unified_queue) {
 		struct dpg_pause_state new_state;
 
 		if (ring->funcs->type == AMDGPU_RING_TYPE_VCN_ENC) {
@@ -544,8 +548,12 @@ void amdgpu_vcn_ring_begin_use(struct am
 
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


