Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09711192B7C;
	Tue, 10 Sep 2024 10:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963365; cv=none; b=AAG5123ZSxVpF72B4Y1eAORl/76NoV42NDGgIB6OMhDATrV17JcjTsiolKzClSukyClmmC6vzxQ0IwxCoPehfHUY2sL64LRCMxP7FA8PosJDeyIqWLOquPyCzz/nlG4xvvbwzZykFUpItmjWKjtxB2Bu5idneW9grYozO+fgA94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963365; c=relaxed/simple;
	bh=Rbvci4dg3EUgupz4nt/n1uI2uagxu/U+AevBIDLVJ5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VegrCvvBBC9g2uQ1F6qFMw1t7cXGdVAdujh846Vk/rSpuRmYzp8W6lmJtGk8LGoHf7tLItcqWTlrMCCQBekSIonPZn2Y1bP0IJJl2AcYmneOt2CHkthOOk3wEngB+N1niL3Wm+/p7dtkDWg9kjweTj4OgBAFBc0GS/uCpsqOJRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x2ZRlA8O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x2ZRlA8O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8652CC4CEC3;
	Tue, 10 Sep 2024 10:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963364;
	bh=Rbvci4dg3EUgupz4nt/n1uI2uagxu/U+AevBIDLVJ5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x2ZRlA8OZ9ow2YdNAs1Hlj2KhUEmlqCj/xMld4vFd429yqvDokrt0sIoBl1tXhjnC
	 cP6N7ueApZU9gdZUHZeMREtWN1kgwnrwO0bHdza/wKIToAh4IDEwM6SIPEB6bbZvmO
	 9ah/1vjOOWfr9J1evlVXW8f+eXwzhV0I0tj0j84g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 033/214] drm/amdgpu: fix the waring dereferencing hive
Date: Tue, 10 Sep 2024 11:30:55 +0200
Message-ID: <20240910092600.126098112@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f305a0f8e9b9..a8b7f0aeacf8 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -1178,6 +1178,9 @@ static void psp_xgmi_reflect_topology_info(struct psp_context *psp,
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



