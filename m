Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C865418DB2A;
	Wed, 25 Feb 2026 01:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983181; cv=none; b=U4rhKfSOeDsZOnR7gs2a4Crn8eJw9QJHTZT7D+XltJ5EZpMhlwJNN+YbJxPsXJe9OGTdiXcGibDKmCFFTbcZ+w6kJRoW59aQivuT/MwSwWQa2JvtLfTmdgIz4L887CSj0jLhQb7zvhG0fKq46Zg3odgIYhWFXP3vepVV6PrcPGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983181; c=relaxed/simple;
	bh=mFtOEng3jWATbqOQFSC7oUOoSohbokHrvFirk+5DgBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UfTIh0TqknwxevX2h8Y45H03z1FaeqTmhOdhBzwCs0xUQWjIKWomEJt0IaAWJkgDJXveaiu2jb88Bi/f+eMLosMZMbSlrNNe2Q5WZUbB5P15hb+UstoF/7y3iGZZ+5oD7K1+cLp4j7xsdn/SGyYvQkl6oH7V44tAFDy2V3uIW2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qkFqvbsm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qkFqvbsm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90AC8C116D0;
	Wed, 25 Feb 2026 01:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983181;
	bh=mFtOEng3jWATbqOQFSC7oUOoSohbokHrvFirk+5DgBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qkFqvbsmMSs4tyE4CygyVNZPi88yXMMhGJ0ohHgLr2sTopLASUQPHtrQNexi6+b4X
	 jdRUUGxL6lu0DahJ2MRGwcBEETYxB0TWLDiSJKWnLRJHwOE4jUBLtFS8guRcDwtNqW
	 aQ6Bl9sGwvJ/Xvdtjgtw+lZy/IQFjwCL6/21sLW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aadityarangan Shridhar Iyengar <adiyenga@cisco.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 332/781] PCI/PTM: Fix pcie_ptm_create_debugfs() memory leak
Date: Tue, 24 Feb 2026 17:17:21 -0800
Message-ID: <20260225012407.844552388@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index ed0f9691e7d16..c7c61869bc9cf 100644
--- a/drivers/pci/pcie/ptm.c
+++ b/drivers/pci/pcie/ptm.c
@@ -542,8 +542,10 @@ struct pci_ptm_debugfs *pcie_ptm_create_debugfs(struct device *dev, void *pdata,
 		return NULL;
 
 	dirname = devm_kasprintf(dev, GFP_KERNEL, "pcie_ptm_%s", dev_name(dev));
-	if (!dirname)
+	if (!dirname) {
+		kfree(ptm_debugfs);
 		return NULL;
+	}
 
 	ptm_debugfs->debugfs = debugfs_create_dir(dirname, NULL);
 	ptm_debugfs->pdata = pdata;
@@ -574,6 +576,7 @@ void pcie_ptm_destroy_debugfs(struct pci_ptm_debugfs *ptm_debugfs)
 
 	mutex_destroy(&ptm_debugfs->lock);
 	debugfs_remove_recursive(ptm_debugfs->debugfs);
+	kfree(ptm_debugfs);
 }
 EXPORT_SYMBOL_GPL(pcie_ptm_destroy_debugfs);
 #endif
-- 
2.51.0



