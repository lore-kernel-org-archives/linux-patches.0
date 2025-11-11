Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C0726E703;
	Tue, 11 Nov 2025 01:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824354; cv=none; b=CoakScH5s4D4q1mZXR5DtrZb7KWD5/QOc/zs6TkNOdugOhdr88/A46ghm7D+FciH0UY5tnKjCfUnEvNeeLPds1E0LRiieUAVi5nO0tIPGTBwEdl/IuidLCIk2X93C3YJtjcMUqiinkgCfVdgYTMIen/Gxt2d1MIX3WaLUpnxTE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824354; c=relaxed/simple;
	bh=GHpBvTO86YQbO5Z5kvjhV8vONaBQPWRlvQ7hw+Jn1JI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QreVzHufPY/62hn33KOUu5dq/V8Mz+OME4lRmtNCUg76LtW5I9cSoa2zeVFKh3KMayc6d2fAram5ksnSKt9dNJM/26BWtamPjHCOumtLx7eCbzrjpPF6PT/48M5fO04K0QgTwzqXcX23UXwbLu0IFxnhxM/ObNHx3usV6oSodY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zvhB57LY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zvhB57LY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E9FC19421;
	Tue, 11 Nov 2025 01:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824353;
	bh=GHpBvTO86YQbO5Z5kvjhV8vONaBQPWRlvQ7hw+Jn1JI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zvhB57LYdm9vZlhXVDksCoAq+Quo3yZapYHyGyPZM4xlfvY6uETXsvbRZ26l3JA54
	 5kMaVHU8rBHm+xMwAGduVT0J4LZHrIgwY70PzlXFjlu6iy4bh1wyOoT6kvntqAUCo1
	 gbpHw9YolWRvzwmr4wIoBOzeB9+l/QvyIsvdokt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 479/849] PCI: endpoint: pci-epf-test: Limit PCIe BAR size for fixed BARs
Date: Tue, 11 Nov 2025 09:40:49 +0900
Message-ID: <20251111004548.024391297@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marek.vasut+renesas@mailbox.org>

[ Upstream commit d5f6bd3ee3f5048f272182dc91675c082773999e ]

Currently, the test allocates BAR sizes according to fixed table bar_size.
This does not work with controllers which have fixed size BARs that are
smaller than the requested BAR size. One such controller is Renesas R-Car
V4H PCIe controller, which has BAR4 size limited to 256 bytes, which is
much less than one of the BAR size, 131072 currently requested by this
test. A lot of controllers drivers in-tree have fixed size BARs, and they
do work perfectly fine, but it is only because their fixed size is larger
than the size requested by pci-epf-test.c

Adjust the test such that in case a fixed size BAR is detected, the fixed
BAR size is used, as that is the only possible option.

This helps with test failures reported as follows:

  pci_epf_test pci_epf_test.0: requested BAR size is larger than fixed size
  pci_epf_test pci_epf_test.0: Failed to allocate space for BAR4

Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
[mani: reworded description]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Link: https://patch.msgid.link/20250905184240.144431-1-marek.vasut+renesas@mailbox.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-test.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-test.c b/drivers/pci/endpoint/functions/pci-epf-test.c
index 044f5ea0716d1..31617772ad516 100644
--- a/drivers/pci/endpoint/functions/pci-epf-test.c
+++ b/drivers/pci/endpoint/functions/pci-epf-test.c
@@ -1067,7 +1067,12 @@ static int pci_epf_test_alloc_space(struct pci_epf *epf)
 		if (bar == test_reg_bar)
 			continue;
 
-		base = pci_epf_alloc_space(epf, bar_size[bar], bar,
+		if (epc_features->bar[bar].type == BAR_FIXED)
+			test_reg_size = epc_features->bar[bar].fixed_size;
+		else
+			test_reg_size = bar_size[bar];
+
+		base = pci_epf_alloc_space(epf, test_reg_size, bar,
 					   epc_features, PRIMARY_INTERFACE);
 		if (!base)
 			dev_err(dev, "Failed to allocate space for BAR%d\n",
-- 
2.51.0



