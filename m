Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC8A110E0;
	Fri,  6 Dec 2024 14:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496320; cv=none; b=AxoAZ05BoAYvY6Hl0pGezfEDz23+gMW+iGsEIa/6cAWaTCrhcE4DZGGXiZspQmRKzSXTdB3APuFe0QNYSYEag/gY0VWEy86ZsR/Lj41nsLAcuSJTvTx/eIgbQ7r5rLQktlrwLzEMNX+OxyoBRUfhVgBG33LhTXqrDTnTrn0bdqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496320; c=relaxed/simple;
	bh=XB55o2f7IKcCBO5qYdt/o3qaO/2fV0i37nWgjTHkZf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=td0IaRAnxwt/4PmxIuS5gY0tpFBvDdvVxPtROEjc/Ifz3cgVZ1FY3+MLrz8HJvf86HwWQKl6SvC9o9ELBYdJl61y2TltkBkPHP4a0SFGi4ize4QFol/lpfyn+fW+ghtv85/IPsQMBehtHH04YQ7NaPNxufHWon5jDB3urpXsb+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FdP8POdv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FdP8POdv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21EEEC4CED1;
	Fri,  6 Dec 2024 14:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496319;
	bh=XB55o2f7IKcCBO5qYdt/o3qaO/2fV0i37nWgjTHkZf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FdP8POdvFmlxg4LKLpQgPjPbjv9Y3O9z+ezrSUj05wJJU8dzcBqiCk4OqHFPItPPr
	 wwt45rwQ2WTYZTB9o61BivdEMnEZIEyaAUsrl5YZxjulA07E6Tq7SH8lgBlrvqlrpu
	 VcE8VqN8XFFMjesdblT8/FA6mwf5CC64i9bEm9bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Subject: [PATCH 6.12 086/146] PCI: endpoint: Fix PCI domain ID release in pci_epc_destroy()
Date: Fri,  6 Dec 2024 15:36:57 +0100
Message-ID: <20241206143530.968895445@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit 4acc902ed3743edd4ac2d3846604a99d17104359 upstream.

pci_epc_destroy() invokes pci_bus_release_domain_nr() to release the PCI
domain ID, but there are two issues:

  - 'epc->dev' is passed to pci_bus_release_domain_nr() which was already
    freed by device_unregister(), leading to a use-after-free issue.

  - Domain ID corresponds to the EPC device parent, so passing 'epc->dev'
    is also wrong.

Fix these issues by passing 'epc->dev.parent' to
pci_bus_release_domain_nr() and also do it before device_unregister().

Fixes: 0328947c5032 ("PCI: endpoint: Assign PCI domain number for endpoint controllers")
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20241107-epc_rfc-v2-1-da5b6a99a66f@quicinc.com
[mani: reworded subject and description]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/endpoint/pci-epc-core.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/pci/endpoint/pci-epc-core.c
+++ b/drivers/pci/endpoint/pci-epc-core.c
@@ -837,11 +837,10 @@ EXPORT_SYMBOL_GPL(pci_epc_bus_master_ena
 void pci_epc_destroy(struct pci_epc *epc)
 {
 	pci_ep_cfs_remove_epc_group(epc->group);
-	device_unregister(&epc->dev);
-
 #ifdef CONFIG_PCI_DOMAINS_GENERIC
-	pci_bus_release_domain_nr(&epc->dev, epc->domain_nr);
+	pci_bus_release_domain_nr(epc->dev.parent, epc->domain_nr);
 #endif
+	device_unregister(&epc->dev);
 }
 EXPORT_SYMBOL_GPL(pci_epc_destroy);
 


