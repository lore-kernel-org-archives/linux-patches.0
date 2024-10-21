Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8A31E47AB;
	Mon, 21 Oct 2024 10:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506590; cv=none; b=RMYxSz9u23ngdAEns7jMW03Rz+k9CYow7PX/48ZiEFr5wPLzX94v5MnVAaGu5U3kZnPwck60aMhl5th5vbDUHJRYNiC0iJhFt92KZrKufx3wa7vDkugwwTVsQe26RrAjL2fFXCfWsi0ggf7mKDRjg15CorFLU4JZ2qDyj+NpzuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506590; c=relaxed/simple;
	bh=hRD+Hd9dr0ctciHcRcGUyENPwyU5H1jQVa43R6YHIz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MB2tOJf6uIetPBK4rcA+f3ODiHFKgo0CYgNDmFjsXLQncVuo0fXDRYe+3+ok+WEafPHbAjgXGqFxpEDKBv6IyQ+QtC+Hro+F6kTkxVHXW8F+Je0PW53CavRjzP8b5+q99ezUqSHTjNOJ7/wCtRGEPFL8/BGoR2+9qIZO6Une1Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D0AYz824; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D0AYz824"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF37C4CEC3;
	Mon, 21 Oct 2024 10:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506590;
	bh=hRD+Hd9dr0ctciHcRcGUyENPwyU5H1jQVa43R6YHIz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D0AYz824IkevZdOgVxl5v31PhfoyjjiZfEhTx3rTOdM+dGTAW85VNv4Mkh24PEVv9
	 mm4O+5sv/CATEHagpZuY5UC15Oe1IK0alEGljQKZlMJkA+F7vfuoVHg4r/H8eyH0kJ
	 5+2E33uYys/NO/Ts95M5bJuM86Q4t2HYNTo4a2fE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Alexander Motin <mav@ixsystems.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.11 055/135] scsi: mpi3mr: Validate SAS port assignments
Date: Mon, 21 Oct 2024 12:23:31 +0200
Message-ID: <20241021102301.482220893@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

commit b9e63d6c7c0e94a99e1af7c9c0c7fad13a2f2453 upstream.

A sanity check on phy_mask was added in commit 3668651def2c ("scsi:
mpi3mr: Sanitise num_phys"). This causes warning messages when more than
64 phys are detected and devices connected to phys greater than 64 are
dropped.

The phy_mask bitmap is only needed for controller phys and not required
for expander phys. Controller phys can go up to a maximum of 64 and
therefore u64 is good enough to contain phy_mask bitmap.

To suppress those warnings and allow devices to be discovered as before
the offending commit, restrict the phy_mask setting and lowest phy
setting only to the controller phys.

Fixes: 3668651def2c ("scsi: mpi3mr: Sanitise num_phys")
Cc: stable@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202410051943.Mp9o5DlF-lkp@intel.com/
Reported-by: Alexander Motin <mav@ixsystems.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Link: https://lore.kernel.org/r/20241008074353.200379-1-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/mpi3mr/mpi3mr.h           |    4 +--
 drivers/scsi/mpi3mr/mpi3mr_transport.c |   42 +++++++++++++++++++++------------
 2 files changed, 29 insertions(+), 17 deletions(-)

--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -541,8 +541,8 @@ struct mpi3mr_hba_port {
  * @port_list: List of ports belonging to a SAS node
  * @num_phys: Number of phys associated with port
  * @marked_responding: used while refresing the sas ports
- * @lowest_phy: lowest phy ID of current sas port
- * @phy_mask: phy_mask of current sas port
+ * @lowest_phy: lowest phy ID of current sas port, valid for controller port
+ * @phy_mask: phy_mask of current sas port, valid for controller port
  * @hba_port: HBA port entry
  * @remote_identify: Attached device identification
  * @rphy: SAS transport layer rphy object
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -590,12 +590,13 @@ static enum sas_linkrate mpi3mr_convert_
  * @mrioc: Adapter instance reference
  * @mr_sas_port: Internal Port object
  * @mr_sas_phy: Internal Phy object
+ * @host_node: Flag to indicate this is a host_node
  *
  * Return: None.
  */
 static void mpi3mr_delete_sas_phy(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_sas_port *mr_sas_port,
-	struct mpi3mr_sas_phy *mr_sas_phy)
+	struct mpi3mr_sas_phy *mr_sas_phy, u8 host_node)
 {
 	u64 sas_address = mr_sas_port->remote_identify.sas_address;
 
@@ -605,9 +606,13 @@ static void mpi3mr_delete_sas_phy(struct
 
 	list_del(&mr_sas_phy->port_siblings);
 	mr_sas_port->num_phys--;
-	mr_sas_port->phy_mask &= ~(1 << mr_sas_phy->phy_id);
-	if (mr_sas_port->lowest_phy == mr_sas_phy->phy_id)
-		mr_sas_port->lowest_phy = ffs(mr_sas_port->phy_mask) - 1;
+
+	if (host_node) {
+		mr_sas_port->phy_mask &= ~(1 << mr_sas_phy->phy_id);
+
+		if (mr_sas_port->lowest_phy == mr_sas_phy->phy_id)
+			mr_sas_port->lowest_phy = ffs(mr_sas_port->phy_mask) - 1;
+	}
 	sas_port_delete_phy(mr_sas_port->port, mr_sas_phy->phy);
 	mr_sas_phy->phy_belongs_to_port = 0;
 }
@@ -617,12 +622,13 @@ static void mpi3mr_delete_sas_phy(struct
  * @mrioc: Adapter instance reference
  * @mr_sas_port: Internal Port object
  * @mr_sas_phy: Internal Phy object
+ * @host_node: Flag to indicate this is a host_node
  *
  * Return: None.
  */
 static void mpi3mr_add_sas_phy(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_sas_port *mr_sas_port,
-	struct mpi3mr_sas_phy *mr_sas_phy)
+	struct mpi3mr_sas_phy *mr_sas_phy, u8 host_node)
 {
 	u64 sas_address = mr_sas_port->remote_identify.sas_address;
 
@@ -632,9 +638,12 @@ static void mpi3mr_add_sas_phy(struct mp
 
 	list_add_tail(&mr_sas_phy->port_siblings, &mr_sas_port->phy_list);
 	mr_sas_port->num_phys++;
-	mr_sas_port->phy_mask |= (1 << mr_sas_phy->phy_id);
-	if (mr_sas_phy->phy_id < mr_sas_port->lowest_phy)
-		mr_sas_port->lowest_phy = ffs(mr_sas_port->phy_mask) - 1;
+	if (host_node) {
+		mr_sas_port->phy_mask |= (1 << mr_sas_phy->phy_id);
+
+		if (mr_sas_phy->phy_id < mr_sas_port->lowest_phy)
+			mr_sas_port->lowest_phy = ffs(mr_sas_port->phy_mask) - 1;
+	}
 	sas_port_add_phy(mr_sas_port->port, mr_sas_phy->phy);
 	mr_sas_phy->phy_belongs_to_port = 1;
 }
@@ -675,7 +684,7 @@ static void mpi3mr_add_phy_to_an_existin
 			if (srch_phy == mr_sas_phy)
 				return;
 		}
-		mpi3mr_add_sas_phy(mrioc, mr_sas_port, mr_sas_phy);
+		mpi3mr_add_sas_phy(mrioc, mr_sas_port, mr_sas_phy, mr_sas_node->host_node);
 		return;
 	}
 }
