Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3BB2D8DC3;
	Tue, 11 Nov 2025 01:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823527; cv=none; b=NzDSAFBk523129aD0TBnz1mnnlL3L6aAcnm40s8vOpwJ2/HN+n324aoMZrJwJ7IvlKw8DRtUB/CLnkVzizW41lCp+kiahloupf0RjvS9QIFxmTVE466waeIl9GRqQLOVWDg26WlZqiG5869XCrFkV9jYgVwJfxxNzorfrS4bHSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823527; c=relaxed/simple;
	bh=0rNzVPN2oHOTMFhhw4qLxmq0MPhsZtUGFCP/xR6JtlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ANlKYRBiJLoOXBLklP0P0Ey8tn0UP0bTBJSMNhnZSDlCp/59QmhUIuWedDS5Zvwle2mXWbsHxE5zhDSn91eq9ncGJgJsQ7p2z8SKRwG5EuEjiafU+kgq/Fh/4SSXo+65+gkAuniBg58xceK1E+b17BrLtJbRpHElNYqwRzwE27I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d9gUPiVV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d9gUPiVV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7832C113D0;
	Tue, 11 Nov 2025 01:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823527;
	bh=0rNzVPN2oHOTMFhhw4qLxmq0MPhsZtUGFCP/xR6JtlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d9gUPiVV4fv/6CtHb9s15oEgKAemP8wgmXpWJC/MxN6Q6qIib+q/WOEkaUN97UN9G
	 n4/HCCG9pJn+oKSvcHKXmMYT/+1qYvp8jZdWjewkqwDvJxVPnQ6tV8yPy/ZZwDok8z
	 KeB+29OMXf+SzimMPuC6b9VH95Y5hS2QnsIMwo/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenglei Xie <Chenglei.Xie@amd.com>,
	Shravan Kumar Gande <Shravankumar.Gande@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 317/849] drm/amdgpu: refactor bad_page_work for corner case handling
Date: Tue, 11 Nov 2025 09:38:07 +0900
Message-ID: <20251111004544.080428211@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenglei Xie <Chenglei.Xie@amd.com>

[ Upstream commit d2fa0ec6e0aea6ffbd41939d0c7671db16991ca4 ]

When a poison is consumed on the guest before the guest receives the host's poison creation msg, a corner case may occur to have poison_handler complete processing earlier than it should to cause the guest to hang waiting for the req_bad_pages reply during a VF FLR, resulting in the VM becoming inaccessible in stress tests.

To fix this issue, this patch refactored the mailbox sequence by seperating the bad_page_work into two parts req_bad_pages_work and handle_bad_pages_work.
Old sequence:
  1.Stop data exchange work
  2.Guest sends MB_REQ_RAS_BAD_PAGES to host and keep polling for IDH_RAS_BAD_PAGES_READY
  3.If the IDH_RAS_BAD_PAGES_READY arrives within timeout limit, re-init the data exchange region for updated bad page info
    else timeout with error message
New sequence:
req_bad_pages_work:
  1.Stop data exhange work
  2.Guest sends MB_REQ_RAS_BAD_PAGES to host
Once Guest receives IDH_RAS_BAD_PAGES_READY event
handle_bad_pages_work:
  3.re-init the data exchange region for updated bad page info

Signed-off-by: Chenglei Xie <Chenglei.Xie@amd.com>
Reviewed-by: Shravan Kumar Gande <Shravankumar.Gande@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h |  3 +-
 drivers/gpu/drm/amd/amdgpu/mxgpu_ai.c    | 32 +++++++++++++++++++---
 drivers/gpu/drm/amd/amdgpu/mxgpu_nv.c    | 35 +++++++++++++++++++-----
 drivers/gpu/drm/amd/amdgpu/soc15.c       |  1 -
 4 files changed, 58 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h
