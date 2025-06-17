Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451A72356A4;
	Tue, 17 Jun 2025 16:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178767; cv=none; b=JQuvN6UzKEfYZf/78uz4DEhiHK9oTMmpwuLYiTFyOuGtoGyAPMzvatQxWEbrHbZQhkH4jPeoY2GEVDG0jW6XMyjehHSfBgklJjie8G9cclh7VtxwZm+DYwzhjcrv7BmgZivcc7uFsAtu2gghlep3njVLDsRyj3QIyTB1fwjgo/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178767; c=relaxed/simple;
	bh=HRjJah2P6ZmD4Y2Qk/2IUkn6obCcICwfcCDFdyypGro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ovS3lW9GtgzbqJqfrWbvak2qOBYd36gvR87087L6OTTy0ftkxthfhDSFMMO6oFct3ssKE3hQTMrEm0DP/ZrPNeM2bUySNEGdGi1hkoI6BaTAlE7sgNm9W2aWD7wUfnJrfs1ZafScukANcqZr7paIL5PHHoYqoQ8FAOWKX/bqqZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0HrrbV7L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0HrrbV7L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B68C4CEE3;
	Tue, 17 Jun 2025 16:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178767;
	bh=HRjJah2P6ZmD4Y2Qk/2IUkn6obCcICwfcCDFdyypGro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0HrrbV7L3mW36rtjywvjLaPwSdiNpuvzyR0NBQR673hh7KaEoNcfkWGwltE40S5bt
	 6MrI2EvI9N32SgbqRYo6lQ2xqdr0d+R+s9eWZQieuylfKCMGjw3EkF5kyAGLsUdAIV
	 62MA5qao3jGJH9YFPPc1fY2oPAXIRLB2/7EdTvM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhe Qiao <qiaozhe@iscas.ac.cn>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 507/780] PCI/ACPI: Fix allocated memory release on error in pci_acpi_scan_root()
Date: Tue, 17 Jun 2025 17:23:35 +0200
Message-ID: <20250617152512.154160424@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhe Qiao <qiaozhe@iscas.ac.cn>

[ Upstream commit 631b2af2f35737750af284be22e63da56bf20139 ]

In the pci_acpi_scan_root() function, when creating a PCI bus fails,
we need to free up the previously allocated memory, which can avoid
invalid memory usage and save resources.

Fixes: 789befdfa389 ("arm64: PCI: Migrate ACPI related functions to pci-acpi.c")
Signed-off-by: Zhe Qiao <qiaozhe@iscas.ac.cn>
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lore.kernel.org/r/20250430060603.381504-1-qiaozhe@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-acpi.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
index af370628e5839..b78e0e4173244 100644
--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -1676,24 +1676,19 @@ struct pci_bus *pci_acpi_scan_root(struct acpi_pci_root *root)
 		return NULL;
 
 	root_ops = kzalloc(sizeof(*root_ops), GFP_KERNEL);
-	if (!root_ops) {
-		kfree(ri);
-		return NULL;
-	}
+	if (!root_ops)
+		goto free_ri;
 
 	ri->cfg = pci_acpi_setup_ecam_mapping(root);
-	if (!ri->cfg) {
-		kfree(ri);
-		kfree(root_ops);
-		return NULL;
-	}
+	if (!ri->cfg)
+		goto free_root_ops;
 
 	root_ops->release_info = pci_acpi_generic_release_info;
 	root_ops->prepare_resources = pci_acpi_root_prepare_resources;
 	root_ops->pci_ops = (struct pci_ops *)&ri->cfg->ops->pci_ops;
 	bus = acpi_pci_root_create(root, root_ops, &ri->common, ri->cfg);
 	if (!bus)
-		return NULL;
+		goto free_cfg;
 
 	/* If we must preserve the resource configuration, claim now */
 	host = pci_find_host_bridge(bus);
@@ -1710,6 +1705,14 @@ struct pci_bus *pci_acpi_scan_root(struct acpi_pci_root *root)
 		pcie_bus_configure_settings(child);
 
 	return bus;
+
+free_cfg:
+	pci_ecam_free(ri->cfg);
+free_root_ops:
+	kfree(root_ops);
+free_ri:
+	kfree(ri);
+	return NULL;
 }
 
 void pcibios_add_bus(struct pci_bus *bus)
-- 
2.39.5



