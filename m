Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDAC71C6F51;
	Tue, 27 Aug 2024 15:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771733; cv=none; b=S2J0YfTwas4uTxJ7aESBnRfmuKO5eGLGjH0ypG3jxUgMozaeer+sLso7nTN51elp9cfjvErH+kSuYTWztUUSUOn9s5wCfXfl9iNMg68Fs3Gt83kXVeXqW46Qe5XlyAUpsXazgFx9o5jMdQuEiosKd/+2dUbIQb5hUt/EQTKfnrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771733; c=relaxed/simple;
	bh=GbehYxQN3TerK1eCeo/Vzx5cXzjcwRI8gdeuU84wLSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WNxCszlZEhMEbpasmapI3baRHloM7UgE/TS7TqUu9iHa81UtKX42udWKQlsTDwfLT+ZYt3XOlnV+2LwNB9ujfNyEK6pOZl2q6BNyAOSMvEkTp2qdo7aRYETdI7Zj/Ol8uxqKEsxQ8pXe8x2OYIstawyKNRus/YdA46gD6zsWe20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GB9mDcwd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GB9mDcwd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BCBDC4DDFF;
	Tue, 27 Aug 2024 15:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771732;
	bh=GbehYxQN3TerK1eCeo/Vzx5cXzjcwRI8gdeuU84wLSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GB9mDcwd/pEGjcFucbpaUku+au9xk0tiA15r6GHPG3qCT058kqzx1VAvCVd2A1by3
	 e3TRuApkMi898PSOAGiWuqI9bofi57f5WRr/A0knwno56rQ1N+b26hTkNSlaXwOkZY
	 e/Smec+sIQWgXKHO309Y9XQl9gGCJam9NiGgDt+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boyuan Zhang <boyuan.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.10 270/273] drm/amdgpu/vcn: not pause dpg for unified queue
Date: Tue, 27 Aug 2024 16:39:54 +0200
Message-ID: <20240827143843.673056202@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
@@ -393,7 +393,9 @@ static void amdgpu_vcn_idle_work_handler
 		for (i = 0; i < adev->vcn.num_enc_rings; ++i)
 			fence[j] += amdgpu_fence_count_emitted(&adev->vcn.inst[j].ring_enc[i]);
 
-		if (adev->pg_flags & AMD_PG_SUPPORT_VCN_DPG)	{
+		/* Only set DPG pause for VCN3 or below, VCN4 and above will be handled by FW */
+		if (adev->pg_flags & AMD_PG_SUPPORT_VCN_DPG &&
+		    !adev->vcn.using_unified_queue) {
 			struct dpg_pause_state new_state;
 
 			if (fence[j] ||
@@ -439,7 +441,9 @@ void amdgpu_vcn_ring_begin_use(struct am
 	amdgpu_device_ip_set_powergating_state(adev, AMD_IP_BLOCK_TYPE_VCN,
 	       AMD_PG_STATE_UNGATE);
 
-	if (adev->pg_flags & AMD_PG_SUPPORT_VCN_DPG)	{
+	/* Only set DPG pause for VCN3 or below, VCN4 and above will be handled by FW */
+	if (adev->pg_flags & AMD_PG_SUPPORT_VCN_DPG &&
+	    !adev->vcn.using_unified_queue) {
 		struct dpg_pause_state new_state;
 
 		if (ring->funcs->type == AMDGPU_RING_TYPE_VCN_ENC) {
@@ -465,8 +469,12 @@ void amdgpu_vcn_ring_begin_use(struct am
 
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


