Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E9B1E9B3D;
	Thu,  3 Jul 2025 15:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555367; cv=none; b=T++eEiSCClv7l/npocFhw8QO0eLejLIGuSAfTNh9fXqNMrCtzk3Mk2JDeabZfe8ak3N7aSvtNCgTo2MgSIGOnluCP7zsmah6u7OaavA2NcApbqdKktOYhvJqBD0R0bM4MLRslJiFgf6qpsRNywdpZfujOOh21QUUmCPq9iJ3o+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555367; c=relaxed/simple;
	bh=Ghrrd0h/Xo8iFwFvh5Z69Py2u9uzaKoV57O6QOjHlp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V1fbxdC20zqW/klYaRyi1cJC7B97nyI5DUFvPdgRPjKr8VOIHoaoGtrOU4xUSyTPh7qjWogbFx8++HdVRCMd1wmxtNhQebPgUAmF/wec+8xbMAHAv6xNGJ5IFWd4mQ1inbboF0WVJp2bMknosHizOrsoce69eXPLmgjLbj2puJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rBEzDEZy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rBEzDEZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC157C4CEE3;
	Thu,  3 Jul 2025 15:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555367;
	bh=Ghrrd0h/Xo8iFwFvh5Z69Py2u9uzaKoV57O6QOjHlp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rBEzDEZySdDpKRTPvUTAgSJgYArM2qB90ta9ng+3b7sZweJZOH7/5a4dH0Lkq1AJb
	 SXMdV8HXmePkxr/b2a2IpmI8400SmcOE88wdL78S7ldm+kDJsNojiKFJ6KbAUD7pbU
	 n7OZsFJ+dYzmAODjx0hHd9pqIwBMxwKmBKeoEZdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sonny Jiang <sonny.jiang@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.15 227/263] drm/amdgpu: VCN v5_0_1 to prevent FW checking RB during DPG pause
Date: Thu,  3 Jul 2025 16:42:27 +0200
Message-ID: <20250703144013.492017851@linuxfoundation.org>
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

From: Sonny Jiang <sonny.jiang@amd.com>

commit 46e15197b513e60786a44107759d6ca293d6288c upstream.

Add a protection to ensure programming are all complete prior VCPU
starting. This is a WA for an unintended VCPU running.

Signed-off-by: Sonny Jiang <sonny.jiang@amd.com>
Acked-by: Leo Liu <leo.liu@amd.com>
Reviewed-by: Ruijing Dong <ruijing.dong@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c29521b529fa5e225feaf709d863a636ca0cbbfa)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c
@@ -629,6 +629,9 @@ static int vcn_v5_0_1_start_dpg_mode(str
 	if (indirect)
 		amdgpu_vcn_psp_update_sram(adev, inst_idx, AMDGPU_UCODE_ID_VCN0_RAM);
 
+	/* resetting ring, fw should not check RB ring */
+	fw_shared->sq.queue_mode |= FW_QUEUE_RING_RESET;
+
 	/* Pause dpg */
 	vcn_v5_0_1_pause_dpg_mode(vinst, &state);
 
@@ -641,7 +644,7 @@ static int vcn_v5_0_1_start_dpg_mode(str
 	tmp = RREG32_SOC15(VCN, vcn_inst, regVCN_RB_ENABLE);
 	tmp &= ~(VCN_RB_ENABLE__RB1_EN_MASK);
 	WREG32_SOC15(VCN, vcn_inst, regVCN_RB_ENABLE, tmp);
-	fw_shared->sq.queue_mode |= FW_QUEUE_RING_RESET;
+
 	WREG32_SOC15(VCN, vcn_inst, regUVD_RB_RPTR, 0);
 	WREG32_SOC15(VCN, vcn_inst, regUVD_RB_WPTR, 0);
 
@@ -652,6 +655,7 @@ static int vcn_v5_0_1_start_dpg_mode(str
 	tmp = RREG32_SOC15(VCN, vcn_inst, regVCN_RB_ENABLE);
 	tmp |= VCN_RB_ENABLE__RB1_EN_MASK;
 	WREG32_SOC15(VCN, vcn_inst, regVCN_RB_ENABLE, tmp);
+	/* resetting done, fw can check RB ring */
 	fw_shared->sq.queue_mode &= ~(FW_QUEUE_RING_RESET | FW_QUEUE_DPG_HOLD_OFF);
 
 	WREG32_SOC15(VCN, vcn_inst, regVCN_RB1_DB_CTRL,


