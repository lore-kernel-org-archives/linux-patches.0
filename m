Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAAC3192D70;
	Tue, 10 Sep 2024 10:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963438; cv=none; b=U01kwB9q+LnwtLD6BZhfnI9rMLouJyrytk20HXB0kiEqR/PAY8ClcLyLIm9n/OwYr+m9wd/QvjvlmZ2+swuhvBbeyMqBkEEcJdoIORH5VhgAqDO2IFY2k0PzUJVT1Zsy14vRk+Q/hnhdTBv7aVo4b4DmPtdISNoe3IA0quSkk4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963438; c=relaxed/simple;
	bh=MfqTLIH6vJw/bEKO4DvpK72lsSLDaKCBxUFWjuH8YNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=raS1zrv403EfYcIFund6boJKrTyeITtKlc8pnFPzKIijXqnay0wQc7AU5XNkbnnAaWpRkwZrsTljj+3tABedxJd5LfS2oJz28MJ+2RdoFhv3BBDG5QI7fpRuYwdi+cAcdM+FDE6BW70SgHC+phJ5w4c1R4lSapevZck1D0bio7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oy1lDsq3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oy1lDsq3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FBC1C4CEC3;
	Tue, 10 Sep 2024 10:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963438;
	bh=MfqTLIH6vJw/bEKO4DvpK72lsSLDaKCBxUFWjuH8YNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oy1lDsq37GIcgXRCAnDaBAU4LbbqRDyNtRkt2yHq+dV0xg0yqBRHfMG/DE0gXYSeH
	 cbz2l57fDW5SEZbSF2+0vM4Vg89fZmgDGPr4AOSe6HGdhwhYNvQX6CDJGmM4MEjVAt
	 XHeOnIP3v0b/r1QOPBObOEC7Mn36IlVd9D5Wx58w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chen <michael.chen@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 030/214] drm/amdkfd: Reconcile the definition and use of oem_id in struct kfd_topology_device
Date: Tue, 10 Sep 2024 11:30:52 +0200
Message-ID: <20240910092600.019934305@linuxfoundation.org>
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
index d54ceebd346b..30c70b3ab17f 100644
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
index 98cca5f2b27f..59e7ca0e8470 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
@@ -910,8 +910,7 @@ static void kfd_update_system_properties(void)
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
index a8db017c9b8e..c2dbd75b9161 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_topology.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_topology.h
@@ -184,7 +184,10 @@ struct kfd_topology_device {
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



