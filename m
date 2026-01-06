Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2DE366551;
	Tue,  6 Jan 2026 18:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722438; cv=none; b=l3CBPdOdSbibnOHUgmvC4RV7rbKbPKVBWs2b8mk/s831v1+iAxOhHFDrUiLRRluhEuimo+bf96u3We8zeKX2cpyjdfGGYL/5SmGYsidVEYs/h3pZLb5Ir3P9natH4dQADlrjxW7uyuLPM5mizPqteJCp+UWqvgBp9sx32vgCDqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722438; c=relaxed/simple;
	bh=WfQArtvYuCYGbpdTK+oQog2PoT0RGJbC8xqbE+NhavM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=maNvZr4N20r4+ueckaALyFoSVCJjBoEi3J8JSSqa4onTBqOnwwr0xfChb7yPIxjKe9k2cSgkKYn3oSrg6P4T0OXbk/O2avFbVJyVGG0aiScQY5MNN86dSecUM1c3pnAWlMPwTWOZrVCAiEkcfMKS8HxR7FgS18zTXCm6yj9xmiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U252y3DH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U252y3DH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473DEC116C6;
	Tue,  6 Jan 2026 18:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722438;
	bh=WfQArtvYuCYGbpdTK+oQog2PoT0RGJbC8xqbE+NhavM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U252y3DHGbFcgJfRMdWHQfciTUJM68/8rVSXHpuLO7sZa628z/pT2IX6iYa59CsqL
	 6EiE/MbKAFv7hB/AredUbgrAKYCRCQ0oB3e4K93bt17F28OyvZ93qVdnigatWeID85
	 /4/m4tOV2vLMS4lmam6j/3F5ooFgqizaLYDBDNgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 263/312] drm/amdgpu/gmc12: add amdgpu_vm_handle_fault() handling
Date: Tue,  6 Jan 2026 18:05:37 +0100
Message-ID: <20260106170557.361430085@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit ff28ff98db6a8eeb469e02fb8bd1647b353232a9 upstream.

We need to call amdgpu_vm_handle_fault() on page fault
on all gfx9 and newer parts to properly update the
page tables, not just for recoverable page faults.

Cc: stable@vger.kernel.org
Reviewed-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c
@@ -91,6 +91,8 @@ static int gmc_v12_0_process_interrupt(s
 				       struct amdgpu_iv_entry *entry)
 {
 	struct amdgpu_vmhub *hub;
+	bool retry_fault = !!(entry->src_data[1] & 0x80);
+	bool write_fault = !!(entry->src_data[1] & 0x20);
 	uint32_t status = 0;
 	u64 addr;
 
@@ -102,6 +104,31 @@ static int gmc_v12_0_process_interrupt(s
 	else
 		hub = &adev->vmhub[AMDGPU_GFXHUB(0)];
 
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


