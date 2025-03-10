Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795BC232369;
	Mon, 10 Mar 2025 17:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628988; cv=none; b=NpVHLuGY2sKmWsPw6UYTC6hzmHaZ/tDKWSOVr8OfbMJv3qNs7YcSz32CoZbTgTLUXkpmxmyH/F5l/HtNBd9DUicrYUYklJ5UBu4QGclu85CxYtHmNAHyUIAQAh+ZQ69WDxXfDqkm6UKqAuwl0Ub55WpmpQgHUD3BA+RzTtl3ryc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628988; c=relaxed/simple;
	bh=RoCNLDPNcClAsDoCUpcjcyKG/JUDt4+DOHdhnr5cyFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VriUyuHA88pgEVP4GhwMwieKlTKvsUexM8tbmAOEoooMojB1UYfXI6Phczl7KbDMTd9mCFq9v+hbZ0+gU+vOkbTBubvQswKoK+iocwb39EkBuxrHKWTvsZbyHLPgl1CuPuv0By/8bk8kQUDh7n0d4tvc4KrOk/mY4NwfUcefQ5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tPh7dy60; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tPh7dy60"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9F8C4CEE5;
	Mon, 10 Mar 2025 17:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628988;
	bh=RoCNLDPNcClAsDoCUpcjcyKG/JUDt4+DOHdhnr5cyFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tPh7dy60Qs/oioEQEcm/zjq2ilTpm4icXfmQthxf8awzTecM4bzHvHBniFJ8tOHsP
	 9cPnJYWhYwWZFkKIg6xZqLgQeI9H5kveLl5e4Q4dmleBc7dDUmxTWXqI3HGsvl20kq
	 JCvsQLcRPsOQqepso2SIc6tPVp8MMZH4hqKSIyM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 138/620] PCI: endpoint: Destroy the EPC device in devm_pci_epc_destroy()
Date: Mon, 10 Mar 2025 17:59:44 +0100
Message-ID: <20250310170551.047894100@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ecbb0fb3b653c..64f9bae6d15b9 100644
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



