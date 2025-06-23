Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4832624169B;
	Mon, 23 Jun 2025 13:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684343; cv=none; b=h/tWpzYkhMK0crvUMduQY4eJchx17L7YoBrCPOfiu02KTlhBYg/h8Gu3Mg/u+D6dP4FRtY3LSdYlWepYBiuIQysafzM8kYWXBW7kiygGvieReiqoBlrisDrww+lgctUwKfa//F8oNyBaR9BPGoV8NyTMW70/SISF1u6UZIfME0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684343; c=relaxed/simple;
	bh=jD7HNrUZ7KII2aeTIjkPzPKukbe2yr5baLg+8ebvLQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=czVk8wWtFWQWmiAj7AncBlhYtzfQgFUBWb+MNCQ3PM9xt0lRc5MlbTlP/8/GLK3GbXffrNXW9My+10o2t7UMCKj2oSEAEFSorqhbsOAUd0xYxdfY5vQBpXeJ01MjdUf69QbO2Ay8QiYTGZ/sLWF9sJoDQmhO4dFdzsMyp2p0uOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WgLLQpRl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WgLLQpRl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D145AC4CEEA;
	Mon, 23 Jun 2025 13:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684343;
	bh=jD7HNrUZ7KII2aeTIjkPzPKukbe2yr5baLg+8ebvLQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WgLLQpRlL9dn/c/6mxw24+b0ae7RAtq84q1EDwtdQtdgojhAfvngj4xnRbVl4m5Hb
	 TiIONI6arcpAxJNVwRwe2Vxe9WKb2L6wniFsou7ZLnqMno57Iftb7QwdDrZjdVjNKj
	 RW/PtgxctArtqwup6YSLDXb5buEKzXVW+SM7iNz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.15 025/592] s390/pci: Allow re-add of a reserved but not yet removed device
Date: Mon, 23 Jun 2025 14:59:43 +0200
Message-ID: <20250623130700.831802034@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Schnelle <schnelle@linux.ibm.com>

commit 4b1815a52d7eb03b3e0e6742c6728bc16a4b2d1d upstream.