@@ -736,7 +745,7 @@ static void mpi3mr_del_phy_from_an_exist
 				mpi3mr_delete_sas_port(mrioc, mr_sas_port);
 			else
 				mpi3mr_delete_sas_phy(mrioc, mr_sas_port,
-				    mr_sas_phy);
+				    mr_sas_phy, mr_sas_node->host_node);
 			return;
 		}
 	}
@@ -1028,7 +1037,7 @@ mpi3mr_alloc_hba_port(struct mpi3mr_ioc
 /**
  * mpi3mr_get_hba_port_by_id - find hba port by id
  * @mrioc: Adapter instance reference
- * @port_id - Port ID to search
+ * @port_id: Port ID to search
  *
  * Return: mpi3mr_hba_port reference for the matched port
  */
@@ -1367,7 +1376,8 @@ static struct mpi3mr_sas_port *mpi3mr_sa
 	mpi3mr_sas_port_sanity_check(mrioc, mr_sas_node,
 	    mr_sas_port->remote_identify.sas_address, hba_port);
 
-	if (mr_sas_node->num_phys >= sizeof(mr_sas_port->phy_mask) * 8)
+	if (mr_sas_node->host_node && mr_sas_node->num_phys >=
+			sizeof(mr_sas_port->phy_mask) * 8)
 		ioc_info(mrioc, "max port count %u could be too high\n",
 		    mr_sas_node->num_phys);
 
@@ -1377,7 +1387,7 @@ static struct mpi3mr_sas_port *mpi3mr_sa
 		    (mr_sas_node->phy[i].hba_port != hba_port))
 			continue;
 
-		if (i >= sizeof(mr_sas_port->phy_mask) * 8) {
+		if (mr_sas_node->host_node && (i >= sizeof(mr_sas_port->phy_mask) * 8)) {
 			ioc_warn(mrioc, "skipping port %u, max allowed value is %zu\n",
 			    i, sizeof(mr_sas_port->phy_mask) * 8);
 			goto out_fail;
@@ -1385,7 +1395,8 @@ static struct mpi3mr_sas_port *mpi3mr_sa
 		list_add_tail(&mr_sas_node->phy[i].port_siblings,
 		    &mr_sas_port->phy_list);
 		mr_sas_port->num_phys++;
-		mr_sas_port->phy_mask |= (1 << i);
+		if (mr_sas_node->host_node)
+			mr_sas_port->phy_mask |= (1 << i);
 	}
 
 	if (!mr_sas_port->num_phys) {
@@ -1394,7 +1405,8 @@ static struct mpi3mr_sas_port *mpi3mr_sa
 		goto out_fail;
 	}
 
-	mr_sas_port->lowest_phy = ffs(mr_sas_port->phy_mask) - 1;
+	if (mr_sas_node->host_node)
+		mr_sas_port->lowest_phy = ffs(mr_sas_port->phy_mask) - 1;
 
 	if (mr_sas_port->remote_identify.device_type == SAS_END_DEVICE) {
 		tgtdev = mpi3mr_get_tgtdev_by_addr(mrioc,


