Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9311B1D0F6E;
	Wed,  2 Oct 2024 14:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878583; cv=none; b=eBFyIl/7Bg7MOqst0cNKVA5Nf7tLZBxy0hOG8ar6AWeFN6LHu8GShS/z135dkgYTRMX3kw7QrfISOq5kD55+zaY2BjpD1J515/2EEfzebcuqwucPA46YgTSerKVery1+xLrhMTe0S2alb5yD2f8LOFq6fntdydzFQS3pILPM8Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878583; c=relaxed/simple;
	bh=GjCPCdLSdQiAHhO+/gGLNWGYBdP4OUOdvr9EKIQrZok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E1YwsygBaryExC/yUuHJVXH7YX2FR8FtRig9VqF7kVu0R0Q70FZXQXRYXJ6yAaiH47ovT2fazgoXNJgqno3stf7eV1iEW6ZSWVpMggmONmDh+YtCJ130P31n9C3SvAqk1v4sU9QBYOeysTfGk9yVTs8ZCqYn25Iy+3eezDQxh9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=apnAf9dF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="apnAf9dF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E0C3C4CEC2;
	Wed,  2 Oct 2024 14:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878583;
	bh=GjCPCdLSdQiAHhO+/gGLNWGYBdP4OUOdvr9EKIQrZok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=apnAf9dFV+1xrAmFx3R+ML5ZupC4u3bDnnIjuvHt5y+R19woBsdG/8FlRsG1QFeIg
	 RcJE1xfUGCG0EpMQzwaiOmkmjlF/N+oH5o2TVAF6qTMytDB64XvamRLwhC57oJhH4x
	 SDmN5Ys8RZht3GT5OX0jcTyQ+ZtVAMSxP11oYEPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew W Carlis <mattc@purestorage.com>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.10 463/634] PCI: Revert to the original speed after PCIe failed link retraining
Date: Wed,  2 Oct 2024 14:59:23 +0200
Message-ID: <20241002125829.378739250@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit f68dea13405c94381d08f42dbf0416261622bdad upstream.

When `pcie_failed_link_retrain' has failed to retrain the link by hand
it leaves the link speed restricted to 2.5GT/s, which will then affect
any device that has been plugged in later on, which may not suffer from
the problem that caused the speed restriction to have been attempted.
Consequently such a downstream device will suffer from an unnecessary
communication throughput limitation and therefore performance loss.

Remove the speed restriction then and revert the Link Control 2 register
to its original state if link retraining with the speed restriction in
place has failed.  Retrain the link again afterwards so as to remove any
residual state, waiting on LT rather than DLLLA to avoid an excessive
delay and ignoring the result as this training is supposed to fail
anyway.

Fixes: a89c82249c37 ("PCI: Work around PCIe link training failures")
Link: https://lore.kernel.org/linux-pci/alpine.DEB.2.21.2408251412590.30766@angie.orcam.me.uk
Reported-by: Matthew W Carlis <mattc@purestorage.com>
Link: https://lore.kernel.org/r/20240806000659.30859-1-mattc@purestorage.com/
Link: https://lore.kernel.org/r/20240722193407.23255-1-mattc@purestorage.com/
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Cc: <stable@vger.kernel.org> # v6.5+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/quirks.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -66,7 +66,7 @@
  * apply this erratum workaround to any downstream ports as long as they
  * support Link Active reporting and have the Link Control 2 register.
  * Restrict the speed to 2.5GT/s then with the Target Link Speed field,
- * request a retrain and wait 200ms for the data link to go up.
+ * request a retrain and check the result.
  *
  * If this turns out successful and we know by the Vendor:Device ID it is
  * safe to do so, then lift the restriction, letting the devices negotiate
@@ -74,6 +74,10 @@
  * firmware may have already arranged and lift it with ports that already
  * report their data link being up.
  *
+ * Otherwise revert the speed to the original setting and request a retrain
+ * again to remove any residual state, ignoring the result as it's supposed
+ * to fail anyway.
+ *
  * Return TRUE if the link has been successfully retrained, otherwise FALSE.
  */
 bool pcie_failed_link_retrain(struct pci_dev *dev)
@@ -92,6 +96,8 @@ bool pcie_failed_link_retrain(struct pci
 	pcie_capability_read_word(dev, PCI_EXP_LNKSTA, &lnksta);
 	if ((lnksta & (PCI_EXP_LNKSTA_LBMS | PCI_EXP_LNKSTA_DLLLA)) ==
 	    PCI_EXP_LNKSTA_LBMS) {
+		u16 oldlnkctl2 = lnkctl2;
+
 		pci_info(dev, "broken device, retraining non-functional downstream link at 2.5GT/s\n");
 
 		lnkctl2 &= ~PCI_EXP_LNKCTL2_TLS;
@@ -100,6 +106,9 @@ bool pcie_failed_link_retrain(struct pci
 
 		if (pcie_retrain_link(dev, false)) {
 			pci_info(dev, "retraining failed\n");
+			pcie_capability_write_word(dev, PCI_EXP_LNKCTL2,
+						   oldlnkctl2);
+			pcie_retrain_link(dev, true);
 			return false;
 		}
 


