Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D994C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 13:06:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C52DAC433B5;
	Mon, 14 Nov 2022 13:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668431200;
	bh=IaQAV87arvBD3pKiqQLOuNjtaG5jOTE8VUO5ubkoQnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n00scA+ZXaj3wUpaWlb3sZKpKu0H2E95eu+QwfVpmh62ulTK3mTQdvtosUq++iEix
	 lGuBvNlUV31FtoSh1PYMN0q4aMS/78oQzOyrKJKey84/nGHmsrOgFTfNakafCfbDi/
	 vcVSo146evEoz0G6bXSAgxrodKKBznUoeyKEzQCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 107/190] net: mv643xx_eth: disable napi when init rxq or txq failed in mv643xx_eth_open()
Date: Mon, 14 Nov 2022 13:45:31 +0100
Message-Id: <20221114124503.376815420@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit f111606b63ff2282428ffbac0447c871eb957b6c ]

When failed to init rxq or txq in mv643xx_eth_open() for opening device,
napi isn't disabled. When open mv643xx_eth device next time, it will
trigger a BUG_ON() in napi_enable(). Compile tested only.

Fixes: 2257e05c1705 ("mv643xx_eth: get rid of receive-side locking")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Link: https://lore.kernel.org/r/20221109025432.80900-1-shaozhengchao@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mv643xx_eth.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index b6be0552a6c1..40a5957b1449 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -2481,6 +2481,7 @@ static int mv643xx_eth_open(struct net_device *dev)
 	for (i = 0; i < mp->rxq_count; i++)
 		rxq_deinit(mp->rxq + i);
 out:
+	napi_disable(&mp->napi);
 	free_irq(dev->irq, dev);
 
 	return err;
-- 
2.35.1



