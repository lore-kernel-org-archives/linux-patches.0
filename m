Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5599218AB3;
	Thu, 12 Dec 2024 15:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016490; cv=none; b=oY1p9eMRsiHDh/AD/y/TpUsxUA6ZFkLNl44HjIgUzgrrjan50Ga1y2APnhoUccJRoCJ+cIjkn18nDi8lBEhMc+vKDEem4FPhnVS3aluXEBQ80jilVX0QHUJTGK+RJm6Ub3vHhPHplBz/sM01fiHaX9JGMLWQUkwcU35KQ0m6tYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016490; c=relaxed/simple;
	bh=ccUjpQQLx5PoI7hvBgFHbPiSc5G1LtATBolt5Q/MUTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kiG+A/U229FvbmjLF273I/iycHzLtVnjAty25Le+TsWRus5SEJBj850kLrjUeB7v1ufqxPmIAE+83ZTng0neh9QGBDnSwPaF3dKiCBVroaHAlkMmAcVIHx1HLlDvsISY+LXx7rffs/BrF44Suoj9YYdZ2X+Gp1isLN54VmHRTY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PvCIEh63; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PvCIEh63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 400FDC4CEE3;
	Thu, 12 Dec 2024 15:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016490;
	bh=ccUjpQQLx5PoI7hvBgFHbPiSc5G1LtATBolt5Q/MUTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PvCIEh63rEx9eZ399fBqpkBSdMKrxDKo6cmoeaaf5o2w2HNrGw8MrZFo5VxbtfeJX
	 JHtUwSuUAcJWaZIXUURp7FnAR3QuAQeKFxMFKVDm3LmycNkR0DCNxe/rxnOisrKx3B
	 57B+AlgyQEZbEaW+ALmJ8kg+2W/qcgWFYnEbnGC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 213/466] s390/pci: Use topology ID for multi-function devices
Date: Thu, 12 Dec 2024 15:56:22 +0100
Message-ID: <20241212144315.202619324@linuxfoundation.org>
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

[ Upstream commit 126034faaac5f356822c4a9bebfa75664da11056 ]

The newly introduced topology ID (TID) field in the CLP Query PCI
Function explicitly identifies groups of PCI functions whose RIDs belong
to the same (sub-)topology. When available use the TID instead of the
PCHID to match zPCI busses/domains for multi-function devices. Note that
currently only a single PCI bus per TID is supported. This change is
required because in future machines the PCHID will not identify a PCI
card but a specific port in the case of some multi-port NICs while from
a PCI point of view the entire card is a subtopology.

Reviewed-by: Gerd Bayer <gbayer@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/pci.h     |  9 ++++++---
 arch/s390/include/asm/pci_clp.h |  8 +++++---
 arch/s390/pci/pci_bus.c         | 17 ++++++++++-------
 arch/s390/pci/pci_clp.c         |  3 +++
 4 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
index b10801fa73569..83789e39d1d5e 100644
--- a/arch/s390/include/asm/pci.h
+++ b/arch/s390/include/asm/pci.h
@@ -106,9 +106,10 @@ struct zpci_bus {
 	struct list_head	resources;
 	struct list_head	bus_next;
 	struct resource		bus_resource;
-	int			pchid;
+	int			topo;		/* TID if topo_is_tid, PCHID otherwise */
 	int			domain_nr;
-	bool			multifunction;
+	u8			multifunction	: 1;
+	u8			topo_is_tid	: 1;
 	enum pci_bus_speed	max_bus_speed;
 };
 
