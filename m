Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9097B
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 08:53:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B646C433C1;
	Wed, 23 Nov 2022 08:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669193597;
	bh=0j001YFAcghLDoEGQe4uCu9JDJ39LdCq9HR75CkG+G4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PlxvlMwAxYyylJP7foqE2NAnZjXE/w46p68oDQVJkw37O4IzeSPt9seWH/TCm0BWa
	 fuUSpiPSKqFYGA6YSynolDKGbZCGPVYem1U63Eha4SvkReVadTx3YJcd7StgRsUgFt
	 WCA70acDgkPmczK6TmQW8mx+GlJdaOxuglIlebd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 12/76] net: cxgb3_main: disable napi when bind qsets failed in cxgb_up()
Date: Wed, 23 Nov 2022 09:50:11 +0100
Message-Id: <20221123084547.137876252@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084546.742331901@linuxfoundation.org>
References: <20221123084546.742331901@linuxfoundation.org>
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
index 9627ed0b2f1c..6d08fd3284dc 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -1304,6 +1304,7 @@ static int cxgb_up(struct adapter *adap)
 		if (ret < 0) {
 			CH_ERR(adap, "failed to bind qsets, err %d\n", ret);
 			t3_intr_disable(adap);
+			quiesce_rx(adap);
 			free_irq_resources(adap);
 			err = ret;
 			goto out;
-- 
2.35.1



