Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B629315821A;
	Tue, 23 Jul 2024 18:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759332; cv=none; b=pecCX5eP9o2ESb9Z/Uw61jiKHOqWTlcI90mo5T/mrtdYpBWyCf5ZIzwQzOl9fat9zLn9i4g1tTcBrLyTkUcrIeQ2Kh3Pm3z6iR7Nhwf14iKiaKCGeqCxrx4wjBN5kG9eLcK7xE3VlLTejKAcDeUEU31nlgH9i0/DOYECMIoUg54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759332; c=relaxed/simple;
	bh=/mRR6KUqQtGRMwJ3vqJsLPbEnsFeKrfG6dnk9V2UQLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tQJ5zNB9VeNkXl/y+15Akm98jXYBXnLMGNI/cgl0JSqGmz926jEua3Rca8+3i4ZPIKYOzD1D7I+w7ntzYhdq0PBJdOWKAi/WyAVYgQnd/PRtgAWIr0OHJaEovVA9iZd9Daef4OhxgOtOxm6ipl0thcdA/yZq/LS1oE4eEh/VHzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tl+6w25U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tl+6w25U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 394D2C4AF0A;
	Tue, 23 Jul 2024 18:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759332;
	bh=/mRR6KUqQtGRMwJ3vqJsLPbEnsFeKrfG6dnk9V2UQLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tl+6w25UtGOj7LN8HQ9RSSizOg8rX343ot6zTcCcnCtBV3p+QW9irmf6Hysl+8Hze
	 1hn8bvS9va0pD5HDZxMplTUDtEyUfoKPm4y9AokxfJ8xITxLWq2djNIZyKh0eW4TRt
	 AK4byC42VTcGnQFznxI5CM1NmDLrgXj9g1f1zaWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ganesh Goudar <ganeshgr@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 080/105] powerpc/eeh: avoid possible crash when edev->pdev changes
Date: Tue, 23 Jul 2024 20:23:57 +0200
Message-ID: <20240723180406.329129613@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d2873d17d2b15..e4624d7896294 100644
--- a/arch/powerpc/kernel/eeh_pe.c
+++ b/arch/powerpc/kernel/eeh_pe.c
@@ -850,6 +850,7 @@ struct pci_bus *eeh_pe_bus_get(struct eeh_pe *pe)
 {
 	struct eeh_dev *edev;
 	struct pci_dev *pdev;
+	struct pci_bus *bus = NULL;
 
 	if (pe->type & EEH_PE_PHB)
 		return pe->phb->bus;
@@ -860,9 +861,11 @@ struct pci_bus *eeh_pe_bus_get(struct eeh_pe *pe)
 
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



