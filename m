Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54CA515CAC
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:52:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87FD6C433D6;
	Tue,  8 Nov 2022 13:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915560;
	bh=mP28hgTECRkM7eRlw0Ihu4xzwRxs2xy0goivN0V1pp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TLM/cuhojq0oFH3yOpOIMhM19h5/e/j1LmgpIcUKwiyG7bYXkmtM5ij83jLKM0RyJ
	 NRIiXPMm7qopPZuZZ3ghCB7yL26rEwH9HPBwBSMn4Ed9j7bgsDa/oGC0sQqsWA9+97
	 W5EE67hnT3/X0ttPg8JhekxlESgHCRpmMWvO/GI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shang XiaoJing <shangxiaojing@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 025/118] nfc: nxp-nci: Fix potential memory leak in nxp_nci_send()
Date: Tue,  8 Nov 2022 14:38:23 +0100
Message-Id: <20221108133341.754151632@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shang XiaoJing <shangxiaojing@huawei.com>

[ Upstream commit 7bf1ed6aff0f70434bd0cdd45495e83f1dffb551 ]

nxp_nci_send() will call nxp_nci_i2c_write(), and only free skb when
nxp_nci_i2c_write() failed. However, even if the nxp_nci_i2c_write()
run succeeds, the skb will not be freed in nxp_nci_i2c_write(). As the
result, the skb will memleak. nxp_nci_send() should also free the skb
when nxp_nci_i2c_write() succeeds.

Fixes: dece45855a8b ("NFC: nxp-nci: Add support for NXP NCI chips")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/nxp-nci/core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/nxp-nci/core.c b/drivers/nfc/nxp-nci/core.c
index 2b0c7232e91f..b68b315689c3 100644
--- a/drivers/nfc/nxp-nci/core.c
+++ b/drivers/nfc/nxp-nci/core.c
@@ -77,10 +77,13 @@ static int nxp_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
 		return -EINVAL;
 
 	r = info->phy_ops->write(info->phy_id, skb);
-	if (r < 0)
+	if (r < 0) {
 		kfree_skb(skb);
+		return r;
+	}
 
-	return r;
+	consume_skb(skb);
+	return 0;
 }
 
 static struct nci_ops nxp_nci_ops = {
-- 
2.35.1



