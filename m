Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2981D5ABA;
	Wed, 25 Feb 2026 01:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983178; cv=none; b=RurHZ7Tn8Y9HSrCNdas1VyL5pjY65jIAUML2NBUlw01VZstEyRhSKWO4y/yiE4b85TJQtFDSegT+JCxtzvNkefRWZV/ykpQtgYUMlfpu/tFe/eCc623Ns5J+JBqsadeVPA3qtxjkaTVaL9vyiK2gUNpRKgadMPbsIoZOrEMmsEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983178; c=relaxed/simple;
	bh=zBjZjYQ7LMchrZDs4QlXJy74nIVjalAQ3UlZTIqNeqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W8jAtgQlB/X9KGIcbZRYaRODmM+SIj9UOxkf3fa39Ns98EAds6TT6R9cdJz0bpcHTI5UJK2KUzdQmQS/qQo9VYiYHrQEay2OLKvNe9TPVOeyJwe4Kxdgqzci5e0KiyEDIRucOoBhotbp5wzlwDDFnFBr/6Fddu8MWj08ZgC0yuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rl59Wwky; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rl59Wwky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 732F6C116D0;
	Wed, 25 Feb 2026 01:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983178;
	bh=zBjZjYQ7LMchrZDs4QlXJy74nIVjalAQ3UlZTIqNeqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rl59Wwkyb2eooNLoeZUBasamGDtpzWByNAyI5p4sroeQKoXNOIRSQUGwZ5n/I+ZGA
	 diEz3uJbOnlQavHgTs65XRWbHGJkPsVB6RFZXmtYTC0xdNs+pxZn+emzyT+UE9JGBo
	 T0f/J9nTBXwMGnXwEldzJqApvq/qjtw+7X3D0W6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 329/781] PCI/portdrv: Fix potential resource leak
Date: Tue, 24 Feb 2026 17:17:18 -0800
Message-ID: <20260225012407.772618471@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

[ Upstream commit 01464a3fdf91c041a381d93a1b6fefbdb819a46f ]

pcie_port_probe_service() unconditionally calls get_device() (unless it
fails). So drop that reference also unconditionally as it's fine for a
PCIe driver to not have a remove callback.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Link: https://patch.msgid.link/e1c68c3b3f1af8427e98ca5e2c79f8bf0ebe2ce4.1764688034.git.u.kleine-koenig@baylibre.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/portdrv.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/pcie/portdrv.c b/drivers/pci/pcie/portdrv.c
index 38a41ccf79b9a..a0991da482136 100644
--- a/drivers/pci/pcie/portdrv.c
+++ b/drivers/pci/pcie/portdrv.c
@@ -557,10 +557,10 @@ static int pcie_port_remove_service(struct device *dev)
 
 	pciedev = to_pcie_device(dev);
 	driver = to_service_driver(dev->driver);
-	if (driver && driver->remove) {
+	if (driver && driver->remove)
 		driver->remove(pciedev);
-		put_device(dev);
-	}
+
+	put_device(dev);
 	return 0;
 }
 
-- 
2.51.0



