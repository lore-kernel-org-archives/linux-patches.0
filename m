Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713E47D09F;
	Mon,  8 Apr 2024 13:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583375; cv=none; b=duPVP8GjGosZ+M2yCNWZoYXy4756QN14Pvn/bsRuCJosvY8/zae/PWMbDHWqN0H7ZZHUiNMwm/+/BwSxV10sRx14Y4IIxSGwavItulMBeKGfFSIKVdsKGZTDJg6KN0KSSdOPimr9hOfz5HFOT2QuVHQMyBq8QekFQB5I5FrlPaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583375; c=relaxed/simple;
	bh=dd9w9qTK1Cse1b6SvZ4b1cjOjjMOZQKntb9OUgpicGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YFjHaWBfiPVJT/mLB4iqNqGOBkMT08Vn164BCHpuG9KJEf1lKCt9xU7/AB9QvtmvyZQbhHpmmvCw+p5eCBiw+tBsPna6TTHiFzPcmVZPMY4RpSikIuYratJ0iVCPWL9V0eTOgqkMkleVjMJ0OBR53zYn6lMJRmY8C+1+atCiFy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dqJBojXq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dqJBojXq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC93FC433F1;
	Mon,  8 Apr 2024 13:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583375;
	bh=dd9w9qTK1Cse1b6SvZ4b1cjOjjMOZQKntb9OUgpicGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dqJBojXqcBQKCk1PeBWWrL3T1CeLGwWRDn2oPPZxTyPmT0fvpztA+W+M14/KtDXgI
	 jnCV9GYdw3OqjVSdaJaRYykc1EBparnAgVCmxP2t7u5uAJemy6HE/urvJu/EwNFO7a
	 wlrWEngVxNpEI6dldP1zu4kndzhnibQl+zqAzBYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huai-Yuan Liu <qq810974084@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 189/252] spi: mchp-pci1xxx: Fix a possible null pointer dereference in pci1xxx_spi_probe
Date: Mon,  8 Apr 2024 14:58:08 +0200
Message-ID: <20240408125312.528858933@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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
index 3638e974f5d49..06bf58b7e5d72 100644
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



