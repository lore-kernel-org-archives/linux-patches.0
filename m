Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0E14FC8E0;
	Tue, 13 Oct 2026 12:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893071; cv=none; b=FALzvHCoZk8siqKKdAj1RS34FXaK1HWMMIaVwgBW0nm9j68L+5c5q4vXiDbh6RXf8YKJfciX5fQ2axEt5/Sudc/Y2cYQ1OHVPYKEaZdYrHyYt9vsrrcT1YLxGX8Edk/6qGVkSYR2/oA+bC/PmEt79wpJbA8v5NLvYc3sdRcAg1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893071; c=relaxed/simple;
	bh=2dYIHh4axmM7ot6F5v/OsAGfQz/WOcvpiqpv7ILb8O0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j4e3NNq5YPUpqDyaReogjfPV3MPbrlzvhJWe2K6AndQqZSdPXVryGXm01DDRW2TEnqHWdoI4f0eGc2tik+C7ImK11FarIX7IqVeodHOKaKemH7McBTE1HeW2yWya0ILHn+eCIejiTI6Rsor1RJw3c/2z4ZGfxIyXrDF7MKBqgxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RKfdXj0N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RKfdXj0N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D05A11F000FF;
	Tue, 13 Oct 2026 12:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893070;
	bh=H0iThbfR6wzlWjih+IbV9ZtWMIfGBDlVSxl51/UHacE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RKfdXj0NrYG4TUval3RDLszcqukELZLA/z4R5whx6z1LkisK4npfgMRgSdQYRrE6P
	 1GjCQZrF5BGmKAOKqV36KKd1k3bSHXm1eDZw2ljMHV+MRje2f3ibSeqeH7Ihv9zuAk
	 hRdhe0uQ0XiQjH0aqeOPkZftghuohI/9TPRE/ZfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 101/621] Bluetooth: btintel_pcie: use managed IRQ teardown
Date: Tue, 13 Oct 2026 13:31:36 +0200
Message-ID: <20261013112923.244793966@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1540,7 +1540,7 @@ static irqreturn_t btintel_pcie_irq_msix
 static int btintel_pcie_setup_irq(struct btintel_pcie_data *data)
 {
 	int err;
-	int num_irqs, i;
+	int num_irqs, i, j;
 
 	for (i = 0; i < BTINTEL_PCIE_MSIX_VEC_MAX; i++)
 		data->msix_entries[i].entry = i;
@@ -1569,6 +1569,10 @@ static int btintel_pcie_setup_irq(struct
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
@@ -2531,7 +2535,7 @@ static void btintel_pcie_remove(struct p
 		struct msix_entry *msix_entry;
 
 		msix_entry = &data->msix_entries[i];
-		free_irq(msix_entry->vector, msix_entry);
+		devm_free_irq(&pdev->dev, msix_entry->vector, msix_entry);
 	}
 
 	pci_free_irq_vectors(pdev);


