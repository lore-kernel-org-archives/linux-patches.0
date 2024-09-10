Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD9418C32F;
	Tue, 10 Sep 2024 09:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962372; cv=none; b=kpWCFKGirIoJB2lDM5jyRAhC4QGR4NXZaVMUsV3v4g4yztYM+aLueDX9DPJJODgIJuVSprxXDN4TsKgLE/h+cVU6uKp32m+FVhMSBfgyOnPgUwcECKTgYJkHpQGNhv91TEgypx+QiH9XbfnMvTYvTsGj+xh1EG5sBQKyqhLqUIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962372; c=relaxed/simple;
	bh=QuXOG6ysEopYTkM3XFEUqI4Ny0S1N9StyTkudo/GvkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uBiWp/gWpSR/NaadQg6tcbb8mmTSSx7UpwOhj/doHP18UFYPqNIkQ5jMgiJSHP/1EI0ZcJzXRydC3qqpoyb9JX7NX89KhX/WgXKNUIaCncB6NC93VuAOLl1au0IxYYbwlsty1QvNgOfqw+ENoFUzEuvZZZydzpu3P7bHrId3de4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jRRsUJYT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jRRsUJYT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8990C4CEC3;
	Tue, 10 Sep 2024 09:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962372;
	bh=QuXOG6ysEopYTkM3XFEUqI4Ny0S1N9StyTkudo/GvkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jRRsUJYTZHSwq87ox6k/7MVIvG28GuxAOgjvEQmulipknZ0CcXBA7Nc11at1yQIVu
	 oO5qz2wqf/jNp76uL4FWxJ3DtPOcVYm+nkCtFAkkJkVzrsqR9n32TN4fbewgJ3mSGO
	 3wO7voSH4/4bHjnET0KL3nWga2mPkdHIhpkPRiws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chen <michael.chen@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 012/121] drm/amdkfd: Reconcile the definition and use of oem_id in struct kfd_topology_device
Date: Tue, 10 Sep 2024 11:31:27 +0200
Message-ID: <20240910092546.328847663@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index a49e2ab071d6..de892ee147de 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
@@ -883,8 +883,7 @@ static void kfd_update_system_properties(void)
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
index d4718d58d0f2..7230b5b5bfe5 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_topology.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_topology.h
@@ -172,7 +172,10 @@ struct kfd_topology_device {
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



