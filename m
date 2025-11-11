Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A9D343D73;
	Tue, 11 Nov 2025 01:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823186; cv=none; b=fWAEaRmyO2Qq1tEbz9ixIhCLJqbIAaDnSCJSRXiZNezQYCyGzhibKh2IT046jVdYDYXoZ68nkjmU2R4pquaEVg1+5AerOr5EGPanxBs/58pMvjinXEkLGUTHNe1pgJAFDADXbY3PkYjO02cSrNCmrlqtlpeeKlkdP0R4gvQsuQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823186; c=relaxed/simple;
	bh=MeEokvo1UgbKz9s89h9AIh/Uu00eiPDbKoFApAEQ/mQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lUnx6iijuTK03c3L8ppYlH/pAM4hpxN7+Wg24TlkXxsYfBdOhKgj+EmaVbx2fj10HYDaJHPM/Uq7dU8xnTJMOSXVQTUZHsMRuATxzUadQzFhxn/jgA62xqQJI+Mc6CAR6MeorGz7iDWANYz1THwXQbT+nQ3+oyQBaKfx6yeV5os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vE4T1nr0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vE4T1nr0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F06C116B1;
	Tue, 11 Nov 2025 01:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823186;
	bh=MeEokvo1UgbKz9s89h9AIh/Uu00eiPDbKoFApAEQ/mQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vE4T1nr0KHINUrG0BmzdirhrmblAK9sCqInWRTDx6YEqNtcVgtmfu6+zS0A7pBJBT
	 ZxutKgxegB6e6O8h/+2kxRyAYokbYVQLXnvLO/8X8xAHT1kQjhPqqnJHPD+rsn4l68
	 t+mtaqxrl20ULb7BL+f3Wxi2Mrp0GkMoi6h5UodM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Stanley.Yang" <Stanley.Yang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 249/849] drm/amdgpu: Fix vcn v5.0.1 poison irq call trace
Date: Tue, 11 Nov 2025 09:36:59 +0900
Message-ID: <20251111004542.452002209@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanley.Yang <Stanley.Yang@amd.com>

[ Upstream commit b1b29aa88f5367d0367c8eeef643635bc6009a9a ]

Why:
    [13014.890792] Call Trace:
    [13014.890793]  <TASK>
    [13014.890795]  ? show_trace_log_lvl+0x1d6/0x2ea
    [13014.890799]  ? show_trace_log_lvl+0x1d6/0x2ea
    [13014.890800]  ? vcn_v5_0_1_hw_fini+0xe9/0x110 [amdgpu]
    [13014.890872]  ? show_regs.part.0+0x23/0x29
    [13014.890873]  ? show_regs.cold+0x8/0xd
    [13014.890874]  ? amdgpu_irq_put+0xc6/0xe0 [amdgpu]
    [13014.890934]  ? __warn+0x8c/0x100
    [13014.890936]  ? amdgpu_irq_put+0xc6/0xe0 [amdgpu]
    [13014.890995]  ? report_bug+0xa4/0xd0
    [13014.890999]  ? handle_bug+0x39/0x90
    [13014.891001]  ? exc_invalid_op+0x19/0x70
    [13014.891003]  ? asm_exc_invalid_op+0x1b/0x20
    [13014.891005]  ? amdgpu_irq_put+0xc6/0xe0 [amdgpu]
    [13014.891065]  ? amdgpu_irq_put+0x63/0xe0 [amdgpu]
    [13014.891124]  vcn_v5_0_1_hw_fini+0xe9/0x110 [amdgpu]
    [13014.891189]  amdgpu_ip_block_hw_fini+0x3b/0x78 [amdgpu]
    [13014.891309]  amdgpu_device_fini_hw+0x3c1/0x479 [amdgpu]
How:
    Add omitted vcn poison irq get call.

Signed-off-by: Stanley.Yang <Stanley.Yang@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c | 10 +++++-----
 drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c  |  7 +++++++
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c
index 54523dc1f7026..03ec4b741d194 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c
@@ -1058,6 +1058,11 @@ static int jpeg_v5_0_1_ras_late_init(struct amdgpu_device *adev, struct ras_comm
 	if (r)
 		return r;
 
+	r = amdgpu_ras_bind_aca(adev, AMDGPU_RAS_BLOCK__JPEG,
+				&jpeg_v5_0_1_aca_info, NULL);
+	if (r)
+		goto late_fini;
+
 	if (amdgpu_ras_is_supported(adev, ras_block->block) &&
 		adev->jpeg.inst->ras_poison_irq.funcs) {
 		r = amdgpu_irq_get(adev, &adev->jpeg.inst->ras_poison_irq, 0);
@@ -1065,11 +1070,6 @@ static int jpeg_v5_0_1_ras_late_init(struct amdgpu_device *adev, struct ras_comm
 			goto late_fini;
 	}
 
-	r = amdgpu_ras_bind_aca(adev, AMDGPU_RAS_BLOCK__JPEG,
-				&jpeg_v5_0_1_aca_info, NULL);
-	if (r)
-		goto late_fini;
-
 	return 0;
 
 late_fini:
diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c b/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c
index d8bbb93767318..cb560d64da08c 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c
@@ -1608,6 +1608,13 @@ static int vcn_v5_0_1_ras_late_init(struct amdgpu_device *adev, struct ras_commo
 	if (r)
 		goto late_fini;
 
+	if (amdgpu_ras_is_supported(adev, ras_block->block) &&
+		adev->vcn.inst->ras_poison_irq.funcs) {
+		r = amdgpu_irq_get(adev, &adev->vcn.inst->ras_poison_irq, 0);
+		if (r)
+			goto late_fini;
+	}
+
 	return 0;
 
 late_fini:
-- 
2.51.0



