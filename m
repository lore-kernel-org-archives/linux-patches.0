Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273DC1C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:49:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 668C8C433C1;
	Wed, 23 Nov 2022 09:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196977;
	bh=SdcKlAwypcLs/pbgUt3hnQsTMteq0JL8OduNhqFzqt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OFCHgyPbM1ocCYQiu5lItOsXtRFbIbOBRqb6bCit4Psygin9nwiTcjlihfmG5i1Zb
	 uDC6xgEeJha375n8HahBjkhLltZ6zXyCf9PZOERnsehWm2DLlyyOYMgiebIhD+atRV
	 dx8z0n8J/DIKW317SBwfnQ4YGjkmHzWR2xltYt24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyang Xuan <william.xuanziyang@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 163/314] octeon_ep: ensure get mac address successfully before eth_hw_addr_set()
Date: Wed, 23 Nov 2022 09:50:08 +0100
Message-Id: <20221123084632.957016975@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ziyang Xuan <william.xuanziyang@huawei.com>

[ Upstream commit 848ffce2f0c93f3481052340a919123a21f808b6 ]

octep_get_mac_addr() can fail because send mbox message failed. If this
happens, octep_dev->mac_addr will be zero. It should not continue to
initialize. Add exception handling for octep_get_mac_addr() to fix it.

Fixes: 862cd659a6fb ("octeon_ep: Add driver framework and device initialization")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeon_ep/octep_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index ac1e37afbe7b..8a6a81bcec5c 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -1072,7 +1072,11 @@ static int octep_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->max_mtu = OCTEP_MAX_MTU;
 	netdev->mtu = OCTEP_DEFAULT_MTU;
 
-	octep_get_mac_addr(octep_dev, octep_dev->mac_addr);
+	err = octep_get_mac_addr(octep_dev, octep_dev->mac_addr);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to get mac address\n");
+		goto register_dev_err;
+	}
 	eth_hw_addr_set(netdev, octep_dev->mac_addr);
 
 	err = register_netdev(netdev);
-- 
2.35.1



