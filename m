Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5914F149C51;
	Fri,  6 Dec 2024 15:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498651; cv=none; b=T9g8xOEorHHQwCpJIpDJYByZV+X5ar58QJn4GfVLSk+vbj73QM+fy85f+GVgjNLZE/gLTxrV022BaZQr/TOy3bwctZ8XOgsL3aVjUolylK3HhGpselsdz9dLWL6DrUtck28qI5X94Axkv3uQT7kvFKGdkaff/CQL3ZeBLw/SsEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498651; c=relaxed/simple;
	bh=EDzYtfUiCyBaIimkHKTMpMsjsbJYw99W5XkZo5Hfgho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cNQEcRdtXij4EN7cOJaqH+N55njwuuvJlHEQ76X4VK05A+JWjwdm/dWe5vtEb6tnFdctkzqT3prkhRz4EwR/uEHFytB24uK8waphxpAYgNmeKqkYz9iiptMYGKLrwZZBistpvGvuXuS2lb92u8tG9KJYTBfH3kX60A8FwQhFSoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZtDn7XMp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZtDn7XMp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A52C4CED1;
	Fri,  6 Dec 2024 15:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498651;
	bh=EDzYtfUiCyBaIimkHKTMpMsjsbJYw99W5XkZo5Hfgho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZtDn7XMplmCMJeM+dFnpQFaJrH6j6GvQvL/+6h9og696/nW4czg9jOnXRi3xn6yFt
	 EjBiJKWSBsqTYLmQqNe+UdOvyTcFkN28rjnVIHJFQPd0Y0nHpaDbsbwEk64PAy3ROn
	 bdcaeHxW4/CvUHWiS3tCBV1JRAUNB/7jo6nIrmJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Subject: [PATCH 6.6 647/676] PCI: endpoint: Clear secondary (not primary) EPC in pci_epc_remove_epf()
Date: Fri,  6 Dec 2024 15:37:46 +0100
Message-ID: <20241206143718.639648666@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit 688d2eb4c6fcfdcdaed0592f9df9196573ff5ce2 upstream.

In addition to a primary endpoint controller, an endpoint function may be
associated with a secondary endpoint controller, epf->sec_epc, to provide
NTB (non-transparent bridge) functionality.

Previously, pci_epc_remove_epf() incorrectly cleared epf->epc instead of
epf->sec_epc when removing from the secondary endpoint controller.

Extend the epc->list_lock coverage and clear either epf->epc or
epf->sec_epc as indicated.

Link: https://lore.kernel.org/r/20241107-epc_rfc-v2-2-da5b6a99a66f@quicinc.com
Fixes: 63840ff53223 ("PCI: endpoint: Add support to associate secondary EPC with EPF")
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
[mani: reworded subject and description]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/endpoint/pci-epc-core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/pci/endpoint/pci-epc-core.c
+++ b/drivers/pci/endpoint/pci-epc-core.c
@@ -663,18 +663,18 @@ void pci_epc_remove_epf(struct pci_epc *
 	if (!epc || IS_ERR(epc) || !epf)
 		return;
 
+	mutex_lock(&epc->list_lock);
 	if (type == PRIMARY_INTERFACE) {
 		func_no = epf->func_no;
 		list = &epf->list;
+		epf->epc = NULL;
 	} else {
 		func_no = epf->sec_epc_func_no;
 		list = &epf->sec_epc_list;
+		epf->sec_epc = NULL;
 	}
-
-	mutex_lock(&epc->list_lock);
 	clear_bit(func_no, &epc->function_num_map);
 	list_del(list);
-	epf->epc = NULL;
 	mutex_unlock(&epc->list_lock);
 }
 EXPORT_SYMBOL_GPL(pci_epc_remove_epf);


