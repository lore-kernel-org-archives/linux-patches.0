Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367301C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:12:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD0EC433D6;
	Wed, 23 Nov 2022 09:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194779;
	bh=hTkRJlBmpEbwzu6R14t196Ngt7/0UnjtNJsBCwb2hGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mKuvxGzmud6jEXo7aelo58jw9JTxLdcObAeN7JlxFFegXZeBPcFejn+gOVOnmhxQV
	 mntcz2QfPgQ2tw5a7cbYFaYqDHsxEq3hqafMeHmMuYkdBcWv/uw/SbivFe3QmEWYh1
	 2xZ1/nGpf6gH4lFUxgU7UteoGIB2pIk1DDiaqqwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 031/156] net: cxgb3_main: disable napi when bind qsets failed in cxgb_up()
Date: Wed, 23 Nov 2022 09:49:48 +0100
Message-Id: <20221123084559.080436031@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
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

[ Upstream commit d75aed1428da787cbe42bc073d76f1354f364d92 ]

When failed to bind qsets in cxgb_up() for opening device, napi isn't
disabled. When open cxgb3 device next time, it will trigger a BUG_ON()
in napi_enable(). Compile tested only.

Fixes: 48c4b6dbb7e2 ("cxgb3 - fix port up/down error path")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Link: https://lore.kernel.org/r/20221109021451.121490-1-shaozhengchao@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index 97ff8608f0ab..b0fd22cbeef4 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -1303,6 +1303,7 @@ static int cxgb_up(struct adapter *adap)
 		if (ret < 0) {
 			CH_ERR(adap, "failed to bind qsets, err %d\n", ret);
 			t3_intr_disable(adap);
+			quiesce_rx(adap);
 			free_irq_resources(adap);
 			err = ret;
 			goto out;
-- 
2.35.1



