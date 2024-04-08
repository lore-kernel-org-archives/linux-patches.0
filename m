Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186847B3E5;
	Mon,  8 Apr 2024 13:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582090; cv=none; b=eWCmXSH9RK1OkFPlbFGJ8MHqPZmrw9m8N+jTEcQ55jpaiv46nQFyJw65s2+KvX26FT2Tk6y/HbOdUeXWdUBefvR4H1d7IOj+cZRKd9m29GKriP/8LRZe3s5nTygU4NaTgytJZkUd/6v6ow2I/W2icdglqmd982ngoH4mUjf6SnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582090; c=relaxed/simple;
	bh=0iIRDluz93Rbp/stYHM7ESl0RtbGOaHeT3gWZ+8nnmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iTJ0U8v5CA3NaNs/9BX36eVG/C2a2rnJAGXCKgwxXKBvxMbGpMnTLJ2C74Hl2l043xQd52P6yLaKRxMwMzL5t4/QzwE/n/yzrL4esKOvyAVnzK8A+/AHY+ynQCXWggsEtoTVlw//36FLRm5i4HKHzlsyGlXWULSTcen7t0dUHNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lPxulRF7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lPxulRF7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F57FC433C7;
	Mon,  8 Apr 2024 13:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582089;
	bh=0iIRDluz93Rbp/stYHM7ESl0RtbGOaHeT3gWZ+8nnmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lPxulRF7R88O3rn6+bqg4CrGmxW8Nt/v2sBHPRK2XaB3ehWqpt1sORJSCLJXtJGrD
	 zwN2A3TX9vqdtJpGAvXPh/vyvMejlcejwMolO6gdMmwWLXqg99Q2+mLZj4QA3XeH0N
	 ymskc17+wcAKbDhHJmqKjPgBww15yo+/FeiyaXDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt <cryptearth@googlemail.com>,
	Conrad Kostecki <conikost@gentoo.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 110/690] ahci: asm1064: asm1166: dont limit reported ports
Date: Mon,  8 Apr 2024 14:49:36 +0200
Message-ID: <20240408125403.510278334@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Conrad Kostecki <conikost@gentoo.org>

[ Upstream commit 6cd8adc3e18960f6e59d797285ed34ef473cc896 ]

Previously, patches have been added to limit the reported count of SATA
ports for asm1064 and asm1166 SATA controllers, as those controllers do
report more ports than physically having.

While it is allowed to report more ports than physically having in CAP.NP,
it is not allowed to report more ports than physically having in the PI
(Ports Implemented) register, which is what these HBAs do.
(This is a AHCI spec violation.)

Unfortunately, it seems that the PMP implementation in these ASMedia HBAs
is also violating the AHCI and SATA-IO PMP specification.

What these HBAs do is that they do not report that they support PMP
(CAP.SPM (Supports Port Multiplier) is not set).

Instead, they have decided to add extra "virtual" ports in the PI register
that is used if a port multiplier is connected to any of the physical
ports of the HBA.

Enumerating the devices behind the PMP as specified in the AHCI and
SATA-IO specifications, by using PMP READ and PMP WRITE commands to the
physical ports of the HBA is not possible, you have to use the "virtual"
ports.

This is of course bad, because this gives us no way to detect the device
and vendor ID of the PMP actually connected to the HBA, which means that
we can not apply the proper PMP quirks for the PMP that is connected to
the HBA.

Limiting the port map will thus stop these controllers from working with
SATA Port Multipliers.

This patch reverts both patches for asm1064 and asm1166, so old behavior
is restored and SATA PMP will work again, but it will also reintroduce the
(minutes long) extra boot time for the ASMedia controllers that do not
have a PMP connected (either on the PCIe card itself, or an external PMP).

However, a longer boot time for some, is the lesser evil compared to some
other users not being able to detect their drives at all.

Fixes: 0077a504e1a4 ("ahci: asm1166: correct count of reported ports")
Fixes: 9815e3961754 ("ahci: asm1064: correct count of reported ports")
Cc: stable@vger.kernel.org
Reported-by: Matt <cryptearth@googlemail.com>
Signed-off-by: Conrad Kostecki <conikost@gentoo.org>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
[cassel: rewrote commit message]
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/ahci.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 2d1f5cede60b2..7807c7b9f37ab 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -666,19 +666,6 @@ MODULE_PARM_DESC(mobile_lpm_policy, "Default LPM policy for mobile chipsets");
 static void ahci_pci_save_initial_config(struct pci_dev *pdev,
 					 struct ahci_host_priv *hpriv)
 {
-	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA) {
-		switch (pdev->device) {
-		case 0x1166:
-			dev_info(&pdev->dev, "ASM1166 has only six ports\n");
-			hpriv->saved_port_map = 0x3f;
-			break;
-		case 0x1064:
-			dev_info(&pdev->dev, "ASM1064 has only four ports\n");
-			hpriv->saved_port_map = 0xf;
-			break;
-		}
-	}
-
 	if (pdev->vendor == PCI_VENDOR_ID_JMICRON && pdev->device == 0x2361) {
 		dev_info(&pdev->dev, "JMB361 has only one port\n");
 		hpriv->force_port_map = 1;
-- 
2.43.0



