Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8BD350D51;
	Tue, 26 Aug 2025 14:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218250; cv=none; b=njg++kOSUzPNSgy1fDwC36T9m4q+l0s1jlqqymAglzU8yDFmV6BcyD3DrD/a72l7jWlh+73Wwrbou4+U21oqiv1uCet3F5jhhXoQnSKlpPy9AFoZeN98rZgtH4jDzDnjAff+lLWgKgBK/1aUY0HIAYLWIht3vuav3LGxvsC/5M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218250; c=relaxed/simple;
	bh=eYZm/5/tcTBymDZhFs42ix9e6ZOJBSX+2e6ZXvZeQ8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E200IqVLfajBBwjANrZ96+TeE5lc0KG27LPE/+pnufGNduKqs/CxZlZ4mHjs8o8WdQVRzfiGJd8RFo5a4gHNWNd7LDQSqH027Ff7ArUwSg34rT/BNu+kRdo2EDbWnbb0yrmfQfCY47zzVLpEwWcrDyswtEDYVklNMe+UACQFz88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nXYv3y7q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nXYv3y7q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E42EC4CEF1;
	Tue, 26 Aug 2025 14:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218250;
	bh=eYZm/5/tcTBymDZhFs42ix9e6ZOJBSX+2e6ZXvZeQ8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nXYv3y7qdmgEINC/9HIuJtJWj8gfjWAEzpZLpIufn15piP4hjHxOYKk/ngzevA4ZU
	 jngkUYNb/cBgqsswa3HcYXIXAr+li+kEI+U95d8izHdy91dfrEL2L+RiptnULRty2y
	 S37w2OwckPsF2GWooAuyAn3TX+Iq91OV4yl8W4Z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
	Guchun Chen <guchun.chen@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Shivani Agarwal <shivani.agarwal@broadcom.com>
Subject: [PATCH 5.10 451/523] drm/amdgpu: handle the case of pci_channel_io_frozen only in amdgpu_pci_resume
Date: Tue, 26 Aug 2025 13:11:01 +0200
Message-ID: <20250826110935.576675411@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guchun Chen <guchun.chen@amd.com>

[ Upstream commit 248b061689a40f4fed05252ee2c89f87cf26d7d8 ]

In current code, when a PCI error state pci_channel_io_normal is detectd,
it will report PCI_ERS_RESULT_CAN_RECOVER status to PCI driver, and PCI
driver will continue the execution of PCI resume callback report_resume by
pci_walk_bridge, and the callback will go into amdgpu_pci_resume
finally, where write lock is releasd unconditionally without acquiring
such lock first. In this case, a deadlock will happen when other threads
start to acquire the read lock.

To fix this, add a member in amdgpu_device strucutre to cache
pci_channel_state, and only continue the execution in amdgpu_pci_resume
when it's pci_channel_io_frozen.

Fixes: c9a6b82f45e2 ("drm/amdgpu: Implement DPC recovery")
Suggested-by: Andrey Grodzovsky <andrey.grodzovsky@amd.com>
Signed-off-by: Guchun Chen <guchun.chen@amd.com>
Reviewed-by: Andrey Grodzovsky <andrey.grodzovsky@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
[Shivani: Modified to apply on 5.10.y]
Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu.h        |    1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    6 ++++++
 2 files changed, 7 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -997,6 +997,7 @@ struct amdgpu_device {
 
 	bool                            in_pci_err_recovery;
 	struct pci_saved_state          *pci_state;
+	pci_channel_state_t		pci_channel_state;
 };
 
 static inline struct amdgpu_device *drm_to_adev(struct drm_device *ddev)
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4944,6 +4944,8 @@ pci_ers_result_t amdgpu_pci_error_detect
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
 
+	adev->pci_channel_state = state;
+
 	switch (state) {
 	case pci_channel_io_normal:
 		return PCI_ERS_RESULT_CAN_RECOVER;
@@ -5079,6 +5081,10 @@ void amdgpu_pci_resume(struct pci_dev *p
 
 	DRM_INFO("PCI error: resume callback!!\n");
 
+	/* Only continue execution for the case of pci_channel_io_frozen */
+	if (adev->pci_channel_state != pci_channel_io_frozen)
+		return;
+
 	for (i = 0; i < AMDGPU_MAX_RINGS; ++i) {
 		struct amdgpu_ring *ring = adev->rings[i];
 


