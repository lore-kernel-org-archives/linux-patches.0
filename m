Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9797E111;
	Mon,  8 Apr 2024 13:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583448; cv=none; b=XUAmKXVwQlhVIssUeZnZpa3pRsxE4DBY4vJra1x+ZPaph5JTgCZEITx+fEz0z6nG5fG5nmoz2D7MtNiprfOtotrT/dz88JiXyy96cIds/ZOKeL7Tm/cOsLTw8JFD3lhyqM636Csh3MDR1PpZdZaCZ4BCvdX5Stl/jdfi+jkBies=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583448; c=relaxed/simple;
	bh=9KPqyBC9SQJxWaB85a/LvsC8aIPDi0IzLsI8tT6WeXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W1k7Z5MdaMVGJi8sezKQM8X2REW5742lRPQ3MOKRuwQ7DxAiffcVl4KMRicC5CHb7JXpkC8e021y6c2kiVn8Ahxgaty+FEeGhYhAfp0Slmtz3XSiL9iR/Wige3/neCkGrT0e66pMnmW7AeYVFLm1GBIfwZflobXlMgPbLL9OGBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w1b2YhxN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w1b2YhxN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1622BC433F1;
	Mon,  8 Apr 2024 13:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583448;
	bh=9KPqyBC9SQJxWaB85a/LvsC8aIPDi0IzLsI8tT6WeXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w1b2YhxNPSrKKqdq9y4CeiCU8ZUlgPbq8d6P675iCZfj64zurm6L4pjbGk4mosSad
	 C9vkSagjwd84oMUJBGRVhYWctPwFSi2o/L87IWY4ryU0Pey9wkDeJWaMM9DCS8JPgw
	 406kSnKJcH8j7OX8Fn0lHGfs0jGN2MctOxmxQ77U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huai-Yuan Liu <qq810974084@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 180/273] spi: mchp-pci1xxx: Fix a possible null pointer dereference in pci1xxx_spi_probe
Date: Mon,  8 Apr 2024 14:57:35 +0200
Message-ID: <20240408125314.867753816@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huai-Yuan Liu <qq810974084@gmail.com>

[ Upstream commit 1f886a7bfb3faf4c1021e73f045538008ce7634e ]

In function pci1xxxx_spi_probe, there is a potential null pointer that
may be caused by a failed memory allocation by the function devm_kzalloc.
Hence, a null pointer check needs to be added to prevent null pointer
dereferencing later in the code.

To fix this issue, spi_bus->spi_int[iter] should be checked. The memory
allocated by devm_kzalloc will be automatically released, so just directly
return -ENOMEM without worrying about memory leaks.

Fixes: 1cc0cbea7167 ("spi: microchip: pci1xxxx: Add driver for SPI controller of PCI1XXXX PCIe switch")
Signed-off-by: Huai-Yuan Liu <qq810974084@gmail.com>
Link: https://msgid.link/r/20240403014221.969801-1-qq810974084@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-pci1xxxx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/spi/spi-pci1xxxx.c b/drivers/spi/spi-pci1xxxx.c
index 5b2d3e4e21b7a..5a42266820522 100644
--- a/drivers/spi/spi-pci1xxxx.c
+++ b/drivers/spi/spi-pci1xxxx.c
@@ -275,6 +275,8 @@ static int pci1xxxx_spi_probe(struct pci_dev *pdev, const struct pci_device_id *
 		spi_bus->spi_int[iter] = devm_kzalloc(&pdev->dev,
 						      sizeof(struct pci1xxxx_spi_internal),
 						      GFP_KERNEL);
+		if (!spi_bus->spi_int[iter])
+			return -ENOMEM;
 		spi_sub_ptr = spi_bus->spi_int[iter];
 		spi_sub_ptr->spi_host = devm_spi_alloc_host(dev, sizeof(struct spi_controller));
 		if (!spi_sub_ptr->spi_host)
-- 
2.43.0



