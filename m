Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77331C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:49:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11334C433D6;
	Wed, 23 Nov 2022 09:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196965;
	bh=Aggbpxdm1Mi46rnqdyBpdbKOOM0lFimbly89tIXEB1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ocjGP3HcotFtIPvvcAfRTBpQ+A7ttwKK54jzqkOsPchKVRBW7af6k/EEGelJx94Kk
	 GvN24egb1Cxy71gkhWAJ7AMp+54t8RVdktHF0fGsHHuqblYDREfQL4GfAk/os5UQ48
	 oFZlytk/6TFWmAcVa5+6q0poR4ZDEsvhJG09dzcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyang Xuan <william.xuanziyang@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 160/314] octeon_ep: delete unnecessary napi rollback under set_queues_err in octep_open()
Date: Wed, 23 Nov 2022 09:50:05 +0100
Message-Id: <20221123084632.820672883@linuxfoundation.org>
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

[ Upstream commit 298b83e180d53a310f9b47e3bf13b7b583e75e9c ]

octep_napi_add() and octep_napi_enable() are all after
netif_set_real_num_{tx,rx}_queues() in octep_open(), so it is unnecessary
napi rollback under set_queues_err. Delete them to fix it.

Fixes: 37d79d059606 ("octeon_ep: add Tx/Rx processing and interrupt support")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeon_ep/octep_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index 97f080c66dd4..7083c995d0c1 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -527,8 +527,6 @@ static int octep_open(struct net_device *netdev)
 	return 0;
 
 set_queues_err:
-	octep_napi_disable(oct);
-	octep_napi_delete(oct);
 	octep_clean_irqs(oct);
 setup_irq_err:
 	octep_free_oqs(oct);
-- 
2.35.1



