Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061822;
	b=Fp2xD1rAAzu3dSyzMYA/rF20lNjvbSn2tOBeu8MDq0wBE0DpNTBMxlofaR0sfmVwGCqh
	 ijb+iLkp/UNgIC5V3jMIDqAcNZ89zJ5DFI/V41kD4g0i1z1K9TBQ1CDJysgB+f0bDoDtl
	 saqlbt/LDfuDLUjCMyXY4E9WuAHbo2JEhYuc+wq1+UeYLS2XdobdDCsz+2PdsGgbqggda
	 FT26/7439cKzFYtw3kjFl0gnJyCqnRbs4CADcTL0GB9y/ruPw3U5qIBoEXpauK1d38amT
	 SymUq5RHUYmAD3FtlUkJV8/YcdV83xvXh6MSSHrrwdXZ645xKx/R5yMBkUfwE7hHG0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061822;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fdeTWeq2a1vpyzb3WazGeynyu7y2ADzBVptw37tyl3U=;
	b=JurO8v9y9RKrjHwXY+rFsm6G3GvY43BN9nc0YuEL/EpM75D/xj9fAEOQF7T3XJ9065ig
	 66IlITMzmEqGFVeNvV68Wta1pCy5b8m+etSeK6z7d+yzIRKBO+Mdu2016MruUXmt/PAUz
	 Jh5mNnoBMBEEWV7Qk+G6MuN/xEHpdi0iXXt74AhWy8EwAiBLtaL4Hi+j9SUJbibxrKQS1
	 hK4qB7kzbfxsNeoi2rrdIzggs8LRrbT/KMGgP7NmnhMlDOpQ6nmjh9dYGepIOL/K90O4t
	 9xqBQo4TpcfalsJpqtbMFN7G7Jrgtcb2CR7k/nxDoTxFL+HyizGPntMnTtzuHN9yIEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k8gsdKQr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A93C606A320;
	Thu, 19 Nov 2026 04:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k8gsdKQr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 601EE1F000C4;
	Thu, 19 Nov 2026 04:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061821;
	bh=fdeTWeq2a1vpyzb3WazGeynyu7y2ADzBVptw37tyl3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k8gsdKQr2RqUfLkEudHRHRlzj3FOecMdzcTb8ldjG/UgspnvZTuELvTE6dDyEVYZ3
	 VspieK0rpx9MLfJg/JN2ltKxtl+Agw154MjFN04/MK1UTNamx3YMPyXkF3sUX3Xbdd
	 6rFb/aL0MqBzDWqpqL6Ele5IEupfnweJHTTYXTHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1648/1848] PCI: Fix out-of-bounds MMIO read in nvme_disable_and_flr()
Date: Wed, 18 Nov 2026 16:01:26 +0100
Message-ID: <20261118150028.727474745@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7e05cf575cfc7..45262341ec60a 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3929,7 +3929,7 @@ static int nvme_disable_and_flr(struct pci_dev *dev, int probe)
 	if (probe)
 		return 0;
 
-	bar = pci_iomap(dev, 0, NVME_REG_CC + sizeof(cfg));
+	bar = pci_iomap(dev, 0, NVME_REG_CSTS + sizeof(u32));
 	if (!bar)
 		return -ENOTTY;
 
-- 
2.53.0



