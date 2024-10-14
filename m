Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9D5E571;
	Mon, 14 Oct 2024 14:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728915964; cv=none; b=Gqzwe36JV6U1Cap3N6oFaskbUsbjnD/tX3kSA3q25V9ib0Qco/i/sV0g61SoSBU+d4YRMhE5PglXfz1GxlRBXXvdGxjpPT9Pq5cnAsOyi1lKAAPAGnPlGie4bpzHbaEtY1phrak2XRLWWIP9kM/GnFK3TgyI3aYXBvpQK1yU/sI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728915964; c=relaxed/simple;
	bh=+UXLl5uZF006oRNWZnBGeQpZd1+msQyBdhqgkt3EY+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KNsuMUorW5pAOqOUbkdfXf7yNOkrzs0Ta2EXO3baHr9mY9UjcoMswLkWD0mRh1ZgajMWhKDpDAZ5/qcztf32FSPa7Lk1Fi5UV43aGifuZD2/n06v4MQarBQV0+Fj8Hg9EYKgEn6LZdghOkH2j04TB8YEpctNqbt+OCTDlEDQfiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tSnaVISC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tSnaVISC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F8CC4CEC3;
	Mon, 14 Oct 2024 14:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728915964;
	bh=+UXLl5uZF006oRNWZnBGeQpZd1+msQyBdhqgkt3EY+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tSnaVISCAO6cnig5ObffRMhs+s6SolfwLBA89BC/IWMLKIaw1qn7dQRpnU4Aj8UPe
	 5vhhhtG3cZEDo5Q0bWNhuYyuSBKzLn2QzYmEW1ao8m1AhxEKQgSdQFUyEUA86rQtko
	 4cvua9elUG3q+5NXUdL1y6xzMsTdAnlyXfyntHak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 048/214] PCI: endpoint: Assign PCI domain number for endpoint controllers
Date: Mon, 14 Oct 2024 16:18:31 +0200
Message-ID: <20241014141046.865841165@linuxfoundation.org>
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

[ Upstream commit 0328947c50324cf4b2d8b181bf948edb8101f59f ]

Right now, PCI endpoint subsystem doesn't assign PCI domain number for the
PCI endpoint controllers. But this domain number could be useful to the EPC
drivers to uniquely identify each controller based on the hardware instance
when there are multiple ones present in an SoC (even multiple RC/EP).

So let's make use of the existing pci_bus_find_domain_nr() API to allocate
domain numbers based on either devicetree (linux,pci-domain) property or
dynamic domain number allocation scheme.

It should be noted that the domain number allocated by this API will be
based on both RC and EP controllers in a SoC. If the 'linux,pci-domain' DT
property is present, then the domain number represents the actual hardware
instance of the PCI endpoint controller. If not, then the domain number
will be allocated based on the PCI EP/RC controller probe order.

If the architecture doesn't support CONFIG_PCI_DOMAINS_GENERIC (rare), then
currently a warning is thrown to indicate that the architecture specific
implementation is needed.

Link: https://lore.kernel.org/linux-pci/20240828-pci-qcom-hotplug-v4-5-263a385fbbcb@linaro.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/pci-epc-core.c | 14 ++++++++++++++
 include/linux/pci-epc.h             |  2 ++
 2 files changed, 16 insertions(+)

diff --git a/drivers/pci/endpoint/pci-epc-core.c b/drivers/pci/endpoint/pci-epc-core.c
index 84309dfe0c684..085a2de8b923d 100644
--- a/drivers/pci/endpoint/pci-epc-core.c
+++ b/drivers/pci/endpoint/pci-epc-core.c
@@ -838,6 +838,10 @@ void pci_epc_destroy(struct pci_epc *epc)
 {
 	pci_ep_cfs_remove_epc_group(epc->group);
 	device_unregister(&epc->dev);
+
+#ifdef CONFIG_PCI_DOMAINS_GENERIC
+	pci_bus_release_domain_nr(NULL, &epc->dev);
+#endif
 }
 EXPORT_SYMBOL_GPL(pci_epc_destroy);
 
@@ -900,6 +904,16 @@ __pci_epc_create(struct device *dev, const struct pci_epc_ops *ops,
 	epc->dev.release = pci_epc_release;
 	epc->ops = ops;
 
+#ifdef CONFIG_PCI_DOMAINS_GENERIC
+	epc->domain_nr = pci_bus_find_domain_nr(NULL, dev);
+#else
+	/*
+	 * TODO: If the architecture doesn't support generic PCI
+	 * domains, then a custom implementation has to be used.
+	 */
+	WARN_ONCE(1, "This architecture doesn't support generic PCI domains\n");
+#endif
+
 	ret = dev_set_name(&epc->dev, "%s", dev_name(dev));
 	if (ret)
 		goto put_dev;
diff --git a/include/linux/pci-epc.h b/include/linux/pci-epc.h
index 85bdf2adb7607..8e3dcac55dcd5 100644
--- a/include/linux/pci-epc.h
+++ b/include/linux/pci-epc.h
@@ -128,6 +128,7 @@ struct pci_epc_mem {
  * @group: configfs group representing the PCI EPC device
  * @lock: mutex to protect pci_epc ops
  * @function_num_map: bitmap to manage physical function number
+ * @domain_nr: PCI domain number of the endpoint controller
  * @init_complete: flag to indicate whether the EPC initialization is complete
  *                 or not
  */
@@ -145,6 +146,7 @@ struct pci_epc {
 	/* mutex to protect against concurrent access of EP controller */
 	struct mutex			lock;
 	unsigned long			function_num_map;
+	int				domain_nr;
 	bool				init_complete;
 };
 
-- 
2.43.0



