Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1815324291A;
	Tue, 29 Apr 2025 17:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947142; cv=none; b=M9vtuxzhnVooAzI0AtStXV69sIuNzn7KsZg0kkyo+D9EB7u5nsYz/eZPb/0SYIN/519Kv0W+aybPgfWc4/ve2zu+g43KUdNe/wYXWC+IP4PzLAFPsvBRsgrkhR8RsDm7qQ6XNLFyK6tPIejfNMOGxndk2twxPIWoW2th+UMR3r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947142; c=relaxed/simple;
	bh=Pjd03rHM5CXdXf2Tkjz8FmOEMTUNpg7RWwqJ++zNsnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sMc42oUyNow85nKWGNJG78VK1z1u/DNm7NHcHpuhHK7EDWiEpSeL19mwJTZsFlEjA3me7sCtkdwq7Efre6RH5FX9sNICdSrgUtuHxttS2hLW+2jPbF0Vg12VMtyFDpsVb/yi54a6hElqSFeQM2XeoK4UYiT/bai/4oWmv5I36NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZvnWx8B1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZvnWx8B1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A80EC4CEE3;
	Tue, 29 Apr 2025 17:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947142;
	bh=Pjd03rHM5CXdXf2Tkjz8FmOEMTUNpg7RWwqJ++zNsnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZvnWx8B1YLsYJQQALy3wIVVh7xc6QPVodfHA6lGfjYlnJ64lwGkoMC/hmPiMRtn3+
	 wZ0/bHjpfRUvPLQ0XkUOIhbVdOfcCGAo67AztZtrOQM4ghDRMZmArNmdFUCpfmLzKV
	 zQlxzkUoUQubpUhvs4JQlv5JkpZNT+W5z+GRhaR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhishek Sahu <abhsahu@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Feng Liu <Feng.Liu3@windriver.com>,
	He Zhe <Zhe.He@windriver.com>
Subject: [PATCH 5.10 185/286] vfio/pci: fix memory leak during D3hot to D0 transition
Date: Tue, 29 Apr 2025 18:41:29 +0200
Message-ID: <20250429161115.582857220@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

From: Abhishek Sahu <abhsahu@nvidia.com>

commit eadf88ecf6ac7d6a9f47a76c6055d9a1987a8991 upstream.

If 'vfio_pci_core_device::needs_pm_restore' is set (PCI device does
not have No_Soft_Reset bit set in its PMCSR config register), then
the current PCI state will be saved locally in
'vfio_pci_core_device::pm_save' during D0->D3hot transition and same
will be restored back during D3hot->D0 transition.
For saving the PCI state locally, pci_store_saved_state() is being
used and the pci_load_and_free_saved_state() will free the allocated
memory.

But for reset related IOCTLs, vfio driver calls PCI reset-related
API's which will internally change the PCI power state back to D0. So,
when the guest resumes, then it will get the current state as D0 and it
will skip the call to vfio_pci_set_power_state() for changing the
power state to D0 explicitly. In this case, the memory pointed by
'pm_save' will never be freed. In a malicious sequence, the state changing
to D3hot followed by VFIO_DEVICE_RESET/VFIO_DEVICE_PCI_HOT_RESET can be
run in a loop and it can cause an OOM situation.

This patch frees the earlier allocated memory first before overwriting
'pm_save' to prevent the mentioned memory leak.

Fixes: 51ef3a004b1e ("vfio/pci: Restore device state on PM transition")
Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
Link: https://lore.kernel.org/r/20220217122107.22434-2-abhsahu@nvidia.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
[Minor context change fixed]
Signed-off-by: Feng Liu <Feng.Liu3@windriver.com>
Signed-off-by: He Zhe <Zhe.He@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/pci/vfio_pci.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -299,6 +299,19 @@ int vfio_pci_set_power_state(struct vfio
 	if (!ret) {
 		/* D3 might be unsupported via quirk, skip unless in D3 */
 		if (needs_save && pdev->current_state >= PCI_D3hot) {
+			/*
+			 * The current PCI state will be saved locally in
+			 * 'pm_save' during the D3hot transition. When the
+			 * device state is changed to D0 again with the current
+			 * function, then pci_store_saved_state() will restore
+			 * the state and will free the memory pointed by
+			 * 'pm_save'. There are few cases where the PCI power
+			 * state can be changed to D0 without the involvement
+			 * of the driver. For these cases, free the earlier
+			 * allocated memory first before overwriting 'pm_save'
+			 * to prevent the memory leak.
+			 */
+			kfree(vdev->pm_save);
 			vdev->pm_save = pci_store_saved_state(pdev);
 		} else if (needs_restore) {
 			pci_load_and_free_saved_state(pdev, &vdev->pm_save);


