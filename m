Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F7617588;
	Sat,  3 Feb 2024 04:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933980; cv=none; b=i5zFUZML0O+JZ0dZ4ZEXnsnYRxjDZWqncz2pP5r3hAApkyIFtHNvhOKhZrN9TOG9qgeEQQqDuZD/c4T5duaXDODnn7vvQO6uEBC3eMRMxLOGrb6EWs9pen7zllNZvug6SpO8c4xFeU4FyqYv0KMJUv1SKgoNajIEVICWr26x1w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933980; c=relaxed/simple;
	bh=vyDlqbSPN9Glsvbg7hF21sDz4cU26RGRPeuVLIzCLL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T3vWZUZt8gnO+mM/U6W2FYzDPPPzFztlgD4tg7GQKoKvl+ZBCfempoY/Er1q5b4OxPAO8NBEWTx5QPo4aLgpoJ5IN7wIqod+ifqZIcLxlAZFiC+sXSB2C1C2wlYLGhAzAdYnjNZiQ3berelbmt3Ra1+cNRPj09LgHrOlO+LcW3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G9h0+QPS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G9h0+QPS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC7B3C433F1;
	Sat,  3 Feb 2024 04:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933979;
	bh=vyDlqbSPN9Glsvbg7hF21sDz4cU26RGRPeuVLIzCLL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G9h0+QPSfLfwUnjB4Ihy8mT2dT6MBAxq708JbQBKW9cyLteF//TOZSmj7CcXnpBQd
	 yuB7NvJ1Js6cqFBcGv93HA9gMP6RijW4+xvxi9eCAI3AQvDj+CloX+GQMSR5R6Z5jB
	 rTnx1vq+8lAioQI9zbM2RwlGenvMC6PeasrvSv8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett Creeley <brett.creeley@amd.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 336/353] pds_core: Rework teardown/setup flow to be more common
Date: Fri,  2 Feb 2024 20:07:34 -0800
Message-ID: <20240203035414.412031268@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brett Creeley <brett.creeley@amd.com>

[ Upstream commit bc90fbe0c3182157d2be100a2f6c2edbb1820677 ]

Currently the teardown/setup flow for driver probe/remove is quite
a bit different from the reset flows in pdsc_fw_down()/pdsc_fw_up().
One key piece that's missing are the calls to pci_alloc_irq_vectors()
and pci_free_irq_vectors(). The pcie reset case is calling
pci_free_irq_vectors() on reset_prepare, but not calling the
corresponding pci_alloc_irq_vectors() on reset_done. This is causing
unexpected/unwanted interrupt behavior due to the adminq interrupt
being accidentally put into legacy interrupt mode. Also, the
pci_alloc_irq_vectors()/pci_free_irq_vectors() functions are being
called directly in probe/remove respectively.

Fix this inconsistency by making the following changes:
  1. Always call pdsc_dev_init() in pdsc_setup(), which calls
     pci_alloc_irq_vectors() and get rid of the now unused
     pds_dev_reinit().
  2. Always free/clear the pdsc->intr_info in pdsc_teardown()
     since this structure will get re-alloced in pdsc_setup().
  3. Move the calls of pci_free_irq_vectors() to pdsc_teardown()
     since pci_alloc_irq_vectors() will always be called in
     pdsc_setup()->pdsc_dev_init() for both the probe/remove and
     reset flows.
  4. Make sure to only create the debugfs "identity" entry when it
     doesn't already exist, which it will in the reset case because
     it's already been created in the initial call to pdsc_dev_init().

Fixes: ffa55858330f ("pds_core: implement pci reset handlers")
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Link: https://lore.kernel.org/r/20240129234035.69802-7-brett.creeley@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/core.c    | 13 +++++--------
 drivers/net/ethernet/amd/pds_core/core.h    |  1 -
 drivers/net/ethernet/amd/pds_core/debugfs.c |  4 ++++
 drivers/net/ethernet/amd/pds_core/dev.c     |  7 -------
 drivers/net/ethernet/amd/pds_core/main.c    |  2 --
 5 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/amd/pds_core/core.c b/drivers/net/ethernet/amd/pds_core/core.c
index 65c8a7072e35..7658a7286767 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -404,10 +404,7 @@ int pdsc_setup(struct pdsc *pdsc, bool init)
 	int numdescs;
 	int err;
 
