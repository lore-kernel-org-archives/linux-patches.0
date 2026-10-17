Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3433038AC99;
	Sat, 17 Oct 2026 17:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257689; cv=none; b=CbPAyA+IqvV+Ih6YM+Emepa0FU8UnMUEQzFwzXH71yRk6/9k1X30SbVBwje+VHm+HS8dr+G1dcC8U8OYwHNnFcEYy9epkPB4vfGd/pyO90rgXV4YVxQY6OBuTS6OcVBbvcomObeq6oQ2azpbSYq/VtuI7VhghcJhLveJ+L0pTKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257689; c=relaxed/simple;
	bh=qeZWnJp8HIMCn0+XGBl6st3/g0uND8XjKGP1EXYq1Jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NNZyB2jB/cQTd8jSnu+8aG66edWqSSfHHntpct1AfIuBX6aBMlMnT0uBqnWjraoz7s8yCXxCEuUdtSDMO740Mcuk1q3YmP7y/fODl+PzMuRczSWYtqUCg8qdh4wa09Bz0imGWjIN+L2/v0phXtFDbeTNSG3UjPzak0tLJE6hunQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TLit5DyN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TLit5DyN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771861F000C4;
	Sat, 17 Oct 2026 17:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257688;
	bh=MkXYCwEBGsZZ8Al0MSmo2zrij8O6sZ1Ocrb4jkUtXEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TLit5DyNFSUshEH2PiaPynptKZnh/Mdqf5MAj3Ln0K/yklOMI4OA2dSfuQSfSZSd0
	 Au0PJgIhUmfqvGo8H0eLuO7xqFHV9Du1oUt1qaVh0AOY6vJ9/qK8tCRLlRT3037jyU
	 lL7OdU1xB2DGgRjSa1yqiBLDjqfYvshfYI8cpk1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0639/1674] scsi: lpfc: Remove shost_lock protection for fc_host_port shost APIs
Date: Sat, 17 Oct 2026 17:48:31 +0200
Message-ID: <20261017160447.497595526@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 4be4ad6cd2371ffca86e4446feae3d8373e4b02a ]

Desiring to reduce the amount of unnecessary shost_lock acquisitions in the
lpfc driver, it has been determined that there is no need for shost_lock
protection when retrieving fc_host port information because it is only for
display to user via sysfs.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20240131185112.149731-12-justintee8345@gmail.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: ede596b1434b ("scsi: lpfc: Handle mailbox timeouts in lpfc_get_sfp_info")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_attr.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 8123062ec2faf..6d8c94dec4188 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -6434,8 +6434,6 @@ lpfc_get_host_port_type(struct Scsi_Host *shost)
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
 
-	spin_lock_irq(shost->host_lock);
-
 	if (vport->port_type == LPFC_NPIV_PORT) {
 		fc_host_port_type(shost) = FC_PORTTYPE_NPIV;
 	} else if (lpfc_is_link_up(phba)) {
@@ -6452,8 +6450,6 @@ lpfc_get_host_port_type(struct Scsi_Host *shost)
 		}
 	} else
 		fc_host_port_type(shost) = FC_PORTTYPE_UNKNOWN;
-
-	spin_unlock_irq(shost->host_lock);
 }
 
 /**
@@ -6466,8 +6462,6 @@ lpfc_get_host_port_state(struct Scsi_Host *shost)
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
 
-	spin_lock_irq(shost->host_lock);
-
 	if (vport->fc_flag & FC_OFFLINE_MODE)
 		fc_host_port_state(shost) = FC_PORTSTATE_OFFLINE;
 	else {
@@ -6495,8 +6489,6 @@ lpfc_get_host_port_state(struct Scsi_Host *shost)
 			break;
 		}
 	}
-
-	spin_unlock_irq(shost->host_lock);
 }
 
 /**
@@ -6509,8 +6501,6 @@ lpfc_get_host_speed(struct Scsi_Host *shost)
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
 
-	spin_lock_irq(shost->host_lock);
-
 	if ((lpfc_is_link_up(phba)) && (!(phba->hba_flag & HBA_FCOE_MODE))) {
 		switch(phba->fc_linkspeed) {
 		case LPFC_LINK_SPEED_1GHZ:
@@ -6573,8 +6563,6 @@ lpfc_get_host_speed(struct Scsi_Host *shost)
 		}
 	} else
 		fc_host_speed(shost) = FC_PORTSPEED_UNKNOWN;
-
-	spin_unlock_irq(shost->host_lock);
 }
 
 /**
@@ -6588,8 +6576,6 @@ lpfc_get_host_fabric_name (struct Scsi_Host *shost)
 	struct lpfc_hba   *phba = vport->phba;
 	u64 node_name;
 
-	spin_lock_irq(shost->host_lock);
-
 	if ((vport->port_state > LPFC_FLOGI) &&
 	    ((vport->fc_flag & FC_FABRIC) ||
 	     ((phba->fc_topology == LPFC_TOPOLOGY_LOOP) &&
@@ -6599,8 +6585,6 @@ lpfc_get_host_fabric_name (struct Scsi_Host *shost)
 		/* fabric is local port if there is no F/FL_Port */
 		node_name = 0;
 
-	spin_unlock_irq(shost->host_lock);
-
 	fc_host_fabric_name(shost) = node_name;
 }
 
-- 
2.53.0



