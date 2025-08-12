Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820001EBFE0;
	Tue, 12 Aug 2025 17:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021516; cv=none; b=UONsLaFSa6o+RsxAHFDI9H2Grk0UKtf+7fs3fMTV9UrK52S4BJpS926YkCvmiKUfBhOvBC+EOu2mzKX8N9WPSQ6N+qBa5hJzvZhRQS5W30Yfi4JAZNjIplqjPwAzis1f7HmsPMhU9dGWUA4A8rXcHE58EOiDEuxgvMN2OUCAtbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021516; c=relaxed/simple;
	bh=/Q46k/7T/Pj6x/5AOMuaFftowSBQ77OThUxBu8Gx4aY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQ+QCjLNpJkINEcfdztGcRYC3NKvukp/jGMvn+WUbOBG9kKWKr6u0O4vUiD9ja3jdsYcEjRgGlvTyX//cvr8nkA3a0nV19Cyz+jguLh6GMPJaCZr2B8KyGZH9QPSQjSmlZA6F7VchpmAmv8jvnDfgkxHKsGkpFTjg9kYkNNkPGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WsHpQW11; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WsHpQW11"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A9BC4CEF1;
	Tue, 12 Aug 2025 17:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021516;
	bh=/Q46k/7T/Pj6x/5AOMuaFftowSBQ77OThUxBu8Gx4aY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WsHpQW11Q0/LxiTWgaf95KIWOfJJPxdXlqrR4+6CBAcgtdPoVAdXS4o8XWiET2vqR
	 yxlpZ8e8wI2F4uqGmL0AcgxgmAnzNWmz8nsCW/j9BybcqVkoNNs5kTOThSOVA+BFif
	 q90URw3kIIUV+sweKmFX+mmwOIcX1I8fvwfyaH54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <mani@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 145/262] PCI: endpoint: pci-epf-vntb: Fix the incorrect usage of __iomem attribute
Date: Tue, 12 Aug 2025 19:28:53 +0200
Message-ID: <20250812172959.274391303@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <mani@kernel.org>

[ Upstream commit 61ae7f8694fb4b57a8c02a1a8d2b601806afc999 ]

__iomem attribute is supposed to be used only with variables holding the
MMIO pointer. But here, 'mw_addr' variable is just holding a 'void *'
returned by pci_epf_alloc_space(). So annotating it with __iomem is clearly
wrong. Hence, drop the attribute.

This also fixes the below sparse warning:

  drivers/pci/endpoint/functions/pci-epf-vntb.c:524:17: warning: incorrect type in assignment (different address spaces)
  drivers/pci/endpoint/functions/pci-epf-vntb.c:524:17:    expected void [noderef] __iomem *mw_addr
  drivers/pci/endpoint/functions/pci-epf-vntb.c:524:17:    got void *
  drivers/pci/endpoint/functions/pci-epf-vntb.c:530:21: warning: incorrect type in assignment (different address spaces)
  drivers/pci/endpoint/functions/pci-epf-vntb.c:530:21:    expected unsigned int [usertype] *epf_db
  drivers/pci/endpoint/functions/pci-epf-vntb.c:530:21:    got void [noderef] __iomem *mw_addr
  drivers/pci/endpoint/functions/pci-epf-vntb.c:542:38: warning: incorrect type in argument 2 (different address spaces)
  drivers/pci/endpoint/functions/pci-epf-vntb.c:542:38:    expected void *addr
  drivers/pci/endpoint/functions/pci-epf-vntb.c:542:38:    got void [noderef] __iomem *mw_addr

Fixes: e35f56bb0330 ("PCI: endpoint: Support NTB transfer between RC and EP")
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20250709125022.22524-1-mani@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-vntb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-vntb.c b/drivers/pci/endpoint/functions/pci-epf-vntb.c
index 8bdd295f21cc..33c3f9b980e6 100644
--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -531,7 +531,7 @@ static int epf_ntb_db_bar_init(struct epf_ntb *ntb)
 	struct device *dev = &ntb->epf->dev;
 	int ret;
 	struct pci_epf_bar *epf_bar;
-	void __iomem *mw_addr;
+	void *mw_addr;
 	enum pci_barno barno;
 	size_t size = sizeof(u32) * ntb->db_count;
 
-- 
2.39.5