-	if (init)
-		err = pdsc_dev_init(pdsc);
-	else
-		err = pdsc_dev_reinit(pdsc);
+	err = pdsc_dev_init(pdsc);
 	if (err)
 		return err;
 
@@ -479,10 +476,9 @@ void pdsc_teardown(struct pdsc *pdsc, bool removing)
 		for (i = 0; i < pdsc->nintrs; i++)
 			pdsc_intr_free(pdsc, i);
 
-		if (removing) {
-			kfree(pdsc->intr_info);
-			pdsc->intr_info = NULL;
-		}
+		kfree(pdsc->intr_info);
+		pdsc->intr_info = NULL;
+		pdsc->nintrs = 0;
 	}
 
 	if (pdsc->kern_dbpage) {
@@ -490,6 +486,7 @@ void pdsc_teardown(struct pdsc *pdsc, bool removing)
 		pdsc->kern_dbpage = NULL;
 	}
 
+	pci_free_irq_vectors(pdsc->pdev);
 	set_bit(PDSC_S_FW_DEAD, &pdsc->state);
 }
 
diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
index cbd5716f46e6..110c4b826b22 100644
--- a/drivers/net/ethernet/amd/pds_core/core.h
+++ b/drivers/net/ethernet/amd/pds_core/core.h
@@ -281,7 +281,6 @@ int pdsc_devcmd_locked(struct pdsc *pdsc, union pds_core_dev_cmd *cmd,
 		       union pds_core_dev_comp *comp, int max_seconds);
 int pdsc_devcmd_init(struct pdsc *pdsc);
 int pdsc_devcmd_reset(struct pdsc *pdsc);
-int pdsc_dev_reinit(struct pdsc *pdsc);
 int pdsc_dev_init(struct pdsc *pdsc);
 
 void pdsc_reset_prepare(struct pci_dev *pdev);
diff --git a/drivers/net/ethernet/amd/pds_core/debugfs.c b/drivers/net/ethernet/amd/pds_core/debugfs.c
index 8ec392299b7d..4e8579ca1c8c 100644
--- a/drivers/net/ethernet/amd/pds_core/debugfs.c
+++ b/drivers/net/ethernet/amd/pds_core/debugfs.c
@@ -64,6 +64,10 @@ DEFINE_SHOW_ATTRIBUTE(identity);
 
 void pdsc_debugfs_add_ident(struct pdsc *pdsc)
 {
+	/* This file will already exist in the reset flow */
+	if (debugfs_lookup("identity", pdsc->dentry))
+		return;
+
 	debugfs_create_file("identity", 0400, pdsc->dentry,
 			    pdsc, &identity_fops);
 }
diff --git a/drivers/net/ethernet/amd/pds_core/dev.c b/drivers/net/ethernet/amd/pds_core/dev.c
index 62a38e0a8454..e65a1632df50 100644
--- a/drivers/net/ethernet/amd/pds_core/dev.c
+++ b/drivers/net/ethernet/amd/pds_core/dev.c
@@ -316,13 +316,6 @@ static int pdsc_identify(struct pdsc *pdsc)
 	return 0;
 }
 
-int pdsc_dev_reinit(struct pdsc *pdsc)
-{
-	pdsc_init_devinfo(pdsc);
-
-	return pdsc_identify(pdsc);
-}
-
 int pdsc_dev_init(struct pdsc *pdsc)
 {
 	unsigned int nintrs;
diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
index 05fdeb235e5f..cdbf053b5376 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -438,7 +438,6 @@ static void pdsc_remove(struct pci_dev *pdev)
 		mutex_destroy(&pdsc->config_lock);
 		mutex_destroy(&pdsc->devcmd_lock);
 
-		pci_free_irq_vectors(pdev);
 		pdsc_unmap_bars(pdsc);
 		pci_release_regions(pdev);
 	}
@@ -470,7 +469,6 @@ void pdsc_reset_prepare(struct pci_dev *pdev)
 	pdsc_stop_health_thread(pdsc);
 	pdsc_fw_down(pdsc);
 
-	pci_free_irq_vectors(pdev);
 	pdsc_unmap_bars(pdsc);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
-- 
2.43.0



