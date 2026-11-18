Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056291;
	b=UNTHze6fAPX9ZEP/cyjwAEanfin4DyUDWN5/aHF0C82/Dg1IHEQP382HmpuXDmfNO9Iy
	 4ulcLYZaYc3jrUDYZiLB4lfYLY/wWnai3k5eZTIM7PFQxIbTNvu46AcD7nXV03pZy1/hV
	 +MvXac/rfTu/beOwhM45V0N6WNtBIeYjWOF/yPXdtCO1jVSXiJ28MrfKF8d1TI7PUKCdi
	 L5gTJQ7Wev1bSt9whLeOJQ/GoiEKw69Uu9Tc4fraostbHm3MrEFxa5yZ4l5y4Xz78DTLu
	 v7uIsdwc1r50NBdgopuD8IXsSa/jkCRzjxvs900PoGwE8OsG74tw00cszTT9ETuKC6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056291;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YT9PAFepTOd3J03JpptjbuNa3eFfMOmkYYqUSdXQJB4=;
	b=yDg18dYaLCdT2RYKcCME89sk48WHVf3aQeU9KxILIlG0WiI/qPwM4dorm3iR2Ypoh0sV
	 kdtcWmth4WlL0TrO6FoJNLitkXrmbiKgE1UwiWSTIZuCkCApncTIYFKOfQLwEdsspaA3x
	 SrfkUiQgo4PsJhqCZUSNxrhUNcoNCqJW3SUVPqJNxM9E34X5+llUYFEgT52SopNpzehoY
	 h7siACk9zqzLywmXDArEb4YOxiFzIR3iIyblnAWnX//JtFLUuZxSyo3NC0fm3zQm55Y3p
	 UQuOCiX/KAy79r7bm91asTDZCbsyF4LcOZPDysUj42vW+hhrg/hxmm6DDsnbg/i7rFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hfVi9qqj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B37606A325;
	Thu, 19 Nov 2026 02:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hfVi9qqj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D13661F000C6;
	Thu, 19 Nov 2026 02:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056291;
	bh=YT9PAFepTOd3J03JpptjbuNa3eFfMOmkYYqUSdXQJB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hfVi9qqjTig+4RpPW4mNZXxvbHWF/3naHh1cUlaLNmxyhsAbvnV7UaVKFcq7ksQKV
	 2cvtLdBrnPxZGIQJJwBq1fe3UHLBMnTXni4YTxJVOn2nnyNHxLcbcRK40JqzGyEVda
	 BVU/eGcnDaMARzyivb4nHK9cQ1v0EFIFKJ9vay/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1934/2214] PCI: Fix out-of-bounds MMIO read in nvme_disable_and_flr()
Date: Wed, 18 Nov 2026 16:00:10 +0100
Message-ID: <20261118150128.366796919@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6afeb2bcea285..9b5542df0f138 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3957,7 +3957,7 @@ static int nvme_disable_and_flr(struct pci_dev *dev, bool probe)
 	if (probe)
 		return 0;
 
-	bar = pci_iomap(dev, 0, NVME_REG_CC + sizeof(cfg));
+	bar = pci_iomap(dev, 0, NVME_REG_CSTS + sizeof(u32));
 	if (!bar)
 		return -ENOTTY;
 
-- 
2.53.0



