Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3801E495;
	Tue, 14 May 2024 11:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684958; cv=none; b=SAnRnuYbSazE0Cz53CaUg0RvXbXGhR5Pufvig3zeiwMnmpOyPYMDrs3tRF49eD/KzO3VzIYap8KezEmtYlUjCEw1BF6sNPFQy1PuUl3zn/0iILb4WqsYOh/9aC/0Tt2yvMg2Hil1kUlnpLDedDEm+QJrzKhyf2AWLDLgck1KZw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684958; c=relaxed/simple;
	bh=DqARyaufwfzY6hJ2Y79Z6E3xOTghB4FB7Cv4I4gCBU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UynttFEYgdqrDbXABgbatMHiisiW/sg4XCCdcQ++xMQfM0gZaXhd3DPlxOM2bobYPIXhHL/hxgFWwQ3bP+7d91fuSjT7hOpD/L9aJH1J7xiYYG4TozwFxFexT2SHnulbQwHkD/900cUakGP1HVfSh9Ed0qdP+jiWLhnVcq+Hkho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=19CHH5ke; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="19CHH5ke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E8C7C2BD10;
	Tue, 14 May 2024 11:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684958;
	bh=DqARyaufwfzY6hJ2Y79Z6E3xOTghB4FB7Cv4I4gCBU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=19CHH5kenu3d3HOjRz6NkIBVutki3IldCe4j7ASkDDMTkB+YH4H+eRy8OUppiyxCl
	 OFEPN1vD9AocyRzScAt734sz/MB4RigxTU5+Sc9iNj9aK2jFbvIX2THV1D0buNguuJ
	 CXfjnvz/UN3WgkaDYTjQs5wz7H9tvLofLuiMlE+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukul Joshi <mukul.joshi@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 113/301] drm/amdkfd: Check cgroup when returning DMABuf info
Date: Tue, 14 May 2024 12:16:24 +0200
Message-ID: <20240514101036.517383420@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

From: Mukul Joshi <mukul.joshi@amd.com>

[ Upstream commit 9d7993a7ab9651afd5fb295a4992e511b2b727aa ]

Check cgroup permissions when returning DMA-buf info and
based on cgroup info return the GPU id of the GPU that have
access to the BO.

Signed-off-by: Mukul Joshi <mukul.joshi@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index c157721214e8d..505a9078bc157 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -1516,7 +1516,7 @@ static int kfd_ioctl_get_dmabuf_info(struct file *filep,
 
 	/* Find a KFD GPU device that supports the get_dmabuf_info query */
 	for (i = 0; kfd_topology_enum_kfd_devices(i, &dev) == 0; i++)
-		if (dev)
+		if (dev && !kfd_devcgroup_check_permission(dev))
 			break;
 	if (!dev)
 		return -EINVAL;
@@ -1538,7 +1538,7 @@ static int kfd_ioctl_get_dmabuf_info(struct file *filep,
 	if (xcp_id >= 0)
 		args->gpu_id = dmabuf_adev->kfd.dev->nodes[xcp_id]->id;
 	else
-		args->gpu_id = dmabuf_adev->kfd.dev->nodes[0]->id;
+		args->gpu_id = dev->id;
 	args->flags = flags;
 
 	/* Copy metadata buffer to user mode */
-- 
2.43.0



