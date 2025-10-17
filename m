Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365A132E131;
	Fri, 17 Oct 2025 15:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715658; cv=none; b=je8j6PemQpc6A5VrE0wXCs7GVkAqUh3YraIYJlHQyvETb9kfVtM11iMW1nUG0SVArvtYVvXp3xd3fRcutITKjKGFwW4H954LCzPFlDqHChvmn3ha6DIrnxxpV/ZP1DCYF7whVRpe9sEuCvgE2ZNyGkpJkdd2FUG3ngYJvN1nRB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715658; c=relaxed/simple;
	bh=aeYQ5Xg5F6RWwuGYjypHMKFyTJNw6OFo2JyGfVxTvH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sar8Ue04ZTLYFjiB6KVtakf+CMVv+DAUwotjPUxJLnGeWH/WKWkLVjNlZGCvf51HRcEaMOL3stIjrLGqBDtzOSmY7tW4/8IuRV6NI/97dDkj0HupVHWy6AKcwWXGpCgE2X+CZCiKxbN05R5LwiCntDzksbbEjzErTwFjFYLHT+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eM3M+6Xz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eM3M+6Xz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC6DC4CEFE;
	Fri, 17 Oct 2025 15:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715657;
	bh=aeYQ5Xg5F6RWwuGYjypHMKFyTJNw6OFo2JyGfVxTvH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eM3M+6XzGz1kLuX27zmswgogWsltvtLQ0fwn/GsTVbrOINPABqzFK0l0+h7G69Ibv
	 OGD6sxur3ROa5sG4MtV4KvAkYoUE/Ii755CtVlWfpOs5xa00J3TVwY6JYKnEpqKnd2
	 jl25E66rJoCS9Y8GVuFjp25y/Uq+00nfflWv9+VE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <mani@kernel.org>
Subject: [PATCH 6.17 292/371] PCI/pwrctrl: Fix device and OF node leak at bus scan
Date: Fri, 17 Oct 2025 16:54:27 +0200
Message-ID: <20251017145212.635350657@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

commit e24bbbe0780262a21fc8619fe99078a5b8d64b18 upstream.

Make sure to drop the references to the pwrctrl OF node and device taken by
of_pci_find_child_device() and of_find_device_by_node() respectively when
scanning the bus.

Fixes: 957f40d039a9 ("PCI/pwrctrl: Move creation of pwrctrl devices to pci_scan_device()")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Cc: stable@vger.kernel.org	# v6.15
Link: https://patch.msgid.link/20250721153609.8611-3-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/probe.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index f41128f91ca7..a56dfa1c9b6f 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -2516,9 +2516,15 @@ static struct platform_device *pci_pwrctrl_create_device(struct pci_bus *bus, in
 	struct device_node *np;
 
 	np = of_pci_find_child_device(dev_of_node(&bus->dev), devfn);
-	if (!np || of_find_device_by_node(np))
+	if (!np)
 		return NULL;
 
+	pdev = of_find_device_by_node(np);
+	if (pdev) {
+		put_device(&pdev->dev);
+		goto err_put_of_node;
+	}
+
 	/*
 	 * First check whether the pwrctrl device really needs to be created or
 	 * not. This is decided based on at least one of the power supplies
@@ -2526,17 +2532,24 @@ static struct platform_device *pci_pwrctrl_create_device(struct pci_bus *bus, in
 	 */
 	if (!of_pci_supply_present(np)) {
 		pr_debug("PCI/pwrctrl: Skipping OF node: %s\n", np->name);
-		return NULL;
+		goto err_put_of_node;
 	}
 
 	/* Now create the pwrctrl device */
 	pdev = of_platform_device_create(np, NULL, &host->dev);
 	if (!pdev) {
 		pr_err("PCI/pwrctrl: Failed to create pwrctrl device for node: %s\n", np->name);
-		return NULL;
+		goto err_put_of_node;
 	}
 
+	of_node_put(np);
+
 	return pdev;
+
+err_put_of_node:
+	of_node_put(np);
+
+	return NULL;
 }
 #else
 static struct platform_device *pci_pwrctrl_create_device(struct pci_bus *bus, int devfn)
-- 
2.51.0



