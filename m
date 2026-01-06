Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC802135D7;
	Tue,  6 Jan 2026 18:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722489; cv=none; b=Nmj+3KrgZNN01nACFHnR8u/fazpfGfM6HY7BSbiuIsQdmrzYPV3GbzMQDSkXKGB9TWsvoQDCPccqhCzKqvh6/i6XVdHQlKD6PZM518q94IagoS717EiS4M3qGp0+OirwqxUBxKDjwLaNtP1ym2xsR75Sq00LwJKM6NBm2gUV30s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722489; c=relaxed/simple;
	bh=0C3/bEdU0le9t7WBsvFggsYkYk/R7Ba686SwW5rai9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m+IBBU64HampCJWAidXhIX1sksnuTttX/KamQY/gVL15nCFHak7gVZYcWWZ4mrwygTje/ma3nJE/Zp4vjG8UTZiQNrWiBUp95a+b9g79O3hLSwSyx9tNnLbCj7K2HG3AlWTI2bCoMEFdAXJTlJnuBnQtpilNQRxZ6WOzt/iSpoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fC5pKzAV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fC5pKzAV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E034C116C6;
	Tue,  6 Jan 2026 18:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722488;
	bh=0C3/bEdU0le9t7WBsvFggsYkYk/R7Ba686SwW5rai9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fC5pKzAVWGyeOhqJHEwm0H8xkPwhOQr/qVmT6u4oSQ5HWj5YXCR6FEdOUBWaldz27
	 sC8RMscSlUkEiXnt4FXns0+6N+hC5auFTAhKKLpOTBaw9yiLqbWrpn4Ujd19T/Mf4v
	 Mw3Zse5XJhCU3I2TXsZYSYIOgqdTntr5TtD/ebgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 280/312] drm/amd: Fix unbind/rebind for VCN 4.0.5
Date: Tue,  6 Jan 2026 18:05:54 +0100
Message-ID: <20260106170557.982350577@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello (AMD) <superm1@kernel.org>

commit 93a01629c8bfd30906c76921ec986802d76920c6 upstream.

Unbinding amdgpu has no problems, but binding it again leads to an
error of sysfs file already existing.  This is because it wasn't
actually cleaned up on unbind.  Add the missing cleanup step.

Fixes: 547aad32edac ("drm/amdgpu: add VCN4 ip block support")
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit d717e62e9b6ccff0e3cec78a58dfbd00858448b3)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c
@@ -265,6 +265,8 @@ static int vcn_v4_0_5_sw_fini(struct amd
 	if (amdgpu_sriov_vf(adev))
 		amdgpu_virt_free_mm_table(adev);
 
+	amdgpu_vcn_sysfs_reset_mask_fini(adev);
+
 	for (i = 0; i < adev->vcn.num_vcn_inst; i++) {
 		r = amdgpu_vcn_suspend(adev, i);
 		if (r)


