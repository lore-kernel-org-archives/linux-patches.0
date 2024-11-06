Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660DE1DFD87;
	Wed,  6 Nov 2024 12:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896200; cv=none; b=BSz8yr9LOuPD+EQEXPcMYjFY2iDvp58EsphCjLMiNvd+Quh248C38qnrj+aJe0iK1FaZRLjyj0qQEBpSufJ0dGVWI1rBmNRevhfVAoWq7jWpdlbupF/izB9E/bzq9r0fcLvS6psLyCfSD1D7fALyd6yd5FbqZ9JFIFSpRpntshE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896200; c=relaxed/simple;
	bh=xseTxG3eapKC3XIJxrMfemVLr+3+V8g0FpgqnwP1ZCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WEdGa9KzjCrolcY2g+zvllHgC7qFvTA3WspKaHZW+RviXOg92mIMZLT6+vSpgEybLKcyORUFvPE+pbY2RNKWd7/sYbaW3tYyLnBcqRg0aY6bsSSbmfxhM6QmSN1jUYWB1g671jccTLB0eugYzMOWaII5CRHg8jqH1/eHAMdZu4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BVIT6IAB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BVIT6IAB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD74BC4CED3;
	Wed,  6 Nov 2024 12:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896200;
	bh=xseTxG3eapKC3XIJxrMfemVLr+3+V8g0FpgqnwP1ZCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BVIT6IABzRrBEn/1w/8Bll4yaPwScD8Q4MA97YSuwyP6mdJc/2AVFrWkuPz1/NA1T
	 H+VOiaaIfbHHtlvhjLMItK5K2lvIU3TJfMnW6yFJj4/SO1BW+wHLfPlZDwqczFxdh4
	 hhZIOlxD6WYw6IYBBgXpyv3LQ41eBZfIAE6D0bdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Slaby <jirislaby@kernel.org>,
	Steffen Dirkwinkel <me@steffen.cc>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 077/245] PCI: Fix pci_enable_acs() support for the ACS quirks
Date: Wed,  6 Nov 2024 13:02:10 +0100
Message-ID: <20241106120321.100375443@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit f3c3ccc4fe49dbc560b01d16bebd1b116c46c2b4 ]

There are ACS quirks that hijack the normal ACS processing and deliver to
to special quirk code. The enable path needs to call
pci_dev_specific_enable_acs() and then pci_dev_specific_acs_enabled() will
report the hidden ACS state controlled by the quirk.

The recent rework got this out of order and we should try to call
pci_dev_specific_enable_acs() regardless of any actual ACS support in the
device.

As before command line parameters that effect standard PCI ACS don't
interact with the quirk versions, including the new config_acs= option.

Link: https://lore.kernel.org/r/0-v1-f96b686c625b+124-pci_acs_quirk_fix_jgg@nvidia.com
Fixes: 47c8846a49ba ("PCI: Extend ACS configurability")
Reported-by: Jiri Slaby <jirislaby@kernel.org>
Closes: https://lore.kernel.org/all/e89107da-ac99-4d3a-9527-a4df9986e120@kernel.org
Closes: https://bugzilla.suse.com/show_bug.cgi?id=1229019
Tested-by: Steffen Dirkwinkel <me@steffen.cc>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 85ced6958d6d1..51407c376a222 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1067,8 +1067,15 @@ static void pci_std_enable_acs(struct pci_dev *dev, struct pci_acs *caps)
 static void pci_enable_acs(struct pci_dev *dev)
 {
 	struct pci_acs caps;
+	bool enable_acs = false;
 	int pos;
 
+	/* If an iommu is present we start with kernel default caps */
+	if (pci_acs_enable) {
+		if (pci_dev_specific_enable_acs(dev))
+			enable_acs = true;
+	}
+
 	pos = dev->acs_cap;
 	if (!pos)
 		return;
@@ -1077,11 +1084,8 @@ static void pci_enable_acs(struct pci_dev *dev)
 	pci_read_config_word(dev, pos + PCI_ACS_CTRL, &caps.ctrl);
 	caps.fw_ctrl = caps.ctrl;
 
-	/* If an iommu is present we start with kernel default caps */
-	if (pci_acs_enable) {
-		if (pci_dev_specific_enable_acs(dev))
-			pci_std_enable_acs(dev, &caps);
-	}
+	if (enable_acs)
+		pci_std_enable_acs(dev, &caps);
 
 	/*
 	 * Always apply caps from the command line, even if there is no iommu.
-- 
2.43.0



