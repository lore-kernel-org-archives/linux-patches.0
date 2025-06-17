Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A48E1E8332;
	Tue, 17 Jun 2025 15:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174417; cv=none; b=uarxBfqp22MNyV1yqbF3Yhk274YxZu3/Bslb0JQQj7rj7bkPoQe+45g2BkP8XZ1+I2Xux9GQrEhrAGt+9bcw3tQFca8MGBikCUmSU8MEai9vD6JF3ZSzdr/KdweaD3umdGEMb6i6703VQ+reuWMdiFhug/oUYhdTl+pwboQv7fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174417; c=relaxed/simple;
	bh=DSCtUuEd+Y3Q14Exa79xiF2i1CzwFVscAIzTL4yIDQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PJrVCnQ0Y6ggO+OlIe4FlkhmvKsNcHOC/7KgTSQYANXxCJG2GFOaLmCEN3VDUTuc5aWhSEpqUoeRp9PTWAe/0Ki+EkvZ2htmTx4QdapVklAolbYbHLDMI+YU/oO2XHRp1Fadzze0c5Ys3EECXX4ajhwpOLXCv89RZzhAbwifd6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NlU2SO0i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NlU2SO0i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2659C4CEE7;
	Tue, 17 Jun 2025 15:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174417;
	bh=DSCtUuEd+Y3Q14Exa79xiF2i1CzwFVscAIzTL4yIDQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NlU2SO0iZF79kyYGrdPv5uCGpTgqC4wj3M/b0e9StE6H3YhNzmJKBCjbWFaTFiYLd
	 Vfiz/vLP6qz1bPJ4GSQPzOi+I89hbG1bRUgiEFp0btGR2G+Q0in+n1BuOC6YgA+vZE
	 Nc9jvqptVpB021aQ0YAwzwPDCwKI73aJJjl0YgrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 057/356] drm/amd/pp: Fix potential NULL pointer dereference in atomctrl_initialize_mc_reg_table
Date: Tue, 17 Jun 2025 17:22:52 +0200
Message-ID: <20250617152340.529837483@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Han <hanchunchao@inspur.com>

[ Upstream commit 820116a39f96bdc7d426c33a804b52f53700a919 ]

The function atomctrl_initialize_mc_reg_table() and
atomctrl_initialize_mc_reg_table_v2_2() does not check the return
value of smu_atom_get_data_table(). If smu_atom_get_data_table()
fails to retrieve vram_info, it returns NULL which is later
dereferenced.

Fixes: b3892e2bb519 ("drm/amd/pp: Use atombios api directly in powerplay (v2)")
Fixes: 5f92b48cf62c ("drm/amd/pm: add mc register table initialization")
Signed-off-by: Charles Han <hanchunchao@inspur.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c
index 1fbd23922082a..7e37354a03411 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c
@@ -144,6 +144,10 @@ int atomctrl_initialize_mc_reg_table(
 	vram_info = (ATOM_VRAM_INFO_HEADER_V2_1 *)
 		smu_atom_get_data_table(hwmgr->adev,
 				GetIndexIntoMasterTable(DATA, VRAM_Info), &size, &frev, &crev);
+	if (!vram_info) {
+		pr_err("Could not retrieve the VramInfo table!");
+		return -EINVAL;
+	}
 
 	if (module_index >= vram_info->ucNumOfVRAMModule) {
 		pr_err("Invalid VramInfo table.");
@@ -181,6 +185,10 @@ int atomctrl_initialize_mc_reg_table_v2_2(
 	vram_info = (ATOM_VRAM_INFO_HEADER_V2_2 *)
 		smu_atom_get_data_table(hwmgr->adev,
 				GetIndexIntoMasterTable(DATA, VRAM_Info), &size, &frev, &crev);
+	if (!vram_info) {
+		pr_err("Could not retrieve the VramInfo table!");
+		return -EINVAL;
+	}
 
 	if (module_index >= vram_info->ucNumOfVRAMModule) {
 		pr_err("Invalid VramInfo table.");
-- 
2.39.5



