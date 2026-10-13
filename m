Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5ED64EFFA2;
	Tue, 13 Oct 2026 11:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892266; cv=none; b=TmU3uHLjEAyd9lr0/GafsDcypVsHsUzrtTQbRWuL2IKD/3BcgTbe3Ng/TD4J1TwU+ZgFxIRySgeu1pUmNlKyemlWuyzfgqwmwL5zCw9r2q8uXutwODZg03lwLTGtQh4XZrmghy6lxwJttlqVvZuXEg74zkSOMbdKGMBAHqKlwCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892266; c=relaxed/simple;
	bh=IFDrSJn1x4mfaUYPRfDPDq8R3rSqZY9/9/+fGkyBP6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OupJt5lMloeeaNm4e3MhomY5XqJTIbtluraSNDxvTR+/9A2wdP5N9VdiNihQaE7ON+PA5fSyRsOVLj1WNqx8Ls1Rm0kC1bo0C1Vyp43CSY4dhJwarOhZV4dBJ9dPFsBaN/BIVni8iRLMeLW6aZ3zo2h78J+ZQZUBaCeOzTanO4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1EX4BOSL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1EX4BOSL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E4001F000FF;
	Tue, 13 Oct 2026 11:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892263;
	bh=fwFtpP0WP3XhBwmLWhZExmWMYFsiOal19z43UOvVrMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1EX4BOSLWtL63n5DQoJHzHq5py2jv7NpcFi232DtgDdspTkLNiAQgfrQezE1kb9su
	 uwAXIU7igjiAdbXgJ/X0fgxyjA6pUg8ZNgM5GGVh+v2tjn4YZI5WYfNGTvucC/CeYU
	 mKAHyhkxERQYYmIo93Qr3LFggtoAmlgCyl1CNIOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.2 114/281] Bluetooth: btintel_pcie: use managed IRQ teardown
Date: Tue, 13 Oct 2026 13:37:10 +0200
Message-ID: <20261013112857.915700476@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1715,7 +1715,7 @@ static irqreturn_t btintel_pcie_irq_msix
 static int btintel_pcie_setup_irq(struct btintel_pcie_data *data)
 {
 	int err;
-	int num_irqs, i;
+	int num_irqs, i, j;
 
 	for (i = 0; i < BTINTEL_PCIE_MSIX_VEC_MAX; i++)
 		data->msix_entries[i].entry = i;
@@ -1744,6 +1744,10 @@ static int btintel_pcie_setup_irq(struct
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
@@ -3003,7 +3007,7 @@ static void btintel_pcie_remove(struct p
 		struct msix_entry *msix_entry;
 
 		msix_entry = &data->msix_entries[i];
-		free_irq(msix_entry->vector, msix_entry);
+		devm_free_irq(&pdev->dev, msix_entry->vector, msix_entry);
 	}
 
 	pci_free_irq_vectors(pdev);


