Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2D921420B;
	Tue,  6 Jan 2026 18:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722505; cv=none; b=mvQSYM+YbMfjBUmKalOXdpxWXovRJKAcZHhxKI57rVCelnCultbbq8xwSavMIjzdwis3Ob1bFbiXTP2Z7r17hbj1uHqnjBXvOFyf3s4M5c88USnX9mT46m0OwLL1/4TNN5KKNpDqQb7MqxrW94LZDLqCbm4oqfis2wwMi2ZXLjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722505; c=relaxed/simple;
	bh=nD5zGpd+VTJ74TZDQTedHBF+GPDMrejn1Y7/qCVpcWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GmhNyi0f9/N8SD9qEzSv4TfUgz/gnYCDutw5bjTWz4f0LNj+UkCqLfFwA27n6R8xkY7aSDiQQDvZI7gJjM/p5SNc0z0utMNARWgcvw5gc0TNNoDIe3wWkpPTgURbB/EvgBYyKtr94y9ziuSGLP06EPBvBFSEIZYOu6q6i3W9M8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EKAukg9r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EKAukg9r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFEA9C19423;
	Tue,  6 Jan 2026 18:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722505;
	bh=nD5zGpd+VTJ74TZDQTedHBF+GPDMrejn1Y7/qCVpcWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EKAukg9rUV6bY9SCYi1K4hj8bxTihi0NmIWGNnNCQQJPRaf4Uonu2HeaTn+JF1YgM
	 uaaIgvve+8KaJGksEOaALRZ0m0aWjmVfMaDe06/yZI9tlkaSeHSHqjHbCiFGsqrOWl
	 FKiD81aSNKxjYz96/69qlgXqTKnU11VokMQ6e4zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 267/312] drm/amdgpu/gmc11: add amdgpu_vm_handle_fault() handling
Date: Tue,  6 Jan 2026 18:05:41 +0100
Message-ID: <20260106170557.504445575@linuxfoundation.org>
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


