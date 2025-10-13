Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D463530FC2A;
	Mon, 13 Oct 2025 15:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369731; cv=none; b=k/F51JtPgwV1dVv2sfBmWNxpFxIryvotVgszYOQdrxwA4MW9a/qOs0aRuE1SB0KWLgyhQwcW3i9URhGwsf9S+5ESfWiQ0rLQBAsbk/xUD9+6hMj2y1CMLelRmmzdjUvSWy4/DBC6rDCV4bximB4Lrh5khwrL1oEa8XkzXJpzmDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369731; c=relaxed/simple;
	bh=FYJQYpK8RGK/FJibNslU53VOCvl10D1ZqkDl4uPzQOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GGwd2GJ4x2dtUqEZFdWBoFNQnbAUuZ52d8XP6aMBfguq7qmI+xz36MEVdcIzOg+BEi5a94+f0IbFh8INNXNkyeBmgZSuWAD5hvREgqMu7MsylebNDk56FYh8po+9raXGRjH0Kgc6rNONE+J6X58A42YEr6D+guj0W4sJR067sSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dlh8wGtY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dlh8wGtY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC1EC4CEE7;
	Mon, 13 Oct 2025 15:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369731;
	bh=FYJQYpK8RGK/FJibNslU53VOCvl10D1ZqkDl4uPzQOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dlh8wGtYpL8ZnM2eq8BZkKbBbKYbp4kkM758DlmSmSXWmnWcTBHigfxrOIJNN+mjH
	 Ydu0oF2Pff5cAIOIVIrjRsoCm2I8e0uDjD3/wQROr7mqVbPqpzKLVTDh25PKdIF2In
	 xGTJbMZTvRzlMbS+/duBvH4u2imHhL+ZalgUpzws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 350/563] PCI: endpoint: pci-epf-test: Fix doorbell test support
Date: Mon, 13 Oct 2025 16:43:31 +0200
Message-ID: <20251013144423.949373549@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit f272210b28d050df56ec7dfaecb9fa3bebca6419 ]

The doorbell feature temporarily overrides the inbound translation to point
to the address stored in epf_test->db_bar.phys_addr, i.e., it calls
set_bar() twice without ever calling clear_bar(), as calling clear_bar()
would clear the BAR's PCI address assigned by the host.

Thus, when disabling the doorbell, restore the inbound translation to point
to the memory allocated for the BAR.

Without this, running the PCI endpoint kselftest doorbell test case more
than once would fail.

Fixes: eff0c286aa91 ("PCI: endpoint: pci-epf-test: Add doorbell test support")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20250908161942.534799-2-cassel@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-test.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-test.c b/drivers/pci/endpoint/functions/pci-epf-test.c
index e091193bd8a8a..2a85d3eda92f0 100644
--- a/drivers/pci/endpoint/functions/pci-epf-test.c
+++ b/drivers/pci/endpoint/functions/pci-epf-test.c
@@ -772,12 +772,24 @@ static void pci_epf_test_disable_doorbell(struct pci_epf_test *epf_test,
 	u32 status = le32_to_cpu(reg->status);
 	struct pci_epf *epf = epf_test->epf;
 	struct pci_epc *epc = epf->epc;
+	int ret;
 
 	if (bar < BAR_0)
 		goto set_status_err;
 
 	pci_epf_test_doorbell_cleanup(epf_test);
-	pci_epc_clear_bar(epc, epf->func_no, epf->vfunc_no, &epf_test->db_bar);
+
+	/*
+	 * The doorbell feature temporarily overrides the inbound translation
+	 * to point to the address stored in epf_test->db_bar.phys_addr, i.e.,
+	 * it calls set_bar() twice without ever calling clear_bar(), as
+	 * calling clear_bar() would clear the BAR's PCI address assigned by
+	 * the host. Thus, when disabling the doorbell, restore the inbound
+	 * translation to point to the memory allocated for the BAR.
+	 */
+	ret = pci_epc_set_bar(epc, epf->func_no, epf->vfunc_no, &epf->bar[bar]);
+	if (ret)
+		goto set_status_err;
 
 	status |= STATUS_DOORBELL_DISABLE_SUCCESS;
 	reg->status = cpu_to_le32(status);
-- 
2.51.0



