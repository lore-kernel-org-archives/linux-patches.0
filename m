Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E602D73B9;
	Tue,  6 Jan 2026 17:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721229; cv=none; b=eH6wdivrkHcsAO2uJlmwzUoVaUcG9WzJ3gZdeUc4h2APpNhKu8Bs9VV/UjT+s8sMTUrLDWVZE6ZxLzGZORsqyEKpPUZOSB+4vW0n7dy9V7eNl9J24pe/1ybFlVzfT3rWweo9DANa2Z45zT8Nf88flcVwT14O50lPkPe7d1k8BLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721229; c=relaxed/simple;
	bh=IJfNp7p/56k5O3ywbh28aaMq+717n+nNcbPE5UUfTtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m70L36mEuK1oZvOiB/zBIHYsr1yoMgs+gI4EVTwWLg4oKX+7wpOcf18e8bN8ExXIQ+0djzSq/0s8g1SqhYBEoXt4UQSSXIszUIWQKg1C7fXT1lwCmiFAnjjkyQmauuuNsvS0Q1yZ/AgqMVqBFela0fiJRVmX0p2rdfK+l1Mla4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iew/ePQT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iew/ePQT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7882C16AAE;
	Tue,  6 Jan 2026 17:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721229;
	bh=IJfNp7p/56k5O3ywbh28aaMq+717n+nNcbPE5UUfTtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iew/ePQT3BAjLF7WiBRE1OIxx/BcgeHdD0JImyXmbjpr6xB5Ph49d4KhbNDVVXLmS
	 VSbD4g6XCux14sSceRKp+oNV0aGBjUqGoEsLhDY2fdLAw48Ba7e5ova+3/zKkRvgS5
	 7SfBMLDhL3wxDg9J2mokXkSrAa6AYpTGPqDM2sMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 457/567] drm/amdgpu/gmc12: add amdgpu_vm_handle_fault() handling
Date: Tue,  6 Jan 2026 18:03:59 +0100
Message-ID: <20260106170508.251782268@linuxfoundation.org>
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


