Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53825253B71;
	Mon, 23 Jun 2025 13:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685913; cv=none; b=AvdysV1beptVoiwt/GW8vkzPfyBSOc2I2XHukpUWuCj9Gf/y4PBJ/9Mf5WdzFSGXJrn/CITpAxZc8YSb+01FpFtmdNcqcluKY2F7HXaJXBBicBf7AsAt+wq4nylU+rcHNYwkoENuruj1kredy59gadp9Zd03tf6iqqyemk0Amxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685913; c=relaxed/simple;
	bh=kptJsJYlW2eEy0aYSwaEnCwektdBD+0BAdwU7ButdcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=atsDy8iHQZmbImbWscyy24RYX+sD9pnL7ThXC04GyVyh/0mBrP9l6eDFtoZfVEcP4PR3srYkk2Kvyo165e7LLn8ipiP03X6iTav0WvtfShMrOx+PoO6nN86BlUfCmWIVyhUq8XEZQnOAANeTYyesRdBpPnDI1/3KzUdvHy17FyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qNK2+S1z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qNK2+S1z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB07C4CEEA;
	Mon, 23 Jun 2025 13:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685913;
	bh=kptJsJYlW2eEy0aYSwaEnCwektdBD+0BAdwU7ButdcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qNK2+S1z3TYaCSyhtxA/Tbpb2dzH79KwcGXF6Kdsl27eHRFVp9cM6+TRVdchOTw+6
	 wXmG4xVoYQpYrMaXEcMLv7gUaABIOtsNYbQttrMoQcqZP0T+oT6F0RkKf0O5nhcoFB
	 ycq2jT+1Q48QgJVyEM/tLxbeJaFHj+hl1hhRvq3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 037/508] drm/amd/pp: Fix potential NULL pointer dereference in atomctrl_initialize_mc_reg_table
Date: Mon, 23 Jun 2025 15:01:22 +0200
Message-ID: <20250623130646.158828184@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



