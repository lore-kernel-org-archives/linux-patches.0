Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C50385D7B;
	Sat, 17 Oct 2026 17:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258194; cv=none; b=cWHtNfT0rwkHt3rjQI1/vUcaZnXhQNKXVFuPbxdcRaUzh2r5nhrjOOPNBSYokhhKm8U+1DUdiADnnhaDAVTKB8sFMj7g+U8A0SevAeHYlAQ43HfTVFHf0espGLTdPLpIvMWZGigRF8fGbpEcQFshVrMQbYpvqvDGG0CIU0NhPtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258194; c=relaxed/simple;
	bh=IluWR79RPloSPDgY7zqC+XA9HPBgtAIkoxFfBZRc29g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iNXD7pd1tdQT/hf6ScN91pzqu5TTGOqxdfU29YPu086QRxk/dkgx3ZHTNHQawS5RPiT8jQ8ogiT7xgifF9U15CzfZ4szIUHvRgugT4ZmZiYKH4Carl84t9rVqHMtFpSNGsK7ahoSl1Gu/nmi6Q8lkk6wqzTRLQPrVcI5uANGQdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LtGEzDN3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LtGEzDN3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BC401F000C4;
	Sat, 17 Oct 2026 17:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258193;
	bh=Sx+6bDt2FylF8WL9XjMxC+0lF78+SBr7qrsfvQrOJao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LtGEzDN3FsRoTvsnsDxNhJBMIc+ZNC6Dudk9wuhPX6hbN7wRJQrUNnzGZgSYmhwt7
	 APu2durf5PE9dM2vAG3qljYEMGIgnzDjqgra4GFQkQxe1/NRIjFLVaAiwdISpaEE+m
	 MeASfWa89A+Oo7mlhUGy7P3MoaJaerAnmUDScw/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Christian Bruel <christian.bruel@foss.st.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0750/1674] PCI: endpoint: pci-epf-test: Fix double free that causes kernel to oops
Date: Sat, 17 Oct 2026 17:50:22 +0200
Message-ID: <20261017160450.355961307@linuxfoundation.org>
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

From: Christian Bruel <christian.bruel@foss.st.com>

[ Upstream commit 934e9d137d937706004c325fa1474f9e3f1ba10a ]

Fix a kernel oops found while testing the stm32_pcie Endpoint driver
with handling of PERST# deassertion:

During EP initialization, pci_epf_test_alloc_space() allocates all BARs,
which are further freed if epc_set_bar() fails (for instance, due to no
free inbound window).

However, when pci_epc_set_bar() fails, the error path:

  pci_epc_set_bar() ->
    pci_epf_free_space()

does not clear the previous assignment to epf_test->reg[bar].

Then, if the host reboots, the PERST# deassertion restarts the BAR
allocation sequence with the same allocation failure (no free inbound
window), creating a double free situation since epf_test->reg[bar] was
deallocated and is still non-NULL.

Thus, make sure that pci_epf_alloc_space() and pci_epf_free_space()
invocations are symmetric, and as such, set epf_test->reg[bar] to NULL
when memory is freed.

Reviewed-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Christian Bruel <christian.bruel@foss.st.com>
Link: https://lore.kernel.org/r/20250124123043.96112-1-christian.bruel@foss.st.com
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-test.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/endpoint/functions/pci-epf-test.c b/drivers/pci/endpoint/functions/pci-epf-test.c
index 97c2ccdc6ad76..cf6e00802b53a 100644
--- a/drivers/pci/endpoint/functions/pci-epf-test.c
+++ b/drivers/pci/endpoint/functions/pci-epf-test.c
@@ -706,6 +706,7 @@ static void pci_epf_test_unbind(struct pci_epf *epf)
 					  epf_bar);
 			pci_epf_free_space(epf, epf_test->reg[bar], bar,
 					   PRIMARY_INTERFACE);
+			epf_test->reg[bar] = NULL;
 		}
 	}
 }
@@ -740,6 +741,7 @@ static int pci_epf_test_set_bar(struct pci_epf *epf)
 		if (ret) {
 			pci_epf_free_space(epf, epf_test->reg[bar], bar,
 					   PRIMARY_INTERFACE);
+			epf_test->reg[bar] = NULL;
 			dev_err(dev, "Failed to set BAR%d\n", bar);
 			if (bar == test_reg_bar)
 				return ret;
-- 
2.53.0



