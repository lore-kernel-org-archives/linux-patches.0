Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4FA3590D0;
	Tue, 16 Dec 2025 12:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887724; cv=none; b=a34wBZie15vYfUOEneaBXO2YpFwoRE3fz5QOdezSONkUgAYmFj4f1nCoeYzUBwgebxvDvdSZtHa9Ftog+aV1yltlFdyujfs/qYmMbPY362C0Z8fXXE1fJ6AotK/TW0xBCM8ZDUXjCYDrYDNxOc+e+ha8M2n21yjC4TQobqqL2is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887724; c=relaxed/simple;
	bh=Gbs9eAnHVENAYDXVyz4qUd42MnEUF5lk44kH7BK0zvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jWhG1DqS93T9RImddmuV5YOf+U0s/B5gUa6uIZ9b6fGLMB9xV9fYwpbWl0h/9NQjtYWtz619ZiSVCcD1ZJn5SCsqGOxGhXoM40n5sfoJM7T40yAv3r6N4Z+x1BF8HpW01CRmCXJlrG5NAzZX076lhQGT3tv+suGPv1LsiQCAAAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=guXy6qVF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="guXy6qVF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B169DC4CEF1;
	Tue, 16 Dec 2025 12:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887724;
	bh=Gbs9eAnHVENAYDXVyz4qUd42MnEUF5lk44kH7BK0zvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=guXy6qVFY4MBhD8KXbbuaKeqq0I1ru2CAfyjGMVnTgQFYJLsj1qKjhHbU9Lytil22
	 qT80mqUdcWuCt+1i3eA08Gr+OW853xxyyof8ArLyk0KsPQkw0ahhV65kXjK+88LO0T
	 vzgwY2CSORNwKZc9xsJ2FtUCQDt4gsdEgrOmb0+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Bruel <christian.bruel@foss.st.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 311/614] PCI: stm32: Fix EP page_size alignment
Date: Tue, 16 Dec 2025 12:11:18 +0100
Message-ID: <20251216111412.636129618@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Bruel <christian.bruel@foss.st.com>

[ Upstream commit ff529a9307a03ec03ed9751da053b57149300053 ]

pci_epc_mem_alloc_addr() allocates a CPU address from the ATU window phys
base and a page number. Set the ep->page_size so the resulting CPU address
is correctly aligned with the ATU required alignment.

Fixes: 151f3d29baf4 ("PCI: stm32-ep: Add PCIe Endpoint support for STM32MP25")
Signed-off-by: Christian Bruel <christian.bruel@foss.st.com>
[mani: added fixes tag]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20251114-atu_align_ep-v1-1-88da5366fa04@foss.st.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-stm32-ep.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-stm32-ep.c b/drivers/pci/controller/dwc/pcie-stm32-ep.c
index faa6433a784f3..7d48038d576d9 100644
--- a/drivers/pci/controller/dwc/pcie-stm32-ep.c
+++ b/drivers/pci/controller/dwc/pcie-stm32-ep.c
@@ -214,6 +214,8 @@ static int stm32_add_pcie_ep(struct stm32_pcie *stm32_pcie,
 
 	ep->ops = &stm32_pcie_ep_ops;
 
+	ep->page_size = stm32_pcie_epc_features.align;
+
 	ret = dw_pcie_ep_init(ep);
 	if (ret) {
 		dev_err(dev, "Failed to initialize ep: %d\n", ret);
-- 
2.51.0



