Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249EB2208E;
	Sat,  3 Feb 2024 04:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933911; cv=none; b=GpE+EhgfQP0KfwiykAvuc3z7hhxYdFYolLg+S0dU3ML+aQtj8ybYPc4Kq88qkFpwdrP5IaCZiEkTOzYRzHFnEiRKZH5hwLOTaU1/MXtqwxuRVqLZiUzo0OihpUJ9HBlBlEGY/WxDF5P+GwzA9fJsUnFY7LXyv6t30E3kKYfhaog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933911; c=relaxed/simple;
	bh=VlT3nY/76iFv6Uoawgq52uIRosEHjTM4fghrtQfLEBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d0E237qcz7oXbZXvBmbe0+8LSDmXvVB8eH5vi83kAXmbCDgG4MZoG4oBUbxnplP9KJ3uHsbGxMsZGuTqWqyfXH7JigMKioIonHvhv+g8QWNPKObwQhaDEcvXc4oUIQG5OLxk3vvGoQGCEsZU3Uw/V5u6GM1xj1K5BsRpINCWrqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YTYOTyjq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YTYOTyjq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0FF9C433F1;
	Sat,  3 Feb 2024 04:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933911;
	bh=VlT3nY/76iFv6Uoawgq52uIRosEHjTM4fghrtQfLEBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YTYOTyjqlFrRCY9rdlpYDyOSsnroMyESI+Gq3M+5uLDGZCLXy6vs03JWpBNTbZHKx
	 XbLRVyDHKv+BSK5Y3LjC224dj57FkJOf/KXx+7sNdINJXSPRTLSQS1JN6mPubO9zS0
	 W2qDjddImZ2KjQoB675vRrePie4iopM7l2nheRTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 263/353] PCI: Fix 64GT/s effective data rate calculation
Date: Fri,  2 Feb 2024 20:06:21 -0800
Message-ID: <20240203035412.069771718@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit ac4f1897fa5433a1b07a625503a91b6aa9d7e643 ]

Unlike the lower rates, the PCIe 64GT/s Data Rate uses 1b/1b encoding, not
128b/130b (PCIe r6.1 sec 1.2, Table 1-1).  Correct the PCIE_SPEED2MBS_ENC()
calculation to reflect that.

Link: https://lore.kernel.org/r/20240102172701.65501-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index f43873049d52..c6283ba78197 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -272,7 +272,7 @@ void pci_bus_put(struct pci_bus *bus);
 
 /* PCIe speed to Mb/s reduced by encoding overhead */
 #define PCIE_SPEED2MBS_ENC(speed) \
-	((speed) == PCIE_SPEED_64_0GT ? 64000*128/130 : \
+	((speed) == PCIE_SPEED_64_0GT ? 64000*1/1 : \
 	 (speed) == PCIE_SPEED_32_0GT ? 32000*128/130 : \
 	 (speed) == PCIE_SPEED_16_0GT ? 16000*128/130 : \
 	 (speed) == PCIE_SPEED_8_0GT  ?  8000*128/130 : \
-- 
2.43.0



