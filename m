Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2652620F08C;
	Tue, 15 Jul 2025 13:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586915; cv=none; b=pFTm21jY3O/zTKetLSMlz29nzFDYWaeraj1ojbrXajD0EXP822WmZgdFS8aS7vPSjZ5KGCnVP+T1NNrQobWx8N9xHhfbPiEMVE9Pc/H+rlaPamQa9vT//IPyR6B8Q7sl05mAT24fnCYHAQ7HeT/2MmwIiW0CfbAD2EnRq8Ip8G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586915; c=relaxed/simple;
	bh=JiF4eNf0bHUvHJuO6IleC6Zy/IiOftiwMJJN66J5ga4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PucQmMtKZwCDePS80KlFJ2KulQKMy38d9HyzER+7dCMlazCxs1TPXxdlKXKQzg9Xl4KtUaNAITHFza7BjTYWbZn5RaQZ0Pu3NvD1Yr0x9ZZJasDp1l+aKEgJ347cttWlVZqmYaNRGafT+rUd1oPUB90DVvhSSmH7Mqx0KgyXLWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MGTfbsrh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MGTfbsrh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB9CDC4CEE3;
	Tue, 15 Jul 2025 13:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586915;
	bh=JiF4eNf0bHUvHJuO6IleC6Zy/IiOftiwMJJN66J5ga4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MGTfbsrhh5UwbaC66a7uhIcO/cld05cp2tDaxgs4cRchDmQP8xL7YOKegT+gBfr/I
	 edU3csiKG0GY2bqm5eKF6Lt56tOBFQ4DTgQcU1YiKKYiiutNuMSRkSxLaM9Y9xTYtH
	 2I2YEi3piSTyaNdMWQPC2pckowFZHXPMwgGxIZMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Zhe Qiao <qiaozhe@iscas.ac.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.15 097/192] Revert "PCI/ACPI: Fix allocated memory release on error in pci_acpi_scan_root()"
Date: Tue, 15 Jul 2025 15:13:12 +0200
Message-ID: <20250715130818.790304622@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhe Qiao <qiaozhe@iscas.ac.cn>

commit 2b8be57fa0c88ac824a906f29c04d728f9f6047a upstream.

This reverts commit 631b2af2f357 ("PCI/ACPI: Fix allocated memory release
on error in pci_acpi_scan_root()").

The reverted patch causes the 'ri->cfg' and 'root_ops' resources to be
released multiple times.

When acpi_pci_root_create() fails, these resources have already been
released internally by the __acpi_pci_root_release_info() function.

Releasing them again in pci_acpi_scan_root() leads to incorrect behavior
and potential memory issues.

We plan to resolve the issue using a more appropriate fix.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/aEmdnuw715btq7Q5@stanley.mountain/
Signed-off-by: Zhe Qiao <qiaozhe@iscas.ac.cn>
Acked-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/20250619072608.2075475-1-qiaozhe@iscas.ac.cn
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci-acpi.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -1676,19 +1676,24 @@ struct pci_bus *pci_acpi_scan_root(struc
 		return NULL;
 
 	root_ops = kzalloc(sizeof(*root_ops), GFP_KERNEL);
-	if (!root_ops)
-		goto free_ri;
+	if (!root_ops) {
+		kfree(ri);
+		return NULL;
+	}
 
 	ri->cfg = pci_acpi_setup_ecam_mapping(root);
-	if (!ri->cfg)
-		goto free_root_ops;
+	if (!ri->cfg) {
+		kfree(ri);
+		kfree(root_ops);
+		return NULL;
+	}
 
 	root_ops->release_info = pci_acpi_generic_release_info;
 	root_ops->prepare_resources = pci_acpi_root_prepare_resources;
 	root_ops->pci_ops = (struct pci_ops *)&ri->cfg->ops->pci_ops;
 	bus = acpi_pci_root_create(root, root_ops, &ri->common, ri->cfg);
 	if (!bus)
-		goto free_cfg;
+		return NULL;
 
 	/* If we must preserve the resource configuration, claim now */
 	host = pci_find_host_bridge(bus);
@@ -1705,14 +1710,6 @@ struct pci_bus *pci_acpi_scan_root(struc
 		pcie_bus_configure_settings(child);
 
 	return bus;
-
-free_cfg:
-	pci_ecam_free(ri->cfg);
-free_root_ops:
-	kfree(root_ops);
-free_ri:
-	kfree(ri);
-	return NULL;
 }
 
 void pcibios_add_bus(struct pci_bus *bus)


