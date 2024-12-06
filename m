Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E79153A7;
	Fri,  6 Dec 2024 15:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498699; cv=none; b=TwscQEs3eq74I2CP+raS6X8GgXS5nCDRLs29cYuF8oT2/hFqTZp3W8C8i+pwH3g4iRcXt4YlYckHLmw398OBJJMudRea8KpP+d47dEU97TNk2d9vK5vAWUdOvWXYY2H0+AVmDowE+WJn7B+8AaqXdVhVvir2aWrCC8SHsB41m0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498699; c=relaxed/simple;
	bh=FE6SiNZaLG+6UPDCGqlRbwj4RX+yaLguwXin7q1HQbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rNV2F9N5RI/jKgR1roRQpuKtCR6FYfWT3hSgrIw+fasJT4R5Jj1XkwOlrEgfyV/0EXYl7C684O2GRwic4sLTfFA3DiiwJeMmbioGYQPmp5uQJoSQvBaQyLLTLTKpog9/ibJGetX5ijL6qSvUh92VnjmNbW+REBMZhE5v5bq5elA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h/I6kWOo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h/I6kWOo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 817D8C4CED1;
	Fri,  6 Dec 2024 15:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498699;
	bh=FE6SiNZaLG+6UPDCGqlRbwj4RX+yaLguwXin7q1HQbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h/I6kWOotuRXmIBJ1tbwa8HH/K2C6+vzo3pdw5yShZaG1y/e0HUhC38FhvZpDzcfv
	 XlzbJfeULQPEpKqwVbwGnOGTuglqJ8GDCE4263gEVYyrt4KPbNW/kgE4e0J5X425Lh
	 FsdCMT5FGS13lMzyiin1drJVGnZfPWjOZ4DD+YhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Andrea della Porta <andrea.porta@suse.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.6 654/676] PCI: of_property: Assign PCI instead of CPU bus address to dynamic PCI nodes
Date: Fri,  6 Dec 2024 15:37:53 +0100
Message-ID: <20241206143718.914704007@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea della Porta <andrea.porta@suse.com>

commit 5e316d34b53039346e252d0019e2f4167af2c0ef upstream.

When populating "ranges" property for a PCI bridge or endpoint,
of_pci_prop_ranges() incorrectly uses the CPU address of the resource.  In
such PCI nodes, the window should instead be in PCI address space. Call
pci_bus_address() on the resource in order to obtain the PCI bus address.

[Previous discussion at:
https://lore.kernel.org/all/8b4fa91380fc4754ea80f47330c613e4f6b6592c.1724159867.git.andrea.porta@suse.com/]

Link: https://lore.kernel.org/r/20241108094256.28933-1-andrea.porta@suse.com
Fixes: 407d1a51921e ("PCI: Create device tree node for bridge")
Tested-by: Herve Codina <herve.codina@bootlin.com>
Signed-off-by: Andrea della Porta <andrea.porta@suse.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/of_property.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/of_property.c b/drivers/pci/of_property.c
index 5a0b98e69795..886c236e5de6 100644
--- a/drivers/pci/of_property.c
+++ b/drivers/pci/of_property.c
@@ -126,7 +126,7 @@ static int of_pci_prop_ranges(struct pci_dev *pdev, struct of_changeset *ocs,
 		if (of_pci_get_addr_flags(&res[j], &flags))
 			continue;
 
-		val64 = res[j].start;
+		val64 = pci_bus_address(pdev, &res[j] - pdev->resource);
 		of_pci_set_address(pdev, rp[i].parent_addr, val64, 0, flags,
 				   false);
 		if (pci_is_bridge(pdev)) {
-- 
2.47.1



