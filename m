Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D631D13EFE9;
	Tue, 27 Feb 2024 13:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040837; cv=none; b=Edc7ReXE7XqJkOY7hAqyfkxbob1CL+QHZbvoIzN9eLjwxupOIF9MCQdxInsOi+VJk2A8lGEUJDg3uOs7O92viLhaSUQ2jbi+tlftQEc2snGHI1ssjWzrAis8eBYB5d3qnLyDJfscvj8mD7rYAsCyw1qj8Cr7O/Pnt5JMsjO0Lno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040837; c=relaxed/simple;
	bh=XF5Id+bYxlW+zMf5mQguS/mM/EayStkXhChWj1f+DSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l7ng0Hyjl9jVnppgyimXURPY3BslR0DouK8HKieFElZKLljD6vlHoUxN4gH/PNDF1x6Pm+L8pvAOcDzS/jR9nHileXOsvW1dm1QGKNd0AbwPX1TS9UYS1nZKcduR12w+konFc+9nK/1V0QKn2F/w6Wh4UfNNuGN4Olu1Qv0JwTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W++7k+sr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W++7k+sr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62DB7C43399;
	Tue, 27 Feb 2024 13:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040837;
	bh=XF5Id+bYxlW+zMf5mQguS/mM/EayStkXhChWj1f+DSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W++7k+srUq7isAcEooIeInFa6BaNAhvhFqPYy4PgJ0oixBbdKeVbjnxtMN5fgbxQ5
	 igWKiu2glL0PVi8ciEy8MITGi1hU9qXvyDLGO7qmfNY30snIaKEI5HdgVhEFPPGsWw
	 +bzfM9s/btboJY8fZ4P0wfcA+aoFKtFgjrKy9+0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 127/334] drm/amdgpu: Fix HDP flush for VFs on nbio v7.9
Date: Tue, 27 Feb 2024 14:19:45 +0100
Message-ID: <20240227131634.562567917@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 25a3da83e0fb9..db013f86147a1 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c
@@ -431,6 +431,12 @@ static void nbio_v7_9_init_registers(struct amdgpu_device *adev)
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



