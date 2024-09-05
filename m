Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3D61991B0;
	Thu,  5 Sep 2024 09:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529696; cv=none; b=iFW5W/Ey18t7Gbc7fqdTzUG5N3XCVBhMfn9YLEHXP1kT3+gcpEcr2+eYmmCTREEDWO7IThpY0Tc2+VwzdYszzkDi//fq7GMbMDBEskCyeZjiHOV978CNUV0wUNE9TmtDcVfKWxz1w8Awxymd4INuz+6ywTSQAtMHWQrCact0sus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529696; c=relaxed/simple;
	bh=TsHYj67o7kieH+UxqQqRIpRn/633xcyAZ+cQkaAABiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ozjq9WzWPJmrV9Ekm4C36JOBEwlIFKAGLRbky15Agu3MOBhMhwz3qW1zftjlUWCtXtm8iVaKzc++yM9Uj5oDxVPYdIPhHfi+hKQJPBPXr/fsKYceThsDd/meWZvT7EZE7OD4uRZfVm3X8htVUJ2h3CfgJFImw08LvmyYsl5BTsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mYmDKPYE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mYmDKPYE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A19C3C4CEC3;
	Thu,  5 Sep 2024 09:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529696;
	bh=TsHYj67o7kieH+UxqQqRIpRn/633xcyAZ+cQkaAABiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mYmDKPYENa0sd5852cICn27Q5ek7RMyXww12JRbyq9nsR0t+EXfpuLU61ZBST9+RK
	 Nzo9EcTDee7lpxVvpn2E4X5R/qTZyuBxeRyMELe04oIu0Z8XkLKGJ+akMea5GCdSIj
	 s6FD8wZElFQnkkJYA53pY5j5L5Ds4QZ2vEVqFIgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 114/184] drm/amdgpu: fix compiler side-effect check issue for RAS_EVENT_LOG()
Date: Thu,  5 Sep 2024 11:40:27 +0200
Message-ID: <20240905093736.682789017@linuxfoundation.org>
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

From: Yang Wang <kevinyang.wang@amd.com>

[ Upstream commit b712d7c20133b67f13aa134e7534369f19e1214f ]

create a new helper function to avoid compiler 'side-effect'
check about RAS_EVENT_LOG() macro.

Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c | 18 ++++++++++++++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h | 13 ++++++-------
 2 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index 0c4ee06451e9..57fdc4ab9c54 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -4504,3 +4504,21 @@ int amdgpu_ras_reserve_page(struct amdgpu_device *adev, uint64_t pfn)
 
 	return ret;
 }
+
+void amdgpu_ras_event_log_print(struct amdgpu_device *adev, u64 event_id,
+				const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	if (amdgpu_ras_event_id_is_valid(adev, event_id))
+		dev_printk(KERN_INFO, adev->dev, "{%llu}%pV", event_id, &vaf);
+	else
+		dev_printk(KERN_INFO, adev->dev, "%pV", &vaf);
+
+	va_end(args);
+}
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h
index 7021c4a66fb5..d06c01b978cd 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h
@@ -67,13 +67,8 @@ struct amdgpu_iv_entry;
 /* The high three bits indicates socketid */
 #define AMDGPU_RAS_GET_FEATURES(val)  ((val) & ~AMDGPU_RAS_FEATURES_SOCKETID_MASK)
 
-#define RAS_EVENT_LOG(_adev, _id, _fmt, ...)				\
-do {									\
-	if (amdgpu_ras_event_id_is_valid((_adev), (_id)))			\
-	    dev_info((_adev)->dev, "{%llu}" _fmt, (_id), ##__VA_ARGS__);	\
-	else								\
-	    dev_info((_adev)->dev, _fmt, ##__VA_ARGS__);			\
-} while (0)
+#define RAS_EVENT_LOG(adev, id, fmt, ...)	\
+	amdgpu_ras_event_log_print((adev), (id), (fmt), ##__VA_ARGS__);
 
 enum amdgpu_ras_block {
 	AMDGPU_RAS_BLOCK__UMC = 0,
@@ -956,4 +951,8 @@ int amdgpu_ras_put_poison_req(struct amdgpu_device *adev,
 		enum amdgpu_ras_block block, uint16_t pasid,
 		pasid_notify pasid_fn, void *data, uint32_t reset);
 
+__printf(3, 4)
+void amdgpu_ras_event_log_print(struct amdgpu_device *adev, u64 event_id,
+				const char *fmt, ...);
+
 #endif
-- 
2.43.0



