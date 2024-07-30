Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715D0184549;
	Tue, 30 Jul 2024 16:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358644; cv=none; b=rkOO8gB+zA2LBEPIG1Y3mgdBhvlhdK33tWtAikfp+UO4B0mW3Yf+6Hbv/KoX92GwDLZ9lWBxmxasTsErdrLc4yfN3e03MMb4r3FAdpp+htoKAlkdrgIDoVun+ltJNobvgE+2pbdlJwOy4huFAeXevbzkbpHet4NptoETl7xNwqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358644; c=relaxed/simple;
	bh=M0kQz9lXD53w/6kblduJ/9lbAiPpPXEkl+0Lv/Ar8oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rkFrwVQGOXQLvymxisPcLN5DDWgSJ4tvosInTpKeMKCq0lnK28OebC4jtZewhSAX6Z/ILXpfhv2uqGVANOJoew2NQkpVt6zlq6jz2SsxJkDtvx1Uqv9gGn0xPecKvo+EYLr2y0yPswB5oLy2IUxA0IeSi4yzZC35Ld0a0XMhgco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j0rx1SCq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j0rx1SCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF126C32782;
	Tue, 30 Jul 2024 16:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358644;
	bh=M0kQz9lXD53w/6kblduJ/9lbAiPpPXEkl+0Lv/Ar8oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j0rx1SCqoX0r27NJ+XLWrwOEdtiXDqU4TrMwl2rwd2Gl0BRF794mmNDihM976ifVJ
	 4qXEWMVVpd5HHCPjXZU31F94oc0LwLDfN7JrNzrgyukN0sjtb3xmXeYovDt0gO2VUP
	 UTZpE/dz/WBdrr9+wksMkSMuIRDRfroHOEZ+HJNs=
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
Subject: [PATCH 6.10 381/809] PCI: endpoint: pci-epf-test: Make use of cached epc_features in pci_epf_test_core_init()
Date: Tue, 30 Jul 2024 17:44:17 +0200
Message-ID: <20240730151739.714794750@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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
index 977fb79c15677..546d2a27955cf 100644
--- a/drivers/pci/endpoint/functions/pci-epf-test.c
+++ b/drivers/pci/endpoint/functions/pci-epf-test.c
@@ -735,20 +735,12 @@ static int pci_epf_test_core_init(struct pci_epf *epf)
 {
 	struct pci_epf_test *epf_test = epf_get_drvdata(epf);
 	struct pci_epf_header *header = epf->header;
-	const struct pci_epc_features *epc_features;
+	const struct pci_epc_features *epc_features = epf_test->epc_features;
 	struct pci_epc *epc = epf->epc;
 	struct device *dev = &epf->dev;
 	bool linkup_notifier = false;
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
@@ -761,7 +753,7 @@ static int pci_epf_test_core_init(struct pci_epf *epf)
 	if (ret)
 		return ret;
 
-	if (msi_capable) {
+	if (epc_features->msi_capable) {
 		ret = pci_epc_set_msi(epc, epf->func_no, epf->vfunc_no,
 				      epf->msi_interrupts);
 		if (ret) {
@@ -770,7 +762,7 @@ static int pci_epf_test_core_init(struct pci_epf *epf)
 		}
 	}
 
-	if (msix_capable) {
+	if (epc_features->msix_capable) {
 		ret = pci_epc_set_msix(epc, epf->func_no, epf->vfunc_no,
 				       epf->msix_interrupts,
 				       epf_test->test_reg_bar,
-- 
2.43.0



