Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B01A2210EA;
	Thu, 12 Dec 2024 15:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018239; cv=none; b=IY3VJYLJiBDoN6NARlY0lF5CYqsnZVBKfP3tRJT01uwel694+IuLtMivSTs7VPG2FpethQmQdGoDvGTQoOG1k+cKNMea8WulZJlY51FKdlJFvBeqyQ859N8eqYlgQh0S8SvmznMBCQPtQzdHJEP2gLYxDxNjlcN/owxZS/pGB38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018239; c=relaxed/simple;
	bh=WPx0SJocVD4NIrPSFGBQEAVpFA9DUCbcgsTIjLWrs4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mD1qXyT9PGZg4B9cBiiLdtd2VizvbeCChESdXLpg/0YJONmy8shaWRTSGL6p1CIdJ7UMu/O6cAm4zrRhWK7PVgzoGfHKoshiaiHuoznukdasOu/RSjqbq51+cIe6R9B9QccuaaE0vZrAftBRg7Codc3A1g5FFJtk1JlOM0xZmaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iPGJcDUF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iPGJcDUF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5686AC4CED4;
	Thu, 12 Dec 2024 15:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018238;
	bh=WPx0SJocVD4NIrPSFGBQEAVpFA9DUCbcgsTIjLWrs4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iPGJcDUFRVG339sScIRtRfR82J/ad9hNQQ07xzn6teNaSxaHrMb1dg1flVJgfDu5u
	 W0/hKaLP0zWyPOVZRGuxXqV7Pu5NdZ04A4HYbq4Lxvqbl9gakneclRq2Z5KUSBHSSF
	 rJGc/jLmP5/pyrFp82Kt0g+hid4drFTTS3oPcHIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Victor Lu <victorchengchi.lu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 238/356] drm/amdgpu: clear RB_OVERFLOW bit when enabling interrupts for vega20_ih
Date: Thu, 12 Dec 2024 15:59:17 +0100
Message-ID: <20241212144254.018021402@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

From: Victor Lu <victorchengchi.lu@amd.com>

[ Upstream commit 8b22f048331dfd45fdfbf0efdfb1d43deff7518d ]

Port this change to vega20_ih.c:
commit afbf7955ff01 ("drm/amdgpu: clear RB_OVERFLOW bit when enabling interrupts")

Original commit message:
"Why:
Setting IH_RB_WPTR register to 0 will not clear the RB_OVERFLOW bit
if RB_ENABLE is not set.

How to fix:
Set WPTR_OVERFLOW_CLEAR bit after RB_ENABLE bit is set.
The RB_ENABLE bit is required to be set, together with
WPTR_OVERFLOW_ENABLE bit so that setting WPTR_OVERFLOW_CLEAR bit
would clear the RB_OVERFLOW."

Signed-off-by: Victor Lu <victorchengchi.lu@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vega20_ih.c | 27 ++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/vega20_ih.c b/drivers/gpu/drm/amd/amdgpu/vega20_ih.c
index 131e7b769519c..8ab2011e82098 100644
--- a/drivers/gpu/drm/amd/amdgpu/vega20_ih.c
+++ b/drivers/gpu/drm/amd/amdgpu/vega20_ih.c
@@ -114,6 +114,33 @@ static int vega20_ih_toggle_ring_interrupts(struct amdgpu_device *adev,
 	tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, RB_ENABLE, (enable ? 1 : 0));
 	tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, RB_GPU_TS_ENABLE, 1);
 
+	if (enable) {
+		/* Unset the CLEAR_OVERFLOW bit to make sure the next step
+		 * is switching the bit from 0 to 1
+		 */
+		tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, WPTR_OVERFLOW_CLEAR, 0);
+		if (amdgpu_sriov_vf(adev) && amdgpu_sriov_reg_indirect_ih(adev)) {
+			if (psp_reg_program(&adev->psp, ih_regs->psp_reg_id, tmp))
+				return -ETIMEDOUT;
+		} else {
+			WREG32_NO_KIQ(ih_regs->ih_rb_cntl, tmp);
+		}
+
+		/* Clear RB_OVERFLOW bit */
+		tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, WPTR_OVERFLOW_CLEAR, 1);
+		if (amdgpu_sriov_vf(adev) && amdgpu_sriov_reg_indirect_ih(adev)) {
+			if (psp_reg_program(&adev->psp, ih_regs->psp_reg_id, tmp))
+				return -ETIMEDOUT;
+		} else {
+			WREG32_NO_KIQ(ih_regs->ih_rb_cntl, tmp);
+		}
+
+		/* Unset the CLEAR_OVERFLOW bit immediately so new overflows
+		 * can be detected.
+		 */
+		tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, WPTR_OVERFLOW_CLEAR, 0);
+	}
+
 	/* enable_intr field is only valid in ring0 */
 	if (ih == &adev->irq.ih)
 		tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, ENABLE_INTR, (enable ? 1 : 0));
-- 
2.43.0



