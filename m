Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041613;
	b=K14MAppTfeJOsWoaSLEZMjjYfZ7M8CmHV9E1vHy3nH77y7+JlSshnmsTRPr068QjkFtn
	 iAHyR/zzlbqa0lXZVm/tCJKFWPqBdRRvev2JYp3rcoEI1f24LHmK+76uju6fTz0sfa2A8
	 4TTg87rj/QEFD14VtGFq5LRr/rycMznNWoasVNZuizbH6w8mqdOndzhoo25+YE2x6UI+K
	 PYWVsY5Ml3h98m/wl4rwuriXlo27P0uUAEvIZwUCx04uA4w4RVGRgc1SAV20l8iakYUEV
	 vuPyAYlsNX4aAcF1PggdOA0sLrm1LDDSF6g6UhmT+VbDIi3kROHFRdMuEZOjf6qgXNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041613;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BKCuiaCFi7lsq25OEKxjDeSuNeHhMaA4xKmHxnCybu8=;
	b=jIsX5OKJkSl1tCWMB2GxZDJaZh1nwf/LgFJQvxVgmVoAfV241KTl+SaP6YLEfqRDJD9M
	 d2RNjOMG+ZGFooaHWT2R60bzsjOQi93QyIeTufjFGhRhv9OaXysdLSjG+zvRMkjEJK5TJ
	 Mpt716xZO21WaY+OqccoYE/5CUwM8qMkijHO2AyF3Gbc0Z+JmpL80alSTr85AJr/zupQB
	 /JIBUaVMrcqhoKFjr620phWFcoc3F+Da3S3F23VAOIltUvDDSd7+vavRidM6NsL73FZ0Q
	 bDR38KwZC9TYOWwuDOKB3CuvWHcFBMusALZQoWeRr3XsmOm2uRmKEBjW8nQl6aQ9RfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="TT/Vw5FK";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F3D606A31C;
	Wed, 18 Nov 2026 22:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TT/Vw5FK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3FD1F000C4;
	Wed, 18 Nov 2026 22:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041613;
	bh=BKCuiaCFi7lsq25OEKxjDeSuNeHhMaA4xKmHxnCybu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TT/Vw5FKa1fyRUBSRywk/JZBK2wXVYcg/0hbAQTTLkdzffPZuQ6gshpZ9WXp1qtXr
	 mbi4I7xhYcVlOAU78K/rfAjjHW4KwF3IoPs78SN6YgH1IY26OSS7PHaLcTNAhWMGYZ
	 hfCpW6j/qWEl0MmS2BELUfydyj3Up0oxHyhlCM+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2875/3318] PCI: Fix out-of-bounds MMIO read in nvme_disable_and_flr()
Date: Wed, 18 Nov 2026 15:58:17 +0100
Message-ID: <20261118150446.798979017@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 57dd40f2e371a..7957b78cf6130 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4089,7 +4089,7 @@ static int nvme_disable_and_flr(struct pci_dev *dev, bool probe)
 	if (probe)
 		return 0;
 
-	bar = pci_iomap(dev, 0, NVME_REG_CC + sizeof(cfg));
+	bar = pci_iomap(dev, 0, NVME_REG_CSTS + sizeof(u32));
 	if (!bar)
 		return -ENOTTY;
 
-- 
2.53.0



