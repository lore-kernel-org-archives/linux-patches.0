Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF951581F4;
	Tue, 23 Jul 2024 18:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760173; cv=none; b=TMgQ13EMBU1mGon1PytxZfei5/GUwGVmHR1+/iiMfYwjFvc9QqRlX/lxu70HLFJhe/byO4SOfVh76lvvdCWQ6kaY05VMJCHzye3sEgH990+8X2IWkR9A6QZ6bqnX5LbGORN6oa7tFTe5rKqyK2+iZF1+wtJgq/Wcv8gVth/8wFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760173; c=relaxed/simple;
	bh=iYiB4xWqepMs0J5fwrFKRDCBEhWQgkZhWIhKRB2W+rY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LqRW4YcC/K/tnqsIfreHwv4qeFNoGz5S2jfpEbk2EHIW4eIwUehQTYzUx3JC7Ei4yLF/g+FNHNS/kKVZ0DaiG0qxcf1J4vwexyVW2I4fcCmyKEUrTgSdpEzEjrtUWHdKkEzE6bYfti00FokDVqOovIFRymFwxf+bTU51Jzy52ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qd7F1cm6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qd7F1cm6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EA1BC4AF0A;
	Tue, 23 Jul 2024 18:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760172;
	bh=iYiB4xWqepMs0J5fwrFKRDCBEhWQgkZhWIhKRB2W+rY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qd7F1cm6flH78rx+rqOHZZOvdX1vJRyQ7pUb2pTpJnQEyFg4sBGK0/seAhL2DWAnB
	 IRyWyzJLQWB6eC4IxSWG/XjnwJDNOZY7Ur8R2+ILbkoJWPpHCWSwpmbjmA9B+xIGP8
	 L6Z+2gTUyfQtg/9vyQN0q7IPCrJkIP6p3nWIF8oE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ganesh Goudar <ganeshgr@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 126/163] powerpc/eeh: avoid possible crash when edev->pdev changes
Date: Tue, 23 Jul 2024 20:24:15 +0200
Message-ID: <20240723180148.340889144@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index e0ce812796241..7d1b50599dd6c 100644
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



