Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44FB7189B85;
	Tue, 30 Jul 2024 17:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359352; cv=none; b=sGDorDI7r5buPmQ5nA3BLBIMbGfnh0x+KMiq5G0apaqiirqNAVhDGuo78tyaDjxo3KFyCdbw0UvVaBRKP80Yop0T3J+Ub5zHTTtz6HnDJ4AeueyLMM1WFU5Ym0SARwZYQ6SMm+Bm221lOOkF6LnoCb2VEeQCTEXu0T+fL+ZBMx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359352; c=relaxed/simple;
	bh=k6CRQEC5EWVdFPgUIKhJdowCMfTB8GbErKSMnvWtPOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ipqfue7+8gXCHHO2KXxzVPbDz1ELfOOnJPaEcZ+nI8BSaXThOiwVAuSE3psLsjYtqgoKwvcf18aa12CzQHhTktvo24dQrKD3POeGOkV81qpruHMFyqkGWNATl3ztClG/yg0snbo2JeluQICnFlesW3RNBOEMXH2p+mbWw9GLo60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MiPtYRDg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MiPtYRDg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50FC9C32782;
	Tue, 30 Jul 2024 17:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359351;
	bh=k6CRQEC5EWVdFPgUIKhJdowCMfTB8GbErKSMnvWtPOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MiPtYRDg2gg92dB7cwmiopnkkmWPso71SIJwxRBmDbNpj5s88tKBtks2VRPNPOUX9
	 CWkwMLQKobad0urld182HB7twqB2Xf9KJfIZiD7WkQKytg+neKZf858BdZZxTARzb5
	 El80sT/iYXUJ01AjVLxCI7tO9eNfJagEMrzOUNks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 472/809] RDMA/mana_ib: set node_guid
Date: Tue, 30 Jul 2024 17:45:48 +0200
Message-ID: <20240730151743.379640955@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Taranov <kotaranov@microsoft.com>

[ Upstream commit 65357e2c164a08bf20849dd55f46aa71e00334fa ]

Use the mac address for the node_guid of the IB device.

Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
Link: https://lore.kernel.org/r/1717070117-1234-2-git-send-email-kotaranov@linux.microsoft.com
Reviewed-by: Long Li <longli@microsoft.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: 1df03a4b4414 ("RDMA/mana_ib: Set correct device into ib")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mana/device.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/mana/device.c b/drivers/infiniband/hw/mana/device.c
index 7e09ceb3da537..9a7da2ec9cdbb 100644
--- a/drivers/infiniband/hw/mana/device.c
+++ b/drivers/infiniband/hw/mana/device.c
@@ -5,6 +5,7 @@
 
 #include "mana_ib.h"
 #include <net/mana/mana_auxiliary.h>
+#include <net/addrconf.h>
 
 MODULE_DESCRIPTION("Microsoft Azure Network Adapter IB driver");
 MODULE_LICENSE("GPL");
@@ -92,6 +93,7 @@ static int mana_ib_probe(struct auxiliary_device *adev,
 		goto free_ib_device;
 	}
 	ether_addr_copy(mac_addr, upper_ndev->dev_addr);
+	addrconf_addr_eui48((u8 *)&dev->ib_dev.node_guid, upper_ndev->dev_addr);
 	ret = ib_device_set_netdev(&dev->ib_dev, upper_ndev, 1);
 	rcu_read_unlock();
 	if (ret) {
-- 
2.43.0



