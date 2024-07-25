Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE2B1990DD;
	Thu, 25 Jul 2024 14:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919200; cv=none; b=IF96dHXLyYy5Pth9LmXMOmqnCuMUQ8F7iJraqM55v1aBoP9DddFkXSBRab/UMyNFNyRGu/GtZNf7EAPe2+htLRU7whHVfgX+QwJvnFOn3yTaNe3Kr8mRHVWymIOCdAxzU4k1g1jXGiGz6TU9F552oNt4b9/5xhyfpWpT4t+0Tms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919200; c=relaxed/simple;
	bh=I8FDvCB+2+HWXCjzYjdLsdOVKmDhzoBrj9x9L5LrueI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q/E2Y2I0UP7jZtDyeOJ6wYoktRf/Tgu3VShHeyR10DcXINlvLmSD1LBe1TrKusAZT5mX9hUMRMk4KKWLzGtezhsXubr0AjTS4WPCrAHi0f7brMxiaKijlfP9LKRKsyzeHJ0w9xslK3Ph6MC9p/UgsV88pkGx4xxWwp40CoH/rpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w7XjwKc5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w7XjwKc5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89FF8C116B1;
	Thu, 25 Jul 2024 14:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919200;
	bh=I8FDvCB+2+HWXCjzYjdLsdOVKmDhzoBrj9x9L5LrueI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w7XjwKc599mI81IPH8soenauTKwu693HtBV4pwWKs53/q3UJXb93lvcaYwWQCmPTr
	 xtLaRupiZl+k97V1iuBkDfSe7FVW6SrGwmDYlULeSZSkxavdb0yIBrDex+Pxq+LOX3
	 IMJjaV+JBpZiXYrfLLFRYbt3KJmPqCwlTq9W0Bww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ganesh Goudar <ganeshgr@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 54/87] powerpc/eeh: avoid possible crash when edev->pdev changes
Date: Thu, 25 Jul 2024 16:37:27 +0200
Message-ID: <20240725142740.472138043@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142738.422724252@linuxfoundation.org>
References: <20240725142738.422724252@linuxfoundation.org>
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

From: Ganesh Goudar <ganeshgr@linux.ibm.com>

[ Upstream commit a1216e62d039bf63a539bbe718536ec789a853dd ]

If a PCI device is removed during eeh_pe_report_edev(), edev->pdev
will change and can cause a crash, hold the PCI rescan/remove lock
while taking a copy of edev->pdev->bus.

Signed-off-by: Ganesh Goudar <ganeshgr@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240617140240.580453-1-ganeshgr@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/eeh_pe.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/eeh_pe.c b/arch/powerpc/kernel/eeh_pe.c
index 845e024321d47..a856d9ba42d20 100644
--- a/arch/powerpc/kernel/eeh_pe.c
+++ b/arch/powerpc/kernel/eeh_pe.c
@@ -849,6 +849,7 @@ struct pci_bus *eeh_pe_bus_get(struct eeh_pe *pe)
 {
 	struct eeh_dev *edev;
 	struct pci_dev *pdev;
+	struct pci_bus *bus = NULL;
 
 	if (pe->type & EEH_PE_PHB)
 		return pe->phb->bus;
@@ -859,9 +860,11 @@ struct pci_bus *eeh_pe_bus_get(struct eeh_pe *pe)
 
 	/* Retrieve the parent PCI bus of first (top) PCI device */
 	edev = list_first_entry_or_null(&pe->edevs, struct eeh_dev, entry);
+	pci_lock_rescan_remove();
 	pdev = eeh_dev_to_pci_dev(edev);
 	if (pdev)
-		return pdev->bus;
+		bus = pdev->bus;
+	pci_unlock_rescan_remove();
 
-	return NULL;
+	return bus;
 }
-- 
2.43.0



