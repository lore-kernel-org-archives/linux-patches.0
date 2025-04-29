Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B1821ABDB;
	Tue, 29 Apr 2025 17:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947257; cv=none; b=cwkTrQwC6BFpqKCEKUDxdwOS5yFXCfOq8D+2CUXavx1cobXQ2Wz+C3MCa5/2gIFqRMCLSLZJ6J943SrSxYmp5VOK2+fS1mAYdqIgDgyzznkxLfbtx6syImYCy0QfRHAqo0cShqkoNgUUAe85JuAVgmGpRNNeNeJ3m1gobeXJG+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947257; c=relaxed/simple;
	bh=QZ+AGfn1r7Xxl0U5iYOyK7xnSvWOfx36C6AnFXrb6mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rK5RPA0fUoZQBxHv/V1BMZhMvrjYmyPIsP/iWnGuDgzbc049hvfa/6I4m3ql2Gd2nB+fYskk5dwjXBHWO66ooQsm82XVDSD+XWGde4ZZn/2ShRspyak4qeu9l8OWUAEjC0Xcfm8K57X1eyTQq04U5U9hdt/3iXw7IpGlKTiFJRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZUZCYzzd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZUZCYzzd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BF69C4CEE3;
	Tue, 29 Apr 2025 17:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947257;
	bh=QZ+AGfn1r7Xxl0U5iYOyK7xnSvWOfx36C6AnFXrb6mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZUZCYzzdykneaHIwZy65DYuTcEEp6Yj/Xw0HIte63/dEmU3+HT3MQEQKQAjferUG5
	 ntepcKn+vcAQVsIO56igGrpPt/VTEH+cC1IISQxSH8NgkmTQ0YSE1Ba6yALgW+oczD
	 K1SSOHV7GWH6auRS2j7Jh0ksU64v3zpcAoSmxCZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boqun Feng <boqun.feng@gmail.com>,
	Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 222/286] PCI: Introduce domain_nr in pci_host_bridge
Date: Tue, 29 Apr 2025 18:42:06 +0200
Message-ID: <20250429161117.075180457@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boqun Feng <boqun.feng@gmail.com>

[ Upstream commit 15d82ca23c996d50062286d27ed6a42a8105c04a ]

Currently we retrieve the PCI domain number of the host bridge from the
bus sysdata (or pci_config_window if PCI_DOMAINS_GENERIC=y). Actually
we have the information at PCI host bridge probing time, and it makes
sense that we store it into pci_host_bridge. One benefit of doing so is
the requirement for supporting PCI on Hyper-V for ARM64, because the
host bridge of Hyper-V doesn't have pci_config_window, whereas ARM64 is
a PCI_DOMAINS_GENERIC=y arch, so we cannot retrieve the PCI domain
number from pci_config_window on ARM64 Hyper-V guest.

As the preparation for ARM64 Hyper-V PCI support, we introduce the
domain_nr in pci_host_bridge and a sentinel value to allow drivers to
set domain numbers properly at probing time. Currently
CONFIG_PCI_DOMAINS_GENERIC=y archs are only users of this
newly-introduced field.

Link: https://lore.kernel.org/r/20210726180657.142727-2-boqun.feng@gmail.com
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Stable-dep-of: 804443c1f278 ("PCI: Fix reference leak in pci_register_host_bridge()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/probe.c |  6 +++++-
 include/linux/pci.h | 11 +++++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 6439fc2e526c7..be7973e249cd7 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -595,6 +595,7 @@ static void pci_init_host_bridge(struct pci_host_bridge *bridge)
 	bridge->native_pme = 1;
 	bridge->native_ltr = 1;
 	bridge->native_dpc = 1;
+	bridge->domain_nr = PCI_DOMAIN_NR_NOT_SET;
 
 	device_initialize(&bridge->dev);
 }
@@ -899,7 +900,10 @@ static int pci_register_host_bridge(struct pci_host_bridge *bridge)
 	bus->ops = bridge->ops;
 	bus->number = bus->busn_res.start = bridge->busnr;
 #ifdef CONFIG_PCI_DOMAINS_GENERIC
-	bus->domain_nr = pci_bus_find_domain_nr(bus, parent);
+	if (bridge->domain_nr == PCI_DOMAIN_NR_NOT_SET)
+		bus->domain_nr = pci_bus_find_domain_nr(bus, parent);
+	else
+		bus->domain_nr = bridge->domain_nr;
 #endif
 
 	b = pci_find_bus(pci_domain_nr(bus), bridge->busnr);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 30bc462fb1964..a0fd1fe4189e4 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -538,6 +538,16 @@ static inline int pci_channel_offline(struct pci_dev *pdev)
 	return (pdev->error_state != pci_channel_io_normal);
 }
 
+/*
+ * Currently in ACPI spec, for each PCI host bridge, PCI Segment
+ * Group number is limited to a 16-bit value, therefore (int)-1 is
+ * not a valid PCI domain number, and can be used as a sentinel
+ * value indicating ->domain_nr is not set by the driver (and
+ * CONFIG_PCI_DOMAINS_GENERIC=y archs will set it with
+ * pci_bus_find_domain_nr()).
+ */
+#define PCI_DOMAIN_NR_NOT_SET (-1)
+
 struct pci_host_bridge {
 	struct device	dev;
 	struct pci_bus	*bus;		/* Root bus */
@@ -545,6 +555,7 @@ struct pci_host_bridge {
 	struct pci_ops	*child_ops;
 	void		*sysdata;
 	int		busnr;
+	int		domain_nr;
 	struct list_head windows;	/* resource_entry */
 	struct list_head dma_ranges;	/* dma ranges resource list */
 	u8 (*swizzle_irq)(struct pci_dev *, u8 *); /* Platform IRQ swizzler */
-- 
2.39.5



