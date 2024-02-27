Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8F6143C75;
	Tue, 27 Feb 2024 13:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041918; cv=none; b=UIHynDWccFF+yTfvmyuq6phqjxMxB7xLtwR+UMwG9ti9mFzOG/E73L2sSlqxmWMlk7hDT4MrvTlqu9zKvWL50TErusNhKGiYwIgJ48XYDNLAe1f2uW6npafa3fiHFwcvKsePsLWHFihxsjouRenDzrxXJt3fbG9yIfHeG0ZAqZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041918; c=relaxed/simple;
	bh=KxsuNYdkDIOh8vasdPy7cQUO+9S2Ff7jieYYjLFOBqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L19ZTUNNjwhta4QbffurFzzhUEyoFvxvnWXvHgZH/cFLi8FgkwSmK1B681v4TqB9z8bXFgmDKypnfBJNdjxxYpGUU+GLpkypuJnYFDKLV66y/HiocC9qJNMbCDt0d5LkV1ZT+xJO6ZK0dw1fWwcrOHoS9uWqVBGtqKXyxLyChm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ebd2pUOq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ebd2pUOq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96B1C433F1;
	Tue, 27 Feb 2024 13:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041918;
	bh=KxsuNYdkDIOh8vasdPy7cQUO+9S2Ff7jieYYjLFOBqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ebd2pUOqEE6WHdQyXZdFKYFgo64H6qcz8XvxGigiR6G1hpyfLDXmMzqB6jzP/PFld
	 kuNIoJR4/mjF608XAMetOiMXhj2oe9lcHVnYOGJ1mIKm68+wbssjIS3+yaGA3NuDen
	 vYBiEiRO3N3d8M3A2HnTq87F47aSODNWnnqJ3dis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 114/299] drm/amdgpu: Fix HDP flush for VFs on nbio v7.9
Date: Tue, 27 Feb 2024 14:23:45 +0100
Message-ID: <20240227131629.538897172@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 534c8a5b9d5d41d30cdcac93cfa1bca5e17be009 ]

HDP flush remapping is not done for VFs. Keep the original offsets in VF
environment.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c b/drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c
index ae45656eb8779..0a601336cf697 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c
@@ -426,6 +426,12 @@ static void nbio_v7_9_init_registers(struct amdgpu_device *adev)
 	u32 inst_mask;
 	int i;
 
+	if (amdgpu_sriov_vf(adev))
+		adev->rmmio_remap.reg_offset =
+			SOC15_REG_OFFSET(
+				NBIO, 0,
+				regBIF_BX_DEV0_EPF0_VF0_HDP_MEM_COHERENCY_FLUSH_CNTL)
+			<< 2;
 	WREG32_SOC15(NBIO, 0, regXCC_DOORBELL_FENCE,
 		0xff & ~(adev->gfx.xcc_mask));
 
-- 
2.43.0



