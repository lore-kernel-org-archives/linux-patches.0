Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C170E1DE3D6;
	Wed, 19 Feb 2025 08:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954461; cv=none; b=YNvhVGFz6aeeMkIyuw+eW6OqirU+sudv+GokBrI1nex9B7Dz0v2W6DnZGD6RuKLC3FsLRLH/FxqkkOz1OLdjLqu3XEAhZT2lWycdvMTMxcBhK29KNcN4oVm6f4WRdBi5ppNfa5mZzX1Cr1R3o9CpkLzzscPhM8USOtQGY7DuDFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954461; c=relaxed/simple;
	bh=uiNzWH4xhZlWjBdJ+2XYeAbkQ3ndR5vhmAez1zOGdzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hiUfrtHvOyI+ixltylWEcpnNbXPILVd/h6Nmlk2j0qT59XPF4VaxMFsKUeFvRQ2+qgh9qjyx3wofx7i3ZsLpe2+fiJfEztr5/FaEf6aZLAr0uT3mDnI2Icj7pkM57LUTolyDsnyglBKDqXRAnCZLRM50eLXHhST7XCnNvh9yvAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EfGb/2tA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EfGb/2tA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43CF1C4CEE9;
	Wed, 19 Feb 2025 08:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954461;
	bh=uiNzWH4xhZlWjBdJ+2XYeAbkQ3ndR5vhmAez1zOGdzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EfGb/2tAvTJGuPK/EcxO/lRWUFLNYS/wFH02d/PVKXZWg4Syfpkcer8Q/TmxLQvpW
	 UGTqlIHB4pkn9/mqwGOFCrUO3n/pSIufVB4CW2EfDQDU992MdZ9fpKdbSe6pVEJI24
	 DUmot+1Tgk2SHW42tOJiyOOi2+RsuMsoV9u14qT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Halil Pasic <pasic@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.13 171/274] s390/pci: Fix handling of isolated VFs
Date: Wed, 19 Feb 2025 09:27:05 +0100
Message-ID: <20250219082616.283178805@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Schnelle <schnelle@linux.ibm.com>

commit 2844ddbd540fc84d7571cca65d6c43088e4d6952 upstream.

In contrast to the commit message of the fixed commit VFs whose parent
PF is not configured are not always isolated, that is put on their own
PCI domain. This is because for VFs to be added to an existing PCI
domain it is enough for that PCI domain to share the same topology ID or
PCHID. Such a matching PCI domain without a parent PF may exist when
a PF from the same PCI card created the domain with the VF being a child
of a different, non accessible, PF. While not causing technical issues
it makes the rules which VFs are isolated inconsistent.

Fix this by explicitly checking that the parent PF exists on the PCI
domain determined by the topology ID or PCHID before registering the VF.
This works because a parent PF which is under control of this Linux
instance must be enabled and configured at the point where its child VFs
appear because otherwise SR-IOV could not have been enabled on the
parent.

Fixes: 25f39d3dcb48 ("s390/pci: Ignore RID for isolated VFs")
Cc: stable@vger.kernel.org
Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/pci/pci_bus.c |   20 ++++++++++++++++++++
 arch/s390/pci/pci_iov.c |    2 +-
 arch/s390/pci/pci_iov.h |    7 +++++++
 3 files changed, 28 insertions(+), 1 deletion(-)

--- a/arch/s390/pci/pci_bus.c
+++ b/arch/s390/pci/pci_bus.c
@@ -331,6 +331,17 @@ error:
 	return rc;
 }
 
+static bool zpci_bus_is_isolated_vf(struct zpci_bus *zbus, struct zpci_dev *zdev)
+{
+	struct pci_dev *pdev;
+
+	pdev = zpci_iov_find_parent_pf(zbus, zdev);
+	if (!pdev)
+		return true;
+	pci_dev_put(pdev);
+	return false;
+}
+
 int zpci_bus_device_register(struct zpci_dev *zdev, struct pci_ops *ops)
 {
 	bool topo_is_tid = zdev->tid_avail;
@@ -345,6 +356,15 @@ int zpci_bus_device_register(struct zpci
 
 	topo = topo_is_tid ? zdev->tid : zdev->pchid;
 	zbus = zpci_bus_get(topo, topo_is_tid);
+	/*
+	 * An isolated VF gets its own domain/bus even if there exists
+	 * a matching domain/bus already
+	 */
+	if (zbus && zpci_bus_is_isolated_vf(zbus, zdev)) {
+		zpci_bus_put(zbus);
+		zbus = NULL;
+	}
+
 	if (!zbus) {
 		zbus = zpci_bus_alloc(topo, topo_is_tid);
 		if (!zbus)
--- a/arch/s390/pci/pci_iov.c
+++ b/arch/s390/pci/pci_iov.c
@@ -74,7 +74,7 @@ static int zpci_iov_link_virtfn(struct p
  * found. If the function is not a VF or has no RequesterID information,
  * NULL is returned as well.
  */
-static struct pci_dev *zpci_iov_find_parent_pf(struct zpci_bus *zbus, struct zpci_dev *zdev)
+struct pci_dev *zpci_iov_find_parent_pf(struct zpci_bus *zbus, struct zpci_dev *zdev)
 {
 	int i, vfid, devfn, cand_devfn;
 	struct pci_dev *pdev;
--- a/arch/s390/pci/pci_iov.h
+++ b/arch/s390/pci/pci_iov.h
@@ -19,6 +19,8 @@ void zpci_iov_map_resources(struct pci_d
 
 int zpci_iov_setup_virtfn(struct zpci_bus *zbus, struct pci_dev *virtfn, int vfn);
 
+struct pci_dev *zpci_iov_find_parent_pf(struct zpci_bus *zbus, struct zpci_dev *zdev);
+
 #else /* CONFIG_PCI_IOV */
 static inline void zpci_iov_remove_virtfn(struct pci_dev *pdev, int vfn) {}
 
@@ -28,5 +30,10 @@ static inline int zpci_iov_setup_virtfn(
 {
 	return 0;
 }
+
+static inline struct pci_dev *zpci_iov_find_parent_pf(struct zpci_bus *zbus, struct zpci_dev *zdev)
+{
+	return NULL;
+}
 #endif /* CONFIG_PCI_IOV */
 #endif /* __S390_PCI_IOV_h */


