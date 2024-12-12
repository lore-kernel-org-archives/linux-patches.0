Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0F1217F34;
	Thu, 12 Dec 2024 17:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024599; cv=none; b=GPPYXm2HQXqAlPIS5Gul+dE8q5cOP8KgIaRF1s/2ppDs4ODmz6qYIctMk7dRCFCd+CE/abDkI6mJQO1asIZc70xhLbGxgv5ULI8FH5Qq0xqPuy9l8zqxk0KBs8FIQqnGg9EFj9A2IzeQdv2FBKJqP7HOEEREr3vqtBa0uGHCzo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024599; c=relaxed/simple;
	bh=w+ry4ld+l/4SuNkE63omLby853KIoA7+Gq3uYZVHP68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i3cubQvqJIq9z+aI4x9KV/dyAUXz/HLoFjH+VNnImTY/8p3PmOVrHBWrFwEfMf7vD/c+uFy2vVt+RUC2zOiPkM7dUW6lF5Z8JMupDRcX0/hF1VwBRWjJKPLSI7BGzbo6o4Kyp0ZM7rifIIslVotmAJdcKMOvGRr2s8aUCA3kgnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xphbmjuE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xphbmjuE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7413CC4CECE;
	Thu, 12 Dec 2024 17:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024598;
	bh=w+ry4ld+l/4SuNkE63omLby853KIoA7+Gq3uYZVHP68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xphbmjuEGrSKn8CQgccJ/PhJFk7SvmMaWDMe43sqWfGw9iQQLC6bhg/IyaLCW1+zI
	 /zBtNFbUslo6on4POQCQyEWgnZnLXRSNgoTTRvcKAx0N3xIVQVE+52HGwlCgma1EJq
	 Tc/04ivENQdF4t5mdNHueLKQFJa6otR9Ny2feDfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kishon Vijay Abraham I <kishon@ti.com>,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Subject: [PATCH 5.10 319/459] PCI: keystone: Add link up check to ks_pcie_other_map_bus()
Date: Thu, 12 Dec 2024 16:00:57 +0100
Message-ID: <20241212144306.256505029@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -446,6 +446,17 @@ static void __iomem *ks_pcie_other_map_b
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