index 3da3ebb1d9a13..58accf2259b38 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h
@@ -267,7 +267,8 @@ struct amdgpu_virt {
 	struct amdgpu_irq_src		rcv_irq;
 
 	struct work_struct		flr_work;
-	struct work_struct		bad_pages_work;
+	struct work_struct		req_bad_pages_work;
+	struct work_struct		handle_bad_pages_work;
 
 	struct amdgpu_mm_table		mm_table;
 	const struct amdgpu_virt_ops	*ops;
diff --git a/drivers/gpu/drm/amd/amdgpu/mxgpu_ai.c b/drivers/gpu/drm/amd/amdgpu/mxgpu_ai.c
index 48101a34e049f..9a40107a0869d 100644
--- a/drivers/gpu/drm/amd/amdgpu/mxgpu_ai.c
+++ b/drivers/gpu/drm/amd/amdgpu/mxgpu_ai.c
@@ -292,14 +292,32 @@ static void xgpu_ai_mailbox_flr_work(struct work_struct *work)
 	}
 }
 
-static void xgpu_ai_mailbox_bad_pages_work(struct work_struct *work)
+static void xgpu_ai_mailbox_req_bad_pages_work(struct work_struct *work)
 {
-	struct amdgpu_virt *virt = container_of(work, struct amdgpu_virt, bad_pages_work);
+	struct amdgpu_virt *virt = container_of(work, struct amdgpu_virt, req_bad_pages_work);
 	struct amdgpu_device *adev = container_of(virt, struct amdgpu_device, virt);
 
 	if (down_read_trylock(&adev->reset_domain->sem)) {
 		amdgpu_virt_fini_data_exchange(adev);
 		amdgpu_virt_request_bad_pages(adev);
+		up_read(&adev->reset_domain->sem);
+	}
+}
+
+/**
+ * xgpu_ai_mailbox_handle_bad_pages_work - Reinitialize the data exchange region to get fresh bad page information
+ * @work: pointer to the work_struct
+ *
+ * This work handler is triggered when bad pages are ready, and it reinitializes
+ * the data exchange region to retrieve updated bad page information from the host.
+ */
+static void xgpu_ai_mailbox_handle_bad_pages_work(struct work_struct *work)
+{
+	struct amdgpu_virt *virt = container_of(work, struct amdgpu_virt, handle_bad_pages_work);
+	struct amdgpu_device *adev = container_of(virt, struct amdgpu_device, virt);
+
+	if (down_read_trylock(&adev->reset_domain->sem)) {
+		amdgpu_virt_fini_data_exchange(adev);
 		amdgpu_virt_init_data_exchange(adev);
 		up_read(&adev->reset_domain->sem);
 	}
@@ -327,10 +345,15 @@ static int xgpu_ai_mailbox_rcv_irq(struct amdgpu_device *adev,
 	struct amdgpu_ras *ras = amdgpu_ras_get_context(adev);
 
 	switch (event) {
+	case IDH_RAS_BAD_PAGES_READY:
+		xgpu_ai_mailbox_send_ack(adev);
+		if (amdgpu_sriov_runtime(adev))
+			schedule_work(&adev->virt.handle_bad_pages_work);
+		break;
 	case IDH_RAS_BAD_PAGES_NOTIFICATION:
 		xgpu_ai_mailbox_send_ack(adev);
 		if (amdgpu_sriov_runtime(adev))
-			schedule_work(&adev->virt.bad_pages_work);
+			schedule_work(&adev->virt.req_bad_pages_work);
 		break;
 	case IDH_UNRECOV_ERR_NOTIFICATION:
 		xgpu_ai_mailbox_send_ack(adev);
@@ -415,7 +438,8 @@ int xgpu_ai_mailbox_get_irq(struct amdgpu_device *adev)
 	}
 
 	INIT_WORK(&adev->virt.flr_work, xgpu_ai_mailbox_flr_work);
-	INIT_WORK(&adev->virt.bad_pages_work, xgpu_ai_mailbox_bad_pages_work);
+	INIT_WORK(&adev->virt.req_bad_pages_work, xgpu_ai_mailbox_req_bad_pages_work);
+	INIT_WORK(&adev->virt.handle_bad_pages_work, xgpu_ai_mailbox_handle_bad_pages_work);
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/amd/amdgpu/mxgpu_nv.c b/drivers/gpu/drm/amd/amdgpu/mxgpu_nv.c
index f6d8597452ed0..457972aa56324 100644
--- a/drivers/gpu/drm/amd/amdgpu/mxgpu_nv.c
+++ b/drivers/gpu/drm/amd/amdgpu/mxgpu_nv.c
@@ -202,9 +202,6 @@ static int xgpu_nv_send_access_requests_with_param(struct amdgpu_device *adev,
 	case IDH_REQ_RAS_CPER_DUMP:
 		event = IDH_RAS_CPER_DUMP_READY;
 		break;
-	case IDH_REQ_RAS_BAD_PAGES:
-		event = IDH_RAS_BAD_PAGES_READY;
-		break;
 	default:
 		break;
 	}
@@ -359,14 +356,32 @@ static void xgpu_nv_mailbox_flr_work(struct work_struct *work)
 	}
 }
 
