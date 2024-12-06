Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F23545BE3;
	Fri,  6 Dec 2024 14:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496323; cv=none; b=m32EXWcGQPsJQYHMiyYRlifgKq139yHOQInqW9xTQbvKpe5ScHQVg+kCwphE4eDLmynrd0jxf9jqZGH2U1wd/6VJBEmAohZOUQXkY49cdS7TSWrnN1lvzs5yqL+73M1o2+2PImceCPySRbK1jVC3KWoQ2N4A7f5jUmJSUrpuFLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496323; c=relaxed/simple;
	bh=9t8yNb6glpZ+u97M4pCU2rrxNlmDknZhser4GwvfwoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R0sq+zGyEaMBPJOtDMxCoad+KaeMEkAxqeJnjkrK8B5XHv8TYkjkw5VRwuX08rCm3gNbNk4fq5V/66aMQYTAeeyarISeZpSDvE6Yci+4Aq0PjfwfLms9D7OAD7i9FBYZ+M8Fikwfd3OYPfS8omrC3Qq3VklfqTf0K/ompM3fmfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oj/NkW3b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oj/NkW3b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C34CC4CED1;
	Fri,  6 Dec 2024 14:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496323;
	bh=9t8yNb6glpZ+u97M4pCU2rrxNlmDknZhser4GwvfwoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oj/NkW3bOVzMwUXciUOB+G73z9jxknjk4z7o1gvufniYbTq//gJdTf12SIxDKyjXG
	 FLlOoq46XQwYpplp3kSv+AeAVdc7L5SvyUbbbFtLWoOviBDu+r/WB1cWgE9U9wiRY4
	 h1ckcP6B4UvNkSEff6o7HVGSBh94M6ncciObjxxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Subject: [PATCH 6.12 087/146] PCI: endpoint: Clear secondary (not primary) EPC in pci_epc_remove_epf()
Date: Fri,  6 Dec 2024 15:36:58 +0100
Message-ID: <20241206143531.007183201@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -660,18 +660,18 @@ void pci_epc_remove_epf(struct pci_epc *
 	if (IS_ERR_OR_NULL(epc) || !epf)
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


