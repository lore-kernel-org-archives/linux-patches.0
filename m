Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453861474A9;
	Fri,  6 Dec 2024 14:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496249; cv=none; b=jKQBQHmEyNaJiBy+EtYBWR2nI2Trp5e2eZSA7CKocdppSYVydrPen38nff7QgmINRL0qgfXCkQtTyyW1qhFGeoVI8ij/vSpFLmindwmzbFE3CkqHEP33kBv9a4gnMeLD9WEE/YkpGowqEpBV4xQlz+x8PmsVaYglhOwAxgu3YTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496249; c=relaxed/simple;
	bh=d/pXBkMlumEij4y5HtWVdO47s8iiaVtzetAchGaKaes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q8UjMQK0WYraqYAnjFunbnKJRqBFYQo/XSYhGYckaY/91RNExpGbh46otzSgthRO4hOrhWr/Ct2XulPHRTb2RksMhtx4yjSwLqydx2VaOuPWLcwgKrLyEIIT/shhKrABdVPpEr1olIhEOrMThSlfHRBx9yfMoJn9wvH4wD26gGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l+ESD3Hl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l+ESD3Hl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0B23C4CED1;
	Fri,  6 Dec 2024 14:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496249;
	bh=d/pXBkMlumEij4y5HtWVdO47s8iiaVtzetAchGaKaes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l+ESD3Hl6tH7bDaMHfiSgajq9qNOEEI9nnqqy4KUyhdN03lfArw7wUwv8jWku+SvI
	 Jq8Zeq5MWtdFMF+StsQ4TW63/LFlSouH9PUI36VsmhCUVWUqM9pjr1ZbYtcMsc/u/q
	 Zrpky6ehtxR3sFU5OgHt8jaRDCzuB+155rXJcl4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Andrea della Porta <andrea.porta@suse.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.12 097/146] PCI: of_property: Assign PCI instead of CPU bus address to dynamic PCI nodes
Date: Fri,  6 Dec 2024 15:37:08 +0100
Message-ID: <20241206143531.390440126@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/pci/of_property.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/of_property.c
+++ b/drivers/pci/of_property.c
@@ -126,7 +126,7 @@ static int of_pci_prop_ranges(struct pci
 		if (of_pci_get_addr_flags(&res[j], &flags))
 			continue;
 
-		val64 = res[j].start;
+		val64 = pci_bus_address(pdev, &res[j] - pdev->resource);
 		of_pci_set_address(pdev, rp[i].parent_addr, val64, 0, flags,
 				   false);
 		if (pci_is_bridge(pdev)) {


