Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9FE23E23C;
	Tue,  6 Jan 2026 17:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721286; cv=none; b=lWr6TWbGF/3IX8WsV3T6Uf+jYXFKc7Zu7E52o7Uqnc8a9hOpWKgI1WL50IOAIPPk6LuK8Oj+Z+XocCLrRNnN1hVhCPgtEHjuZdgt0t4V8umCq/T6T9YDyZYNq0+AMiv+25zItsA3tNzXLWTbp0U3f0hIvi5oJIyoqy9NvHL+I8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721286; c=relaxed/simple;
	bh=grLqZN+Xv7quk/u5dSXenHQZ3E74EWldJich8AGGoNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AySqJ15VCnX96lLyqID1mxdrIeKL2zIbUccTTUsAT3YT1Dv0N1D5QglbFP53xoMgb3mD9Stg5kZqUCET4lZ1V6kvD7y84vOGwuteMEBi1En4+xMbag/v5MMNJ1xCYVDVCeP/i7y+lckJ5JF78BPmopzH+TAVvOrwJz+lsjHjSvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o/LeqpX6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o/LeqpX6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B11C116C6;
	Tue,  6 Jan 2026 17:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721286;
	bh=grLqZN+Xv7quk/u5dSXenHQZ3E74EWldJich8AGGoNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o/LeqpX6YOGAMyPdBv9F5zXonXY4jWAJ/8cbDHN6sxR+O7mHDWAAyUu7lwcWExXo6
	 4Qkb5twBYptgq4+XX00yz1MHEwiPTsXm3NDNlr3a4BrdgZnnZ4E5FjJFW+qTBawPEx
	 X2wBcxo/CNdXa1I49zI8hRlbcCgXwCb+2PamGgU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 459/567] drm/amdgpu/gmc11: add amdgpu_vm_handle_fault() handling
Date: Tue,  6 Jan 2026 18:04:01 +0100
Message-ID: <20260106170508.324936523@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 3f2289b56cd98f5741056bdb6e521324eff07ce5 upstream.

We need to call amdgpu_vm_handle_fault() on page fault
on all gfx9 and newer parts to properly update the
page tables, not just for recoverable page faults.

Cc: stable@vger.kernel.org
Reviewed-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gmc_v11_0.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/gmc_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v11_0.c
@@ -103,12 +103,39 @@ static int gmc_v11_0_process_interrupt(s
 	uint32_t vmhub_index = entry->client_id == SOC21_IH_CLIENTID_VMC ?
 			       AMDGPU_MMHUB0(0) : AMDGPU_GFXHUB(0);
 	struct amdgpu_vmhub *hub = &adev->vmhub[vmhub_index];
+	bool retry_fault = !!(entry->src_data[1] & 0x80);
+	bool write_fault = !!(entry->src_data[1] & 0x20);
 	uint32_t status = 0;
 	u64 addr;
 
 	addr = (u64)entry->src_data[0] << 12;
 	addr |= ((u64)entry->src_data[1] & 0xf) << 44;
 
+	if (retry_fault) {
+		/* Returning 1 here also prevents sending the IV to the KFD */
+
+		/* Process it only if it's the first fault for this address */
+		if (entry->ih != &adev->irq.ih_soft &&
+		    amdgpu_gmc_filter_faults(adev, entry->ih, addr, entry->pasid,
+					     entry->timestamp))
+			return 1;
+
+		/* Delegate it to a different ring if the hardware hasn't
+		 * already done it.
+		 */
+		if (entry->ih == &adev->irq.ih) {
+			amdgpu_irq_delegate(adev, entry, 8);
+			return 1;
+		}
+
+		/* Try to handle the recoverable page faults by filling page
+		 * tables
+		 */
+		if (amdgpu_vm_handle_fault(adev, entry->pasid, 0, 0, addr,
+					   entry->timestamp, write_fault))
+			return 1;
+	}
+
 	if (!amdgpu_sriov_vf(adev)) {
 		/*
 		 * Issue a dummy read to wait for the status register to


