Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2E91F7561;
	Tue,  3 Dec 2024 16:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242255; cv=none; b=qMBGcvNXhSKnXEBgcgeQal+PG0glqkWvlx22AidrHHj5bjHm6aLTIfXMUC6E2u0wtcc8z04d46headNc0y5Q6bb1OUxKLTsiacKsGmSqiPIpVunNynY/zoe9xD2foTH+945pEAa4gDMLNE3FWGKUnjih+mrcf5IGrSVqgAjoLCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242255; c=relaxed/simple;
	bh=VerR/C2MOWG1r8CPrdZEQdLNt2BhfUxd3yNgTEyjZkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DrVKxuEOCIq8ZBH4wFcFDBus27vxHxL0M0xV1HPxPZqFIptUwKc7zS4GpjcEt9JleEgthldVKQOQaosjkF0X6fkVGiL8BnDS7NbBCzK10UqKpl63sg7VulM+cCmPuse1jP/am0e7z8cooMY7qpP2tXdMhAoAfHJ3t962DX0Js3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OgMfTt/D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OgMfTt/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F68CC4CECF;
	Tue,  3 Dec 2024 16:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242255;
	bh=VerR/C2MOWG1r8CPrdZEQdLNt2BhfUxd3yNgTEyjZkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OgMfTt/D0NwtItNhaSkxN5lic+87esYOz3EJhEg+huXMTYCLxo4hI4zJ/OOB5yXrP
	 O9fMUsNBDYK+cxhbbJbbRRGDU40RlqgTHpV2GFQLWH8KolsquHlFHtSjH3354XfA5G
	 Gifa/2xYF7DHnn6oAU/pjWMZch6m+b4LrgcvVGls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 621/826] s390/pci: Fix potential double remove of hotplug slot
Date: Tue,  3 Dec 2024 15:45:48 +0100
Message-ID: <20241203144807.976366989@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Schnelle <schnelle@linux.ibm.com>

[ Upstream commit c4a585e952ca403a370586d3f16e8331a7564901 ]

In commit 6ee600bfbe0f ("s390/pci: remove hotplug slot when releasing the
device") the zpci_exit_slot() was moved from zpci_device_reserved() to
zpci_release_device() with the intention of keeping the hotplug slot
around until the device is actually removed.

Now zpci_release_device() is only called once all references are
dropped. Since the zPCI subsystem only drops its reference once the
device is in the reserved state it follows that zpci_release_device()
must only deal with devices in the reserved state. Despite that it
contains code to tear down from both configured and standby state. For
the standby case this already includes the removal of the hotplug slot
so would cause a double removal if a device was ever removed in
either configured or standby state.

Instead of causing a potential double removal in a case that should
never happen explicitly WARN_ON() if a device in non-reserved state is
released and get rid of the dead code cases.

Fixes: 6ee600bfbe0f ("s390/pci: remove hotplug slot when releasing the device")
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Gerd Bayer <gbayer@linux.ibm.com>
Tested-by: Gerd Bayer <gbayer@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/pci/pci.c | 34 +++++++++-------------------------
 1 file changed, 9 insertions(+), 25 deletions(-)

diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index be3299609f9b6..635fd8f2acbaa 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -917,10 +917,8 @@ void zpci_device_reserved(struct zpci_dev *zdev)
 void zpci_release_device(struct kref *kref)
 {
 	struct zpci_dev *zdev = container_of(kref, struct zpci_dev, kref);
-	int ret;
 
-	if (zdev->has_hp_slot)
-		zpci_exit_slot(zdev);
+	WARN_ON(zdev->state != ZPCI_FN_STATE_RESERVED);
 
 	if (zdev->zbus->bus)
 		zpci_bus_remove_device(zdev, false);
@@ -928,28 +926,14 @@ void zpci_release_device(struct kref *kref)
 	if (zdev_enabled(zdev))
 		zpci_disable_device(zdev);
 
-	switch (zdev->state) {
-	case ZPCI_FN_STATE_CONFIGURED:
-		ret = sclp_pci_deconfigure(zdev->fid);
-		zpci_dbg(3, "deconf fid:%x, rc:%d\n", zdev->fid, ret);
-		fallthrough;
-	case ZPCI_FN_STATE_STANDBY:
-		if (zdev->has_hp_slot)
-			zpci_exit_slot(zdev);
-		spin_lock(&zpci_list_lock);
-		list_del(&zdev->entry);
-		spin_unlock(&zpci_list_lock);
-		zpci_dbg(3, "rsv fid:%x\n", zdev->fid);
-		fallthrough;
-	case ZPCI_FN_STATE_RESERVED:
-		if (zdev->has_resources)
-			zpci_cleanup_bus_resources(zdev);
-		zpci_bus_device_unregister(zdev);
-		zpci_destroy_iommu(zdev);
-		fallthrough;
-	default:
-		break;
-	}
+	if (zdev->has_hp_slot)
+		zpci_exit_slot(zdev);
+
+	if (zdev->has_resources)
+		zpci_cleanup_bus_resources(zdev);
+
+	zpci_bus_device_unregister(zdev);
+	zpci_destroy_iommu(zdev);
 	zpci_dbg(3, "rem fid:%x\n", zdev->fid);
 	kfree_rcu(zdev, rcu);
 }
-- 
2.43.0



