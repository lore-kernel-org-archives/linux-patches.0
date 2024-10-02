Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CBD01D1E65;
	Wed,  2 Oct 2024 14:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880252; cv=none; b=uPjaHPL0Z6HAk3ZIl8lmcxJk9IXIwMlzUBDZufslcPeb82+DOoMpkBCCSoNxwazFFdLtS6997yZjXnUuPLMuQTfq0PCeSiuVwg0QsMq4P2rzjyphHKP7/W5QAMUSiCD4vcaAbnsWFzy19chgMwBpMnOHSoB8nvtygZ20CjbNTPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880252; c=relaxed/simple;
	bh=TTQepycjUsVn10h9nIOSpJScldsJVLzryPGPnpWyZmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h+3kiYmOt2iYoqjmPY0aMMjT4FZT0Hqvk5gf4CHcBiX0mB4lDii1wt7DKIsiOrENjflKq/4A+y+vgClvZ2Cnf6qv5umeRCpjjV74imzCSmxTVmcSOJY97z3YINB9+qEpBGG5pGCRMpZYmo1//4V+yL9PPvBROM6IYSdgrJHG7ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vVys0SKX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vVys0SKX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D86A9C4CEC2;
	Wed,  2 Oct 2024 14:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880252;
	bh=TTQepycjUsVn10h9nIOSpJScldsJVLzryPGPnpWyZmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vVys0SKX/uoROFRA2TAhE8sXbJQeG5aqoDYFXMQAh33uVgRzXbeYYUBxzZ+TGKie+
	 Q4qK9BEXb3BfVPlB82nf+tg86b23myAzVmNPk8Q14od42k4U/mAhk9O7TzU6JGwfAE
	 tEGnVn8AMHwnkLlj8WNcb45WngkgFbcZR89qgiKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew W Carlis <mattc@purestorage.com>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Subject: [PATCH 6.6 394/538] PCI: Clear the LBMS bit after a link retrain
Date: Wed,  2 Oct 2024 15:00:33 +0200
Message-ID: <20241002125807.986277653@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit 8037ac08c2bbb3186f83a5a924f52d1048dbaec5 upstream.

The LBMS bit, where implemented, is set by hardware either in response
to the completion of retraining caused by writing 1 to the Retrain Link
bit or whenever hardware has changed the link speed or width in attempt
to correct unreliable link operation.  It is never cleared by hardware
other than by software writing 1 to the bit position in the Link Status
register and we never do such a write.

We currently have two places, namely apply_bad_link_workaround() and
pcie_failed_link_retrain() in drivers/pci/controller/dwc/pcie-tegra194.c
and drivers/pci/quirks.c respectively where we check the state of the LBMS
bit and neither is interested in the state of the bit resulting from the
completion of retraining, both check for a link fault.

And in particular pcie_failed_link_retrain() causes issues consequently, by
trying to retrain a link where there's no downstream device anymore and the
state of 1 in the LBMS bit has been retained from when there was a device
downstream that has since been removed.

Clear the LBMS bit then at the conclusion of pcie_retrain_link(), so that
we have a single place that controls it and that our code can track link
speed or width changes resulting from unreliable link operation.

Fixes: a89c82249c37 ("PCI: Work around PCIe link training failures")
Link: https://lore.kernel.org/r/alpine.DEB.2.21.2408091133140.61955@angie.orcam.me.uk
Reported-by: Matthew W Carlis <mattc@purestorage.com>
Link: https://lore.kernel.org/r/20240806000659.30859-1-mattc@purestorage.com/
Link: https://lore.kernel.org/r/20240722193407.23255-1-mattc@purestorage.com/
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Cc: <stable@vger.kernel.org> # v6.5+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5017,7 +5017,15 @@ int pcie_retrain_link(struct pci_dev *pd
 		pcie_capability_clear_word(pdev, PCI_EXP_LNKCTL, PCI_EXP_LNKCTL_RL);
 	}
 
-	return pcie_wait_for_link_status(pdev, use_lt, !use_lt);
+	rc = pcie_wait_for_link_status(pdev, use_lt, !use_lt);
+
+	/*
+	 * Clear LBMS after a manual retrain so that the bit can be used
+	 * to track link speed or width changes made by hardware itself
+	 * in attempt to correct unreliable link operation.
+	 */
+	pcie_capability_write_word(pdev, PCI_EXP_LNKSTA, PCI_EXP_LNKSTA_LBMS);
+	return rc;
 }
 
 /**


