Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BB1397339;
	Sat, 17 Oct 2026 17:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257670; cv=none; b=callA1r992iJdCfuNZb6SA6wVd/QxMnuHXTrKOK+DRoUoWXpzqswxybwWg5QRfGpKXtpCfbjnnfuNZ4Ii7NuviAgXp+PtAJi/sve+RZKIheShR7IOiAW40EKPQEowVNbbMb94upo/jjuNNCSCYcgF5Zvx179x6RKx2fHE9PX9Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257670; c=relaxed/simple;
	bh=hFooGJtAOKRRhMKmMfblv3zfRieobp1HlldYzsiLajY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gPeMUEmC8aOyCFLEg8TZQ20itdecGTvwhhEfmA2cVVmop9PBgjkIkCqkGyzawsn7F48Gb2Jb5TyX8cs5llTHLsc1zZRlxDClAwvQQQT5b2NWxuf4/RpPHvSpbyr2am3MYGvdkc3TN+7yf+i8UK/P2qxr/EJgvyTF/fDtXjQO2v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CLPMIEnK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CLPMIEnK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB6CF1F000C4;
	Sat, 17 Oct 2026 17:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257669;
	bh=7uRsC1VBoRKt/9qoro1mHxtxW1aVKhGIdQTSKGell0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CLPMIEnKggqV/IfG+bw4wPRZITdZMfjvGSp8C2ihM/Vki7uNjWNiqLq6g/ZbzLfF+
	 E+av0kVNFjmyzpQ8xJ9ctK3kw79PPPA6UNTvDifDSGhX8q20tMFTUfLgdH7HGh+qh4
	 lPrKrS8K1nv8L/ElJg+ZwpZga/BsZQ7nf4cQbgHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Frank Li <Frank.Li@nxp.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0633/1674] PCI: endpoint: pci-epf-test: Make use of cached epc_features in pci_epf_test_core_init()
Date: Sat, 17 Oct 2026 17:48:25 +0200
Message-ID: <20261017160447.342446100@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 5a5095a8bd1bd349cce1c879e5e44407a34dda8a ]

Instead of getting the epc_features from pci_epc_get_features() API, use
the cached pci_epf_test::epc_features value to avoid the NULL check. Since
the NULL check is already performed in pci_epf_test_bind(), having one more
check in pci_epf_test_core_init() is redundant and it is not possible to
hit the NULL pointer dereference.

Also with commit a01e7214bef9 ("PCI: endpoint: Remove "core_init_notifier"
flag"), 'epc_features' got dereferenced without the NULL check, leading to
the following false positive Smatch warning:

  drivers/pci/endpoint/functions/pci-epf-test.c:784 pci_epf_test_core_init() error: we previously assumed 'epc_features' could be null (see line 747)

Thus, remove the redundant NULL check and also use the epc_features::
{msix_capable/msi_capable} flags directly to avoid local variables.

[kwilczynski: commit log]
Fixes: 5e50ee27d4a5 ("PCI: pci-epf-test: Add support to defer core initialization")
Closes: https://lore.kernel.org/linux-pci/024b5826-7180-4076-ae08-57d2584cca3f@moroto.mountain
Link: https://lore.kernel.org/linux-pci/20240418-pci-epf-test-fix-v2-1-eacd54831444@linaro.org
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-test.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-test.c b/drivers/pci/endpoint/functions/pci-epf-test.c
index 4cf20ca25ea74..97c2ccdc6ad76 100644
--- a/drivers/pci/endpoint/functions/pci-epf-test.c
+++ b/drivers/pci/endpoint/functions/pci-epf-test.c
@@ -753,19 +753,11 @@ static int pci_epf_test_core_init(struct pci_epf *epf)
 {
 	struct pci_epf_test *epf_test = epf_get_drvdata(epf);
 	struct pci_epf_header *header = epf->header;
-	const struct pci_epc_features *epc_features;
+	const struct pci_epc_features *epc_features = epf_test->epc_features;
 	struct pci_epc *epc = epf->epc;
 	struct device *dev = &epf->dev;
-	bool msix_capable = false;
-	bool msi_capable = true;
 	int ret;
 
-	epc_features = pci_epc_get_features(epc, epf->func_no, epf->vfunc_no);
-	if (epc_features) {
-		msix_capable = epc_features->msix_capable;
-		msi_capable = epc_features->msi_capable;
-	}
-
 	if (epf->vfunc_no <= 1) {
 		ret = pci_epc_write_header(epc, epf->func_no, epf->vfunc_no, header);
 		if (ret) {
@@ -778,7 +770,7 @@ static int pci_epf_test_core_init(struct pci_epf *epf)
 	if (ret)
 		return ret;
 
-	if (msi_capable) {
+	if (epc_features->msi_capable) {
 		ret = pci_epc_set_msi(epc, epf->func_no, epf->vfunc_no,
 				      epf->msi_interrupts);
 		if (ret) {
@@ -787,7 +779,7 @@ static int pci_epf_test_core_init(struct pci_epf *epf)
 		}
 	}
 
-	if (msix_capable) {
+	if (epc_features->msix_capable) {
 		ret = pci_epc_set_msix(epc, epf->func_no, epf->vfunc_no,
 				       epf->msix_interrupts,
 				       epf_test->test_reg_bar,
-- 
2.53.0



