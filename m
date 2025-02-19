Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1D81CBA18;
	Wed, 19 Feb 2025 08:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954137; cv=none; b=OLNrryBOzRZcVkKjx88ogzrXk332NmRhHcGP6KYGhGIe2FWBAAN9nVszpfbsUxVhRlXoAxJoxXCB6xcOqaAtv/WGyzDkaFm0tkmhDWYl6vCyUhFsCZePxjbOTIP1epe5W394cr1/bfydtO+hPhMfDjjckWLst9pnCHiehzgjwOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954137; c=relaxed/simple;
	bh=ZSP7cnhHD1IVmuVDsYstzt1HY2AlKwMxtuiP8CltFK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ff3mt9zSMHcUWZ9FaoS2DZZfWu4++Tmrm8T61+eUbq7RKNxknLbEiaTlaSrE7D5k1Jo/rhheK5hqgwo1PmGaKvY98QxH4/f1SSNBIHoDmBRXtLHFzY1KsJoh7f/xfTeQIQB6crQPH0mXx5qYUq3N7ueSImYklm0yuDDP2HqHIGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pyGISih6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pyGISih6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75044C4CED1;
	Wed, 19 Feb 2025 08:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954136;
	bh=ZSP7cnhHD1IVmuVDsYstzt1HY2AlKwMxtuiP8CltFK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pyGISih6KfRZVqwd80/8Ru4eE2Ua/cDntAHHSbxjEOTBnmZGSTuFqV7Yz9m+DOgCH
	 FA6HVY7+hS6YM/JcLPKxGOV9tmdLalIA9bdgO/LVYeAznM69iZuDkCWfJI2z3/JtoP
	 XwaRSBtIsvuXIVtz/O2NRievMuy7UQK7Fjt93EwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 077/274] PCI: endpoint: Add size check for fixed size BARs in pci_epc_set_bar()
Date: Wed, 19 Feb 2025 09:25:31 +0100
Message-ID: <20250219082612.637497858@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit f015b53d634a10fbceba545de70c3e109665c379 ]

A BAR of type BAR_FIXED has a fixed BAR size (the size cannot be changed).

When using pci_epf_alloc_space() to allocate backing memory for a BAR,
pci_epf_alloc_space() will always set the size to the fixed BAR size if
the BAR type is BAR_FIXED (and will give an error if you the requested size
is larger than the fixed BAR size).

However, some drivers might not call pci_epf_alloc_space() before calling
pci_epc_set_bar(), so add a check in pci_epc_set_bar() to ensure that an
EPF driver cannot set a size different from the fixed BAR size, if the BAR
type is BAR_FIXED.

The pci_epc_function_is_valid() check is removed because this check is now
done by pci_epc_get_features().

Link: https://lore.kernel.org/r/20241213143301.4158431-13-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/pci-epc-core.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/endpoint/pci-epc-core.c b/drivers/pci/endpoint/pci-epc-core.c
index 75c6688290034..111caa42f6b75 100644
--- a/drivers/pci/endpoint/pci-epc-core.c
+++ b/drivers/pci/endpoint/pci-epc-core.c
@@ -609,10 +609,17 @@ EXPORT_SYMBOL_GPL(pci_epc_clear_bar);
 int pci_epc_set_bar(struct pci_epc *epc, u8 func_no, u8 vfunc_no,
 		    struct pci_epf_bar *epf_bar)
 {
-	int ret;
+	const struct pci_epc_features *epc_features;
+	enum pci_barno bar = epf_bar->barno;
 	int flags = epf_bar->flags;
+	int ret;
 
-	if (!pci_epc_function_is_valid(epc, func_no, vfunc_no))
+	epc_features = pci_epc_get_features(epc, func_no, vfunc_no);
+	if (!epc_features)
+		return -EINVAL;
+
+	if (epc_features->bar[bar].type == BAR_FIXED &&
+	    (epc_features->bar[bar].fixed_size != epf_bar->size))
 		return -EINVAL;
 
 	if ((epf_bar->barno == BAR_5 && flags & PCI_BASE_ADDRESS_MEM_TYPE_64) ||
-- 
2.39.5



