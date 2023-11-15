Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66873A8CC
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eed5JkPQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70639C433C8;
	Wed, 15 Nov 2023 19:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077626;
	bh=Xo7gYG5PgFzZOnagYhIE1TIfEz5dHGJSeZrO2k14bIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eed5JkPQFctX5SLGpEKMGXt+Jz8/NQI72mewoFV6i6dzyx88byHzNwhMOkemIaJfz
	 e3cWux6WzgAx2lM633vXCWlLh4hFBqCK8PYiSkgFTqmo+Ncjb4BAREBiYsxuk24Mqk
	 Z0SthKrqXu4f9V93fCQxoBOGDEuLg9ItBXR9HWrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 397/603] PCI: endpoint: Fix double free in __pci_epc_create()
Date: Wed, 15 Nov 2023 14:15:42 -0500
Message-ID: <20231115191640.545615035@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit c9501d268944d6c0475ecb3e740a084a7da9cbfe ]

The pci_epc_release() function frees "epc" so the kfree() on the next line
is a double free.  Drop the redundant free.

Fixes: 7711cbb4862a ("PCI: endpoint: Fix WARN() when an endpoint driver is removed")
Link: https://lore.kernel.org/r/2ce68694-87a7-4c06-b8a4-9870c891b580@moroto.mountain
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/pci-epc-core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/pci/endpoint/pci-epc-core.c b/drivers/pci/endpoint/pci-epc-core.c
index 5a4a8b0be6262..a7d3a92391a41 100644
--- a/drivers/pci/endpoint/pci-epc-core.c
+++ b/drivers/pci/endpoint/pci-epc-core.c
@@ -869,7 +869,6 @@ __pci_epc_create(struct device *dev, const struct pci_epc_ops *ops,
 
 put_dev:
 	put_device(&epc->dev);
-	kfree(epc);
 
 err_ret:
 	return ERR_PTR(ret);
-- 
2.42.0



