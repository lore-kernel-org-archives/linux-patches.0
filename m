Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FF31A29A;
	Sat,  3 Feb 2024 04:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933704; cv=none; b=GBJ8ANJdYGCRJa/xUHeBGM0UZT8jPq+hq8aCSjWU5uNmsSi4jWnH54kW0JuVb67kq2x7N0bimTJSoTyb+3uDIk2eyS2ZiNy4DI9c/1JWsJel/s1Mtca7S6161jl7Kj4hxG8ESL6K2EY93mjACISelLLo8I1IzVZ4zkf3V2WuHsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933704; c=relaxed/simple;
	bh=36gHgXM0ihKL2qAyaOOUJVENgKIOoSPkVwzmlG7ddK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZaYo1X1w71D+6WVSh1gsto3VtxEHoiSCq68W/oUEjrg+lh1GxoFzSb1iU2KwN/bD2UwhdnVAg0AVuHHW1ebjMdWHSgRnWiBeyoeBWKWFFYcohf4wzTWkDGZY7SvvypeJMSwRO7X/wvcadwlqO7fp3QlXTXmSdMuV2XAwUwOdBTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ufbT0Z+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ufbT0Z+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0FDAC433C7;
	Sat,  3 Feb 2024 04:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933703;
	bh=36gHgXM0ihKL2qAyaOOUJVENgKIOoSPkVwzmlG7ddK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ufbT0Z+Td5wWLKuF6J8XlTIl1ib/kX/uSMUmTAK7xZiSoX25Wran9pAIvNcUcRuM
	 yRf4X4r58BGnkVDaaqNz6UOZd+WRaLDzHmlvLl5DSeaHnmqEFtM/vxo2enVP9y+M0r
	 ku9wX5VnSuG61hZh+50hMANZ4wxRCOEGlLdZkE7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett Creeley <brett.creeley@amd.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 305/322] pds_core: Rework teardown/setup flow to be more common
Date: Fri,  2 Feb 2024 20:06:42 -0800
Message-ID: <20240203035408.906332377@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e1f554f25329..eb73c921dc1e 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -407,10 +407,7 @@ int pdsc_setup(struct pdsc *pdsc, bool init)
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
index d6d19f72df00..f410f7d13205 100644
--- a/drivers/net/ethernet/amd/pds_core/core.h
+++ b/drivers/net/ethernet/amd/pds_core/core.h
@@ -281,7 +281,6 @@ int pdsc_devcmd_locked(struct pdsc *pdsc, union pds_core_dev_cmd *cmd,
 		       union pds_core_dev_comp *comp, int max_seconds);
 int pdsc_devcmd_init(struct pdsc *pdsc);
 int pdsc_devcmd_reset(struct pdsc *pdsc);
-int pdsc_dev_reinit(struct pdsc *pdsc);
 int pdsc_dev_init(struct pdsc *pdsc);
 
 int pdsc_intr_alloc(struct pdsc *pdsc, char *name,
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
index 1d590eb463d0..f0e39ab40045 100644
--- a/drivers/net/ethernet/amd/pds_core/dev.c
+++ b/drivers/net/ethernet/amd/pds_core/dev.c
@@ -309,13 +309,6 @@ static int pdsc_identify(struct pdsc *pdsc)
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
index 7471a751e4d8..7cc5a6b94939 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -438,7 +438,6 @@ static void pdsc_remove(struct pci_dev *pdev)
 		mutex_destroy(&pdsc->config_lock);
 		mutex_destroy(&pdsc->devcmd_lock);
 
-		pci_free_irq_vectors(pdev);
 		pdsc_unmap_bars(pdsc);
 		pci_release_regions(pdev);
 	}
@@ -456,7 +455,6 @@ static void pdsc_reset_prepare(struct pci_dev *pdev)
 
 	pdsc_fw_down(pdsc);
 
-	pci_free_irq_vectors(pdev);
 	pdsc_unmap_bars(pdsc);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
-- 
2.43.0



