Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592D7396B75;
	Thu, 15 Jan 2026 16:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496296; cv=none; b=h31VEgZ2cAh71pLd6sG/sGK9ezJtde8kdlzPuLhONnJiF+Ir332diX9pJvOGu+5jMLG26DWGDrYyqknBFK0YEgEHlWzmsdca++7ZNJfdETtZh/O2pDYJBLJW5St1rMlDm17ZX57hoxExNsyMyRPbCN6l0xDcM8hYQbaMtZKNSt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496296; c=relaxed/simple;
	bh=MJ7wasB6lg4r70JRrC3UMjJ7dEK9x0RAVVOwlFNgx5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tWg5C7dYRRqcrCagfTJ8DKJ4MlU76d8tnJOTdRrjNJs4HuE+4JBJIeePKZPVzIboWTpFKplPOVke1v/fgdV9db4Bz3B+neXLxhfun39DR2xtWm07oC3hcevHC0VwnrqDrD6yf2LTJ1+821XpExGtr1xnVO7xP34WaGwBmwA8N4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ody9nuow; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ody9nuow"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCDCDC116D0;
	Thu, 15 Jan 2026 16:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496296;
	bh=MJ7wasB6lg4r70JRrC3UMjJ7dEK9x0RAVVOwlFNgx5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ody9nuowoIGUqW31khzng+QD+5Y5+ylekJjWwQngzcB+D+YrA2iZVblM4acT/GWcF
	 KUsavfsJZJX4QXhjNJwhSx/XrgZkWHCdR+tM+MzCAoi7PkL4rllXVtgGsb/gP0i5tT
	 SLxdRZuO+NfLvJLqX9zX0L6zufWP3+QeS7QJ0jLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 113/181] drm/amd/pm: force send pcie parmater on navi1x
Date: Thu, 15 Jan 2026 17:47:30 +0100
Message-ID: <20260115164206.395684108@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Yang Wang <kevinyang.wang@amd.com>

[ Upstream commit dc8a887de1a7d397ab4131f45676e89565417aa8 ]

v1:
the PMFW didn't initialize the PCIe DPM parameters
and requires the KMD to actively provide these parameters.

v2:
clean & remove unused code logic (lijo)

Fixes: 1a18607c07bb ("drm/amd/pm: override pcie dpm parameters only if it is necessary")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4671
Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit b0dbd5db7cf1f81e4aaedd25cb5e72ce369387b2)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c   | 33 +++++++++----------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
index d0fd9537e6236..a2fcf678182b4 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
@@ -2454,24 +2454,21 @@ static int navi10_update_pcie_parameters(struct smu_context *smu,
 	}
 
 	for (i = 0; i < NUM_LINK_LEVELS; i++) {
-		if (pptable->PcieGenSpeed[i] > pcie_gen_cap ||
-			pptable->PcieLaneCount[i] > pcie_width_cap) {
-			dpm_context->dpm_tables.pcie_table.pcie_gen[i] =
-									pptable->PcieGenSpeed[i] > pcie_gen_cap ?
-									pcie_gen_cap : pptable->PcieGenSpeed[i];
-			dpm_context->dpm_tables.pcie_table.pcie_lane[i] =
-									pptable->PcieLaneCount[i] > pcie_width_cap ?
-									pcie_width_cap : pptable->PcieLaneCount[i];
-			smu_pcie_arg = i << 16;
-			smu_pcie_arg |= dpm_context->dpm_tables.pcie_table.pcie_gen[i] << 8;
-			smu_pcie_arg |= dpm_context->dpm_tables.pcie_table.pcie_lane[i];
-			ret = smu_cmn_send_smc_msg_with_param(smu,
-							SMU_MSG_OverridePcieParameters,
-							smu_pcie_arg,
-							NULL);
-			if (ret)
-				break;
-		}
+		dpm_context->dpm_tables.pcie_table.pcie_gen[i] =
+			pptable->PcieGenSpeed[i] > pcie_gen_cap ?
+			pcie_gen_cap : pptable->PcieGenSpeed[i];
+		dpm_context->dpm_tables.pcie_table.pcie_lane[i] =
+			pptable->PcieLaneCount[i] > pcie_width_cap ?
+			pcie_width_cap : pptable->PcieLaneCount[i];
+		smu_pcie_arg = i << 16;
+		smu_pcie_arg |= dpm_context->dpm_tables.pcie_table.pcie_gen[i] << 8;
+		smu_pcie_arg |= dpm_context->dpm_tables.pcie_table.pcie_lane[i];
+		ret = smu_cmn_send_smc_msg_with_param(smu,
+						      SMU_MSG_OverridePcieParameters,
+						      smu_pcie_arg,
+						      NULL);
+		if (ret)
+			return ret;
 	}
 
 	return ret;
-- 
2.51.0



