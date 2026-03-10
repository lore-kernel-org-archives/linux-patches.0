Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456E73876D7;
	Tue, 10 Mar 2026 11:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141928; cv=none; b=Y7uvpHXKa49MaBSYrPIho9YbT69DljbQ69CMo4ldEbNZgosOqyR7tXnxN7zxfkL9OU95pG6nxZDGMW7oQTGRAeR0Uf9I8xhtnM9+WLK0uegP7yMtMjWjL4C9qGqkHtmDgK+wL35M6vQ1MVawvjbkyi2ofopF/fT3CvizISef6YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141928; c=relaxed/simple;
	bh=GjewYC9lpT0OlmPSZcS5T6Qh1Rafl8dBrJDlmmacaHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A3AYMUj6c1b9QiVhzUqAyk07soWmfRPtyT1IKAvihSDWnp+Ok9L/IMOsUDsq1ojB1LuAkBJlpZ4ywzLCNQLu2VOy/4GkBK6DHoNHNJDbEB8J2coiRlvL07L2r+/fH4DF6ArvKutFexOkVBTqL7QnPKGs64/rn4tK+xwVHQEumEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NtRM0+pS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NtRM0+pS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36116C19423;
	Tue, 10 Mar 2026 11:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141927;
	bh=GjewYC9lpT0OlmPSZcS5T6Qh1Rafl8dBrJDlmmacaHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NtRM0+pSgIMFtcwzPfdBs0B1m2o7LvNAi4QEsXF/iDtPbEKnc16CgVG3Crt/yq0k0
	 D0CMFfeuFG47Aa5U4aYU2GNg6gCL4dBS1O7w62zNka8FBp6/LIzT7ueYO0CwRVqRqd
	 6Np1hwIO8UUYWT4B2QkscSip73/XIGRiKBZeGGZ0oOK/1BoUXgi8XwrH1QYLq4VYag
	 nyjRiQQEKSQPmeOfKzFGIGLcrtjIq5VZQ3jmg3Cl5f7Py9RxqTYLQ9KNZjbPu5AMvQ
	 UpVRcUC56Zd2lGiNpIoeTR2lnnfZKIXvuAimhODRQjNBwzgANECR9E5fiGOuP74vW+
	 kVEYs9lPBh5oA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lijo Lazar <lijo.lazar@amd.com>,
	Ce Sun <cesun102@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 051/314] drm/amdgpu: Fix error handling in slot reset
Date: Tue, 10 Mar 2026 07:15:10 -0400
Message-ID: <738d1861461d66114606eb4aa667c5a6b54a7dce.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit b57c4ec98c17789136a4db948aec6daadceb5024 ]

If the device has not recovered after slot reset is called, it goes to
out label for error handling. There it could make decision based on
uninitialized hive pointer and could result in accessing an uninitialized
list.

Initialize the list and hive properly so that it handles the error
situation and also releases the reset domain lock which is acquired
during error_detected callback.

Fixes: 732c6cefc1ec ("drm/amdgpu: Replace tmp_adev with hive in amdgpu_pci_slot_reset")
Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Ce Sun <cesun102@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit bb71362182e59caa227e4192da5a612b09349696)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index b28ebb44c695d..fb096bf551ef2 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -7062,6 +7062,15 @@ pci_ers_result_t amdgpu_pci_slot_reset(struct pci_dev *pdev)
 	dev_info(adev->dev, "PCI error: slot reset callback!!\n");
 
 	memset(&reset_context, 0, sizeof(reset_context));
+	INIT_LIST_HEAD(&device_list);
+	hive = amdgpu_get_xgmi_hive(adev);
+	if (hive) {
+		mutex_lock(&hive->hive_lock);
+		list_for_each_entry(tmp_adev, &hive->device_list, gmc.xgmi.head)
+			list_add_tail(&tmp_adev->reset_list, &device_list);
+	} else {
+		list_add_tail(&adev->reset_list, &device_list);
+	}
 
 	if (adev->pcie_reset_ctx.swus)
 		link_dev = adev->pcie_reset_ctx.swus;
@@ -7102,19 +7111,13 @@ pci_ers_result_t amdgpu_pci_slot_reset(struct pci_dev *pdev)
 	reset_context.reset_req_dev = adev;
 	set_bit(AMDGPU_NEED_FULL_RESET, &reset_context.flags);
 	set_bit(AMDGPU_SKIP_COREDUMP, &reset_context.flags);
-	INIT_LIST_HEAD(&device_list);
 
-	hive = amdgpu_get_xgmi_hive(adev);
 	if (hive) {
-		mutex_lock(&hive->hive_lock);
 		reset_context.hive = hive;
-		list_for_each_entry(tmp_adev, &hive->device_list, gmc.xgmi.head) {
+		list_for_each_entry(tmp_adev, &hive->device_list, gmc.xgmi.head)
 			tmp_adev->pcie_reset_ctx.in_link_reset = true;
-			list_add_tail(&tmp_adev->reset_list, &device_list);
-		}
 	} else {
 		set_bit(AMDGPU_SKIP_HW_RESET, &reset_context.flags);
-		list_add_tail(&adev->reset_list, &device_list);
 	}
 
 	r = amdgpu_device_asic_reset(adev, &device_list, &reset_context);
-- 
2.51.0

