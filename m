Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088AA1F959
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:34:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC56C433C8;
	Tue,  1 Aug 2023 09:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882463;
	bh=6CH7UG6S5g1k94W3g6/7SX/XdWLR1XYy4Hj/A327TMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gYaXnB2IgBxOBgRsuKTizOLLXoZgIPDSwl2vGGZskFN0AvKvCtSilkyc/2vQYJMED
	 fBs7IJSOtegGRgWyWZnyrbwrF1LtM6h8Q80MjbpfGuPTvix5N361z8TpabmQQdH6EX
	 Z7ENXAIe6qk+DcuO+iRil0x11zSRTJ0ASxo1RHts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jijie Shao <shaojijie@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 086/228] net: hns3: fix wrong tc bandwidth weight data issue
Date: Tue,  1 Aug 2023 11:19:04 +0200
Message-ID: <20230801091925.965376699@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jijie Shao <shaojijie@huawei.com>

[ Upstream commit 116d9f732eef634abbd871f2c6f613a5b4677742 ]

Currently, the weight saved by the driver is used as the query result,
which may be different from the actual weight in the register.
Therefore, the register value read from the firmware is used
as the query result

Fixes: 0e32038dc856 ("net: hns3: refactor dump tc of debugfs")
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 0ebc21401b7c2..726062e512939 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -692,8 +692,7 @@ static int hclge_dbg_dump_tc(struct hclge_dev *hdev, char *buf, int len)
 	for (i = 0; i < HNAE3_MAX_TC; i++) {
 		sch_mode_str = ets_weight->tc_weight[i] ? "dwrr" : "sp";
 		pos += scnprintf(buf + pos, len - pos, "%u     %4s    %3u\n",
-				 i, sch_mode_str,
-				 hdev->tm_info.pg_info[0].tc_dwrr[i]);
+				 i, sch_mode_str, ets_weight->tc_weight[i]);
 	}
 
 	return 0;
-- 
2.39.2



