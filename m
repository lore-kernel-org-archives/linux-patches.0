Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8ADA25E807;
	Tue, 11 Mar 2025 15:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705483; cv=none; b=cuLPFNowPHEECmCyhcP/RoQfMv0isNnBQlUtvIDLYrNKJ7/vc6JIlo6C4tXVnc4NzJh5+4xQ4y1xL7Nemx0BRPiY3DC5/N4BviZltk2gtGK+CI3omILoBPcnh4bxjP+SUaVYH5aXdNWptrnynTL2y2hhG+ajawpp0xSHw5gWPZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705483; c=relaxed/simple;
	bh=QHuIbubvvd1G2YZpjpWq5Uxi9OFJWsJxTSsS/MbK/1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uLICjDrL9n3PlpXPWkZATdp74aWiiGzBW7DfclgG6LZn225jKdbwLCOhjbEXMVjU5D/1wN095J+Iqymf0fwXAmr8bc+twGcwPu3XxHas8fqhCTV28b4oErn1/ZZTeL/Yv9hB3QwtMovInOCDmWxQVaDzzlSg/yi4IXhqXwTXAwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m09obQ5S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m09obQ5S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F363C4CEE9;
	Tue, 11 Mar 2025 15:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705483;
	bh=QHuIbubvvd1G2YZpjpWq5Uxi9OFJWsJxTSsS/MbK/1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m09obQ5SXJ+4PtSR9soD8WBwKh3a70dSWguL3VnrJAZUS3FXroPifuBewCIk32nRz
	 spFH4A/5vzrHLObSTbC9bmeGWGQIQMfGQgwxkeQ/HTJ4nlKcB4Rz+4zImEZfdMAsnA
	 QMo83XUmIRGLHM4kS9Q2lyRpoQlki0Gnxitr5H+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 051/328] PCI: endpoint: Destroy the EPC device in devm_pci_epc_destroy()
Date: Tue, 11 Mar 2025 15:57:01 +0100
Message-ID: <20250311145716.924017831@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 2091508c16204..3c08c2c7d339c 100644
--- a/drivers/pci/endpoint/pci-epc-core.c
+++ b/drivers/pci/endpoint/pci-epc-core.c
@@ -578,7 +578,7 @@ void devm_pci_epc_destroy(struct device *dev, struct pci_epc *epc)
 {
 	int r;
 
-	r = devres_destroy(dev, devm_pci_epc_release, devm_pci_epc_match,
+	r = devres_release(dev, devm_pci_epc_release, devm_pci_epc_match,
 			   epc);
 	dev_WARN_ONCE(dev, r, "couldn't find PCI EPC resource\n");
 }
-- 
2.39.5



