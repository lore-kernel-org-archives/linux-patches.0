Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B184753A7;
	Fri,  6 Dec 2024 15:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498647; cv=none; b=cvhn1qasQPFl1nHeEi9Um7X5/iWevJB4RT55GggVYkjen0hIMt873lr3yTOsi0BIkCC44h+T3H3ebxzYt4a/kHM/jlBFoiRc7L3/XI85F87A1w8vOx6KYjD/CbM96O1b/syNaTNK0lp0wf/biBGOh85wOIP3lX2VlX+YaGvtR0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498647; c=relaxed/simple;
	bh=noW0tsvDxzOreRe6tklhaKELHDBEIs9texRIn5kltgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VY7aXV089BHe+FRE4mQ2u1m2ZgnY3qsTBR2Fwuvo/LrwW0aUpbOL9eaNys5Pgs3BPpN4XgVsEWmT7xofDc2bGKD19KwhgJIDFdCfHHyVrQCtJTqplYi2tx4CKPdhvT3dgMYvFK4Vp/jXJCJpShLN3u1nxn0Z+NfWCrdZ8It8Sj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AfjhKwUB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AfjhKwUB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED23C4CED1;
	Fri,  6 Dec 2024 15:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498647;
	bh=noW0tsvDxzOreRe6tklhaKELHDBEIs9texRIn5kltgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AfjhKwUBK+urZAIN3sGmrYUxO4OECVKAHn64/vi3HeGOagVzLMG0nujXoq/GCwsJ8
	 LkX3fqT21DMA+OaHVa+ORn4bth8TwWvUocDZJhMZsoE47VoubH4bKf0xf+TBcLkQlf
	 43wDS5F7vPSfaJ9Jfcpg6Xyj/TT2Q3tWVO7Unosw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kishon Vijay Abraham I <kishon@ti.com>,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Subject: [PATCH 6.6 646/676] PCI: keystone: Add link up check to ks_pcie_other_map_bus()
Date: Fri,  6 Dec 2024 15:37:45 +0100
Message-ID: <20241206143718.601842340@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -464,6 +464,17 @@ static void __iomem *ks_pcie_other_map_b
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


