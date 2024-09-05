Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED722198A25;
	Thu,  5 Sep 2024 09:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529664; cv=none; b=gb92gp8EshEM2OSW//dKjVO3sOi8OD/a7TOaq4mSknornLb5YEKkqt/nSG8Zv3dqp5qbsjyBl1piQritc5NadGnamfURIzFgDheGAxh9Ty3n3ICr7/bFTw++YNZojB7lNWKYrGE4HIlVxQkieqcQjQzJhRjzCcvEyExhJvENv0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529664; c=relaxed/simple;
	bh=kv17AbBdBBz0ab//oyXeEJXjFbkV6eiNpDxa+qgV1hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SuMVEtg5OLVgT4tbEYMTE5Z22jROTJ9324PnWuLgBIkvRwLOnYz8SL1OXrS0fAk/wG/xp+x3TMFBctc8Fn9ilxMRg4dv7pz8AQdkMAJQPb36B3VE1hQfEmToE9zNwjl6onz8RIlCjvILmlZSPvz2tvlZfmqWwbJd/9tk4GzZxg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J5/5fN0e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J5/5fN0e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5422EC4CEC4;
	Thu,  5 Sep 2024 09:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529663;
	bh=kv17AbBdBBz0ab//oyXeEJXjFbkV6eiNpDxa+qgV1hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J5/5fN0eCHHdm+8zzNoZei5DadRw9orKPAKIYFrQiR9fd6sE5Qc3Z1F463trVXT4M
	 j762ulskeRvmNhDO7p4c4KOQaoEjN9ozofiNGx+5mTBbeA3hqK3J9bRAttirs4YXH0
	 Ihb3aleGcFkPx+YK5Z9BlWMOFVWSSjqaghy/2Ph8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 105/184] drm/amdgpu: fix the waring dereferencing hive
Date: Thu,  5 Sep 2024 11:40:18 +0200
Message-ID: <20240905093736.333744375@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index cef9dd0a012b..b3df27ce7663 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -1375,6 +1375,9 @@ static void psp_xgmi_reflect_topology_info(struct psp_context *psp,
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



