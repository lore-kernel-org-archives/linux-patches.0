Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6065F1C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:14:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47B9C4339B;
	Mon, 20 Mar 2023 15:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325276;
	bh=Yfb8MHwxqTy06ppr8qSF/2qkAnSJW2ABO1kWx4P6/l4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qR6VbWB2+Bmz/y99t6BUYg31hIDU+BiE8iFfOX/1MRV5VXyx1ZKlGcxyRbxCj1WQi
	 xUnKfb+NvmQRk2qxQO7xcBmP6nqDnrdsXf1gQvhbmH7sdGbjrIg4NdcW6OUxd4KAjt
	 Q/6Rlvf1CyaK/iHdcLaCCsfYCxu/i3j7Bzp2fk+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Henzl <thenzl@redhat.com>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 024/211] scsi: mpi3mr: Fix expander node leak in mpi3mr_remove()
Date: Mon, 20 Mar 2023 15:52:39 +0100
Message-Id: <20230320145514.296956206@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tomas Henzl <thenzl@redhat.com>

[ Upstream commit ce756daa36e1ba271bb3334267295e447aa57a5c ]

Add a missing resource clean up in .remove.

Fixes: e22bae30667a ("scsi: mpi3mr: Add expander devices to STL")
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Link: https://lore.kernel.org/r/20230302234336.25456-7-thenzl@redhat.com
Acked-by: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr.h           | 2 ++
 drivers/scsi/mpi3mr/mpi3mr_os.c        | 7 +++++++
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 5 +----
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 68f29ffb05b82..de6914d57402c 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -1394,4 +1394,6 @@ void mpi3mr_flush_drv_cmds(struct mpi3mr_ioc *mrioc);
 void mpi3mr_flush_cmds_for_unrecovered_controller(struct mpi3mr_ioc *mrioc);
 void mpi3mr_free_enclosure_list(struct mpi3mr_ioc *mrioc);
 int mpi3mr_process_admin_reply_q(struct mpi3mr_ioc *mrioc);
+void mpi3mr_expander_node_remove(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_sas_node *sas_expander);
 #endif /*MPI3MR_H_INCLUDED*/
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 2e546c80d98ce..6d55698ea4d16 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -5079,6 +5079,7 @@ static void mpi3mr_remove(struct pci_dev *pdev)
 	unsigned long flags;
 	struct mpi3mr_tgt_dev *tgtdev, *tgtdev_next;
 	struct mpi3mr_hba_port *port, *hba_port_next;
+	struct mpi3mr_sas_node *sas_expander, *sas_expander_next;
 
 	if (!shost)
 		return;
@@ -5119,6 +5120,12 @@ static void mpi3mr_remove(struct pci_dev *pdev)
 	mpi3mr_cleanup_resources(mrioc);
 
 	spin_lock_irqsave(&mrioc->sas_node_lock, flags);
+	list_for_each_entry_safe_reverse(sas_expander, sas_expander_next,
+	    &mrioc->sas_expander_list, list) {
+		spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
+		mpi3mr_expander_node_remove(mrioc, sas_expander);
+		spin_lock_irqsave(&mrioc->sas_node_lock, flags);
+	}
 	list_for_each_entry_safe(port, hba_port_next, &mrioc->hba_port_table_list, list) {
 		ioc_info(mrioc,
 		    "removing hba_port entry: %p port: %d from hba_port list\n",
diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 3b61815979dab..50263ba4f8428 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -9,9 +9,6 @@
 
 #include "mpi3mr.h"
 
-static void mpi3mr_expander_node_remove(struct mpi3mr_ioc *mrioc,
-	struct mpi3mr_sas_node *sas_expander);
-
 /**
  * mpi3mr_post_transport_req - Issue transport requests and wait
  * @mrioc: Adapter instance reference
@@ -2163,7 +2160,7 @@ int mpi3mr_expander_add(struct mpi3mr_ioc *mrioc, u16 handle)
  *
  * Return nothing.
  */
-static void mpi3mr_expander_node_remove(struct mpi3mr_ioc *mrioc,
+void mpi3mr_expander_node_remove(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_sas_node *sas_expander)
 {
 	struct mpi3mr_sas_port *mr_sas_port, *next;
-- 
2.39.2



