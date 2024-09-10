Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CD21885A6;
	Tue, 10 Sep 2024 09:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962078; cv=none; b=taSEDo0ID5wKx3QgVmkouYysg+xyr5fGvD2b+PUNfZAA3mCDFwv1s/++/bATJAKxHX1MyFikaQTqPLBZ6oJNtOz3tdMvoZPjONN873Cz58f3a/JZi9+DsI1ASTQEsEs0EJZv8ib7h3UROrnLsTj21+bm3XjcA3XHvJYMAaYlaq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962078; c=relaxed/simple;
	bh=lG0CLnVG9DGA09crZE7BY7cwQ92ib9lEgxSgUnFykA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bk52ipgJ9MxtGauJuPHSsQxl2knM9+Bg6orOnWdtw3ue9fcwI9kh501WGvQT6B+yKjuTeWyBrsJ61Q2XGsPwEuNfqgnDZR/9oEK5plhokXKyfFMoQN823Hfypw4xud5hIYNSt3G2VlAhsP8Y8XL7CYp+GaM9ZEYbdXxdLjMhpO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kw5XuDNj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kw5XuDNj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20EF2C4CEC3;
	Tue, 10 Sep 2024 09:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962078;
	bh=lG0CLnVG9DGA09crZE7BY7cwQ92ib9lEgxSgUnFykA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kw5XuDNjQbSb7LOrheVlXEGElQO3HqN73m2wpeiHQclXSgdI3rVgDfwlVlJYiUwI4
	 mc9KFsaWaq7QGRwd+ZeXcqE+HVV/3UPH0tW5r92vxhp0erKMpedEyvAgJv0VuaxlHX
	 DlhraZvsSjFWGk60vNqjMOh/UEwn524MYA1MhLEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunxiang Li <Yunxiang.Li@amd.com>,
	Emily Deng <Emily.Deng@amd.com>,
	Zhigang Luo <zhigang.luo@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 280/375] drm/amdgpu: Add reset_context flag for host FLR
Date: Tue, 10 Sep 2024 11:31:17 +0200
Message-ID: <20240910092631.967980401@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

From: Yunxiang Li <Yunxiang.Li@amd.com>

[ Upstream commit 25c01191c2555351922e5515b6b6d31357975031 ]

There are other reset sources that pass NULL as the job pointer, such as
amdgpu_amdkfd_reset_work. Therefore, using the job pointer to check if
the FLR comes from the host does not work.

Add a flag in reset_context to explicitly mark host triggered reset, and
set this flag when we receive host reset notification.

Signed-off-by: Yunxiang Li <Yunxiang.Li@amd.com>
Reviewed-by: Emily Deng <Emily.Deng@amd.com>
Reviewed-by: Zhigang Luo <zhigang.luo@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 6e4aa08fa9c6 ("drm/amdgpu: Fix amdgpu_device_reset_sriov retry logic")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 13 ++++++++-----
 drivers/gpu/drm/amd/amdgpu/amdgpu_reset.h  |  1 +
 drivers/gpu/drm/amd/amdgpu/mxgpu_ai.c      |  1 +
 drivers/gpu/drm/amd/amdgpu/mxgpu_nv.c      |  1 +
 drivers/gpu/drm/amd/amdgpu/mxgpu_vi.c      |  1 +
 5 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 9f7f96be1ac7..bd6f2aba0662 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5057,13 +5057,13 @@ static int amdgpu_device_recover_vram(struct amdgpu_device *adev)
  * amdgpu_device_reset_sriov - reset ASIC for SR-IOV vf
  *
  * @adev: amdgpu_device pointer
