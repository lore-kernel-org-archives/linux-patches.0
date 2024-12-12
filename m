Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2385176AA1;
	Thu, 12 Dec 2024 17:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023078; cv=none; b=u83wo2p8wmeHjK91vmqGJsdPajyu7ihtH/WYOYqJ++T2Ijsh0juZ8jjkL6FWfD2uOWF41vtO2pbg6CYs9xMt2awWIgid0KOMwDEBUYQyOx8uaYtFB6E5qop0MHBQVjglSCrnvizXbVMQD0rvjwI6ufiBJAmbpo1n4aqCssN1Wys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023078; c=relaxed/simple;
	bh=FLtvhAlXC9FivTrlTApQ5DBsJdl/37c+8hItHoy2aKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hvClZ4Go3hvRkJc5xLuw1io54S1BPY1xsepbgA+/Kxrh+TTFWeRaq8DX+vkC8Ne019ingPtZU6Y74ujeSkMdaFwGEEvJRjBgTdZL+Vm0P03S4lT2N9CZpAZZY/xSc1a33FULIsj2EbilaRUHh46F+GhcQcISii6Lp7vGGj9GevA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f4chE5H2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f4chE5H2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B77AC4CED4;
	Thu, 12 Dec 2024 17:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023078;
	bh=FLtvhAlXC9FivTrlTApQ5DBsJdl/37c+8hItHoy2aKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f4chE5H2SJ4RdXLdb9VhPjTjQokvN5WR0bm0hXo+xw9g0/7A4lOB6Tg7TOUwFP1nt
	 gthF00fVoNERlRU6fE0tYDkqka6fhdMzbMxPzqzqR95dnT+WA6RvU3yjDtOgOx/1P7
	 K7bznOaBGhyY2v2uitHCazVirOYtIHYM345Jnx7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kishon Vijay Abraham I <kishon@ti.com>,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Subject: [PATCH 5.15 387/565] PCI: keystone: Add link up check to ks_pcie_other_map_bus()
Date: Thu, 12 Dec 2024 15:59:42 +0100
Message-ID: <20241212144326.939250547@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kishon Vijay Abraham I <kishon@ti.com>

commit 9e9ec8d8692a6f64d81ef67d4fb6255af6be684b upstream.

K2G forwards the error triggered by a link-down state (e.g., no connected
endpoint device) on the system bus for PCI configuration transactions;
these errors are reported as an SError at system level, which is fatal and
hangs the system.

So, apply fix similar to how it was done in the DesignWare Core driver
commit 15b23906347c ("PCI: dwc: Add link up check in dw_child_pcie_ops.map_bus()").

Fixes: 10a797c6e54a ("PCI: dwc: keystone: Use pci_ops for config space accessors")
Link: https://lore.kernel.org/r/20240524105714.191642-3-s-vadapalli@ti.com
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
[kwilczynski: commit log, added tag for stable releases]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pci-keystone.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/pci/controller/dwc/pci-keystone.c
+++ b/drivers/pci/controller/dwc/pci-keystone.c
@@ -440,6 +440,17 @@ static void __iomem *ks_pcie_other_map_b
 	struct keystone_pcie *ks_pcie = to_keystone_pcie(pci);
 	u32 reg;
 
+	/*
+	 * Checking whether the link is up here is a last line of defense
+	 * against platforms that forward errors on the system bus as
+	 * SError upon PCI configuration transactions issued when the link
+	 * is down. This check is racy by definition and does not stop
+	 * the system from triggering an SError if the link goes down
+	 * after this check is performed.
+	 */
+	if (!dw_pcie_link_up(pci))
+		return NULL;
+
 	reg = CFG_BUS(bus->number) | CFG_DEVICE(PCI_SLOT(devfn)) |
 		CFG_FUNC(PCI_FUNC(devfn));
 	if (!pci_is_root_bus(bus->parent))


