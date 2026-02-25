Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C888E239099;
	Wed, 25 Feb 2026 01:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983992; cv=none; b=nbFKeuszyGU4eBcp73WIBYcTbUfMUUJjx/pZSKntw3WHbK5f51/d1N7QwehBOiD7eqGRwsoWUl4mg4oVLWE6WjkCJluZ037skp5mSBLtlfp/Gzd8tq7MzrV057qMdlMFVBx8VmPjEriLfJAGyiA1bX8HVoUL5LSoHmZf7zjtqRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983992; c=relaxed/simple;
	bh=wEccGvuoyHCyv/ypeHe02letJ070K4WRwwdq7bUsR38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mh42gTMXNamTNbZJntb+zs8JJnHzHCP1wT3Eq+RxHmwzsUSdEmyeiv6tjsEDveQMeB1ruD/YTuMFh/447T0t2UHrcxZG44CS75DbQxwWIJFunm6tY1hH7wXljNyct6STdwAFEArjgCeBMrxthXjgdvVKExW7UkZGPOXZtPPUJLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UyISykAO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UyISykAO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D73C116D0;
	Wed, 25 Feb 2026 01:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983992;
	bh=wEccGvuoyHCyv/ypeHe02letJ070K4WRwwdq7bUsR38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UyISykAO4BNLFG29xer1FlbAqwXEZLTvCqJN6aXIF0EqJ7nE8LNVPBa1A6r8BWdiT
	 rtp5O4LQXnRHdHwkn+jdKKSZI3AlS90XH74nJzx1kXknY96TyWpVGe9Ztaexpr7Laz
	 R4XHlhKFpl0uh880nxtLNqrkq7siHXBybKBwR7c0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aadityarangan Shridhar Iyengar <adiyenga@cisco.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 247/641] PCI/PTM: Fix pcie_ptm_create_debugfs() memory leak
Date: Tue, 24 Feb 2026 17:19:33 -0800
Message-ID: <20260225012354.843638561@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Aadityarangan Shridhar Iyengar <adiyenga@cisco.com>

[ Upstream commit 62171369cf17794ddd88f602c2c84d008ecafcff ]

In pcie_ptm_create_debugfs(), if devm_kasprintf() fails after successfully
allocating ptm_debugfs with kzalloc(), the function returns without freeing
the allocated memory, resulting in a memory leak.

Free ptm_debugfs before returning in the devm_kasprintf() error path and in
pcie_ptm_destroy_debugfs().

Fixes: 132833405e61 ("PCI: Add debugfs support for exposing PTM context")
Signed-off-by: Aadityarangan Shridhar Iyengar <adiyenga@cisco.com>
[bhelgaas: squash additional fix from Mani:
https://lore.kernel.org/r/pdp4xc4d5ee3e547mmdro5riui3mclduqdl7j6iclfbozo2a4c@7m3qdm6yrhuv]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20260111163650.33168-1-adiyenga@cisco.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/ptm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pcie/ptm.c b/drivers/pci/pcie/ptm.c
index 65e4b008be00d..41d370f082ee4 100644
--- a/drivers/pci/pcie/ptm.c
+++ b/drivers/pci/pcie/ptm.c
@@ -519,8 +519,10 @@ struct pci_ptm_debugfs *pcie_ptm_create_debugfs(struct device *dev, void *pdata,
 		return NULL;
 
 	dirname = devm_kasprintf(dev, GFP_KERNEL, "pcie_ptm_%s", dev_name(dev));
-	if (!dirname)
+	if (!dirname) {
+		kfree(ptm_debugfs);
 		return NULL;
+	}
 
 	ptm_debugfs->debugfs = debugfs_create_dir(dirname, NULL);
 	ptm_debugfs->pdata = pdata;
@@ -551,6 +553,7 @@ void pcie_ptm_destroy_debugfs(struct pci_ptm_debugfs *ptm_debugfs)
 
 	mutex_destroy(&ptm_debugfs->lock);
 	debugfs_remove_recursive(ptm_debugfs->debugfs);
+	kfree(ptm_debugfs);
 }
 EXPORT_SYMBOL_GPL(pcie_ptm_destroy_debugfs);
 #endif
-- 
2.51.0



