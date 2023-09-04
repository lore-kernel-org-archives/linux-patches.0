Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6700023A0
	for <patches@lists.linux.dev>; Mon,  4 Sep 2023 18:31:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D239C433C8;
	Mon,  4 Sep 2023 18:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693852275;
	bh=aUNpU5lMr7llcRHzXXuTZ1ZtTRWnPaSsD4MQs2XqwmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=prjyR2OnWWu1XxXRl+7zPK9+V0p36dm2V3UaGYGJqmRRQzYEVssbxZKgEVw02uH6A
	 6ESy30cLSBItlbMsVUSAJ5pz5PWMYc/Y2q/4luWXd2gIB8y44yrur3hsHeCn/OCK6O
	 Rl6eVWZdQ7KHwo2AlYBhbn3A1jiLmV05mo8Gss/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lang Yu <Lang.Yu@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.5 01/34] drm/amdgpu: correct vmhub index in GMC v10/11
Date: Mon,  4 Sep 2023 19:29:48 +0100
Message-ID: <20230904182948.663250891@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230904182948.594404081@linuxfoundation.org>
References: <20230904182948.594404081@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lang Yu <Lang.Yu@amd.com>

commit 6f38bdb86a056707b9ecb09e3b44adedc8e8d8a0 upstream.

Align with new vmhub definition.

v2: use client_id == VMC to decide vmhub(Hawking)

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2822
Signed-off-by: Lang Yu <Lang.Yu@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c |    4 +++-
 drivers/gpu/drm/amd/amdgpu/gmc_v11_0.c |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c
@@ -109,9 +109,11 @@ static int gmc_v10_0_process_interrupt(s
 				       struct amdgpu_irq_src *source,
 				       struct amdgpu_iv_entry *entry)
 {
+	uint32_t vmhub_index = entry->client_id == SOC15_IH_CLIENTID_VMC ?
+			       AMDGPU_MMHUB0(0) : AMDGPU_GFXHUB(0);
+	struct amdgpu_vmhub *hub = &adev->vmhub[vmhub_index];
 	bool retry_fault = !!(entry->src_data[1] & 0x80);
 	bool write_fault = !!(entry->src_data[1] & 0x20);
-	struct amdgpu_vmhub *hub = &adev->vmhub[entry->vmid_src];
 	struct amdgpu_task_info task_info;
 	uint32_t status = 0;
 	u64 addr;
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v11_0.c
@@ -97,7 +97,9 @@ static int gmc_v11_0_process_interrupt(s
 				       struct amdgpu_irq_src *source,
 				       struct amdgpu_iv_entry *entry)
 {
-	struct amdgpu_vmhub *hub = &adev->vmhub[entry->vmid_src];
+	uint32_t vmhub_index = entry->client_id == SOC21_IH_CLIENTID_VMC ?
+			       AMDGPU_MMHUB0(0) : AMDGPU_GFXHUB(0);
+	struct amdgpu_vmhub *hub = &adev->vmhub[vmhub_index];
 	uint32_t status = 0;
 	u64 addr;
 


