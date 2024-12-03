Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A491F890F;
	Tue,  3 Dec 2024 16:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242326; cv=none; b=GyJzt8NpOJMS8T4+Tptg4NRhAoD1xIUMihjpOmCslU54kHBuxC0YRFTbKRRJh6L+TtHFqDbLRR4nSrnMW4cHydzkgVbunxieNAuWR2IiiMDkO5DA2BLf4sX6LdUlDHul7G8hJhvGrrDYvgz8MD4N9Kr0w9ltNcdJF8JET2JBTwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242326; c=relaxed/simple;
	bh=GBFW4LRvA/+rZvheXNdz0AUo07S4G6/IJhHLlwpkNmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ULpn9l4y95aq/C6r8S+XCwYiK1pPX9r7hoVmcsAHqgMmYcpJe/wcbTuoCS7xBNGQVQlLjyrjZWcAklpWLQL5bu/aBTFLF4EhGN8Hgh9htX+MPmba41iehLuC6RKd1uDKLKgI1/5f/tZRGxC4gcdgTXZeZsmmHnFKbh2rqNQa89c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XqnWP8ym; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XqnWP8ym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89A8C4CECF;
	Tue,  3 Dec 2024 16:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242326;
	bh=GBFW4LRvA/+rZvheXNdz0AUo07S4G6/IJhHLlwpkNmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XqnWP8ymOcEPMYLHuevfwUU/YiTe1NVm+tuQzBCjTqS8B1rSswdxjp4cgfXGpzJsj
	 wk3sE69loPMwUGEFKpQlW+0mYeAgRfhziYdiwATsz+cQ2kQVP0KQba0V5N7vsxXz8A
	 FMRcKT9qdmH43nXx1jdEMzPMWlh6Wfqqs2lx58GM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuangyi Chiang <ki.chiang65@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.12 673/826] xhci: Combine two if statements for Etron xHCI host
Date: Tue,  3 Dec 2024 15:46:40 +0100
Message-ID: <20241203144810.006717875@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

From: Kuangyi Chiang <ki.chiang65@gmail.com>

commit d7b11fe5790203fcc0db182249d7bfd945e44ccb upstream.

Combine two if statements, because these hosts have the same
quirk flags applied.

[Mathias: has stable tag because other fixes in series depend on this]

Fixes: 91f7a1524a92 ("xhci: Apply broken streams quirk to Etron EJ188 xHCI host")
Cc: stable@vger.kernel.org
Signed-off-by: Kuangyi Chiang <ki.chiang65@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20241106101459.775897-18-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -395,12 +395,8 @@ static void xhci_pci_quirks(struct devic
 		xhci->quirks |= XHCI_DEFAULT_PM_RUNTIME_ALLOW;
 
 	if (pdev->vendor == PCI_VENDOR_ID_ETRON &&
-			pdev->device == PCI_DEVICE_ID_EJ168) {
-		xhci->quirks |= XHCI_RESET_ON_RESUME;
-		xhci->quirks |= XHCI_BROKEN_STREAMS;
-	}
-	if (pdev->vendor == PCI_VENDOR_ID_ETRON &&
-			pdev->device == PCI_DEVICE_ID_EJ188) {
+	    (pdev->device == PCI_DEVICE_ID_EJ168 ||
+	     pdev->device == PCI_DEVICE_ID_EJ188)) {
 		xhci->quirks |= XHCI_RESET_ON_RESUME;
 		xhci->quirks |= XHCI_BROKEN_STREAMS;
 	}


