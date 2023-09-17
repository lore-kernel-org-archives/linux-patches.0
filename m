Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A63746F
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:39:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A70F8C433C8;
	Sun, 17 Sep 2023 20:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694983151;
	bh=ioaW6UywnqBUDQ8gYelRgkdnGAleZi1nrag+zz21NOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hsd5Oax3lcFwLPs0erZPxPiYttWXP/Wv5Yy/5YdCzKUG+sRMsGFRBOZMuOYXx4ITV
	 407rN+fyVIFVH/C3hg+Yn9khW6KLp5nl9leHJCA41VAOkOHdC9yzuKSXk8AmJ2Sdiw
	 c5QkPwjATcoaS1m90G8CF3HnCHsHb45zoK6iRhTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Chen <chenhao418@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 457/511] net: hns3: fix byte order conversion issue in hclge_dbg_fd_tcam_read()
Date: Sun, 17 Sep 2023 21:14:44 +0200
Message-ID: <20230917191124.791289697@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao Chen <chenhao418@huawei.com>

[ Upstream commit efccf655e99b6907ca07a466924e91805892e7d3 ]

req1->tcam_data is defined as "u8 tcam_data[8]", and we convert it as
(u32 *) without considerring byte order conversion,
it may result in printing wrong data for tcam_data.

Convert tcam_data to (__le32 *) first to fix it.

Fixes: b5a0b70d77b9 ("net: hns3: refactor dump fd tcam of debugfs")
Signed-off-by: Hao Chen <chenhao418@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index dd8b73aebe6a5..63665e8a7c718 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -1450,7 +1450,7 @@ static int hclge_dbg_fd_tcam_read(struct hclge_dev *hdev, bool sel_x,
 	struct hclge_desc desc[3];
 	int pos = 0;
 	int ret, i;
-	u32 *req;
+	__le32 *req;
 
 	hclge_cmd_setup_basic_desc(&desc[0], HCLGE_OPC_FD_TCAM_OP, true);
 	desc[0].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
@@ -1475,22 +1475,22 @@ static int hclge_dbg_fd_tcam_read(struct hclge_dev *hdev, bool sel_x,
 			 tcam_msg.loc);
 
 	/* tcam_data0 ~ tcam_data1 */
-	req = (u32 *)req1->tcam_data;
+	req = (__le32 *)req1->tcam_data;
 	for (i = 0; i < 2; i++)
 		pos += scnprintf(tcam_buf + pos, HCLGE_DBG_TCAM_BUF_SIZE - pos,
-				 "%08x\n", *req++);
+				 "%08x\n", le32_to_cpu(*req++));
 
 	/* tcam_data2 ~ tcam_data7 */
-	req = (u32 *)req2->tcam_data;
+	req = (__le32 *)req2->tcam_data;
 	for (i = 0; i < 6; i++)
 		pos += scnprintf(tcam_buf + pos, HCLGE_DBG_TCAM_BUF_SIZE - pos,
-				 "%08x\n", *req++);
+				 "%08x\n", le32_to_cpu(*req++));
 
 	/* tcam_data8 ~ tcam_data12 */
-	req = (u32 *)req3->tcam_data;
+	req = (__le32 *)req3->tcam_data;
 	for (i = 0; i < 5; i++)
 		pos += scnprintf(tcam_buf + pos, HCLGE_DBG_TCAM_BUF_SIZE - pos,
-				 "%08x\n", *req++);
+				 "%08x\n", le32_to_cpu(*req++));
 
 	return ret;
 }
-- 
2.40.1



