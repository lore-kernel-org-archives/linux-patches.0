Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E40B1420BE;
	Tue, 23 Apr 2024 21:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908708; cv=none; b=UYd1v6GEGXlr0wGCEKCw+l+pMccVX97mlcXM0JQw5KhBfTQe8CtWJ3UZFGCWKTIohwSgVSkn0Gz6vLHnPyRzr6pn+A3ByUeD9misCL/nCfX9/JRdnWTmkqcRv+TSegUSMtoBJqKnwu/6v/Ieyt4aTXRvvm7uCvZO78e0BPU8BRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908708; c=relaxed/simple;
	bh=H3+gqjF3dckKL5sj16WIhPU4uUoU+/KxkdfrdD6HMbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZPeqXM/9iEPPFApvfkvMIopYTi5ecXdRhCDIUeW3T26kek/0Ncv0ZWjsOFKepsrgs7J13+HRhx/ivK+ScnjZNjYl4FIBc7Q4Doyn+TKojtGYG9OijzGywmgwzq+EWSwpMyUAYFecvzOfQRVe1O9+SJY2LIVGGRsGMZJvLWGXfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vwh2hJLa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vwh2hJLa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B78EC3277B;
	Tue, 23 Apr 2024 21:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908708;
	bh=H3+gqjF3dckKL5sj16WIhPU4uUoU+/KxkdfrdD6HMbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vwh2hJLaFLmw1evZzOFNSvAIjHxYmh1B9PrzaqbrRH/zkcqrbWxBW/v9apgGFsEsO
	 e7OHQEmnlNkCAa4q7c/UVeMGwNL8mKoJKjq18Ek5Ua6Xp7IwULEViENkuRytE0rQXl
	 /UpMDpCk1fa0M5nERoSqbaHihAj934QVx/Nw89uU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 064/141] PCI: Execute quirk_enable_clear_retrain_link() earlier
Date: Tue, 23 Apr 2024 14:38:52 -0700
Message-ID: <20240423213855.324071619@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej W. Rozycki <macro@orcam.me.uk>

[ Upstream commit 07a8d698de50c4740ac6f709c43e23a6da6e4dbc ]

Make quirk_enable_clear_retrain_link() an early quirk so that any later
fixups can rely on dev->clear_retrain_link to have been already
initialised.

[bhelgaas: reorder to just before it becomes possible to call
pcie_retrain_link() earlier]
Link: https://lore.kernel.org/r/alpine.DEB.2.21.2305310049000.59226@angie.orcam.me.uk
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 92169dc71468e..3959ea7b106b6 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2425,9 +2425,9 @@ static void quirk_enable_clear_retrain_link(struct pci_dev *dev)
 	dev->clear_retrain_link = 1;
 	pci_info(dev, "Enable PCIe Retrain Link quirk\n");
 }
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_PERICOM, 0xe110, quirk_enable_clear_retrain_link);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_PERICOM, 0xe111, quirk_enable_clear_retrain_link);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_PERICOM, 0xe130, quirk_enable_clear_retrain_link);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_PERICOM, 0xe110, quirk_enable_clear_retrain_link);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_PERICOM, 0xe111, quirk_enable_clear_retrain_link);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_PERICOM, 0xe130, quirk_enable_clear_retrain_link);
 
 static void fixup_rev1_53c810(struct pci_dev *dev)
 {
-- 
2.43.0



