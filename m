Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18BE22912F;
	Thu, 12 Dec 2024 16:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022454; cv=none; b=IaL+WeAlV+FzzdMYH6J3PwBGeK3WNRPPo5vc3uR3iNh75qWeL5sLOibm8Y0C2zj3ofGb5JO9JnZ9VTYq5Wycf0O1LAS6VSW2ht8+vIg3zx5V77DW5sk+pRmc/4NYGtSuUzLEiIQpKQSHxmsq7zZsRP3xHEcEarn2Ds9K4RM+dtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022454; c=relaxed/simple;
	bh=zaN0CjDcegDhe90Zinx6BDHaPxzA7rGgpTe/hn43R1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hz8Ppmywz1Xl4YaMvXvTRD3VEb/BFG2Du0HSAduXf9WIss1tGQekTWbG3EU3yCvo/CvvtaKRY96XqCgIgg7GaK2qnRTkxwk7UaOsdKDQRKYvSJ0erNRvrWoxzgMe9MtxGuK1doCyzfUo3Xhq4M0D/6GBCrDaWQFZSaULYDoUoIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fcfIGyuR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fcfIGyuR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ECDFC4CECE;
	Thu, 12 Dec 2024 16:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022454;
	bh=zaN0CjDcegDhe90Zinx6BDHaPxzA7rGgpTe/hn43R1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fcfIGyuRkgXhLkpY2oE52qokp008aJVH8IxJqf06YSJ4xgvYmugxarzcmnVnNjlPy
	 qaBUTeRfK1WY701GWOPnypf1gQN+IlC9Gma64CELLQddj0g6nKhIYSQgqNd47My9OK
	 bPL5fL7nNJrBKMFu45vpgAx+UUuTYnr/m+wLQKfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naveen Naidu <naveennaidu479@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 245/565] PCI: cpqphp: Use PCI_POSSIBLE_ERROR() to check config reads
Date: Thu, 12 Dec 2024 15:57:20 +0100
Message-ID: <20241212144321.159878774@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: weiyufeng <weiyufeng@kylinos.cn>

[ Upstream commit a18a025c2fb5fbf2d1d0606ea0d7441ac90e9c39 ]

When config pci_ops.read() can detect failed PCI transactions, the data
returned to the CPU is PCI_ERROR_RESPONSE (~0 or 0xffffffff).

Obviously a successful PCI config read may *also* return that data if a
config register happens to contain ~0, so it doesn't definitively indicate
an error unless we know the register cannot contain ~0.

Use PCI_POSSIBLE_ERROR() to check the response we get when we read data
from hardware.  This unifies PCI error response checking and makes error
checks consistent and easier to find.

Link: https://lore.kernel.org/r/b12005c0d57bb9d4c8b486724d078b7bd92f8321.1637243717.git.naveennaidu479@gmail.com
Signed-off-by: Naveen Naidu <naveennaidu479@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Stable-dep-of: e2226dbc4a49 ("PCI: cpqphp: Fix PCIBIOS_* return value confusion")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/hotplug/cpqphp_pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/hotplug/cpqphp_pci.c b/drivers/pci/hotplug/cpqphp_pci.c
index 1b2b3f3b648bc..a20875da4ec70 100644
--- a/drivers/pci/hotplug/cpqphp_pci.c
+++ b/drivers/pci/hotplug/cpqphp_pci.c
@@ -138,7 +138,7 @@ static int PCI_RefinedAccessConfig(struct pci_bus *bus, unsigned int devfn, u8 o
 
 	if (pci_bus_read_config_dword(bus, devfn, PCI_VENDOR_ID, &vendID) == -1)
 		return -1;
-	if (vendID == 0xffffffff)
+	if (PCI_POSSIBLE_ERROR(vendID))
 		return -1;
 	return pci_bus_read_config_dword(bus, devfn, offset, value);
 }
@@ -251,7 +251,7 @@ static int PCI_GetBusDevHelper(struct controller *ctrl, u8 *bus_num, u8 *dev_num
 			*dev_num = tdevice;
 			ctrl->pci_bus->number = tbus;
 			pci_bus_read_config_dword(ctrl->pci_bus, *dev_num, PCI_VENDOR_ID, &work);
-			if (!nobridge || (work == 0xffffffff))
+			if (!nobridge || PCI_POSSIBLE_ERROR(work))
 				return 0;
 
 			dbg("bus_num %d devfn %d\n", *bus_num, *dev_num);
-- 
2.43.0