The architecture assumes that PCI functions can be removed synchronously
as PCI events are processed. This however clashes with the reference
counting of struct pci_dev which allows device drivers to hold on to a
struct pci_dev reference even as the underlying device is removed. To
bridge this gap commit 2a671f77ee49 ("s390/pci: fix use after free of
zpci_dev") keeps the struct zpci_dev in ZPCI_FN_STATE_RESERVED state
until common code releases the struct pci_dev. Only when all references
are dropped, the struct zpci_dev can be removed and freed.

Later commit a46044a92add ("s390/pci: fix zpci_zdev_put() on reserve")
moved the deletion of the struct zpci_dev from the zpci_list in
zpci_release_device() to the point where the device is reserved. This
was done to prevent handling events for a device that is already being
removed, e.g. when the platform generates both PCI event codes 0x304
and 0x308. In retrospect, deletion from the zpci_list in the release
function without holding the zpci_list_lock was also racy.

A side effect of this handling is that if the underlying device
re-appears while the struct zpci_dev is in the ZPCI_FN_STATE_RESERVED
state, the new and old instances of the struct zpci_dev and/or struct
pci_dev may clash. For example when trying to create the IOMMU sysfs
files for the new instance. In this case, re-adding the new instance is
aborted. The old instance is removed, and the device will remain absent
until the platform issues another event.

Fix this by allowing the struct zpci_dev to be brought back up right
until it is finally removed. To this end also keep the struct zpci_dev
in the zpci_list until it is finally released when all references have
been dropped.

Deletion from the zpci_list from within the release function is made
safe by using kref_put_lock() with the zpci_list_lock. This ensures that
the releasing code holds the last reference.

Cc: stable@vger.kernel.org
Fixes: a46044a92add ("s390/pci: fix zpci_zdev_put() on reserve")
Reviewed-by: Gerd Bayer <gbayer@linux.ibm.com>
Tested-by: Gerd Bayer <gbayer@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/pci/pci.c       |   32 ++++++++++++++++++++++----------
 arch/s390/pci/pci_bus.h   |    7 ++-----
 arch/s390/pci/pci_event.c |   22 +++++++++++++++++++++-
 3 files changed, 45 insertions(+), 16 deletions(-)

--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -70,6 +70,13 @@ EXPORT_SYMBOL_GPL(zpci_aipb);
 struct airq_iv *zpci_aif_sbv;
 EXPORT_SYMBOL_GPL(zpci_aif_sbv);
 
+void zpci_zdev_put(struct zpci_dev *zdev)
+{
+	if (!zdev)
+		return;
+	kref_put_lock(&zdev->kref, zpci_release_device, &zpci_list_lock);
+}
+
 struct zpci_dev *get_zdev_by_fid(u32 fid)
 {
 	struct zpci_dev *tmp, *zdev = NULL;
@@ -925,21 +932,20 @@ int zpci_deconfigure_device(struct zpci_
  * @zdev: the zpci_dev that was reserved
  *
  * Handle the case that a given zPCI function was reserved by another system.
- * After a call to this function the zpci_dev can not be found via
- * get_zdev_by_fid() anymore but may still be accessible via existing
- * references though it will not be functional anymore.
  */
 void zpci_device_reserved(struct zpci_dev *zdev)
 {
-	/*
-	 * Remove device from zpci_list as it is going away. This also
-	 * makes sure we ignore subsequent zPCI events for this device.
-	 */
-	spin_lock(&zpci_list_lock);
-	list_del(&zdev->entry);
-	spin_unlock(&zpci_list_lock);
+	lockdep_assert_held(&zdev->state_lock);
+	/* We may declare the device reserved multiple times */
+	if (zdev->state == ZPCI_FN_STATE_RESERVED)
+		return;
 	zdev->state = ZPCI_FN_STATE_RESERVED;
 	zpci_dbg(3, "rsv fid:%x\n", zdev->fid);
+	/*
+	 * The underlying device is gone. Allow the zdev to be freed
+	 * as soon as all other references are gone by accounting for
+	 * the removal as a dropped reference.
+	 */
 	zpci_zdev_put(zdev);
 }
 
@@ -948,6 +954,12 @@ void zpci_release_device(struct kref *kr
 	struct zpci_dev *zdev = container_of(kref, struct zpci_dev, kref);
 
 	WARN_ON(zdev->state != ZPCI_FN_STATE_RESERVED);
+	/*
+	 * We already hold zpci_list_lock thanks to kref_put_lock().
+	 * This makes sure no new reference can be taken from the list.
+	 */
+	list_del(&zdev->entry);
+	spin_unlock(&zpci_list_lock);
 
 	if (zdev->has_hp_slot)
 		zpci_exit_slot(zdev);
--- a/arch/s390/pci/pci_bus.h
+++ b/arch/s390/pci/pci_bus.h
@@ -21,11 +21,8 @@ int zpci_bus_scan_device(struct zpci_dev
 void zpci_bus_remove_device(struct zpci_dev *zdev, bool set_error);
 
 void zpci_release_device(struct kref *kref);
-static inline void zpci_zdev_put(struct zpci_dev *zdev)
-{
-	if (zdev)
-		kref_put(&zdev->kref, zpci_release_device);
-}
+
+void zpci_zdev_put(struct zpci_dev *zdev);
 
 static inline void zpci_zdev_get(struct zpci_dev *zdev)
 {
--- a/arch/s390/pci/pci_event.c
+++ b/arch/s390/pci/pci_event.c
@@ -335,6 +335,22 @@ static void zpci_event_hard_deconfigured
 	zdev->state = ZPCI_FN_STATE_STANDBY;
 }
 
+static void zpci_event_reappear(struct zpci_dev *zdev)
+{
+	lockdep_assert_held(&zdev->state_lock);
+	/*
+	 * The zdev is in the reserved state. This means that it was presumed to
+	 * go away but there are still undropped references. Now, the platform
+	 * announced its availability again. Bring back the lingering zdev
+	 * to standby. This is safe because we hold a temporary reference
+	 * now so that it won't go away. Account for the re-appearance of the
+	 * underlying device by incrementing the reference count.
+	 */
+	zdev->state = ZPCI_FN_STATE_STANDBY;
+	zpci_zdev_get(zdev);
+	zpci_dbg(1, "rea fid:%x, fh:%x\n", zdev->fid, zdev->fh);
+}
+
 static void __zpci_event_availability(struct zpci_ccdf_avail *ccdf)
 {
 	struct zpci_dev *zdev = get_zdev_by_fid(ccdf->fid);
@@ -358,8 +374,10 @@ static void __zpci_event_availability(st
 				break;
 			}
 		} else {
+			if (zdev->state == ZPCI_FN_STATE_RESERVED)
+				zpci_event_reappear(zdev);
 			/* the configuration request may be stale */
-			if (zdev->state != ZPCI_FN_STATE_STANDBY)
+			else if (zdev->state != ZPCI_FN_STATE_STANDBY)
 				break;
 			zdev->state = ZPCI_FN_STATE_CONFIGURED;
 		}
@@ -375,6 +393,8 @@ static void __zpci_event_availability(st
 				break;
 			}
 		} else {
+			if (zdev->state == ZPCI_FN_STATE_RESERVED)
+				zpci_event_reappear(zdev);
 			zpci_update_fh(zdev, ccdf->fh);
 		}
 		break;


