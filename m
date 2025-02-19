Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929FC1C5F0C;
	Wed, 19 Feb 2025 09:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956471; cv=none; b=RgU25zZoMT3E2v00Yccf8HOI8oK8j+2OzwhCzKzUKHui+63LHHRkRt+SKRHOjQPqCcHpRG8NaR+LzZnzRT8RGmENYobBjASbjbi32DmGL09ZhAFl2BY5fQhS6C1vdJSTbk85CDD7kz5IVBcHCaRQeHkLwMg8s0h+ncqWuFGGBRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956471; c=relaxed/simple;
	bh=SVPYBhM8sKLgbXjgwJPQHddxEpj8nMa1pZj2FPQv9f8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfnJs2Ktk0oouax3yPrzBUzCrgUUbu0kXRliz472xdFwKaHYYSK0KOMBBRwaghVtzcckQNOxm5h9e/kErlAs1jrf8OkhqWdhfKhnNiFzISFCUn0pSCtVnytuwBMx9BrYWgwxQfvndB8gLwe3momMz1tIe8hOmo5M/3+xMPBXM8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EgwcbRG6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EgwcbRG6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC3BC4CED1;
	Wed, 19 Feb 2025 09:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956471;
	bh=SVPYBhM8sKLgbXjgwJPQHddxEpj8nMa1pZj2FPQv9f8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EgwcbRG65nDiD2YOJIFurMzHcns3oXaR3dUYNCh9Uuhf9Dgyhoz1ehJoop6iEsCFa
	 4gKG64ncZofDS78HXQSh174/TEI5BzpQ4TlEzyd7Ufkeet6u/Yw2xuHP95H5DdsYME
	 mlu0ivIfE2a0KnoCm8ZbR1rzZMlKVBES6JBmNZ5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 190/578] PCI: endpoint: Destroy the EPC device in devm_pci_epc_destroy()
Date: Wed, 19 Feb 2025 09:23:14 +0100
Message-ID: <20250219082700.439791710@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit d4929755e4d02bd3de3ae5569dab69cb9502c54f ]

The devm_pci_epc_destroy() comment says destroys the EPC device, but it
does not actually do that since devres_destroy() does not call
devm_pci_epc_release(), and it also can not fully undo what the API
devm_pci_epc_create() does, so it is faulty.

Fortunately, the faulty API has not been used by current kernel tree.  Use
devres_release() instead of devres_destroy() so the EPC device will be
released.

Link: https://lore.kernel.org/r/20241210-pci-epc-core_fix-v3-1-4d86dd573e4b@quicinc.com
Fixes: 5e8cb4033807 ("PCI: endpoint: Add EP core layer to enable EP controller and EP functions")
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/pci-epc-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/endpoint/pci-epc-core.c b/drivers/pci/endpoint/pci-epc-core.c
index f5a5ec80d1943..eb502426ea6c0 100644
--- a/drivers/pci/endpoint/pci-epc-core.c
+++ b/drivers/pci/endpoint/pci-epc-core.c
@@ -740,7 +740,7 @@ void devm_pci_epc_destroy(struct device *dev, struct pci_epc *epc)
 {
 	int r;
 
-	r = devres_destroy(dev, devm_pci_epc_release, devm_pci_epc_match,
+	r = devres_release(dev, devm_pci_epc_release, devm_pci_epc_match,
 			   epc);
 	dev_WARN_ONCE(dev, r, "couldn't find PCI EPC resource\n");
 }
-- 
2.39.5



