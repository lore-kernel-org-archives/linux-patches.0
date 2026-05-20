Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A493D6673;
	Wed, 20 May 2026 17:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297852; cv=none; b=PbzPd5MOyoYRxFUxMnh6gVC0eN3FSsk/RBUZlNZShCIzGMzmL0PGjh3zi7UW4NzDn8tMP//pJSweTFUZAQuYObCK/Fc5wAzoUjeOnDF7YlCcQD3t1R07qnj958UmOQWStWXVVIKPNIjloQqnAu4rdKnvQg67dWIpP15DLMZNhYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297852; c=relaxed/simple;
	bh=3Bx+GJ0ye3iNYjanvgJqHPl9FEQCwtEex8aQPznrTGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nGiYdoXi2l3enDZrL/yPP/mE8fQ9NxZGn60EOIHIZ5esZ/jEo3n3YN0gcU2XnRNuTwVTECL6PPvlX4uOjwdpJPd17sbDN3jqhJoIPSadlqS909GISKYNiJTVhrBATwqSQLffdelJ58YP8TXrNxLJeIfIyriGFbq/JCXm1zhCfiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zjC7DBGn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zjC7DBGn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 255E21F000E9;
	Wed, 20 May 2026 17:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297851;
	bh=dmj/sMGLe2K3MFTgFUcFqR0PC5Qa2N3WRMn8tm/NJmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zjC7DBGn/ieQv0vUoFOJFp8ZN1yiWLZ6toJmV1bpgWIHwFwPS6ZLfK8nDH8tXPGqG
	 K1Ta7tp9joqB+LLZL7wgGzdQ2+0Fm79FXSQ0xcPBgfBcKYksaLz6Ow0fvr6saUhU6y
	 eXUTcF5k1r3OTw4XGdTRkkoU17zVv/fzZ4/UOXPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Abraham P <george.abraham.p@intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 189/957] PCI/TPH: Allow TPH enable for RCiEPs
Date: Wed, 20 May 2026 18:11:12 +0200
Message-ID: <20260520162138.650960729@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: George Abraham P <george.abraham.p@intel.com>

[ Upstream commit d3e996a596967a62c8a13a279221513461f6ab97 ]

Previously, pcie_enable_tph() only enabled TLP Processing Hints (TPH) if
both the Endpoint and its Root Port advertised TPH support.

Root Complex Integrated Endpoints (RCiEPs) are directly integrated into a
Root Complex and do not have an associated Root Port, so pcie_enable_tph()
never enabled TPH for RCiEPs.

PCIe r7.0 doesn't seem to include a way to learn whether a Root Complex
supports TPH, but sec 2.2.7.1.1 says Functions that lack TPH support should
ignore TPH, and maybe the same is true for Root Complexes:

  A Function that does not support the TPH Completer or Routing capability
  and receives a transaction with the TH bit [which indicates the presence
  of TPH in the TLP header] Set is required to ignore the TH bit and handle
  the Request in the same way as Requests of the same transaction type
  without the TH bit Set.

Allow drivers to enable TPH for any RCiEP with a TPH Requester Capability.

Fixes: f69767a1ada3 ("PCI: Add TLP Processing Hints (TPH) support")
Signed-off-by: George Abraham P <george.abraham.p@intel.com>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260109052923.1170070-1-george.abraham.p@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/tph.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/tph.c b/drivers/pci/tph.c
index cc64f93709a4f..c61456d24f61b 100644
--- a/drivers/pci/tph.c
+++ b/drivers/pci/tph.c
@@ -397,10 +397,13 @@ int pcie_enable_tph(struct pci_dev *pdev, int mode)
 	else
 		pdev->tph_req_type = PCI_TPH_REQ_TPH_ONLY;
 
-	rp_req_type = get_rp_completer_type(pdev);
+	/* Check if the device is behind a Root Port */
+	if (pci_pcie_type(pdev) != PCI_EXP_TYPE_RC_END) {
+		rp_req_type = get_rp_completer_type(pdev);
 
-	/* Final req_type is the smallest value of two */
-	pdev->tph_req_type = min(pdev->tph_req_type, rp_req_type);
+		/* Final req_type is the smallest value of two */
+		pdev->tph_req_type = min(pdev->tph_req_type, rp_req_type);
+	}
 
 	if (pdev->tph_req_type == PCI_TPH_REQ_DISABLE)
 		return -EINVAL;
-- 
2.53.0



