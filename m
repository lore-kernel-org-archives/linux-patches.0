Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C55418B0A;
	Wed, 25 Feb 2026 01:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983296; cv=none; b=NFhyWdP0gYmmXWjuF9gVyEGiPmcV1PIYUh2EFoD8/lH8+5gs92C3SycBqqX+9Bq0ueuZYBqzKZhD/mOF3mGe+9kVf6k/DBa+g9HvbIRxOhABadXy/zSFX71T3aNCePxTiuQ93rwMAEkb3MHHLdrEGv1Kg28dEU0pApjpcExEHic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983296; c=relaxed/simple;
	bh=AfSmd1FjuvenV4lZZx12vagNUGhl5vImPcXk9q6pnPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zh8lE/wLUQ65iJJZPQ6bpTMFBFYmhlo90z8jKQpdNbXagwo3UINTJa83anL4/R0r2vqC6tYWrVG2goPdB66Vzmzqg/if1mUBoWFy9WfPJa9dTSMH4+K1am18KwpnsBiTnmEGUIWgWbTpflRom2tSDPbO/P3/tXhPliC9E+oBz88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AT0RZol9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AT0RZol9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F232EC116D0;
	Wed, 25 Feb 2026 01:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983296;
	bh=AfSmd1FjuvenV4lZZx12vagNUGhl5vImPcXk9q6pnPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AT0RZol90BEiCNJbZV+mJJ306mjDPuspYRiXIwX7hvPrJB5CEnBwYAcTkWoYRhrka
	 DRR1kVWseqtmvyLSyil4JA36sli2tIFxSTSgLd+13yXcwNcJuvgGzr2kz0dGhDRNSk
	 LfXl0NkBrxfKRxNPjAe4ZnGYsy70klLnROy1aIkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 394/781] PCI: endpoint: Add dynamic_inbound_mapping EPC feature
Date: Tue, 24 Feb 2026 17:18:23 -0800
Message-ID: <20260225012409.366784766@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <den@valinux.co.jp>

[ Upstream commit 06a81c5940e46cc7bddee28f16bdd29a12a76344 ]

Introduce a new EPC feature bit (dynamic_inbound_mapping) that indicates
whether an Endpoint Controller can update the inbound address
translation for a BAR without requiring the EPF driver to clear/reset
the BAR first.

Endpoint Function drivers (e.g. vNTB) can use this information to decide
whether it really is safe to call pci_epc_set_bar() multiple times to
update inbound mappings for the BAR.

Suggested-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260124145012.2794108-2-den@valinux.co.jp
Stable-dep-of: 72cb5ed2a5c6 ("PCI: dwc: ep: Add per-PF BAR and inbound ATU mapping support")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pci-epc.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/pci-epc.h b/include/linux/pci-epc.h
index 4286bfdbfdfad..4c8516756c568 100644
--- a/include/linux/pci-epc.h
+++ b/include/linux/pci-epc.h
@@ -223,6 +223,10 @@ struct pci_epc_bar_desc {
 /**
  * struct pci_epc_features - features supported by a EPC device per function
  * @linkup_notifier: indicate if the EPC device can notify EPF driver on link up
+ * @dynamic_inbound_mapping: indicate if the EPC device supports updating
+ *                           inbound mappings for an already configured BAR
+ *                           (i.e. allow calling pci_epc_set_bar() again
+ *                           without first calling pci_epc_clear_bar())
  * @msi_capable: indicate if the endpoint function has MSI capability
  * @msix_capable: indicate if the endpoint function has MSI-X capability
  * @intx_capable: indicate if the endpoint can raise INTx interrupts
@@ -231,6 +235,7 @@ struct pci_epc_bar_desc {
  */
 struct pci_epc_features {
 	unsigned int	linkup_notifier : 1;
+	unsigned int	dynamic_inbound_mapping : 1;
 	unsigned int	msi_capable : 1;
 	unsigned int	msix_capable : 1;
 	unsigned int	intx_capable : 1;
-- 
2.51.0



