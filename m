Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A52224EF95;
	Mon, 24 Feb 2025 14:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408338; cv=none; b=sOqTkr4wGbCq2weolgOJ6cMfMFj7HVyMD9g1bAc1xBmyMS4VrV63EOWMUw7drnm1OM1IKEuCXO9om/HH48DQ7Uv1qawUCyw/LxBIxrCsejcsZFj+o6wi4CL+QEqZDGTfBelWOD6qjLeC9MJROzKg22z2KSSF93oHkQ9o+ESDm/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408338; c=relaxed/simple;
	bh=NPqrY8ViGUTrSMRknVJimsaJxlh7FYllqP/7iAxyu0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S8uLxTKw60p8WA9IQjOseMniD33BmOsK+qSLNCAbVtp/IEAvHEb55quwfpRrWfC29FRzOvAoTTaJBvFonIi4hB0BkwliJ9xJ6WmhurgSePt7RRznXMcqwMf0WqrtYLuOffGvPXWtbgytvpRm+NFNoODfklh0QbFXaEZQTv836VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kFFk5WxL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kFFk5WxL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0A5EC4CEEA;
	Mon, 24 Feb 2025 14:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408338;
	bh=NPqrY8ViGUTrSMRknVJimsaJxlh7FYllqP/7iAxyu0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kFFk5WxLFLxYx5Kb5i3c5Yh5/wKp6V05/DJ8IDBbPd2ITuGHcnd6nINYjA+slcECp
	 8WRm+eOpSlC0+xp1ejRuk2p0k+7J7YjkYwCcP/0ZqOHS5+WfkNxE97RtTvtiXu8ubT
	 P40EYyPnTPMkWCNkgQLqAx4XGmNA8hmMSLZ7mrTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Stanner <pstanner@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 029/154] PCI: Remove devres from pci_intx()
Date: Mon, 24 Feb 2025 15:33:48 +0100
Message-ID: <20250224142608.227451394@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philipp Stanner <pstanner@redhat.com>

[ Upstream commit dfa2f4d5f9e5d757700cefa8ee480099889f1c69 ]

pci_intx() is a hybrid function which can sometimes be managed through
devres. This hybrid nature is undesirable.

Since all users of pci_intx() have by now been ported either to
always-managed pcim_intx() or never-managed pci_intx_unmanaged(), the
devres functionality can be removed from pci_intx().

Consequently, pci_intx_unmanaged() is now redundant, because pci_intx()
itself is now unmanaged.

Remove the devres functionality from pci_intx(). Have all users of
pci_intx_unmanaged() call pci_intx(). Remove pci_intx_unmanaged().

Link: https://lore.kernel.org/r/20241209130632.132074-13-pstanner@redhat.com
Signed-off-by: Philipp Stanner <pstanner@redhat.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: d555ed45a5a1 ("PCI: Restore original INTX_DISABLE bit by pcim_intx()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/devres.c |  4 ++--
 drivers/pci/pci.c    | 43 ++-----------------------------------------
 include/linux/pci.h  |  1 -
 3 files changed, 4 insertions(+), 44 deletions(-)

diff --git a/drivers/pci/devres.c b/drivers/pci/devres.c
index c3699105656a7..70f1a46d07c5e 100644
--- a/drivers/pci/devres.c
+++ b/drivers/pci/devres.c
@@ -416,7 +416,7 @@ static void pcim_intx_restore(struct device *dev, void *data)
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct pcim_intx_devres *res = data;
 
-	pci_intx_unmanaged(pdev, res->orig_intx);
+	pci_intx(pdev, res->orig_intx);
 }
 
 static struct pcim_intx_devres *get_or_create_intx_devres(struct device *dev)
@@ -453,7 +453,7 @@ int pcim_intx(struct pci_dev *pdev, int enable)
 		return -ENOMEM;
 
 	res->orig_intx = !enable;
-	pci_intx_unmanaged(pdev, enable);
+	pci_intx(pdev, enable);
 
 	return 0;
 }
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 3916e0b23cdaf..1aa5d6f98ebda 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -4481,17 +4481,13 @@ void pci_disable_parity(struct pci_dev *dev)
 }
 
 /**
- * pci_intx_unmanaged - enables/disables PCI INTx for device dev,
- * unmanaged version
+ * pci_intx - enables/disables PCI INTx for device dev
  * @pdev: the PCI device to operate on
  * @enable: boolean: whether to enable or disable PCI INTx
  *
  * Enables/disables PCI INTx for device @pdev
- *
- * This function behavios identically to pci_intx(), but is never managed with
- * devres.
  */
-void pci_intx_unmanaged(struct pci_dev *pdev, int enable)
+void pci_intx(struct pci_dev *pdev, int enable)
 {
 	u16 pci_command, new;
 
@@ -4507,41 +4503,6 @@ void pci_intx_unmanaged(struct pci_dev *pdev, int enable)
 
 	pci_write_config_word(pdev, PCI_COMMAND, new);
 }
-EXPORT_SYMBOL_GPL(pci_intx_unmanaged);
-
-/**
- * pci_intx - enables/disables PCI INTx for device dev
- * @pdev: the PCI device to operate on
- * @enable: boolean: whether to enable or disable PCI INTx
- *
- * Enables/disables PCI INTx for device @pdev
- *
- * NOTE:
- * This is a "hybrid" function: It's normally unmanaged, but becomes managed
- * when pcim_enable_device() has been called in advance. This hybrid feature is
- * DEPRECATED! If you want managed cleanup, use pcim_intx() instead.
- */
-void pci_intx(struct pci_dev *pdev, int enable)
-{
-	u16 pci_command, new;
-
-	pci_read_config_word(pdev, PCI_COMMAND, &pci_command);
-
-	if (enable)
-		new = pci_command & ~PCI_COMMAND_INTX_DISABLE;
-	else
-		new = pci_command | PCI_COMMAND_INTX_DISABLE;
-
-	if (new != pci_command) {
-		/* Preserve the "hybrid" behavior for backwards compatibility */
-		if (pci_is_managed(pdev)) {
-			WARN_ON_ONCE(pcim_intx(pdev, enable) != 0);
-			return;
-		}
-
-		pci_write_config_word(pdev, PCI_COMMAND, new);
-	}
-}
 EXPORT_SYMBOL_GPL(pci_intx);
 
 /**
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 6ef32a8d146b1..74114acbb07fb 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1353,7 +1353,6 @@ int __must_check pcim_set_mwi(struct pci_dev *dev);
 int pci_try_set_mwi(struct pci_dev *dev);
 void pci_clear_mwi(struct pci_dev *dev);
 void pci_disable_parity(struct pci_dev *dev);
-void pci_intx_unmanaged(struct pci_dev *pdev, int enable);
 void pci_intx(struct pci_dev *dev, int enable);
 bool pci_check_and_mask_intx(struct pci_dev *dev);
 bool pci_check_and_unmask_intx(struct pci_dev *dev);
-- 
2.39.5



