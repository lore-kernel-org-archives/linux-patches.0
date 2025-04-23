Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2766429DB6F;
	Wed, 23 Apr 2025 15:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421479; cv=none; b=A7AG+g076t5o+BZC4Ant9xcii2DRkU5hJTum5YmT58MB6tc8N5tCcsJ4bjl7fBMeHW++/bVzgDNOFDWcFN9LuGeGXxDibuYgP3LF6pjzvQi5pD8TTFEHKtO9yQPTdYSxhi4wEOS0r04cRim0i6CMGRbcPyzj6J4JZX5LzKxHY5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421479; c=relaxed/simple;
	bh=0quMg7AeQWiTLYW0gxMN1ZED8MgzzIBSwpSbTKGmhgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GnHeR+K4TtT7k+XGDMkG2WfdLEnP22tBSWxu6h9D2bkXf89d690jbYy/g2198wQpIrUJ8+C7WD8VX3zNQmMZMwtMzwhacTUuJUVa0FSXD/p/yMA9T67hMqS+E+KIvTP4CUAXvVW7ruCZkNfk+CpmIwU2g61VWgSp7ws+2p8Oe9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iIhB+bME; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iIhB+bME"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB40C4CEE2;
	Wed, 23 Apr 2025 15:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421479;
	bh=0quMg7AeQWiTLYW0gxMN1ZED8MgzzIBSwpSbTKGmhgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iIhB+bMEBXjo4xkk4AXssEny4407vSfeWbANDMKxEpQXe//s1AOcDC+H9OhKghoZB
	 P/EznrJJ3HcZALI49yvVuf/F6SlwwZw2tr7i+vByReadb/iVxvqACUF+Llhgp9FcjW
	 v1S0A3kon/rYCSta+1JVy9WpbAsLDgcxluOniseQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 141/291] crypto: ccp - Fix check for the primary ASP device
Date: Wed, 23 Apr 2025 16:42:10 +0200
Message-ID: <20250423142630.171418699@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Lendacky <thomas.lendacky@amd.com>

commit 07bb097b92b987db518e72525b515d77904e966e upstream.

Currently, the ASP primary device check does not have support for PCI
domains, and, as a result, when the system is configured with PCI domains
(PCI segments) the wrong device can be selected as primary. This results
in commands submitted to the device timing out and failing. The device
check also relies on specific device and function assignments that may
not hold in the future.

Fix the primary ASP device check to include support for PCI domains and
to perform proper checking of the Bus/Device/Function positions.

Fixes: 2a6170dfe755 ("crypto: ccp: Add Platform Security Processor (PSP) device support")
Cc: stable@vger.kernel.org
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/ccp/sp-pci.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -179,14 +179,17 @@ static bool sp_pci_is_master(struct sp_d
 	pdev_new = to_pci_dev(dev_new);
 	pdev_cur = to_pci_dev(dev_cur);
 
-	if (pdev_new->bus->number < pdev_cur->bus->number)
-		return true;
+	if (pci_domain_nr(pdev_new->bus) != pci_domain_nr(pdev_cur->bus))
+		return pci_domain_nr(pdev_new->bus) < pci_domain_nr(pdev_cur->bus);
 
-	if (PCI_SLOT(pdev_new->devfn) < PCI_SLOT(pdev_cur->devfn))
-		return true;
+	if (pdev_new->bus->number != pdev_cur->bus->number)
+		return pdev_new->bus->number < pdev_cur->bus->number;
 
-	if (PCI_FUNC(pdev_new->devfn) < PCI_FUNC(pdev_cur->devfn))
-		return true;
+	if (PCI_SLOT(pdev_new->devfn) != PCI_SLOT(pdev_cur->devfn))
+		return PCI_SLOT(pdev_new->devfn) < PCI_SLOT(pdev_cur->devfn);
+
+	if (PCI_FUNC(pdev_new->devfn) != PCI_FUNC(pdev_cur->devfn))
+		return PCI_FUNC(pdev_new->devfn) < PCI_FUNC(pdev_cur->devfn);
 
 	return false;
 }