-static void xgpu_nv_mailbox_bad_pages_work(struct work_struct *work)
+static void xgpu_nv_mailbox_req_bad_pages_work(struct work_struct *work)
 {
-	struct amdgpu_virt *virt = container_of(work, struct amdgpu_virt, bad_pages_work);
+	struct amdgpu_virt *virt = container_of(work, struct amdgpu_virt, req_bad_pages_work);
 	struct amdgpu_device *adev = container_of(virt, struct amdgpu_device, virt);
 
 	if (down_read_trylock(&adev->reset_domain->sem)) {
 		amdgpu_virt_fini_data_exchange(adev);
 		amdgpu_virt_request_bad_pages(adev);
+		up_read(&adev->reset_domain->sem);
+	}
+}
+
+/**
+ * xgpu_nv_mailbox_handle_bad_pages_work - Reinitialize the data exchange region to get fresh bad page information
+ * @work: pointer to the work_struct
+ *
+ * This work handler is triggered when bad pages are ready, and it reinitializes
+ * the data exchange region to retrieve updated bad page information from the host.
+ */
+static void xgpu_nv_mailbox_handle_bad_pages_work(struct work_struct *work)
+{
+	struct amdgpu_virt *virt = container_of(work, struct amdgpu_virt, handle_bad_pages_work);
+	struct amdgpu_device *adev = container_of(virt, struct amdgpu_device, virt);
+
+	if (down_read_trylock(&adev->reset_domain->sem)) {
+		amdgpu_virt_fini_data_exchange(adev);
 		amdgpu_virt_init_data_exchange(adev);
 		up_read(&adev->reset_domain->sem);
 	}
@@ -397,10 +412,15 @@ static int xgpu_nv_mailbox_rcv_irq(struct amdgpu_device *adev,
 	struct amdgpu_ras *ras = amdgpu_ras_get_context(adev);
 
 	switch (event) {
+	case IDH_RAS_BAD_PAGES_READY:
+		xgpu_nv_mailbox_send_ack(adev);
+		if (amdgpu_sriov_runtime(adev))
+			schedule_work(&adev->virt.handle_bad_pages_work);
+		break;
 	case IDH_RAS_BAD_PAGES_NOTIFICATION:
 		xgpu_nv_mailbox_send_ack(adev);
 		if (amdgpu_sriov_runtime(adev))
-			schedule_work(&adev->virt.bad_pages_work);
+			schedule_work(&adev->virt.req_bad_pages_work);
 		break;
 	case IDH_UNRECOV_ERR_NOTIFICATION:
 		xgpu_nv_mailbox_send_ack(adev);
@@ -485,7 +505,8 @@ int xgpu_nv_mailbox_get_irq(struct amdgpu_device *adev)
 	}
 
 	INIT_WORK(&adev->virt.flr_work, xgpu_nv_mailbox_flr_work);
-	INIT_WORK(&adev->virt.bad_pages_work, xgpu_nv_mailbox_bad_pages_work);
+	INIT_WORK(&adev->virt.req_bad_pages_work, xgpu_nv_mailbox_req_bad_pages_work);
+	INIT_WORK(&adev->virt.handle_bad_pages_work, xgpu_nv_mailbox_handle_bad_pages_work);
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/amd/amdgpu/soc15.c b/drivers/gpu/drm/amd/amdgpu/soc15.c
index 9e74c9822e622..9785fada4fa79 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -741,7 +741,6 @@ static void soc15_reg_base_init(struct amdgpu_device *adev)
 void soc15_set_virt_ops(struct amdgpu_device *adev)
 {
 	adev->virt.ops = &xgpu_ai_virt_ops;
-
 	/* init soc15 reg base early enough so we can
 	 * request request full access for sriov before
 	 * set_ip_blocks. */
-- 
2.51.0



