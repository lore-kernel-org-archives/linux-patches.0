Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63992BE114;
	Wed, 23 Apr 2025 15:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421687; cv=none; b=ef3k9IIwn1v11eF29AKSnoLtQYBGXMHikN1MxgDDOq9p/8ulKfitYiSEa/e+mw0uMdFcQb8O4ifLXi0x/7jRaUNMYBI3GZpM8epmUdDrPknTxWDnOy7/TF6dqtGEhkLNpkJ7CVmUSTpRepp9k4oZMIvroNyYFzrEKbe65OzOOfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421687; c=relaxed/simple;
	bh=R0oxMAPEdE9jsg7+4/IuhpO63mfluFNC5ubu12KGHCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LlbURY7w7kV5lm2i2TeOR4Opyr/gX58l4oCCJSvUxnlJfjgvslOnkor+2dVQ36xUWB4q5tLrGs8OGO+CvsVkcw2epVthPBkJiwAgat1LITENErCTvMQ/Mg7JbWoPQ3fCMBwv7xgAq6ALDaHk9r+bOA+469Gy0SgZgPhJ3drq4Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VQzY4DAw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VQzY4DAw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0CDBC4CEE8;
	Wed, 23 Apr 2025 15:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421687;
	bh=R0oxMAPEdE9jsg7+4/IuhpO63mfluFNC5ubu12KGHCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VQzY4DAwejGcxonf8gpyBYfbJBOi6IE3cTrlLj8AwIAwe0DAaQ/xI5ABBjuufK1Yx
	 CEf4ZP/1sIBpzlhnWg+M1Kr2fXOhuWqiCwMM4htWzEjW30vbK1u3LrY6zO2cCkH3SC
	 EwDYIws4/GEIJpzPhN3TQJu4PdZkWZAzpUv/4vTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 208/393] crypto: ccp - Fix check for the primary ASP device
Date: Wed, 23 Apr 2025 16:41:44 +0200
Message-ID: <20250423142651.977297413@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -243,14 +243,17 @@ static bool sp_pci_is_master(struct sp_d
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


