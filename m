Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1FF1D7999;
	Mon,  6 Jan 2025 15:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178593; cv=none; b=iktYxMdWIs490+I44eNXf2z/fsaqqM4xDesgzXfPiVlKjw51tJmJ04eaETm6CPfKx0JYBqATGiqwRHZVbZ+eR43P3j8OPrGh9PuV8n9YvE80VCuO4SObGSKJacD6vXE3r/67tAUvyg1yI/ap/jTx7wObLylPem4bnaVvaQf9/po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178593; c=relaxed/simple;
	bh=73Tt77vA9TaPf55fv9Um0Sh/28OEOeFbZb2t4Xq+BJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rzNUSIcj0tzppgC53EFRTDNebl0mWbWuC3DgHlpp8f417f4gWGmzOMcC8J+qAEWl6Rt5HCKL1yhe0GRqltGr1/It/mX1TDn0r/JNOmQ7NIQflWkm6ZvDKpxoHHw6WVEe3m1f/KF8Qn6LMHR5vXwSt8gg/hCXbyklpRD37qI2rDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iniliz6k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iniliz6k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD73C4CEDF;
	Mon,  6 Jan 2025 15:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178593;
	bh=73Tt77vA9TaPf55fv9Um0Sh/28OEOeFbZb2t4Xq+BJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iniliz6kPuAOIzJ+PXJbO9sONgM+7BZ4JaEfyhlmgwSuL67/Z/BoY9UDoqOmYZbXT
	 VuWV7rqiPzl2+25laTkmmnMvcQibnEY0MmVWufAxhuZqW5aqNsP40DawPXO5qfH5MZ
	 MFcMMqhm3sqAzsm1ku7EIgRqOy9KHfK4Ae62N99Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai-Heng Feng <kai.heng.feng@canonical.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 003/168] PCI/AER: Disable AER service on suspend
Date: Mon,  6 Jan 2025 16:15:11 +0100
Message-ID: <20250106151138.587007315@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit 5afc2f763edc5daae4722ee46fea4e627d01fa90 ]

If the link is powered off during suspend, electrical noise may cause
errors that are logged via AER.  If the AER interrupt is enabled and shares
an IRQ with PME, that causes a spurious wakeup during suspend.

Disable the AER interrupt during suspend to prevent this.  Clear error
status before re-enabling IRQ interrupts during resume so we don't get an
interrupt for errors that occurred during the suspend/resume process.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=209149
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216295
Link: https://bugzilla.kernel.org/show_bug.cgi?id=218090
Link: https://lore.kernel.org/r/20240416043225.1462548-2-kai.heng.feng@canonical.com
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
[bhelgaas: drop pci_ancestor_pr3_present() etc, commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/aer.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/pci/pcie/aer.c b/drivers/pci/pcie/aer.c
index 4f7744aab6c7..2908bfda8880 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -1382,6 +1382,22 @@ static int aer_probe(struct pcie_device *dev)
 	return 0;
 }
 
+static int aer_suspend(struct pcie_device *dev)
+{
+	struct aer_rpc *rpc = get_service_data(dev);
+
+	aer_disable_rootport(rpc);
+	return 0;
+}
+
+static int aer_resume(struct pcie_device *dev)
+{
+	struct aer_rpc *rpc = get_service_data(dev);
+
+	aer_enable_rootport(rpc);
+	return 0;
+}
+
 /**
  * aer_root_reset - reset Root Port hierarchy, RCEC, or RCiEP
  * @dev: pointer to Root Port, RCEC, or RCiEP
@@ -1453,6 +1469,8 @@ static struct pcie_port_service_driver aerdriver = {
 	.service	= PCIE_PORT_SERVICE_AER,
 
 	.probe		= aer_probe,
+	.suspend	= aer_suspend,
+	.resume		= aer_resume,
 	.remove		= aer_remove,
 };
 
-- 
2.39.5



