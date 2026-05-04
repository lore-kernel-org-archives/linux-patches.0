Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634821A6827;
	Mon,  4 May 2026 14:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904455; cv=none; b=ie7GMhRgEZDEdXpeiHB9vp/eoBZkblEMsrQ4xk04wVETsHEqKtQcaywd0FSaePX6f6DuXZ6qS9b8tJJH6yZJkFNab2PU55YDeyB5dNXDCEkgDbkLvC4TVEXkQnyLd1zDYy8dteAAjXyXTbXX21NSwhQjxOorebNkhWCVFvJM2nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904455; c=relaxed/simple;
	bh=Nlyi+REnVKECDy1Et6VIDmQDnqY4o22J1ufYCruoi4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KjvzRdFcNT7+HxsQGDTsB+WhfqRL13Ku9Vluph0yDLbQJTfJCoPEphTqT0UFNHq6BCAVbGVRHKvXB4dco6bx9Xhme+SDAHXhtQAhKrwkadTFV1BT1Yb9sm2h9ERFG3X8MRvlmSHadan9ZJ0c03iROGAFzGE++yy0xPpwtagJhzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l7g238TN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l7g238TN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC876C2BCC4;
	Mon,  4 May 2026 14:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904455;
	bh=Nlyi+REnVKECDy1Et6VIDmQDnqY4o22J1ufYCruoi4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l7g238TNlDMpRK1XPv39G0O1zniVr8ffJhPY9oaJ63tMZwcY5RrN0kxhPxDcpjuUK
	 cPznHgpwPM60K4ZM156MsNcJrA583IA4SCBdvzR0ij0DQ1GNgE+Yoy0e/smc/ETJ9y
	 kiy6E5v73G1QONPpYhBKddl4Wrn1SvVBrzdCPKQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 6.12 046/215] PCI: endpoint: pci-epf-ntb: Remove duplicate resource teardown
Date: Mon,  4 May 2026 15:51:05 +0200
Message-ID: <20260504135131.862575947@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <den@valinux.co.jp>

commit 3446beddba450c8d6f9aca2f028712ac527fead3 upstream.

epf_ntb_epc_destroy() duplicates the teardown that the caller is
supposed to do later. This leads to an oops when .allow_link fails or
when .drop_link is performed. Remove the helper.

Also drop pci_epc_put(). EPC device refcounting is tied to configfs EPC
group lifetime, and pci_epc_put() in the .drop_link path is sufficient.

Fixes: 8b821cf76150 ("PCI: endpoint: Add EP function driver to provide NTB functionality")
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260226084142.2226875-3-den@valinux.co.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/endpoint/functions/pci-epf-ntb.c |   56 ---------------------------
 1 file changed, 2 insertions(+), 54 deletions(-)

--- a/drivers/pci/endpoint/functions/pci-epf-ntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-ntb.c
@@ -1495,47 +1495,6 @@ err_alloc_peer_mem:
 }
 
 /**
- * epf_ntb_epc_destroy_interface() - Cleanup NTB EPC interface
- * @ntb: NTB device that facilitates communication between HOST1 and HOST2
- * @type: PRIMARY interface or SECONDARY interface
- *
- * Unbind NTB function device from EPC and relinquish reference to pci_epc
- * for each of the interface.
- */
-static void epf_ntb_epc_destroy_interface(struct epf_ntb *ntb,
-					  enum pci_epc_interface_type type)
-{
-	struct epf_ntb_epc *ntb_epc;
-	struct pci_epc *epc;
-	struct pci_epf *epf;
-
-	if (type < 0)
-		return;
-
-	epf = ntb->epf;
-	ntb_epc = ntb->epc[type];
-	if (!ntb_epc)
-		return;
-	epc = ntb_epc->epc;
-	pci_epc_remove_epf(epc, epf, type);
-	pci_epc_put(epc);
-}
-
-/**
- * epf_ntb_epc_destroy() - Cleanup NTB EPC interface
- * @ntb: NTB device that facilitates communication between HOST1 and HOST2
- *
- * Wrapper for epf_ntb_epc_destroy_interface() to cleanup all the NTB interfaces
- */
-static void epf_ntb_epc_destroy(struct epf_ntb *ntb)
-{
-	enum pci_epc_interface_type type;
-
-	for (type = PRIMARY_INTERFACE; type <= SECONDARY_INTERFACE; type++)
-		epf_ntb_epc_destroy_interface(ntb, type);
-}
-
-/**
  * epf_ntb_epc_create_interface() - Create and initialize NTB EPC interface
  * @ntb: NTB device that facilitates communication between HOST1 and HOST2
  * @epc: struct pci_epc to which a particular NTB interface should be associated
@@ -1614,15 +1573,8 @@ static int epf_ntb_epc_create(struct epf
 
 	ret = epf_ntb_epc_create_interface(ntb, epf->sec_epc,
 					   SECONDARY_INTERFACE);
-	if (ret) {
+	if (ret)
 		dev_err(dev, "SECONDARY intf: Fail to create NTB EPC\n");
-		goto err_epc_create;
-	}
-
-	return 0;
-
-err_epc_create:
-	epf_ntb_epc_destroy_interface(ntb, PRIMARY_INTERFACE);
 
 	return ret;
 }
@@ -1887,7 +1839,7 @@ static int epf_ntb_bind(struct pci_epf *
 	ret = epf_ntb_init_epc_bar(ntb);
 	if (ret) {
 		dev_err(dev, "Failed to create NTB EPC\n");
-		goto err_bar_init;
+		return ret;
 	}
 
 	ret = epf_ntb_config_spad_bar_alloc_interface(ntb);
@@ -1909,9 +1861,6 @@ static int epf_ntb_bind(struct pci_epf *
 err_bar_alloc:
 	epf_ntb_config_spad_bar_free(ntb);
 
-err_bar_init:
-	epf_ntb_epc_destroy(ntb);
-
 	return ret;
 }
 
@@ -1927,7 +1876,6 @@ static void epf_ntb_unbind(struct pci_ep
 
 	epf_ntb_epc_cleanup(ntb);
 	epf_ntb_config_spad_bar_free(ntb);
-	epf_ntb_epc_destroy(ntb);
 }
 
 #define EPF_NTB_R(_name)						\


