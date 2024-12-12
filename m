Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCF12210EA;
	Thu, 12 Dec 2024 15:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016494; cv=none; b=ai2PznLw1FoIjZ1hXNd1oOZ+GgQb/D51r302rDcg6kBoQZV69zgFkLshjR41Hh5T60f641yQGuiTC9dQ/muns+nWKHI1j/Y40rzaVgMU54FB8ZF2dx94naYHli+kU46Rgw19Jd9janql2gbKRE7k3g+ZPjFF5BGjo5i+bZ762a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016494; c=relaxed/simple;
	bh=F+pargqqNjd1jgeLB/nAeOQxXYwRYL9+15y6iSymegU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YCbl4ImJJuKtGWYY+c7dxc8DYzRewDvwhpDqwuamBCceYVjP6z6TQo8jjFjkGqUV7GmJGgD+0SB213R8c2aeY2NQqtljwX6iFMCXoGNZuY2qFZzuKUL346mqUmIsUX1D7nCL8yku1Bn2b1ituYJiIZL9K+Jy9jvymLaD/ex1IUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z4eGvEsf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z4eGvEsf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D30C4CECE;
	Thu, 12 Dec 2024 15:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016494;
	bh=F+pargqqNjd1jgeLB/nAeOQxXYwRYL9+15y6iSymegU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z4eGvEsfmz8LI8NJYFDODZ2obh9i82O0tXBFbo7Xn74lSMcMi5mMaRzBR8V9RRZaX
	 /1breBmcC6xnjJomnuJufhGmGg1qTXGHnoFc1gCmUdu7TENcpFvZ9KjTPbEC8oD+qw
	 YB6c1w6CBKRoNKafWzRzXlz0JBxm+ZyRCXteT+rY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 214/466] s390/pci: Ignore RID for isolated VFs
Date: Thu, 12 Dec 2024 15:56:23 +0100
Message-ID: <20241212144315.242144964@linuxfoundation.org>
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

[ Upstream commit 25f39d3dcb48bbc824a77d16b3d977f0f3713cfe ]

Ensure that VFs used in isolation, that is with their parent PF not
visible to the configuration but with their RID exposed, are treated
compatibly with existing isolated VF use cases without exposed RID
including RoCE Express VFs. This allows creating configurations where
one LPAR manages PFs while their child VFs are used by other LPARs. This
gives the LPAR managing the PFs a role analogous to that of the
hypervisor in a typical use case of passing child VFs to guests.

Instead of creating a multifunction struct zpci_bus whenever a PCI
function with RID exposed is discovered only create such a bus for
configured physical functions and only consider multifunction busses
when searching for an existing bus. Additionally only set zdev->devfn to
the devfn part of the RID once the function is added to a multifunction
bus.

This also fixes probing of more than 7 such isolated VFs from the same
physical bus. This is because common PCI code in pci_scan_slot() only
looks for more functions when pdev->multifunction is set which somewhat
counter intutively is not the case for VFs.

Note that PFs are looked at before their child VFs is guaranteed because
we sort the zpci_list by RID ascending.

Reviewed-by: Gerd Bayer <gbayer@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/pci/pci_bus.c | 33 ++++++++++++++++++++-------------
 arch/s390/pci/pci_clp.c |  2 --
 2 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/arch/s390/pci/pci_bus.c b/arch/s390/pci/pci_bus.c
index 54879e773e4a3..1b74a000ff645 100644
--- a/arch/s390/pci/pci_bus.c
+++ b/arch/s390/pci/pci_bus.c
@@ -168,9 +168,16 @@ void zpci_bus_scan_busses(void)
 	mutex_unlock(&zbus_list_lock);
 }
 
+static bool zpci_bus_is_multifunction_root(struct zpci_dev *zdev)
+{
+	return !s390_pci_no_rid && zdev->rid_available &&
+		zpci_is_device_configured(zdev) &&
+		!zdev->vfn;
+}
+
 /* zpci_bus_create_pci_bus - Create the PCI bus associated with this zbus
  * @zbus: the zbus holding the zdevices
- * @fr: PCI root function that will determine the bus's domain, and bus speeed
+ * @fr: PCI root function that will determine the bus's domain, and bus speed
  * @ops: the pci operations
  *
  * The PCI function @fr determines the domain (its UID), multifunction property
@@ -188,7 +195,7 @@ static int zpci_bus_create_pci_bus(struct zpci_bus *zbus, struct zpci_dev *fr, s
 		return domain;
 
 	zbus->domain_nr = domain;
-	zbus->multifunction = fr->rid_available;
+	zbus->multifunction = zpci_bus_is_multifunction_root(fr);
 	zbus->max_bus_speed = fr->max_bus_speed;
 
 	/*
@@ -238,6 +245,8 @@ static struct zpci_bus *zpci_bus_get(int topo, bool topo_is_tid)
 
 	mutex_lock(&zbus_list_lock);
 	list_for_each_entry(zbus, &zbus_list, bus_next) {
+		if (!zbus->multifunction)
+			continue;
 		if (topo_is_tid == zbus->topo_is_tid && topo == zbus->topo) {
 			kref_get(&zbus->kref);
 			goto out_unlock;
@@ -293,19 +302,22 @@ static int zpci_bus_add_device(struct zpci_bus *zbus, struct zpci_dev *zdev)
 {
 	int rc = -EINVAL;
 
+	if (zbus->multifunction) {
+		if (!zdev->rid_available) {
+			WARN_ONCE(1, "rid_available not set for multifunction\n");
+			return rc;
+		}
+		zdev->devfn = zdev->rid & ZPCI_RID_MASK_DEVFN;
+	}
+
 	if (zbus->function[zdev->devfn]) {
 		pr_err("devfn %04x is already assigned\n", zdev->devfn);
 		return rc;
 	}
-
 	zdev->zbus = zbus;
 	zbus->function[zdev->devfn] = zdev;
 	zpci_nb_devices++;
 
-	if (zbus->multifunction && !zdev->rid_available) {
-		WARN_ONCE(1, "rid_available not set for multifunction\n");
-		goto error;
-	}
 	rc = zpci_init_slot(zdev);
 	if (rc)
 		goto error;
@@ -332,13 +344,8 @@ int zpci_bus_device_register(struct zpci_dev *zdev, struct pci_ops *ops)
 		return -ENOSPC;
 	}
 
-	if (zdev->devfn >= ZPCI_FUNCTIONS_PER_BUS)
-		return -EINVAL;
-
 	topo = topo_is_tid ? zdev->tid : zdev->pchid;
-	if (!s390_pci_no_rid && zdev->rid_available)
-		zbus = zpci_bus_get(topo, topo_is_tid);
-
+	zbus = zpci_bus_get(topo, topo_is_tid);
 	if (!zbus) {
 		zbus = zpci_bus_alloc(topo, topo_is_tid);
 		if (!zbus)
diff --git a/arch/s390/pci/pci_clp.c b/arch/s390/pci/pci_clp.c
index e222036874e51..74dac6da03d5b 100644
--- a/arch/s390/pci/pci_clp.c
+++ b/arch/s390/pci/pci_clp.c
@@ -168,8 +168,6 @@ static int clp_store_query_pci_fn(struct zpci_dev *zdev,
 	zdev->rid_available = response->rid_avail;
 	if (zdev->rid_available)
 		zdev->rid = response->rid;
-	if (!s390_pci_no_rid && zdev->rid_available)
-		zdev->devfn = response->rid & ZPCI_RID_MASK_DEVFN;
 	zdev->tid_avail = response->tid_avail;
 	if (zdev->tid_avail)
 		zdev->tid = response->tid;
-- 
2.43.0



