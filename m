Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54998745C9;
	Mon, 15 Apr 2024 14:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191212; cv=none; b=aH6t2T1EKZh3NhTg8gFCUusVIWCnJfcgp6LVJqqRl+TJCGtHmM2i6ZUH5tJ8cVyX8stH5sPFGx3xszkKd4JYJVQCD7qjIp3xmfAeLFkBeAdVYbrCdo790O8gSf9ERFpizc4ipzf1laILbLV3YsPWh9ikZvIqwNK+Vgos78T5GxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191212; c=relaxed/simple;
	bh=a5vNeoqtBKarquzda8Dcat+M/9eyNOgUsKLg1bmYQ7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TyBtBuFEhbBUuy2jtLm9q36ssPzXCtLIEF4yfhWGvlEg46ULM7vzATe/+fHjV1GVYkQqdk8YCc364viIM0/u3D8D3hl5drA4wdO6j+WuxkYvOJQmewB+AjdUXpjqTZMdJeK9mY5lfn+YJSIVPAdfDyMP2cuxfZbkL2F+gaTjug0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1abj66C6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1abj66C6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0894C2BD10;
	Mon, 15 Apr 2024 14:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191212;
	bh=a5vNeoqtBKarquzda8Dcat+M/9eyNOgUsKLg1bmYQ7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1abj66C6VoktP02ISQg4liX2lpQ20LaUOkA18pOOzGXMydzeWACsJ86eBx9t4DOnU
	 ls6rIYVp0zCoszDq2ojl7CIlZ31tNlujZ6BaN2ni6YMuYDaEvVIQfsE2nSxyxCBvQ6
	 58AQPDmM+9VDJ2NwwyuQ4gW93ylNVIlmlhcflkts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett Creeley <brett.creeley@amd.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 069/172] pds_core: use pci_reset_function for health reset
Date: Mon, 15 Apr 2024 16:19:28 +0200
Message-ID: <20240415142002.505805722@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shannon Nelson <shannon.nelson@amd.com>

[ Upstream commit 2cbab3c296f1addd73b40549a2271b30f960df8b ]

We get the benefit of all the PCI reset locking and recovery if
we use the existing pci_reset_function() that will call our
local reset handlers.

Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 81665adf25d2 ("pds_core: Fix pdsc_check_pci_health function to use work thread")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/core.c | 3 +--
 drivers/net/ethernet/amd/pds_core/core.h | 3 ---
 drivers/net/ethernet/amd/pds_core/main.c | 7 ++++---
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/amd/pds_core/core.c b/drivers/net/ethernet/amd/pds_core/core.c
index 7658a72867675..0d148795a8d09 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -609,8 +609,7 @@ static void pdsc_check_pci_health(struct pdsc *pdsc)
 	if (fw_status != PDS_RC_BAD_PCI)
 		return;
 
-	pdsc_reset_prepare(pdsc->pdev);
-	pdsc_reset_done(pdsc->pdev);
+	pci_reset_function(pdsc->pdev);
 }
 
 void pdsc_health_thread(struct work_struct *work)
diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
index 110c4b826b22d..f410f7d132056 100644
--- a/drivers/net/ethernet/amd/pds_core/core.h
+++ b/drivers/net/ethernet/amd/pds_core/core.h
@@ -283,9 +283,6 @@ int pdsc_devcmd_init(struct pdsc *pdsc);
 int pdsc_devcmd_reset(struct pdsc *pdsc);
 int pdsc_dev_init(struct pdsc *pdsc);
 
-void pdsc_reset_prepare(struct pci_dev *pdev);
-void pdsc_reset_done(struct pci_dev *pdev);
-
 int pdsc_intr_alloc(struct pdsc *pdsc, char *name,
 		    irq_handler_t handler, void *data);
 void pdsc_intr_free(struct pdsc *pdsc, int index);
diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
index 0050c5894563b..345b16127fe8b 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -468,7 +468,7 @@ static void pdsc_restart_health_thread(struct pdsc *pdsc)
 	mod_timer(&pdsc->wdtimer, jiffies + 1);
 }
 
-void pdsc_reset_prepare(struct pci_dev *pdev)
+static void pdsc_reset_prepare(struct pci_dev *pdev)
 {
 	struct pdsc *pdsc = pci_get_drvdata(pdev);
 
@@ -477,10 +477,11 @@ void pdsc_reset_prepare(struct pci_dev *pdev)
 
 	pdsc_unmap_bars(pdsc);
 	pci_release_regions(pdev);
-	pci_disable_device(pdev);
+	if (pci_is_enabled(pdev))
+		pci_disable_device(pdev);
 }
 
-void pdsc_reset_done(struct pci_dev *pdev)
+static void pdsc_reset_done(struct pci_dev *pdev)
 {
 	struct pdsc *pdsc = pci_get_drvdata(pdev);
 	struct device *dev = pdsc->dev;
-- 
2.43.0



