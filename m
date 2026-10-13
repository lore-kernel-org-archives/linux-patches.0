Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5B24E7802;
	Tue, 13 Oct 2026 12:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895998; cv=none; b=Ka2Zu7TYav9AxX+7YgklW+cF4VWV/yn4krMUeC+sJs105oZY7FlK7f3uy3io+Ph4yMtDpOX20FWkB5g3Y09SWaUfiaN9q7WqQBRCzudksSE+2m1UHSPj6wvFqOPWigqohkxahxHEhNmV+lCrqnTYpRU8wnkTxVUEqZDT72zPW1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895998; c=relaxed/simple;
	bh=rLIpCkWyEOMpXJBs4F0h8ShTVg5Nt8mRyl1IYkuBax4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A0Ifj3RG4Evsz9VFSetvFFd+fijwdpHdgqW/J3pt4KDjxnfrTXqYmIVVFSBp7b4sPhyAq4ICeQAEmBOGEdY9X2G7QEm5TSIEyhKofzfDnoqDvkJr/NfpqXbSLANCmVn4irC1ax0uzQ1qbNGgsn2FyURwEwqxOgRCMfhY58riJTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NO9iBDZF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NO9iBDZF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04AE91F000FF;
	Tue, 13 Oct 2026 12:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895997;
	bh=7ArzBJIO5jyP0VZcfGkA5Ac6BWIrTQJHI4v+l3nXtTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NO9iBDZFbwo/bJ8OCpvt3g2d5HiwyFarLFdcqoilscvpVVDWUJrTegYSanKAY17Vi
	 n7hiYr0h6FSGX0KMAtRkdZemtJxUTzcRnlDwyF+4xXHTF8pb5WC6s7Z4ZubkwwH/ku
	 o3iADJqXgU9h294s1BpaNvEeAHIEP4bFFrGcFmmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 419/497] Bluetooth: btintel_pcie: use managed IRQ teardown
Date: Tue, 13 Oct 2026 13:39:46 +0200
Message-ID: <20261013112917.832666151@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit 25016fe8c1ed0fccae107bd629089139ffbafe08 upstream.

The PCIe driver registers its MSI-X handlers with
devm_request_threaded_irq(), but remove() uses free_irq() directly. The
devres actions then retain registrations and attempt to release them again
during device cleanup.

Use devm_free_irq() for the remove path and for already registered vectors
when a later setup request fails. This removes the managed resource at the
same time as the IRQ is released and keeps MSI-X vector teardown ordered
after IRQ ownership is gone.

Fixes: c2b636b3f788 ("Bluetooth: btintel_pcie: Add support for PCIe transport")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btintel_pcie.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -902,7 +902,7 @@ static irqreturn_t btintel_pcie_irq_msix
 static int btintel_pcie_setup_irq(struct btintel_pcie_data *data)
 {
 	int err;
-	int num_irqs, i;
+	int num_irqs, i, j;
 
 	for (i = 0; i < BTINTEL_PCIE_MSIX_VEC_MAX; i++)
 		data->msix_entries[i].entry = i;
@@ -931,6 +931,10 @@ static int btintel_pcie_setup_irq(struct
 						KBUILD_MODNAME,
 						msix_entry);
 		if (err) {
+			for (j = 0; j < i; j++)
+				devm_free_irq(&data->pdev->dev,
+					      data->msix_entries[j].vector,
+					      &data->msix_entries[j]);
 			pci_free_irq_vectors(data->pdev);
 			data->alloc_vecs = 0;
 			return err;
@@ -1648,7 +1652,7 @@ static void btintel_pcie_remove(struct p
 		struct msix_entry *msix_entry;
 
 		msix_entry = &data->msix_entries[i];
-		free_irq(msix_entry->vector, msix_entry);
+		devm_free_irq(&pdev->dev, msix_entry->vector, msix_entry);
 	}
 
 	pci_free_irq_vectors(pdev);