@@ -130,6 +131,7 @@ struct zpci_dev {
 	u16		pchid;		/* physical channel ID */
 	u16		maxstbl;	/* Maximum store block size */
 	u16		rid;		/* RID as supplied by firmware */
+	u16		tid;		/* Topology for which RID is valid */
 	u8		pfgid;		/* function group ID */
 	u8		pft;		/* pci function type */
 	u8		port;
@@ -140,7 +142,8 @@ struct zpci_dev {
 	u8		is_physfn	: 1;
 	u8		util_str_avail	: 1;
 	u8		irqs_registered	: 1;
-	u8		reserved	: 2;
+	u8		tid_avail	: 1;
+	u8		reserved	: 1;
 	unsigned int	devfn;		/* DEVFN part of the RID*/
 
 	u8 pfip[CLP_PFIP_NR_SEGMENTS];	/* pci function internal path */
diff --git a/arch/s390/include/asm/pci_clp.h b/arch/s390/include/asm/pci_clp.h
index f0c677ddd2706..14afb9ce91f3b 100644
--- a/arch/s390/include/asm/pci_clp.h
+++ b/arch/s390/include/asm/pci_clp.h
@@ -110,7 +110,8 @@ struct clp_req_query_pci {
 struct clp_rsp_query_pci {
 	struct clp_rsp_hdr hdr;
 	u16 vfn;			/* virtual fn number */
-	u16			:  3;
+	u16			:  2;
+	u16 tid_avail		:  1;
 	u16 rid_avail		:  1;
 	u16 is_physfn		:  1;
 	u16 reserved1		:  1;
@@ -130,8 +131,9 @@ struct clp_rsp_query_pci {
 	u64 edma;			/* end dma as */
 #define ZPCI_RID_MASK_DEVFN 0x00ff
 	u16 rid;			/* BUS/DEVFN PCI address */
-	u16 reserved0;
-	u32 reserved[10];
+	u32 reserved0;
+	u16 tid;
+	u32 reserved[9];
 	u32 uid;			/* user defined id */
 	u8 util_str[CLP_UTIL_STR_LEN];	/* utility string */
 	u32 reserved2[16];
diff --git a/arch/s390/pci/pci_bus.c b/arch/s390/pci/pci_bus.c
index daa5d7450c7d3..54879e773e4a3 100644
--- a/arch/s390/pci/pci_bus.c
+++ b/arch/s390/pci/pci_bus.c
@@ -232,13 +232,13 @@ static void zpci_bus_put(struct zpci_bus *zbus)
 	kref_put(&zbus->kref, zpci_bus_release);
 }
 
-static struct zpci_bus *zpci_bus_get(int pchid)
+static struct zpci_bus *zpci_bus_get(int topo, bool topo_is_tid)
 {
 	struct zpci_bus *zbus;
 
 	mutex_lock(&zbus_list_lock);
 	list_for_each_entry(zbus, &zbus_list, bus_next) {
-		if (pchid == zbus->pchid) {
+		if (topo_is_tid == zbus->topo_is_tid && topo == zbus->topo) {
 			kref_get(&zbus->kref);
 			goto out_unlock;
 		}
@@ -249,7 +249,7 @@ static struct zpci_bus *zpci_bus_get(int pchid)
 	return zbus;
 }
 
-static struct zpci_bus *zpci_bus_alloc(int pchid)
+static struct zpci_bus *zpci_bus_alloc(int topo, bool topo_is_tid)
 {
 	struct zpci_bus *zbus;
 
@@ -257,7 +257,8 @@ static struct zpci_bus *zpci_bus_alloc(int pchid)
 	if (!zbus)
 		return NULL;
 
-	zbus->pchid = pchid;
+	zbus->topo = topo;
+	zbus->topo_is_tid = topo_is_tid;
 	INIT_LIST_HEAD(&zbus->bus_next);
 	mutex_lock(&zbus_list_lock);
 	list_add_tail(&zbus->bus_next, &zbus_list);
@@ -321,8 +322,9 @@ static int zpci_bus_add_device(struct zpci_bus *zbus, struct zpci_dev *zdev)
 
 int zpci_bus_device_register(struct zpci_dev *zdev, struct pci_ops *ops)
 {
+	bool topo_is_tid = zdev->tid_avail;
 	struct zpci_bus *zbus = NULL;
-	int rc = -EBADF;
+	int topo, rc = -EBADF;
 
 	if (zpci_nb_devices == ZPCI_NR_DEVICES) {
 		pr_warn("Adding PCI function %08x failed because the configured limit of %d is reached\n",
@@ -333,11 +335,12 @@ int zpci_bus_device_register(struct zpci_dev *zdev, struct pci_ops *ops)
 	if (zdev->devfn >= ZPCI_FUNCTIONS_PER_BUS)
 		return -EINVAL;
 
+	topo = topo_is_tid ? zdev->tid : zdev->pchid;
 	if (!s390_pci_no_rid && zdev->rid_available)
-		zbus = zpci_bus_get(zdev->pchid);
+		zbus = zpci_bus_get(topo, topo_is_tid);
 
 	if (!zbus) {
-		zbus = zpci_bus_alloc(zdev->pchid);
+		zbus = zpci_bus_alloc(topo, topo_is_tid);
 		if (!zbus)
 			return -ENOMEM;
 	}
diff --git a/arch/s390/pci/pci_clp.c b/arch/s390/pci/pci_clp.c
index f7430086e9739..e222036874e51 100644
--- a/arch/s390/pci/pci_clp.c
+++ b/arch/s390/pci/pci_clp.c
@@ -170,6 +170,9 @@ static int clp_store_query_pci_fn(struct zpci_dev *zdev,
 		zdev->rid = response->rid;
 	if (!s390_pci_no_rid && zdev->rid_available)
 		zdev->devfn = response->rid & ZPCI_RID_MASK_DEVFN;
+	zdev->tid_avail = response->tid_avail;
+	if (zdev->tid_avail)
+		zdev->tid = response->tid;
 
 	memcpy(zdev->pfip, response->pfip, sizeof(zdev->pfip));
 	if (response->util_str_avail) {
-- 
2.43.0



