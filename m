Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA58D53365;
	Thu, 12 Dec 2024 16:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020856; cv=none; b=FKDK5IatmafU5FF6xI4IH0tN9Tsc2gMNNnu/aX707MfmOEgCFPtHXQDFapkLilU9VTSfmv95ahfytgYSH8QWEnjAz7pNBF/g6rWhY/Y7lDQmkHaK3WIECG/7sc30QOcWM6it/1wH9H7hLYQHBv/dm6u4c9rNsIBmKpyiXnMuVjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020856; c=relaxed/simple;
	bh=c4Jk5FUus3JVxm+rcU3hvFLoBju1UWGYvYussgREcVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HOBHpGF6/+tem3ocjqloaAYRAmEUeA/Etz/ZziBu4kmiKe4cHdNlOZgbRvyoFeUCEt50V9c6oz+sWVB0Dew4kfzJexEhAMsOhRn6XIjuXnVNlG6z+Kn4K770sKptKb5VBDudjt1ZTAl8ifd90A7Wph7YXkadUQifbRsBOWE7hTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W9v5WQBd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W9v5WQBd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC21DC4CECE;
	Thu, 12 Dec 2024 16:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020856;
	bh=c4Jk5FUus3JVxm+rcU3hvFLoBju1UWGYvYussgREcVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W9v5WQBdFDb+kQDRL6iJALKoq1AKUnAKaANY6X7Bjuc9TzvIaqSuaHa6LzboizhzA
	 BZsWnGlYy18/aKtkT4lq9Ywm4O5v4TeFy7pK136MoGClwaoWy8CO/gY1gQY4NCD8Nz
	 hhTFXsaBq3JSAlNtWE1BvlMLuztoQGZKc0gRyqAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 578/772] PCI: endpoint: Clear secondary (not primary) EPC in pci_epc_remove_epf()
Date: Thu, 12 Dec 2024 15:58:43 +0100
Message-ID: <20241212144413.831879149@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit 688d2eb4c6fcfdcdaed0592f9df9196573ff5ce2 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/pci-epc-core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/endpoint/pci-epc-core.c b/drivers/pci/endpoint/pci-epc-core.c
index 6cce430d431b1..f5a5ec80d1943 100644
--- a/drivers/pci/endpoint/pci-epc-core.c
+++ b/drivers/pci/endpoint/pci-epc-core.c
@@ -664,18 +664,18 @@ void pci_epc_remove_epf(struct pci_epc *epc, struct pci_epf *epf,
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
-- 
2.43.0



