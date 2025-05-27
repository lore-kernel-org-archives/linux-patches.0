Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC47280030;
	Tue, 27 May 2025 17:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367129; cv=none; b=T36eDo4mlkMuHDDOcZpJPI/pIOGcvkQkBf6lRoq2ZEFEHkP3cNFNpuLUASN1Gk/tRl3+uEhNOtjhBKGtWrRGuJnuWov6Cm09VrpYVDyUYKn6gOSg6ttyjmc2jO2QlfGxQLLh55JomdsNJ9o+jwp+UauB9aSVXfB18aDr3752l7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367129; c=relaxed/simple;
	bh=OdG1MfHpfPdkO8L6XF9CD4R6SiKwfaiQIm9b7jNgWFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o5xA69bcetOwBZe9NOcamaGGSrnUtwTrQOFeigwh/Npyof2AXftzgCRRFFPeLUSKbb/U0R0CO5RE3t76jc3B1HaJM8l2EXY2frDPQp579Ez2asarlzXl1tTElLgTJqIZ4wAP23H77ZIYaLyuG3NwygDcMxZhmX4RTITj7DZTu6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=02rdC6ig; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="02rdC6ig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C64DC4CEEB;
	Tue, 27 May 2025 17:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367128;
	bh=OdG1MfHpfPdkO8L6XF9CD4R6SiKwfaiQIm9b7jNgWFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=02rdC6iglruWEmtv0Jw8mczmGRmOsquHLnOYczB8vnpsX0iHxHG5iwQZn5couT6Mo
	 4ozemF8JYJH5Elh8PRmABaZTOURflthuz+Ic53JeQpZysdcq9Mx06ouDymwDEbwLl/
	 o5ciOsA90QW2DhrX2Dte+LnjNmj/ctWYqet31gfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 280/783] drm/amdgpu: Reinit FW shared flags on VCN v5.0.1
Date: Tue, 27 May 2025 18:21:17 +0200
Message-ID: <20250527162524.487088349@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 6ef5ccaad76d907d4257f20de992f89c0f7a7f8e ]

After a full device reset, shared memory region will clear out and it's
not possible to reliably save the region in case of RAS errors.
Reinitialize the flags if required.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c | 28 ++++++++++++++++++-------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c b/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c
index 8b0b3739a5377..cdbc10d7c9fb7 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c
@@ -65,6 +65,22 @@ static int vcn_v5_0_1_early_init(struct amdgpu_ip_block *ip_block)
 	return amdgpu_vcn_early_init(adev);
 }
 
+static void vcn_v5_0_1_fw_shared_init(struct amdgpu_device *adev, int inst_idx)
+{
+	struct amdgpu_vcn5_fw_shared *fw_shared;
+
+	fw_shared = adev->vcn.inst[inst_idx].fw_shared.cpu_addr;
+
+	if (fw_shared->sq.is_enabled)
+		return;
+	fw_shared->present_flag_0 =
+		cpu_to_le32(AMDGPU_FW_SHARED_FLAG_0_UNIFIED_QUEUE);
+	fw_shared->sq.is_enabled = 1;
+
+	if (amdgpu_vcnfw_log)
+		amdgpu_vcn_fwlog_init(&adev->vcn.inst[inst_idx]);
+}
+
 /**
  * vcn_v5_0_1_sw_init - sw init for VCN block
  *
@@ -95,8 +111,6 @@ static int vcn_v5_0_1_sw_init(struct amdgpu_ip_block *ip_block)
 		return r;
 
 	for (i = 0; i < adev->vcn.num_vcn_inst; i++) {
-		volatile struct amdgpu_vcn5_fw_shared *fw_shared;
-
 		vcn_inst = GET_INST(VCN, i);
 
 		ring = &adev->vcn.inst[i].ring_enc[0];
@@ -111,12 +125,7 @@ static int vcn_v5_0_1_sw_init(struct amdgpu_ip_block *ip_block)
 		if (r)
 			return r;
 
-		fw_shared = adev->vcn.inst[i].fw_shared.cpu_addr;
-		fw_shared->present_flag_0 = cpu_to_le32(AMDGPU_FW_SHARED_FLAG_0_UNIFIED_QUEUE);
-		fw_shared->sq.is_enabled = true;
-
-		if (amdgpu_vcnfw_log)
-			amdgpu_vcn_fwlog_init(&adev->vcn.inst[i]);
+		vcn_v5_0_1_fw_shared_init(adev, i);
 	}
 
 	/* TODO: Add queue reset mask when FW fully supports it */
@@ -188,6 +197,9 @@ static int vcn_v5_0_1_hw_init(struct amdgpu_ip_block *ip_block)
 				 9 * vcn_inst),
 				adev->vcn.inst[i].aid_id);
 
+		/* Re-init fw_shared, if required */
+		vcn_v5_0_1_fw_shared_init(adev, i);
+
 		r = amdgpu_ring_test_helper(ring);
 		if (r)
 			return r;
-- 
2.39.5



