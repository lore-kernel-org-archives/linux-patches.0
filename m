Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E153C23
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC10C433C0;
	Mon, 19 Jun 2023 10:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171213;
	bh=6XzkXsJMheokHPVeaWHMhs8g74qBEE++WTTZCVP1Lj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W8fYgjXRLLZECgz26aUsBaV/yUyX0hFoVk5ctNZJDK0kQRVgAVK/EDYxHTFkvqvoM
	 TSU21y9w2EjHCwiW/XX6DK14NzFrGP6MgFzPoXw+6w1INKdhVprGp8ybFGD5iFP2C6
	 WFiAQARJMK4HiU3Mo5qitVbnnzUwlhtrPKnJoL5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 181/187] octeon_ep: Add missing check for ioremap
Date: Mon, 19 Jun 2023 12:29:59 +0200
Message-ID: <20230619102206.461178790@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 9a36e2d44d122fe73a2a76ba73f1d50a65cf8210 ]

Add check for ioremap() and return the error if it fails in order to
guarantee the success of ioremap().

Fixes: 862cd659a6fb ("octeon_ep: Add driver framework and device initialization")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Link: https://lore.kernel.org/r/20230615033400.2971-1-jiasheng@iscas.ac.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeon_ep/octep_main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index 5a898fb88e375..c70d2500a3634 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -941,6 +941,9 @@ int octep_device_setup(struct octep_device *oct)
 		oct->mmio[i].hw_addr =
 			ioremap(pci_resource_start(oct->pdev, i * 2),
 				pci_resource_len(oct->pdev, i * 2));
+		if (!oct->mmio[i].hw_addr)
+			goto unmap_prev;
+
 		oct->mmio[i].mapped = 1;
 	}
 
@@ -980,7 +983,9 @@ int octep_device_setup(struct octep_device *oct)
 	return 0;
 
 unsupported_dev:
-	for (i = 0; i < OCTEP_MMIO_REGIONS; i++)
+	i = OCTEP_MMIO_REGIONS;
+unmap_prev:
+	while (i--)
 		iounmap(oct->mmio[i].hw_addr);
 
 	kfree(oct->conf);
-- 
2.39.2



