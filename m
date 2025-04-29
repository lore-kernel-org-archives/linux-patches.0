Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3894024A07D;
	Tue, 29 Apr 2025 17:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947267; cv=none; b=LR7wWaw8J9bvLgtgM6Qrzq9I1LXrt+o+vqUIRimHSaMKBWGTS7MlavJ5TypXwilkUQxOZPtTKdr7Ol5Xztzr0u2PK4ZSJgTErdzY5+DJo87GVxqr2zVFxDwae0UJOkQr74HfPUFa2GFtjFv/iCh7P+4j7PyXD4jT2ABJiEULKiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947267; c=relaxed/simple;
	bh=35M7TmC+x7tldQ/874kVXzfjGKd06LM/+W2bM4fbkzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E4dY4h9dLNfbGlEjXJpyzfHze5iDGonSs8IMGSQOdT+Ra5LXdC39b3j0GHuuasK6BOdjGUpnUjMlNa0E4VL4xmJ49s0j0ZZuPsf5RsQChXKVhFVvCN7wDYUbF8+xgxOtw4VMnWI3BfcYyVe5N4B6z2iDOAAReA0gTWtyDIwYyuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fHSZlM8A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fHSZlM8A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862AAC4CEF2;
	Tue, 29 Apr 2025 17:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947267;
	bh=35M7TmC+x7tldQ/874kVXzfjGKd06LM/+W2bM4fbkzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fHSZlM8AEdQPLoHmOwO/zfZkK/92RIq/8Xga/AHSbZjFN9AGenoKXBUfAKaIRi5i6
	 cELsNzKdpNvcv5Dc2ZBUNHN5tLZwWDMbRLibEV2SMPccMDD3O+k7pSihv+3TfKXi6s
	 01/mXEo4m8EfSJMmWm6KpDRGE7ARyOCcqFXEHvYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 224/286] PCI: Assign PCI domain IDs by ida_alloc()
Date: Tue, 29 Apr 2025 18:42:08 +0200
Message-ID: <20250429161117.155362651@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pali Rohár <pali@kernel.org>

[ Upstream commit c14f7ccc9f5dcf9d06ddeec706f85405b2c80600 ]

Replace assignment of PCI domain IDs from atomic_inc_return() to
ida_alloc().

Use two IDAs, one for static domain allocations (those which are defined in
device tree) and second for dynamic allocations (all other).

During removal of root bus / host bridge, also release the domain ID.  The
released ID can be reused again, for example when dynamically loading and
unloading native PCI host bridge drivers.

This change also allows to mix static device tree assignment and dynamic by
kernel as all static allocations are reserved in dynamic pool.

[bhelgaas: set "err" if "bus->domain_nr < 0"]
Link: https://lore.kernel.org/r/20220714184130.5436-1-pali@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Stable-dep-of: 804443c1f278 ("PCI: Fix reference leak in pci_register_host_bridge()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c    | 103 +++++++++++++++++++++++++------------------
 drivers/pci/probe.c  |   7 +++
 drivers/pci/remove.c |   6 +++
 include/linux/pci.h  |   1 +
 4 files changed, 74 insertions(+), 43 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 1d4585b07de3b..24916e78c507c 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -6467,60 +6467,70 @@ static void pci_no_domains(void)
 }
 
 #ifdef CONFIG_PCI_DOMAINS_GENERIC
-static atomic_t __domain_nr = ATOMIC_INIT(-1);
+static DEFINE_IDA(pci_domain_nr_static_ida);
+static DEFINE_IDA(pci_domain_nr_dynamic_ida);
 
