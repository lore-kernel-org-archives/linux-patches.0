Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9975F1FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:44:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18449C433C8;
	Tue,  1 Aug 2023 09:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883049;
	bh=16cfi/g7p/2iMFvSdKJCVLn1kV4PoleEJJK2VL/Upgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C7cmHxTdyM2LHC1i6W6pqVlYDtaCZTynMBUS1Zs4zO8hw2bDG9EapqXE8Xt/Gp/nF
	 4qz8iKvt+LmT3UmTZxk0mrAFEhqXsnImm8FfTIkoXtGYoUecpw/rmeskqi8U6Djwzo
	 Wu2BpifShRAv3+tmK9LdzbnXRwRf/QjY+wWEDruI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jijie Shao <shaojijie@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 068/239] net: hns3: fix wrong tc bandwidth weight data issue
Date: Tue,  1 Aug 2023 11:18:52 +0200
Message-ID: <20230801091928.132892221@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
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
index 233c132dc513e..409db2e709651 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -693,8 +693,7 @@ static int hclge_dbg_dump_tc(struct hclge_dev *hdev, char *buf, int len)
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



