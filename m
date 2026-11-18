Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049818;
	b=yaQvBaBbOB27YN5x+/8V2ogUc0wUpNT19EWPomL+UehDNcsvfr0rZXYSiYFBoHR2GT1E
	 MPeb5PpXA23xmHL8xu1r//aLPRbgb23nxSYI4zopv+tZ74oHp+9qY3q7Mazq06Mj1B1i7
	 PRx+XtnWXxq6v11Pp2JaLHvMBuBcCwQMNpLzezIfWDEeVf7sggiWdpf7y8BXQA9fJzQQJ
	 S+UMuOcNA3WG/EHknrwq057h089JrYoTmatWxZ9R84Ivn1JrLoNBReY5c65m0CqZTAGVy
	 BpP4UAlc3o/DRhCPE49/Gl0gxjbKzHgI2Isa99/Xz4N8crHbuX2SaJuo9SSUA9k3VeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049818;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L8zmXXG/UuR+dOIWx2tH0FmCU0bkaBB2yqLqXUMIW1k=;
	b=25SXvV9Pa8j+2agrV04r2vDXR4kbqcaQboLvgyaqce+6fybQQmYgoY4sHcd4/T/EyToR
	 OWFmvnqXmRaSXkRWi4R57/yQdTpE5939xn4ZkB2V6shEU42k8nq1rvT8xISHQyt8irNb8
	 RMtX0AQAzbxAztb4CMNNjQi9yhI3xCn1hAVyppkxy6PYouBwZkQ4UDW4Lq75/5IyTjDjA
	 /SuMq3iR4VPF8C9ArIbkqewJVUmNg8XMmX5d/xl/6CZNXhT9wzn9wnpujuqVui2WPEt7q
	 5IEkccIfoFf86DM2E62FvIYlFyG1M4880w7Fw1kZhc4G7LUmaTOPzHOpp+dS9qiAJ1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ulmlXSLp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655B3606A325;
	Thu, 19 Nov 2026 00:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ulmlXSLp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A201F000C4;
	Thu, 19 Nov 2026 00:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049818;
	bh=L8zmXXG/UuR+dOIWx2tH0FmCU0bkaBB2yqLqXUMIW1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ulmlXSLp4b1inSnBi5TIc87Xnk/DCgShZzroZly4EDc+5gtZENB41EhcH1Z4F5PPw
	 sKXVB64Be01R5ckY5NIQvnxDIpJVrG8vyPuwLUXM4nXB6JkkjcZgPL0dLu4kDiza1l
	 MURdmMUuhQWDhI4ZWxqJBcwtJ4CF8RLts6QKNYwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2486/2857] PCI: Fix out-of-bounds MMIO read in nvme_disable_and_flr()
Date: Wed, 18 Nov 2026 15:58:40 +0100
Message-ID: <20261118150331.075666239@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ab89ac0cab833..f15f576879dbd 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3988,7 +3988,7 @@ static int nvme_disable_and_flr(struct pci_dev *dev, bool probe)
 	if (probe)
 		return 0;
 
-	bar = pci_iomap(dev, 0, NVME_REG_CC + sizeof(cfg));
+	bar = pci_iomap(dev, 0, NVME_REG_CSTS + sizeof(u32));
 	if (!bar)
 		return -ENOTTY;
 
-- 
2.53.0



