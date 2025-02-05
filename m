Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699E31519BF;
	Wed,  5 Feb 2025 15:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767884; cv=none; b=S10vUl1hVIRqxZgbtiY3j9eRNSEOc6y/63Rjyj+nszZ/y+VAPFV1Hbiu1XPOrPs/4Sdi1jjnZzBQYPZAw38pbqo4MvzLGdq22b4dZqhY0iohxLsSA5Fknu5i320ilfo2QfFm9t707Yu+U4iSpiYerJUoM8yVNTpcSp/TWdZGy7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767884; c=relaxed/simple;
	bh=YAO0DKD9rG4F1ekmicqgPsgYxHDyv1M2bAgLKjsqVLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FxI+Ts8n4JZkg9qyejgfZq2R8bNzddAZCFOv0tObmhDXz7h1SU8tVw/q4PopfTmqrvRWJDU56VmBJTCd4PwertBfQ5wpdMvXpY0C/CgVWcG+L9zMJlAIz+EV/8BG6xJT6uPjYaeBR8CeepPNc1Su1RN9FOAfLuSd3Mh4ZSQ2JTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YJOcghvL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YJOcghvL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F1DC4CED1;
	Wed,  5 Feb 2025 15:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767884;
	bh=YAO0DKD9rG4F1ekmicqgPsgYxHDyv1M2bAgLKjsqVLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YJOcghvLAVqtflRa+2uJuakYI+fxgRbCBFouFPTfJ0KS1oVpSowcBouBkJbsPMEOL
	 xq0kFZM3ZcyLFGNFmpRg5MMQgodXvw8ZdKPvpYoC0KNGwQ25fgcUwt/rxLnQWp54tC
	 mcKvFd06pDgrxWL30V/L+kspMnWUZa/Wl3Gm+rEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 444/623] PCI: endpoint: Destroy the EPC device in devm_pci_epc_destroy()
Date: Wed,  5 Feb 2025 14:43:06 +0100
Message-ID: <20250205134513.203390043@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index bed7c7d1fe3c3..75c6688290034 100644
--- a/drivers/pci/endpoint/pci-epc-core.c
+++ b/drivers/pci/endpoint/pci-epc-core.c
@@ -942,7 +942,7 @@ void devm_pci_epc_destroy(struct device *dev, struct pci_epc *epc)
 {
 	int r;
 
-	r = devres_destroy(dev, devm_pci_epc_release, devm_pci_epc_match,
+	r = devres_release(dev, devm_pci_epc_release, devm_pci_epc_match,
 			   epc);
 	dev_WARN_ONCE(dev, r, "couldn't find PCI EPC resource\n");
 }
-- 
2.39.5



