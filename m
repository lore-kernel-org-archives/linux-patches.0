Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3B618D65E;
	Thu,  5 Sep 2024 09:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530164; cv=none; b=BTjuXVwT3kPbqfEPnUmEU+JQsjSCEWITqkokE/ut4e1pQg7BTl8bNkJb8mVb9Nkr5L6A02iGlWcXdOALmn4GmTfSParUhawQ4Oh8a6YRoF67bWRdtnez/aMoWcoJTzoOSIDTYVecm/wMuX9FpW21XejV8CuNHt+2BdHhzGMLuRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530164; c=relaxed/simple;
	bh=wpNoiFHEWXvuJ1i1zqveqnOHUS/eBoPDUOnW2rBQbiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ds3uiAm3iPEI7GS+/Jq2KaXkqT47t9K1WFhYjRITQ4XTkADuYnM3tL2CYcqko3FhehcgqdIkgK6lX1Si534fzOalbD9ZJgZSZW9qpULxW7jSf3XsRTywWRO/I4iO584dThDerW77uoM5Q7ARNDkgsHOb3f6rTvIBOPvS4jd6Sn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H1Daagpr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H1Daagpr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38163C4CEC4;
	Thu,  5 Sep 2024 09:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530163;
	bh=wpNoiFHEWXvuJ1i1zqveqnOHUS/eBoPDUOnW2rBQbiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H1Daagpr+CQLm8Hi5WF3jLcj4WooaQXOg5Q1WaVR+SUAjFpsheRfdzRTXNLHTZsUa
	 WgHtSQ78w0vbb8VVD7fP+66Jchk3hlsPgAFOfNAba+wT2848+o3lcwmzV44pyIa0En
	 NsWkwVVvjl8fzK4mFKiO5zV0MDGN3Wz073tXcTCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chen <michael.chen@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 074/132] drm/amdkfd: Reconcile the definition and use of oem_id in struct kfd_topology_device
Date: Thu,  5 Sep 2024 11:41:01 +0200
Message-ID: <20240905093725.133411248@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

From: Michael Chen <michael.chen@amd.com>

[ Upstream commit 10f624ef239bd136cdcc5bbc626157a57b938a31 ]

Currently oem_id is defined as uint8_t[6] and casted to uint64_t*
in some use case. This would lead code scanner to complain about
access beyond. Re-define it in union to enforce 8-byte size and
alignment to avoid potential issue.

Signed-off-by: Michael Chen <michael.chen@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_crat.h     | 2 --
 drivers/gpu/drm/amd/amdkfd/kfd_topology.c | 3 +--
 drivers/gpu/drm/amd/amdkfd/kfd_topology.h | 5 ++++-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_crat.h b/drivers/gpu/drm/amd/amdkfd/kfd_crat.h
index 74c2d7a0d628..2f54ee08f269 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_crat.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_crat.h
@@ -42,8 +42,6 @@
 #define CRAT_OEMTABLEID_LENGTH	8
 #define CRAT_RESERVED_LENGTH	6
 
-#define CRAT_OEMID_64BIT_MASK ((1ULL << (CRAT_OEMID_LENGTH * 8)) - 1)
-
 /* Compute Unit flags */
 #define COMPUTE_UNIT_CPU	(1 << 0)  /* Create Virtual CRAT for CPU */
 #define COMPUTE_UNIT_GPU	(1 << 1)  /* Create Virtual CRAT for GPU */
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_topology.c b/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
index 61157fddc15c..8362a71ab707 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
@@ -958,8 +958,7 @@ static void kfd_update_system_properties(void)
 	dev = list_last_entry(&topology_device_list,
 			struct kfd_topology_device, list);
 	if (dev) {
-		sys_props.platform_id =
-			(*((uint64_t *)dev->oem_id)) & CRAT_OEMID_64BIT_MASK;
+		sys_props.platform_id = dev->oem_id64;
 		sys_props.platform_oem = *((uint64_t *)dev->oem_table_id);
 		sys_props.platform_rev = dev->oem_revision;
 	}
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_topology.h b/drivers/gpu/drm/amd/amdkfd/kfd_topology.h
index 27386ce9a021..2d1c9d771bef 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_topology.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_topology.h
@@ -154,7 +154,10 @@ struct kfd_topology_device {
 	struct attribute		attr_gpuid;
 	struct attribute		attr_name;
 	struct attribute		attr_props;
-	uint8_t				oem_id[CRAT_OEMID_LENGTH];
+	union {
+		uint8_t				oem_id[CRAT_OEMID_LENGTH];
+		uint64_t			oem_id64;
+	};
 	uint8_t				oem_table_id[CRAT_OEMTABLEID_LENGTH];
 	uint32_t			oem_revision;
 };
-- 
2.43.0



