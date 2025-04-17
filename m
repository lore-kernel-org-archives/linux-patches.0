Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76821A3178;
	Thu, 17 Apr 2025 18:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913572; cv=none; b=EUOsYehkcEsGzEJvA4++N3m7JbCGO6o/AxXPsCINxWhRwLCJpKg19q3dppobzAklrExqdRjeY//MNQdbwLR+GRwvN6yi61qYCooVzKKl/ZaesRe1hu5sY+uF1tRENUn4x3j2dV99uNxPgiosrCIWJP4E4Z6tJdeRJ/CA/DEuUro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913572; c=relaxed/simple;
	bh=vzOJoke5qhsZlrXqF2qZNHyW6gzvv7J1TpKoHHtvvjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OP8+GnAvRQt+Q+iJTl352LkDXw9XN4XKFuSUszf3E4sh1sAQBVRmz0mspbyotlIUYkTxZ5692WY5pnhHIJn18rB9Tx/HqxbBk6+zlMX7A/ur4/jUof1gOfL86yix4UPf+yL9aU+MWBNRfezxlWIUMvmmDh79Q34zsVxZMZM8jJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I5MIqRvX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I5MIqRvX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48CB1C4CEE4;
	Thu, 17 Apr 2025 18:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913572;
	bh=vzOJoke5qhsZlrXqF2qZNHyW6gzvv7J1TpKoHHtvvjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I5MIqRvXCMl7hQo6CV/Tq3rbNdq1LABIbZs11QB36yw0zo5PuUVZ6ccIHhdDjzN+X
	 gQHEZPPO2XaXTJjNr3kUMfeG6zDcHM1QoNJKDUHARtt+vXDBKTSUrkzonCJPATvBO+
	 P9na6AD6O7Ita2khVRYZEU/83vpngHhNpzRSYPyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.14 383/449] crypto: ccp - Fix check for the primary ASP device
Date: Thu, 17 Apr 2025 19:51:11 +0200
Message-ID: <20250417175133.675465904@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -189,14 +189,17 @@ static bool sp_pci_is_master(struct sp_d
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