- * @from_hypervisor: request from hypervisor
+ * @reset_context: amdgpu reset context pointer
  *
  * do VF FLR and reinitialize Asic
  * return 0 means succeeded otherwise failed
  */
 static int amdgpu_device_reset_sriov(struct amdgpu_device *adev,
-				     bool from_hypervisor)
+				     struct amdgpu_reset_context *reset_context)
 {
 	int r;
 	struct amdgpu_hive_info *hive = NULL;
@@ -5072,12 +5072,15 @@ static int amdgpu_device_reset_sriov(struct amdgpu_device *adev,
 retry:
 	amdgpu_amdkfd_pre_reset(adev);
 
-	if (from_hypervisor)
+	if (test_bit(AMDGPU_HOST_FLR, &reset_context->flags)) {
+		clear_bit(AMDGPU_HOST_FLR, &reset_context->flags);
 		r = amdgpu_virt_request_full_gpu(adev, true);
-	else
+	} else {
 		r = amdgpu_virt_reset_gpu(adev);
+	}
 	if (r)
 		return r;
+
 	amdgpu_ras_set_fed(adev, false);
 	amdgpu_irq_gpu_reset_resume_helper(adev);
 
@@ -5831,7 +5834,7 @@ int amdgpu_device_gpu_recover(struct amdgpu_device *adev,
 	/* Actual ASIC resets if needed.*/
 	/* Host driver will handle XGMI hive reset for SRIOV */
 	if (amdgpu_sriov_vf(adev)) {
-		r = amdgpu_device_reset_sriov(adev, job ? false : true);
+		r = amdgpu_device_reset_sriov(adev, reset_context);
 		if (r)
 			adev->asic_reset_res = r;
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_reset.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_reset.h
index b11d190ece53..5a9cc043b858 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_reset.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_reset.h
@@ -33,6 +33,7 @@ enum AMDGPU_RESET_FLAGS {
 	AMDGPU_NEED_FULL_RESET = 0,
 	AMDGPU_SKIP_HW_RESET = 1,
 	AMDGPU_SKIP_COREDUMP = 2,
+	AMDGPU_HOST_FLR = 3,
 };
 
 struct amdgpu_reset_context {
diff --git a/drivers/gpu/drm/amd/amdgpu/mxgpu_ai.c b/drivers/gpu/drm/amd/amdgpu/mxgpu_ai.c
index c5ba9c4757a8..f4c47492e0cd 100644
--- a/drivers/gpu/drm/amd/amdgpu/mxgpu_ai.c
+++ b/drivers/gpu/drm/amd/amdgpu/mxgpu_ai.c
@@ -292,6 +292,7 @@ static void xgpu_ai_mailbox_flr_work(struct work_struct *work)
 		reset_context.method = AMD_RESET_METHOD_NONE;
 		reset_context.reset_req_dev = adev;
 		clear_bit(AMDGPU_NEED_FULL_RESET, &reset_context.flags);
+		set_bit(AMDGPU_HOST_FLR, &reset_context.flags);
 
 		amdgpu_device_gpu_recover(adev, NULL, &reset_context);
 	}
diff --git a/drivers/gpu/drm/amd/amdgpu/mxgpu_nv.c b/drivers/gpu/drm/amd/amdgpu/mxgpu_nv.c
index fa9d1b02f391..14cc7910e5cf 100644
--- a/drivers/gpu/drm/amd/amdgpu/mxgpu_nv.c
+++ b/drivers/gpu/drm/amd/amdgpu/mxgpu_nv.c
@@ -328,6 +328,7 @@ static void xgpu_nv_mailbox_flr_work(struct work_struct *work)
 		reset_context.method = AMD_RESET_METHOD_NONE;
 		reset_context.reset_req_dev = adev;
 		clear_bit(AMDGPU_NEED_FULL_RESET, &reset_context.flags);
+		set_bit(AMDGPU_HOST_FLR, &reset_context.flags);
 
 		amdgpu_device_gpu_recover(adev, NULL, &reset_context);
 	}
diff --git a/drivers/gpu/drm/amd/amdgpu/mxgpu_vi.c b/drivers/gpu/drm/amd/amdgpu/mxgpu_vi.c
index 14a065516ae4..78cd07744ebe 100644
--- a/drivers/gpu/drm/amd/amdgpu/mxgpu_vi.c
+++ b/drivers/gpu/drm/amd/amdgpu/mxgpu_vi.c
@@ -529,6 +529,7 @@ static void xgpu_vi_mailbox_flr_work(struct work_struct *work)
 		reset_context.method = AMD_RESET_METHOD_NONE;
 		reset_context.reset_req_dev = adev;
 		clear_bit(AMDGPU_NEED_FULL_RESET, &reset_context.flags);
+		set_bit(AMDGPU_HOST_FLR, &reset_context.flags);
 
 		amdgpu_device_gpu_recover(adev, NULL, &reset_context);
 	}
-- 
2.43.0



