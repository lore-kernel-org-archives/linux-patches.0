Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9750926B096;
	Thu, 13 Feb 2025 15:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459582; cv=none; b=G/xd8H211MNdG4fUcgA0DpcuZhdcOupMXto+DVAnZhCtWYM+3JORVYictIaLFG08EMG/0+G7+UATI2UOdVqMTvRbSTsnK36mAjLf6wojTjki8PmZZE06G/sY4b3jIbuBNoqvqZXR9lZu06PdUvLIhYYBjem7awyaiWpho4A+J70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459582; c=relaxed/simple;
	bh=LVs+1BQ8IxzLIRh3DUPYEYiyypdgSGRWWrlbkYmkCuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lf848VN3HFlZ292hF0aqdA2GfSPhJzve3ScRnMKZE0/F7SDI6z3t3E/NhMYpWtgNLlVXZPQtOGaCpJCy4+KpN/aPE5gEY8PM0oJtwtcCp2wPyCZ1uGWxl9s7RzEVo2wGmSrbyu7gZSWrNN0pC/ULqVUh7rIFo7efAg1mCR1Miss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xAQ7MarE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xAQ7MarE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41E6C4CED1;
	Thu, 13 Feb 2025 15:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459582;
	bh=LVs+1BQ8IxzLIRh3DUPYEYiyypdgSGRWWrlbkYmkCuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xAQ7MarEKtwevOGyr2KpbatFXD2GhLXfEFqi5e3tAng+eURhgmzuAkypRVOzZTWYC
	 LgFO0/RxDJoD479RZbN76fq5aoHV81VDUq100IiXd+HqUb+fudjU070aCEKsAfHmA8
	 m5pucyZeLeMvbzsrKA3wcacVQpWAxRjTStz3gAno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 6.13 276/443] PCI: dwc: ep: Prevent changing BAR size/flags in pci_epc_set_bar()
Date: Thu, 13 Feb 2025 15:27:21 +0100
Message-ID: <20250213142451.260136109@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

commit 3708acbd5f169ebafe1faa519cb28adc56295546 upstream.

In commit 4284c88fff0e ("PCI: designware-ep: Allow pci_epc_set_bar() update
inbound map address") set_bar() was modified to support dynamically
changing the backing physical address of a BAR that was already configured.

This means that set_bar() can be called twice, without ever calling
clear_bar() (as calling clear_bar() would clear the BAR's PCI address
assigned by the host).

This can only be done if the new BAR size/flags does not differ from the
existing BAR configuration. Add these missing checks.

If we allow set_bar() to set e.g. a new BAR size that differs from the
existing BAR size, the new address translation range will be smaller than
the BAR size already determined by the host, which would mean that a read
past the new BAR size would pass the iATU untranslated, which could allow
the host to read memory not belonging to the new struct pci_epf_bar.

While at it, add comments which clarifies the support for dynamically
changing the physical address of a BAR. (Which was also missing.)

Fixes: 4284c88fff0e ("PCI: designware-ep: Allow pci_epc_set_bar() update inbound map address")
Link: https://lore.kernel.org/r/20241213143301.4158431-10-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pcie-designware-ep.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -222,8 +222,28 @@ static int dw_pcie_ep_set_bar(struct pci
 	if ((flags & PCI_BASE_ADDRESS_MEM_TYPE_64) && (bar & 1))
 		return -EINVAL;
 
-	if (ep->epf_bar[bar])
+	/*
+	 * Certain EPF drivers dynamically change the physical address of a BAR
+	 * (i.e. they call set_bar() twice, without ever calling clear_bar(), as
+	 * calling clear_bar() would clear the BAR's PCI address assigned by the
+	 * host).
+	 */
+	if (ep->epf_bar[bar]) {
+		/*
+		 * We can only dynamically change a BAR if the new BAR size and
+		 * BAR flags do not differ from the existing configuration.
+		 */
+		if (ep->epf_bar[bar]->barno != bar ||
+		    ep->epf_bar[bar]->size != size ||
+		    ep->epf_bar[bar]->flags != flags)
+			return -EINVAL;
+
+		/*
+		 * When dynamically changing a BAR, skip writing the BAR reg, as
+		 * that would clear the BAR's PCI address assigned by the host.
+		 */
 		goto config_atu;
+	}
 
 	reg = PCI_BASE_ADDRESS_0 + (4 * bar);
 


