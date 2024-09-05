Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01BE21494DB;
	Thu,  5 Sep 2024 10:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530661; cv=none; b=aKlxWuDrYuZ1G6E1MXbm8TWF7BLBIBpXD+x8lbkFGw8MCHaWWOiWWdP1zF/xIm0a4wCSZ66A5kWP5WYZ/1miPHJkyekzmyx3ttiU0jU7izYv0cSP5tq4C1Svh5kkfsVAsu87fsSmRGn+yYHB65xtYm0qurlg+pdGszkIz15pYKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530661; c=relaxed/simple;
	bh=tSPnYhr6BiQ53L3YN+L1Qf+MAARWaOZbLepC6Zz8LlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q1jQujMcK5n1X9T3rr8Bl121MJCdoTBrX0GNHFGO0i+QfpBW1xjE1o/TCD6XDG2F7u6ND0VIhYgGgM/+qXbGnlZw7Js/jQDhGjiHqnbhfmp/D3//VD6yt7L1Y+6hrTmH5grs2+oURW9wyALHanN+1qICQejWgR5yzcKWG+ughqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bh/HzDCy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bh/HzDCy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E75C4CEC3;
	Thu,  5 Sep 2024 10:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530660;
	bh=tSPnYhr6BiQ53L3YN+L1Qf+MAARWaOZbLepC6Zz8LlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bh/HzDCyCWl58V52l4XLmvDyV/rIt2dCfjiW3ifq4bagLHTUplrytPzKP51JkB8kY
	 5PXnWaB2lacr6QZJKwjF2PSgPlwVsP7R4yqqsmEmdh/R3Anp16Bvw/Z/2D3l2KgtQg
	 MM2V0hy7GdWPOA1Zm2M1kX3Ju0hoZwEJfsr9ovys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 062/101] drm/amdgpu: fix the waring dereferencing hive
Date: Thu,  5 Sep 2024 11:41:34 +0200
Message-ID: <20240905093718.566560830@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <jesse.zhang@amd.com>

[ Upstream commit 1940708ccf5aff76de4e0b399f99267c93a89193 ]

Check the amdgpu_hive_info *hive that maybe is NULL.

Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Reviewed-by: Tim Huang <Tim.Huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index 8764ff7ed97e..f8740ad08af4 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -1297,6 +1297,9 @@ static void psp_xgmi_reflect_topology_info(struct psp_context *psp,
 	uint8_t dst_num_links = node_info.num_links;
 
 	hive = amdgpu_get_xgmi_hive(psp->adev);
+	if (WARN_ON(!hive))
+		return;
+
 	list_for_each_entry(mirror_adev, &hive->device_list, gmc.xgmi.head) {
 		struct psp_xgmi_topology_info *mirror_top_info;
 		int j;
-- 
2.43.0



