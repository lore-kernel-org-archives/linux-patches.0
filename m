Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7041487CD;
	Thu, 12 Dec 2024 15:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017383; cv=none; b=NrSEJaCtvxafWSTMCTQRToEsvinLe4h94aBXewSeoyO7qegUs/2oFZRe4/c2clofrioTSED7W5CmBY90TKuOcsjOFirHNVtCzBJ5ZSa/3VuUZ5fEbdviJzdBRcOywosjaHt1KpftjPTKYcxqOAvRgn3+bSdTQ8zwjCV6h6StWZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017383; c=relaxed/simple;
	bh=Wr6IvQoVqaY8PssLWs/s4bsbVM+PmVR2twfyqBepFq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pfvxRpkfAydyiaBv9e6bG28GcSf5QHXsDyyPrNzwFvpSoCDrkLdDOVlRhtTOi4GiGAoG4TiPTW/o3bbj20IKNdGa51v4W7wbnwW1UCgDGzrqXSz03FawCmzXRoUcIcSg/6jPm4POVKGaQjv/ECmIyJUlbBIUR450mF/yWzpTwrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K3l7X+nq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K3l7X+nq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB32C4CECE;
	Thu, 12 Dec 2024 15:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017382;
	bh=Wr6IvQoVqaY8PssLWs/s4bsbVM+PmVR2twfyqBepFq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K3l7X+nquyuYEFD657ri+py6ehCZAeBNdZWa+zF9K7qRiTOe2h8EzcXzqNxE3k/Wg
	 pC7yJ2Lf7UAXLLFiDsrfXIzQvNYGvZeD2O5pbPIy0pSJ136XKuXUgjgYeYznMOYXxX
	 W2uXgP6eloyrQxa7BLRweOu0RR+4p0juYuAtGCG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.12 464/466] s390/pci: Fix leak of struct zpci_dev when zpci_add_device() fails
Date: Thu, 12 Dec 2024 16:00:33 +0100
Message-ID: <20241212144325.200056416@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

commit 48796104c864cf4dafa80bd8c2ce88f9c92a65ea upstream.

Prior to commit 0467cdde8c43 ("s390/pci: Sort PCI functions prior to
creating virtual busses") the IOMMU was initialized and the device was
registered as part of zpci_create_device() with the struct zpci_dev
freed if either resulted in an error. With that commit this was moved
into a separate function called zpci_add_device().

While this new function logs when adding failed, it expects the caller
not to use and to free the struct zpci_dev on error. This difference
between it and zpci_create_device() was missed while changing the
callers and the incompletely initialized struct zpci_dev may get used in
zpci_scan_configured_device in the error path. This then leads to
a crash due to the device not being registered with the zbus. It was
also not freed in this case. Fix this by handling the error return of
zpci_add_device(). Since in this case the zdev was not added to the
zpci_list it can simply be discarded and freed. Also make this more
explicit by moving the kref_init() into zpci_add_device() and document
that zpci_zdev_get()/zpci_zdev_put() must be used after adding.

Cc: stable@vger.kernel.org
Fixes: 0467cdde8c43 ("s390/pci: Sort PCI functions prior to creating virtual busses")
Reviewed-by: Gerd Bayer <gbayer@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/pci/pci.c       |   21 +++++++++++++++++----
 arch/s390/pci/pci_event.c |   10 ++++++++--
 2 files changed, 25 insertions(+), 6 deletions(-)

--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -779,8 +779,9 @@ int zpci_hot_reset_device(struct zpci_de
  * @fh: Current Function Handle of the device to be created
  * @state: Initial state after creation either Standby or Configured
  *
- * Creates a new zpci device and adds it to its, possibly newly created, zbus
- * as well as zpci_list.
+ * Allocates a new struct zpci_dev and queries the platform for its details.
+ * If successful the device can subsequently be added to the zPCI subsystem
+ * using zpci_add_device().
  *
  * Returns: the zdev on success or an error pointer otherwise
  */
@@ -803,7 +804,6 @@ struct zpci_dev *zpci_create_device(u32
 		goto error;
 	zdev->state =  state;
 
-	kref_init(&zdev->kref);
 	mutex_init(&zdev->state_lock);
 	mutex_init(&zdev->fmb_lock);
 	mutex_init(&zdev->kzdev_lock);
@@ -816,6 +816,17 @@ error:
 	return ERR_PTR(rc);
 }
 
+/**
+ * zpci_add_device() - Add a previously created zPCI device to the zPCI subsystem
+ * @zdev: The zPCI device to be added
+ *
+ * A struct zpci_dev is added to the zPCI subsystem and to a virtual PCI bus creating
+ * a new one as necessary. A hotplug slot is created and events start to be handled.
+ * If successful from this point on zpci_zdev_get() and zpci_zdev_put() must be used.
+ * If adding the struct zpci_dev fails the device was not added and should be freed.
+ *
+ * Return: 0 on success, or an error code otherwise
+ */
 int zpci_add_device(struct zpci_dev *zdev)
 {
 	int rc;
@@ -829,6 +840,7 @@ int zpci_add_device(struct zpci_dev *zde
 	if (rc)
 		goto error_destroy_iommu;
 
+	kref_init(&zdev->kref);
 	spin_lock(&zpci_list_lock);
 	list_add_tail(&zdev->entry, &zpci_list);
 	spin_unlock(&zpci_list_lock);
@@ -1105,7 +1117,8 @@ static void zpci_add_devices(struct list
 	list_sort(NULL, scan_list, &zpci_cmp_rid);
 	list_for_each_entry_safe(zdev, tmp, scan_list, entry) {
 		list_del_init(&zdev->entry);
-		zpci_add_device(zdev);
+		if (zpci_add_device(zdev))
+			kfree(zdev);
 	}
 }
 
--- a/arch/s390/pci/pci_event.c
+++ b/arch/s390/pci/pci_event.c
@@ -340,7 +340,10 @@ static void __zpci_event_availability(st
 			zdev = zpci_create_device(ccdf->fid, ccdf->fh, ZPCI_FN_STATE_CONFIGURED);
 			if (IS_ERR(zdev))
 				break;
-			zpci_add_device(zdev);
+			if (zpci_add_device(zdev)) {
+				kfree(zdev);
+				break;
+			}
 		} else {
 			/* the configuration request may be stale */
 			if (zdev->state != ZPCI_FN_STATE_STANDBY)
@@ -354,7 +357,10 @@ static void __zpci_event_availability(st
 			zdev = zpci_create_device(ccdf->fid, ccdf->fh, ZPCI_FN_STATE_STANDBY);
 			if (IS_ERR(zdev))
 				break;
-			zpci_add_device(zdev);
+			if (zpci_add_device(zdev)) {
+				kfree(zdev);
+				break;
+			}
 		} else {
 			zpci_update_fh(zdev, ccdf->fh);
 		}


