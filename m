Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD7319E802;
	Mon, 14 Oct 2024 14:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916545; cv=none; b=NgLraLfjwGhd77qk6KOvSCQkWbkd9GS/gRVNFh7n24TYR2yWeI8ScLZabgHRbvLYM7au6Mw0Ta7w9WGWAa6nVzm5BJRjQ1uAFbxvQGQYl201GgBxcz02ycw66CqTYzR1K4+xI0X+PPG/ZG426GUZ0sm2A4a6PRNYw3TcAlvBWxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916545; c=relaxed/simple;
	bh=/VBKV0w8i3EXy4hP5+3BnX5kO/AbaIC47qk8Qxr9TGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZA5qHSTbFzQfjMHuQyUkOWbOyUu4sAK8q7uP9Ju/FdnJSw3Xf4x/UtXqlmsVMtsLCjlDN9QclOI0Z1khXZAajpGHASI/waG3Xe0JXixqB7ujbcmBLQfSSsfIyYr6gprx9uaXu4YCxJxQDmNbCWzXJqD8XAL15izV/fZqYkXJ3xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=agHcVBX2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="agHcVBX2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D21C4CEC3;
	Mon, 14 Oct 2024 14:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916544;
	bh=/VBKV0w8i3EXy4hP5+3BnX5kO/AbaIC47qk8Qxr9TGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=agHcVBX2oekqkWxdZ0lG3LJZKW+hpZfobNZxzSpWvGtxWPm8xcIdYgsZ4/19MsSFa
	 wqjN7c7R/hKl45VSA4zgX6gOuam4IFv5AbknHKkHQ4wUk55kRHL8HRwZ92IMmqI6vz
	 AyFrbF52HCtzFTYZ1cJbt2tRVCnZtmkgjqX8k7YA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Subject: [PATCH 6.11 213/214] PCI: Pass domain number to pci_bus_release_domain_nr() explicitly
Date: Mon, 14 Oct 2024 16:21:16 +0200
Message-ID: <20241014141053.288403051@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

commit 0cca961a026177af69044f10d6ae76d8ce043764 upstream.

The pci_bus_release_domain_nr() API is supposed to free the domain
number allocated by pci_bus_find_domain_nr(). Most of the callers of
pci_bus_find_domain_nr(), store the domain number in pci_bus::domain_nr.

As such, the pci_bus_release_domain_nr() implicitly frees the domain
number by dereferencing 'struct pci_bus'. However, one of the callers
of this API, the PCI endpoint subsystem, doesn't have 'struct pci_bus',
so it only passes NULL. Due to this, the API will end up dereferencing
the NULL pointer.

To fix this issue, pass the domain number to this API explicitly. Since
'struct pci_bus' is not used for anything else other than extracting the
domain number, it makes sense to pass the domain number directly.

Fixes: 0328947c5032 ("PCI: endpoint: Assign PCI domain number for endpoint controllers")
Closes: https://lore.kernel.org/linux-pci/c0c40ddb-bf64-4b22-9dd1-8dbb18aa2813@stanley.mountain
Link: https://lore.kernel.org/linux-pci/20240912053025.25314-1-manivannan.sadhasivam@linaro.org
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/endpoint/pci-epc-core.c |    2 +-
 drivers/pci/pci.c                   |   14 +++++++-------
 drivers/pci/probe.c                 |    2 +-
 drivers/pci/remove.c                |    2 +-
 include/linux/pci.h                 |    2 +-
 5 files changed, 11 insertions(+), 11 deletions(-)

--- a/drivers/pci/endpoint/pci-epc-core.c
+++ b/drivers/pci/endpoint/pci-epc-core.c
@@ -840,7 +840,7 @@ void pci_epc_destroy(struct pci_epc *epc
 	device_unregister(&epc->dev);
 
 #ifdef CONFIG_PCI_DOMAINS_GENERIC
-	pci_bus_release_domain_nr(NULL, &epc->dev);
+	pci_bus_release_domain_nr(&epc->dev, epc->domain_nr);
 #endif
 }
 EXPORT_SYMBOL_GPL(pci_epc_destroy);
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -6814,16 +6814,16 @@ static int of_pci_bus_find_domain_nr(str
 	return ida_alloc(&pci_domain_nr_dynamic_ida, GFP_KERNEL);
 }
 
-static void of_pci_bus_release_domain_nr(struct pci_bus *bus, struct device *parent)
+static void of_pci_bus_release_domain_nr(struct device *parent, int domain_nr)
 {
-	if (bus->domain_nr < 0)
+	if (domain_nr < 0)
 		return;
 
 	/* Release domain from IDA where it was allocated. */
-	if (of_get_pci_domain_nr(parent->of_node) == bus->domain_nr)
-		ida_free(&pci_domain_nr_static_ida, bus->domain_nr);
+	if (of_get_pci_domain_nr(parent->of_node) == domain_nr)
+		ida_free(&pci_domain_nr_static_ida, domain_nr);
 	else
-		ida_free(&pci_domain_nr_dynamic_ida, bus->domain_nr);
+		ida_free(&pci_domain_nr_dynamic_ida, domain_nr);
 }
 
 int pci_bus_find_domain_nr(struct pci_bus *bus, struct device *parent)
@@ -6832,11 +6832,11 @@ int pci_bus_find_domain_nr(struct pci_bu
 			       acpi_pci_bus_find_domain_nr(bus);
 }
 
-void pci_bus_release_domain_nr(struct pci_bus *bus, struct device *parent)
+void pci_bus_release_domain_nr(struct device *parent, int domain_nr)
 {
 	if (!acpi_disabled)
 		return;
-	of_pci_bus_release_domain_nr(bus, parent);
+	of_pci_bus_release_domain_nr(parent, domain_nr);
 }
 #endif
 
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1061,7 +1061,7 @@ unregister:
 
 free:
 #ifdef CONFIG_PCI_DOMAINS_GENERIC
-	pci_bus_release_domain_nr(bus, parent);
+	pci_bus_release_domain_nr(parent, bus->domain_nr);
 #endif
 	kfree(bus);
 	return err;
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -179,7 +179,7 @@ void pci_remove_root_bus(struct pci_bus
 #ifdef CONFIG_PCI_DOMAINS_GENERIC
 	/* Release domain_nr if it was dynamically allocated */
 	if (host_bridge->domain_nr == PCI_DOMAIN_NR_NOT_SET)
-		pci_bus_release_domain_nr(bus, host_bridge->dev.parent);
+		pci_bus_release_domain_nr(host_bridge->dev.parent, bus->domain_nr);
 #endif
 
 	pci_remove_bus(bus);
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1884,7 +1884,7 @@ static inline int acpi_pci_bus_find_doma
 { return 0; }
 #endif
 int pci_bus_find_domain_nr(struct pci_bus *bus, struct device *parent);
-void pci_bus_release_domain_nr(struct pci_bus *bus, struct device *parent);
+void pci_bus_release_domain_nr(struct device *parent, int domain_nr);
 #endif
 
 /* Some architectures require additional setup to direct VGA traffic */