-static int pci_get_new_domain_nr(void)
+static void of_pci_reserve_static_domain_nr(void)
 {
-	return atomic_inc_return(&__domain_nr);
+	struct device_node *np;
+	int domain_nr;
+
+	for_each_node_by_type(np, "pci") {
+		domain_nr = of_get_pci_domain_nr(np);
+		if (domain_nr < 0)
+			continue;
+		/*
+		 * Permanently allocate domain_nr in dynamic_ida
+		 * to prevent it from dynamic allocation.
+		 */
+		ida_alloc_range(&pci_domain_nr_dynamic_ida,
+				domain_nr, domain_nr, GFP_KERNEL);
+	}
 }
 
 static int of_pci_bus_find_domain_nr(struct device *parent)
 {
-	static int use_dt_domains = -1;
-	int domain = -1;
+	static bool static_domains_reserved = false;
+	int domain_nr;
 
-	if (parent)
-		domain = of_get_pci_domain_nr(parent->of_node);
+	/* On the first call scan device tree for static allocations. */
+	if (!static_domains_reserved) {
+		of_pci_reserve_static_domain_nr();
+		static_domains_reserved = true;
+	}
+
+	if (parent) {
+		/*
+		 * If domain is in DT, allocate it in static IDA.  This
+		 * prevents duplicate static allocations in case of errors
+		 * in DT.
+		 */
+		domain_nr = of_get_pci_domain_nr(parent->of_node);
+		if (domain_nr >= 0)
+			return ida_alloc_range(&pci_domain_nr_static_ida,
+					       domain_nr, domain_nr,
+					       GFP_KERNEL);
+	}
 
 	/*
-	 * Check DT domain and use_dt_domains values.
-	 *
-	 * If DT domain property is valid (domain >= 0) and
-	 * use_dt_domains != 0, the DT assignment is valid since this means
-	 * we have not previously allocated a domain number by using
-	 * pci_get_new_domain_nr(); we should also update use_dt_domains to
-	 * 1, to indicate that we have just assigned a domain number from
-	 * DT.
-	 *
-	 * If DT domain property value is not valid (ie domain < 0), and we
-	 * have not previously assigned a domain number from DT
-	 * (use_dt_domains != 1) we should assign a domain number by
-	 * using the:
-	 *
-	 * pci_get_new_domain_nr()
-	 *
-	 * API and update the use_dt_domains value to keep track of method we
-	 * are using to assign domain numbers (use_dt_domains = 0).
-	 *
-	 * All other combinations imply we have a platform that is trying
-	 * to mix domain numbers obtained from DT and pci_get_new_domain_nr(),
-	 * which is a recipe for domain mishandling and it is prevented by
-	 * invalidating the domain value (domain = -1) and printing a
-	 * corresponding error.
+	 * If domain was not specified in DT, choose a free ID from dynamic
+	 * allocations. All domain numbers from DT are permanently in
+	 * dynamic allocations to prevent assigning them to other DT nodes
+	 * without static domain.
 	 */
-	if (domain >= 0 && use_dt_domains) {
-		use_dt_domains = 1;
-	} else if (domain < 0 && use_dt_domains != 1) {
-		use_dt_domains = 0;
-		domain = pci_get_new_domain_nr();
-	} else {
-		if (parent)
-			pr_err("Node %pOF has ", parent->of_node);
-		pr_err("Inconsistent \"linux,pci-domain\" property in DT\n");
-		domain = -1;
-	}
+	return ida_alloc(&pci_domain_nr_dynamic_ida, GFP_KERNEL);
+}
 
-	return domain;
+static void of_pci_bus_release_domain_nr(struct pci_bus *bus, struct device *parent)
+{
+	if (bus->domain_nr < 0)
+		return;
+
+	/* Release domain from IDA where it was allocated. */
+	if (of_get_pci_domain_nr(parent->of_node) == bus->domain_nr)
+		ida_free(&pci_domain_nr_static_ida, bus->domain_nr);
+	else
+		ida_free(&pci_domain_nr_dynamic_ida, bus->domain_nr);
 }
 
 int pci_bus_find_domain_nr(struct pci_bus *bus, struct device *parent)
@@ -6528,6 +6538,13 @@ int pci_bus_find_domain_nr(struct pci_bus *bus, struct device *parent)
 	return acpi_disabled ? of_pci_bus_find_domain_nr(parent) :
 			       acpi_pci_bus_find_domain_nr(bus);
 }
+
+void pci_bus_release_domain_nr(struct pci_bus *bus, struct device *parent)
+{
+	if (!acpi_disabled)
+		return;
+	of_pci_bus_release_domain_nr(bus, parent);
+}
 #endif
 
 /**
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index a2c53f6d1848a..012ca242bedf4 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -904,6 +904,10 @@ static int pci_register_host_bridge(struct pci_host_bridge *bridge)
 		bus->domain_nr = pci_bus_find_domain_nr(bus, parent);
 	else
 		bus->domain_nr = bridge->domain_nr;
+	if (bus->domain_nr < 0) {
+		err = bus->domain_nr;
+		goto free;
+	}
 #endif
 
 	b = pci_find_bus(pci_domain_nr(bus), bridge->busnr);
@@ -1022,6 +1026,9 @@ static int pci_register_host_bridge(struct pci_host_bridge *bridge)
 	device_del(&bridge->dev);
 
 free:
+#ifdef CONFIG_PCI_DOMAINS_GENERIC
+	pci_bus_release_domain_nr(bus, parent);
+#endif
 	kfree(bus);
 	return err;
 }
diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index 95dec03d9f2a9..611547b52b46d 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -159,6 +159,12 @@ void pci_remove_root_bus(struct pci_bus *bus)
 	pci_remove_bus(bus);
 	host_bridge->bus = NULL;
 
+#ifdef CONFIG_PCI_DOMAINS_GENERIC
+	/* Release domain_nr if it was dynamically allocated */
+	if (host_bridge->domain_nr == PCI_DOMAIN_NR_NOT_SET)
+		pci_bus_release_domain_nr(bus, host_bridge->dev.parent);
+#endif
+
 	/* remove the host bridge */
 	device_del(&host_bridge->dev);
 }
diff --git a/include/linux/pci.h b/include/linux/pci.h
index a0fd1fe4189e4..d3d84eb466f02 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1667,6 +1667,7 @@ static inline int acpi_pci_bus_find_domain_nr(struct pci_bus *bus)
 { return 0; }
 #endif
 int pci_bus_find_domain_nr(struct pci_bus *bus, struct device *parent);
+void pci_bus_release_domain_nr(struct pci_bus *bus, struct device *parent);
 #endif
 
 /* Some architectures require additional setup to direct VGA traffic */
-- 
2.39.5



