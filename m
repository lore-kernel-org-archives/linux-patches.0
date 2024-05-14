Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA7940862;
	Tue, 14 May 2024 10:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682989; cv=none; b=oNwGoCpwD/ZpkLuS9fDKYztr6hUTgNnuMrjXRss/DT0oJnob4fAJ8LSMYrK5ZyxKaEwgwpQLimsvi+bX80zlNsOY79JoOjlw9HU8ytu8UWzyhKZQFA6G5Cww1B0gadK46qEArA9Zp2Yiu8fIPkfaEMCCTz2zVKkyAh46EdB+c7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682989; c=relaxed/simple;
	bh=r7qKTv8mANj1zrDoSMmU0eoTsyiqtZBbjIzWkLw4XKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hI+IhgSBnOqamxp/pGD3kUEdybLc1rhzNMSXoDBfx8vNiuRAE/8QWmWdziNagl2wbSVo7f27it8YXnMIdog7ogjiJjirNdByHwonX0/lBD9+zHiUd6Ru1YAQJ26yFyKsjFkraq5OoVTHH/BnS0auFdgzTWDFjf0PoMyrDYZCmP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h2LjUXLR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h2LjUXLR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A4AC2BD10;
	Tue, 14 May 2024 10:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682989;
	bh=r7qKTv8mANj1zrDoSMmU0eoTsyiqtZBbjIzWkLw4XKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h2LjUXLRZAfHMgrfax+UL42lqhd4aHp0yo4lOAB/UpRxK1LvysQMosvom3YaRWM9O
	 Om/LKAU1pSXKCoh0Z1JFmDLuOeQAXq39sFWO2zhrGdJGp1JGF1Q1wiBI3L67UASyDn
	 THjPaC82wC0wBrdztPbaEyOumPcFXaR3knPkMC/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukul Joshi <mukul.joshi@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 115/336] drm/amdkfd: Check cgroup when returning DMABuf info
Date: Tue, 14 May 2024 12:15:19 +0200
Message-ID: <20240514101042.945519506@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 08da993df1480..7d5ffc2bad793 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -1522,7 +1522,7 @@ static int kfd_ioctl_get_dmabuf_info(struct file *filep,
 
 	/* Find a KFD GPU device that supports the get_dmabuf_info query */
 	for (i = 0; kfd_topology_enum_kfd_devices(i, &dev) == 0; i++)
-		if (dev)
+		if (dev && !kfd_devcgroup_check_permission(dev))
 			break;
 	if (!dev)
 		return -EINVAL;
@@ -1544,7 +1544,7 @@ static int kfd_ioctl_get_dmabuf_info(struct file *filep,
 	if (xcp_id >= 0)
 		args->gpu_id = dmabuf_adev->kfd.dev->nodes[xcp_id]->id;
 	else
-		args->gpu_id = dmabuf_adev->kfd.dev->nodes[0]->id;
+		args->gpu_id = dev->id;
 	args->flags = flags;
 
 	/* Copy metadata buffer to user mode */
-- 
2.43.0



