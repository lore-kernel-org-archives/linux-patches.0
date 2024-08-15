Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60E41A76B7;
	Thu, 15 Aug 2024 13:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728774; cv=none; b=tUhjBgNkEn7TXYylE3p/2f++DyAw/iLrYVxfbzg8GwQTSF3gAyLZRPAQal2MCTS0ltuPwJyQ8Sjh90qcS5M8atI1/fpd2Rl8CLKv/SNqOhUFA+FFgyh61qGILD5YS/rZBIUMtzDAZjBjR6W94+XcJp9ocufU100Ta/FhB9KVsL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728774; c=relaxed/simple;
	bh=CTBsuA7LxTZt/eZfFw4Ukm5h8RCIpWpDHwkzyPj26iU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=unugrDh8rKMC3aG3aePQyH+MCZW3Zp6pVHdSCpRFz4+KaGomWhiFTFEypYJcr7dCQGxk78AeJsVenD2f0g2zrgH0R8/ofrMQjOd62Zt1kUF6Ea5+LRsqervxpYzZRvxNFtF2FK9Osi+pv8YI/cufEvmrrnULIYjlz4rdXQW4O7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=arEDeeIo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="arEDeeIo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26AB0C4AF0E;
	Thu, 15 Aug 2024 13:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728774;
	bh=CTBsuA7LxTZt/eZfFw4Ukm5h8RCIpWpDHwkzyPj26iU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=arEDeeIoDjBDDDCpBshJ4STvCSIOL3oPE7w+QLLm4iAbkyDzLV0EZylT4j0Wi7pxQ
	 NsdSUjRnHNekq4Yzqi+laScPHrX3bj2gEUjeUBgqlPRfJg0BPm68nljPXlxz5386Xq
	 tARGkIRhaTqmNg6zOxeQj4GCN1dbDdQbDKpa8Guo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Liu <wei.liu@kernel.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Michael Kelley <mhklinux@outlook.com>,
	stable@kernel.org
Subject: [PATCH 4.19 078/196] PCI: hv: Return zero, not garbage, when reading PCI_INTERRUPT_PIN
Date: Thu, 15 Aug 2024 15:23:15 +0200
Message-ID: <20240815131855.061263542@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Liu <wei.liu@kernel.org>

commit fea93a3e5d5e6a09eb153866d2ce60ea3287a70d upstream.

The intent of the code snippet is to always return 0 for both
PCI_INTERRUPT_LINE and PCI_INTERRUPT_PIN.

The check misses PCI_INTERRUPT_PIN. This patch fixes that.

This is discovered by this call in VFIO:

    pci_read_config_byte(vdev->pdev, PCI_INTERRUPT_PIN, &pin);

The old code does not set *val to 0 because it misses the check for
PCI_INTERRUPT_PIN. Garbage is returned in that case.

Fixes: 4daace0d8ce8 ("PCI: hv: Add paravirtual PCI front-end for Microsoft Hyper-V VMs")
Link: https://lore.kernel.org/linux-pci/20240701202606.129606-1-wei.liu@kernel.org
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-hyperv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -650,8 +650,8 @@ static void _hv_pcifront_read_config(str
 		   PCI_CAPABILITY_LIST) {
 		/* ROM BARs are unimplemented */
 		*val = 0;
-	} else if (where >= PCI_INTERRUPT_LINE && where + size <=
-		   PCI_INTERRUPT_PIN) {
+	} else if ((where >= PCI_INTERRUPT_LINE && where + size <= PCI_INTERRUPT_PIN) ||
+		   (where >= PCI_INTERRUPT_PIN && where + size <= PCI_MIN_GNT)) {
 		/*
 		 * Interrupt Line and Interrupt PIN are hard-wired to zero
 		 * because this front-end only supports message-signaled


