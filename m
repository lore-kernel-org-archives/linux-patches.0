Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30A3197A76;
	Wed,  5 Feb 2025 14:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767116; cv=none; b=mb4hH+XqmhAOm9S0A19AtBijo/xAV9lWll/2PZA7qdIQA/AzreAdPL9irs0QGvoT3o9JVjsl3jjYCfx3VCjQO0pAe1UQCqZzaO2ffRgup55dr0X3+huW4mVAVsYIXD2/fIMv3/msh/7HXXxIXshCUGVevjfjxmZAuZ2mV6iP6Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767116; c=relaxed/simple;
	bh=IKX1q/bvASayUUG9JN+Wfvi7rQVoTdynRwnnzhaclJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=og7OmqjOmtEBGlBK1jFVmdISG4CRLJUoAQ8twdzDhTY7C1S7fxckSfgfpbQ6SxGzvbbD4uo2nWHB0mm/g0APx07p6ldivfpJGUaoZWtY303MRVYiSOdUe9NNBJqbYHECFbupTphYVVCQ8PRP+E/dm/D8UZjOGcbh9mG6i8exJbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1r0LQj3T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1r0LQj3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D002C4CED1;
	Wed,  5 Feb 2025 14:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767116;
	bh=IKX1q/bvASayUUG9JN+Wfvi7rQVoTdynRwnnzhaclJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1r0LQj3Tx/2k/0jjU2BpJMEpNG/Nt/Hp75mNE2DyViTY/K5aS3qmoTmKD3SE/+t6N
	 KNgq0gncMY78r2YRTPmUVHPtEtE5U70U42LekRTW4oGnpqTpxt+bTkPjLEptWbI1l8
	 PXGjzbWwYIC0TeUYZCHP8jvM8ueUUU4genZBqcws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 408/590] PCI: endpoint: Destroy the EPC device in devm_pci_epc_destroy()
Date: Wed,  5 Feb 2025 14:42:43 +0100
Message-ID: <20250205134510.876637348@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 62f7dff437309..de665342dc16d 100644
--- a/drivers/pci/endpoint/pci-epc-core.c
+++ b/drivers/pci/endpoint/pci-epc-core.c
@@ -856,7 +856,7 @@ void devm_pci_epc_destroy(struct device *dev, struct pci_epc *epc)
 {
 	int r;
 
-	r = devres_destroy(dev, devm_pci_epc_release, devm_pci_epc_match,
+	r = devres_release(dev, devm_pci_epc_release, devm_pci_epc_match,
 			   epc);
 	dev_WARN_ONCE(dev, r, "couldn't find PCI EPC resource\n");
 }
-- 
2.39.5



