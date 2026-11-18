Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020204;
	b=uQxaGReQV/RMh15PZFGdNcBeUtyf/7Cp/HW9NOldm32Sy0yqP21kGeOdYEuQQxZy3OQI
	 s5efISfEljAsVart9bXHY/WQ7ddPiru/JXvsiDGCLvMuRfFo9BvbxjH90g18lh0vlu6XH
	 4VI7nWPOH7cxC0RZtaFPcYtZLnceaSXhgFV5PqFNzNdYxAEzgmDEEC6hbXeCbTfGhl/iX
	 13WiRfIrgqo+aR3gP4g2FL0S4o3Tn5Ahf59OQTd4ikTmFmrUlaZPPDifBRHcoe7c2W9oe
	 0OB0b48pztjOmELol9i9zK9yb+g4RU1hg+oeDSTkZcMpn80gdfxkKp23GV0BxlqiTUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020204;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xc1efQPzao7eNA6/oXDKbGrx1fQwHOuYN5n7yFGK69c=;
	b=ifuQR5d7L8jl93OsS+tTpIN4ZaAFzrpF5Z5julUBRdcoEc4kgYOexOe83A9jeLJy8Iva
	 pYAxt0w1BseC5HiwRet3dzmTBUCoicS60GaIcUjgmDivGH4dk9RmrQdkBvKh3OFiZ6rf7
	 ZrNrXhGe4VOLDyBKRoLBfCTN1Bh/CNtxRIqIECy/GzkX2vtmvkxIGzs3m9PZJhe8Ou+vA
	 e/6Oc3uIW3WKN4b7f+XzFeP/Te2chUOBzoRIzrEUDgO3ydQ9XTBryP3X43c6WPOIHvowN
	 FpS9vKsdWvcsj20J1bidsXmoLCo1kegU4HPFeXIEyhVdLPp8jBekFlDyiFf6DCpyhsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PK0xlXAD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57C2606A32C;
	Wed, 18 Nov 2026 16:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PK0xlXAD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D0641F000C4;
	Wed, 18 Nov 2026 16:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020204;
	bh=xc1efQPzao7eNA6/oXDKbGrx1fQwHOuYN5n7yFGK69c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PK0xlXADVXw+ls1NDBej9MoFz3bHXn8B9ODYRMQZaKmSH/deLCX6+rcXV/1704a9C
	 SEAIpWl9j3ZnH0ume6uEu/FubROpPr9q1naEpdSlFoQfaK+MeqjiHtRFx6q53oKJDV
	 BO8cKnHDeAv1bLlGcEzUxd2iMGHg0o7V+9s/JeIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1867/2651] PCI: Fix out-of-bounds MMIO read in nvme_disable_and_flr()
Date: Wed, 18 Nov 2026 15:51:47 +0100
Message-ID: <20261118150354.188547525@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index d4fcc336bc2a9..50fcb66753571 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4128,7 +4128,7 @@ static int nvme_disable_and_flr(struct pci_dev *dev, bool probe)
 	if (probe)
 		return 0;
 
-	bar = pci_iomap(dev, 0, NVME_REG_CC + sizeof(cfg));
+	bar = pci_iomap(dev, 0, NVME_REG_CSTS + sizeof(u32));
 	if (!bar)
 		return -ENOTTY;
 
-- 
2.53.0



