Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031883;
	b=hK7LnfCx9qO0ORvKT0u0XFfHiLAUhxAx7bt+kEA5okQBcTCLFWdheNZCuGjMgjfAyZ1a
	 0uJtDw/bYAaBQNoFmVR1cZdaTLfpM+rcDSkSxiw7XKQWI67zc/gFw9I9gPwlgH1HYFKaQ
	 6dz4PD6hbFUadxFKmWoISc5pgWEX8cUqPtF9ZfrMc69tZX6T3rJOBIND9haqeNs/k6NpG
	 E7uieCc088rwrn2Pk9a3Lslp8sb/x8VtFVLJwNwmPi7ZT84UWwFCFpw8oG8sBooML0X4L
	 +lnWh9BxjmYynL2xrfjeAyENqZrqdKSxul9rZePzVCY0zgJ2Xx1CU9zYHZRcd0Yekfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031883;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r4D0iNqcCg8cfAyQBuwWpR94uMmWavA3R6vJn+qgF48=;
	b=GPjByjbhagHl62Htt4FkHAHZARlsuoQZK8Z0enSw4GWkfZyqHQ4Aw3aItamFPZNKeGLj
	 EE+bZ+XWtHwUAm5X7KNQkqFDkk1cTfkHfBThpYyVwdwS5pZvLsbNoQ2xQhZa9FtfqN9hy
	 yCOU2lRIvG/D1joXm+0RfrjRpLzoYpcLTagR4kieneG6ca3m+QOxGJzGov+/5HT+Me9Xl
	 ONpuQkVMOf7jpDHVkt+YPPu/cPaIaxMI0XWQau02WY3slx01paGUqAKDmLtsEB3GAcJtK
	 rq2MHpFkOfu1NpM+ali6itdf7uNT7IOBPBzN1p5eaWGxW+dJWtl0/EFdSVa5pa+H83g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LMfJythM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA29606A31C;
	Wed, 18 Nov 2026 19:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LMfJythM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A6D1F000C5;
	Wed, 18 Nov 2026 19:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031883;
	bh=r4D0iNqcCg8cfAyQBuwWpR94uMmWavA3R6vJn+qgF48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LMfJythMelQEyzVc+jbgLqgx0NQEdLJxFScCpaWeDJb76MbJsPMvPaocQYR2GJodD
	 b3RAhe957t9U7W3s+KIXE81zUxDPQ970YOT1y+hn5JqARNDBXv9sxAolm68lkzyutc
	 hvv5x0stajec7OxIWVyQlN4L5DobYozEJXYBHxOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1215/1756] PCI: Fix out-of-bounds MMIO read in nvme_disable_and_flr()
Date: Wed, 18 Nov 2026 15:55:42 +0100
Message-ID: <20261118150058.174737410@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>

[ Upstream commit 6aaa3f42e3410ea8e26c857477260159f724cb1d ]

In nvme_disable_and_flr(), the PCI bar is mapped using
NVME_REG_CC + sizeof(cfg) which is (0x14 + 4 = 0x18 bytes)

However, the function later reads the controller status from
NVME_REG_CSTS - offset 0x1C, which is outside the mapped 0x18 byte
boundary. This violates the API contract.

Fix this by increasing the mapping size to include NVME_REG_CSTS. Also
change sizeof(cfg) to sizeof(u32) to make the intent clearer.

Fixes: ffb0863426eb9 ("PCI: Disable Samsung SM961/PM961 NVMe before FLR")
Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Alex Williamson <alex@shazbot.org>
Link: https://patch.msgid.link/20260903164615.5744-1-raizudeen.kerneldev@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 5b266583acb57..3d568e217c157 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4107,7 +4107,7 @@ static int nvme_disable_and_flr(struct pci_dev *dev, bool probe)
 	if (probe)
 		return 0;
 
-	bar = pci_iomap(dev, 0, NVME_REG_CC + sizeof(cfg));
+	bar = pci_iomap(dev, 0, NVME_REG_CSTS + sizeof(u32));
 	if (!bar)
 		return -ENOTTY;
 
-- 
2.53.0



