Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8077E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:15:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C33EC433D6;
	Wed,  2 Nov 2022 03:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667358922;
	bh=sOInzPtP8lXgKqDmoe2QjiMo59HXozo9QBb+wiglYG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kVSu+igi8dS2ttAX5X/vVkC6BITc4PCu+4Xwr2c7zkFPq5vifv/g1X4WaSM+UGflI
	 EkmAOmFxxwJ+DWWBhwzmhqwRdBi8Xwo/1FqGxFwfmkHO3gBQDJE5JfD14NCxG/urh5
	 /7KcalmbBXjpOuGFhIwTm57CqgZ2GO7R50nGtJv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 47/91] net: hinic: fix memory leak when reading function table
Date: Wed,  2 Nov 2022 03:33:30 +0100
Message-Id: <20221102022056.364086928@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
References: <20221102022055.039689234@linuxfoundation.org>
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

[ Upstream commit 4c1f602df8956bc0decdafd7e4fc7eef50c550b1 ]

When the input parameter idx meets the expected case option in
hinic_dbg_get_func_table(), read_data is not released. Fix it.

Fixes: 5215e16244ee ("hinic: add support to query function table")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/huawei/hinic/hinic_debugfs.c  | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_debugfs.c b/drivers/net/ethernet/huawei/hinic/hinic_debugfs.c
index 19eb839177ec..061952c6c21a 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_debugfs.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_debugfs.c
@@ -85,6 +85,7 @@ static int hinic_dbg_get_func_table(struct hinic_dev *nic_dev, int idx)
 	struct tag_sml_funcfg_tbl *funcfg_table_elem;
 	struct hinic_cmd_lt_rd *read_data;
 	u16 out_size = sizeof(*read_data);
+	int ret = ~0;
 	int err;
 
 	read_data = kzalloc(sizeof(*read_data), GFP_KERNEL);
@@ -111,20 +112,25 @@ static int hinic_dbg_get_func_table(struct hinic_dev *nic_dev, int idx)
 
 	switch (idx) {
 	case VALID:
-		return funcfg_table_elem->dw0.bs.valid;
+		ret = funcfg_table_elem->dw0.bs.valid;
+		break;
 	case RX_MODE:
-		return funcfg_table_elem->dw0.bs.nic_rx_mode;
+		ret = funcfg_table_elem->dw0.bs.nic_rx_mode;
+		break;
 	case MTU:
-		return funcfg_table_elem->dw1.bs.mtu;
+		ret = funcfg_table_elem->dw1.bs.mtu;
+		break;
 	case RQ_DEPTH:
-		return funcfg_table_elem->dw13.bs.cfg_rq_depth;
+		ret = funcfg_table_elem->dw13.bs.cfg_rq_depth;
+		break;
 	case QUEUE_NUM:
-		return funcfg_table_elem->dw13.bs.cfg_q_num;
+		ret = funcfg_table_elem->dw13.bs.cfg_q_num;
+		break;
 	}
 
 	kfree(read_data);
 
-	return ~0;
+	return ret;
 }
 
 static ssize_t hinic_dbg_cmd_read(struct file *filp, char __user *buffer, size_t count,
-- 
2.35.1



