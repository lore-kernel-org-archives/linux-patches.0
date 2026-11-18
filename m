Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026681;
	b=NI9EpEvCGYAf17Ak5YJE8F+TR3DBsCt/f0KJRsEwDfov4vi8mCS4RSu0KkSnNbTd1DZC
	 33FphiGD0ysJkezeyqy34FRBgInvOt2ASLgowU3g0wY+kF1vSk9DO/pKLBdFhaplDo2k0
	 td4O6LZYN3K7ZlGTcu7XQn48r8pyzLXZnqqz24XwEAlfcSB74rR0ScvkG2kv20wG5Lyz2
	 eUfvo1ABQ10iw5G4iQnww5ckOUVTLudHGxxlTDev7lkzqTveUpl3FlUr4p7iFQqW+73Ic
	 JFXizj7Rp3gqAyrMHMPS4yXdKABfxrnHHZwaSYHwtibyefe2VIM+cNruVm+MYO+2esg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026681;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ffhmDsU/h058ASV50e1YyLQt7Zht7oPexJTF3HeX9go=;
	b=w7dcAzO6mouGkS3QCpt9eLHplRhnxLXubGwyB009iBTIEDCYZAVG1Ppus6jzb6NMI9XK
	 Cs0ef5GuVN7lTvQr0autEkS+xwyJnNucEi4hWg+Q3Lj66A2PaMY1IeJYp18dqlTNp42SQ
	 Lo016Hw3mtFnDQz7v93HnHDKEyeXLW7ys214gTAD/49NgV8HG/njNuHfoO1lVCGOcfBqV
	 VHuAYMTT3k2Aw/HQeLetUk5lenXXLsLa2Vtcy/vLhbM4boXcBARMFvGxU1ktGsygcQB65
	 4pN1kd9XMSZASlud0FW9lBDlGpxnkbCdbYkSEIJA03ND+Nv30XIDCYnTkq+//6iMupQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LgKmMnl5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322A1606A32C;
	Wed, 18 Nov 2026 18:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LgKmMnl5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E921F000C5;
	Wed, 18 Nov 2026 18:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026681;
	bh=ffhmDsU/h058ASV50e1YyLQt7Zht7oPexJTF3HeX9go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LgKmMnl5BuYJR/F0wLVMtlRih3RpM+NfpNwkUmaLSqN7qM0G3c1toFjKcdtrhQS6s
	 qOr9ZbRIEtG0RYR1pF/SUvsDRwsjBUv/UHnmZ/Hf8lwA1R+eyCGWeoQEv6ahIDl7V/
	 Qiq/6BWt5iPd56ULKxKhOfukc05pWb6qycKPsl+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1522/2151] PCI: Fix out-of-bounds MMIO read in nvme_disable_and_flr()
Date: Wed, 18 Nov 2026 15:54:17 +0100
Message-ID: <20261118150217.281593000@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 812b01d24fc47..d0552b7bf9783 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4116,7 +4116,7 @@ static int nvme_disable_and_flr(struct pci_dev *dev, bool probe)
 	if (probe)
 		return 0;
 
-	bar = pci_iomap(dev, 0, NVME_REG_CC + sizeof(cfg));
+	bar = pci_iomap(dev, 0, NVME_REG_CSTS + sizeof(u32));
 	if (!bar)
 		return -ENOTTY;
 
-- 
2.53.0



