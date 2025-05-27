Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0AEF25A323;
	Tue, 27 May 2025 17:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365516; cv=none; b=KeRI6NRNoFlOcTpyEcXtn1Q2d9Ifp9yXLWLurmjtx7O8M7/GvViXSrONjlVvWisLS5BbwoPZ0m0IIIAT8/NMrkO/YA8QrvNMR2FLlOKqibs1tPn44bO1RTN2vZgklt5+uxZtLM2PgnYNI7CEgN8dawM1abXwoIAvM14/YvAQyMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365516; c=relaxed/simple;
	bh=3wQLB1djwlESRWfexQdm2oOlTMNb09FgYwJ3qReJhS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uWpaZDpnpD98TxDppGNwdgGZBfyWecUiAXtRyAzISFFw6YRG/mWo+JRwlQJfbEAS8Im5pFAjtCUZeEVNl91riLfLVJzEi6L0OdKS7JS4WCzVsnK9lu5S1hWzLuBOLYin7zGmxTHTJZLPPdytUuQMzgO7SoD4ox3qCEAZWq9a2Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UBPAD94V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UBPAD94V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 106EBC4CEE9;
	Tue, 27 May 2025 17:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365516;
	bh=3wQLB1djwlESRWfexQdm2oOlTMNb09FgYwJ3qReJhS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UBPAD94VDjQKcZ/zq/bdsEN+8Lu5Z763ZBdKcUqx/JmWSMIq4hzN1hkTK9VwouiSt
	 ywesc2R3PHFxQzuPZy/IUDPtMjA+uaYTDwUvUXGxDnYbTz8oFaU30PXGCp28xUkzeD
	 PZLrWVuk+MHzf3A2RiLfb/fTn3HgurMAFrBdtwd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 401/626] drm/amdgpu: Use active umc info from discovery
Date: Tue, 27 May 2025 18:24:54 +0200
Message-ID: <20250527162501.308782693@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit f7a594e40517fa2ab25d5ca10e7b6a158f529fb5 ]

There could be configs where some UMC instances are harvested. This
information is obtained through discovery data and populated in
umc.active_mask. Avoid reassigning this as AID mask, instead use the
mask directly while iterating through umc instances. This is to avoid
accesses to harvested UMC instances.

v2: fix warning (Alex)

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_umc.c | 42 +++++++++++++++++++++++++
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c   |  1 -
 2 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_umc.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_umc.c
index bb7b9b2eaac1a..8da0bddab3d23 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_umc.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_umc.c
@@ -383,6 +383,45 @@ int amdgpu_umc_fill_error_record(struct ras_err_data *err_data,
 	return 0;
 }
 
+static int amdgpu_umc_loop_all_aid(struct amdgpu_device *adev, umc_func func,
+				   void *data)
+{
+	uint32_t umc_node_inst;
+	uint32_t node_inst;
+	uint32_t umc_inst;
+	uint32_t ch_inst;
+	int ret;
+
+	/*
+	 * This loop is done based on the following -
+	 * umc.active mask = mask of active umc instances across all nodes
+	 * umc.umc_inst_num = maximum number of umc instancess per node
+	 * umc.node_inst_num = maximum number of node instances
+	 * Channel instances are not assumed to be harvested.
+	 */
+	dev_dbg(adev->dev, "active umcs :%lx umc_inst per node: %d",
+		adev->umc.active_mask, adev->umc.umc_inst_num);
+	for_each_set_bit(umc_node_inst, &(adev->umc.active_mask),
+			 adev->umc.node_inst_num * adev->umc.umc_inst_num) {
+		node_inst = umc_node_inst / adev->umc.umc_inst_num;
+		umc_inst = umc_node_inst % adev->umc.umc_inst_num;
+		LOOP_UMC_CH_INST(ch_inst) {
+			dev_dbg(adev->dev,
+				"node_inst :%d umc_inst: %d ch_inst: %d",
+				node_inst, umc_inst, ch_inst);
+			ret = func(adev, node_inst, umc_inst, ch_inst, data);
+			if (ret) {
+				dev_err(adev->dev,
+					"Node %d umc %d ch %d func returns %d\n",
+					node_inst, umc_inst, ch_inst, ret);
+				return ret;
+			}
+		}
+	}
+
+	return 0;
+}
+
 int amdgpu_umc_loop_channels(struct amdgpu_device *adev,
 			umc_func func, void *data)
 {
@@ -391,6 +430,9 @@ int amdgpu_umc_loop_channels(struct amdgpu_device *adev,
 	uint32_t ch_inst         = 0;
 	int ret = 0;
 
+	if (adev->aid_mask)
+		return amdgpu_umc_loop_all_aid(adev, func, data);
+
 	if (adev->umc.node_inst_num) {
 		LOOP_UMC_EACH_NODE_INST_AND_CH(node_inst, umc_inst, ch_inst) {
 			ret = func(adev, node_inst, umc_inst, ch_inst, data);
diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
index 9a212413c6d3a..78c527b56f7c5 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
@@ -1461,7 +1461,6 @@ static void gmc_v9_0_set_umc_funcs(struct amdgpu_device *adev)
 		adev->umc.umc_inst_num = UMC_V12_0_UMC_INSTANCE_NUM;
 		adev->umc.node_inst_num /= UMC_V12_0_UMC_INSTANCE_NUM;
 		adev->umc.channel_offs = UMC_V12_0_PER_CHANNEL_OFFSET;
-		adev->umc.active_mask = adev->aid_mask;
 		adev->umc.retire_unit = UMC_V12_0_BAD_PAGE_NUM_PER_CHANNEL;
 		if (!adev->gmc.xgmi.connected_to_cpu && !adev->gmc.is_app_apu)
 			adev->umc.ras = &umc_v12_0_ras;
-- 
2.39.5



