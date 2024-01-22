Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39056135A46;
	Tue, 23 Jan 2024 00:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969653; cv=none; b=FPIijQxv4LyzyjT4UaiU/9W21ABcg3BAykFzkN/Q6ULjQjQVFXHB6xY8rE51L48siB1f3okIGnLpTW5oChePQmG3i5Flnldw4rBF+RWuZv/DDFGmvU1YdKfk8/0/Pjq4CS8ezVI3SG177bDEf1ki++guo9sxfUW93Tnm13pz+Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969653; c=relaxed/simple;
	bh=8rpxGzffVRS5QeVB3jL1Ao3yuAIvz+Zu8+Y0LDKzYRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mQCymrwSQtF2gmg2JFkqcI9EIZGLD/bvSnE2dYFWSjl7NdDGnchc992TsdjOfkfTEivxPmOcmsm/UHR8+0hk5LVp3IAwF5lhde08FqRSSuoQacRGvByUlvVOBLfoYBVhZc5RSpLXw/eBa4csoIEn+X6T3pi8Jyrg+HbsnSCWaGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=USWhano+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="USWhano+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A70C433C7;
	Tue, 23 Jan 2024 00:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969653;
	bh=8rpxGzffVRS5QeVB3jL1Ao3yuAIvz+Zu8+Y0LDKzYRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=USWhano+TwRI8CRvLl50U/6lecM56DxgTdXDYL9CVhvQ1xkwj2k4XAYbPLmxN+k9t
	 2D3usbhsqgw8gFnxrTfhdUpD/+mYfm4DssGmUl7u76tvJ7M10Sv3gickVus1Ol/2L1
	 B5J6z7sMWGn/k6vg8uTt7rAvcNLkP/1ZcmjojSLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Cornwall <jay.cornwall@amd.com>,
	Kaibo Ma <ent3rm4n@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.7 385/641] Revert "drm/amdkfd: Relocate TBA/TMA to opposite side of VM hole"
Date: Mon, 22 Jan 2024 15:54:49 -0800
Message-ID: <20240122235829.997890581@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kaibo Ma <ent3rm4n@gmail.com>

commit 0f35b0a7b8fa402adbffa2565047cdcc4c480153 upstream.

That commit causes NULL pointer dereferences in dmesgs when
running applications using ROCm, including clinfo, blender,
and PyTorch, since v6.6.1. Revert it to fix blender again.

This reverts commit 96c211f1f9ef82183493f4ceed4e347b52849149.

Closes: https://github.com/ROCm/ROCm/issues/2596
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/2991
Reviewed-by: Jay Cornwall <jay.cornwall@amd.com>
Signed-off-by: Kaibo Ma <ent3rm4n@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_flat_memory.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_flat_memory.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_flat_memory.c
@@ -330,12 +330,6 @@ static void kfd_init_apertures_vi(struct
 	pdd->gpuvm_limit =
 		pdd->dev->kfd->shared_resources.gpuvm_size - 1;
 
-	/* dGPUs: the reserved space for kernel
-	 * before SVM
-	 */
-	pdd->qpd.cwsr_base = SVM_CWSR_BASE;
-	pdd->qpd.ib_base = SVM_IB_BASE;
-
 	pdd->scratch_base = MAKE_SCRATCH_APP_BASE_VI();
 	pdd->scratch_limit = MAKE_SCRATCH_APP_LIMIT(pdd->scratch_base);
 }
@@ -345,18 +339,18 @@ static void kfd_init_apertures_v9(struct
 	pdd->lds_base = MAKE_LDS_APP_BASE_V9();
 	pdd->lds_limit = MAKE_LDS_APP_LIMIT(pdd->lds_base);
 
-	pdd->gpuvm_base = PAGE_SIZE;
+        /* Raven needs SVM to support graphic handle, etc. Leave the small
+         * reserved space before SVM on Raven as well, even though we don't
+         * have to.
+         * Set gpuvm_base and gpuvm_limit to CANONICAL addresses so that they
+         * are used in Thunk to reserve SVM.
+         */
+        pdd->gpuvm_base = SVM_USER_BASE;
 	pdd->gpuvm_limit =
 		pdd->dev->kfd->shared_resources.gpuvm_size - 1;
 
 	pdd->scratch_base = MAKE_SCRATCH_APP_BASE_V9();
 	pdd->scratch_limit = MAKE_SCRATCH_APP_LIMIT(pdd->scratch_base);
-
-	/*
-	 * Place TBA/TMA on opposite side of VM hole to prevent
-	 * stray faults from triggering SVM on these pages.
-	 */
-	pdd->qpd.cwsr_base = pdd->dev->kfd->shared_resources.gpuvm_size;
 }
 
 int kfd_init_apertures(struct kfd_process *process)
@@ -413,6 +407,12 @@ int kfd_init_apertures(struct kfd_proces
 					return -EINVAL;
 				}
 			}
+
+                        /* dGPUs: the reserved space for kernel
+                         * before SVM
+                         */
+                        pdd->qpd.cwsr_base = SVM_CWSR_BASE;
+                        pdd->qpd.ib_base = SVM_IB_BASE;
 		}
 
 		dev_dbg(kfd_device, "node id %u\n", id);


