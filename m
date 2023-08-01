Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490051F959
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:34:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE051C433C9;
	Tue,  1 Aug 2023 09:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882461;
	bh=hTy8gvcqHTFIoR8SGIscVUuFWrZynvdlb0lZ1Lc9OCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CBh1Hg820Q5qsXRZ6+yvpkfnjoD0Bb0l4SeFRME4rG50AUfTYedFbVLvWbnAePogZ
	 Ut4SKq38sswkSUpbacE9/cA0i/9jWB5DPMHBTY+ucR5YYqP4IDBMNoDgF6LG0AsKPA
	 p6Vbaa83mfgDtZaZqcocVIbkgaPEwyug1qT6kqYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Lan <lanhao@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 085/228] net: hns3: fix the imp capability bit cannot exceed 32 bits issue
Date: Tue,  1 Aug 2023 11:19:03 +0200
Message-ID: <20230801091925.925237763@linuxfoundation.org>
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

From: Hao Lan <lanhao@huawei.com>

[ Upstream commit b27d0232e8897f7c896dc8ad80c9907dd57fd3f3 ]

Current only the first 32 bits of the capability flag bit are considered.
When the matching capability flag bit is greater than 31 bits,
it will get an error bit.This patch use bitmap to solve this issue.
It can handle each capability bit whitout bit width limit.

Fixes: da77aef9cc58 ("net: hns3: create common cmdq resource allocate/free/query APIs")
Signed-off-by: Hao Lan <lanhao@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  3 ++-
 .../hns3/hns3_common/hclge_comm_cmd.c         | 21 ++++++++++++++++---
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 17137de9338cf..fcb8b6dc5ab92 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -31,6 +31,7 @@
 #include <linux/pci.h>
 #include <linux/pkt_sched.h>
 #include <linux/types.h>
+#include <linux/bitmap.h>
 #include <net/pkt_cls.h>
 
 #define HNAE3_MOD_VERSION "1.0"
@@ -402,7 +403,7 @@ struct hnae3_ae_dev {
 	unsigned long hw_err_reset_req;
 	struct hnae3_dev_specs dev_specs;
 	u32 dev_version;
-	unsigned long caps[BITS_TO_LONGS(HNAE3_DEV_CAPS_MAX_NUM)];
+	DECLARE_BITMAP(caps, HNAE3_DEV_CAPS_MAX_NUM);
 	void *priv;
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
index c797d54f98caa..2ccb0f5460797 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
@@ -170,6 +170,20 @@ static const struct hclge_comm_caps_bit_map hclge_vf_cmd_caps[] = {
 	{HCLGE_COMM_CAP_GRO_B, HNAE3_DEV_SUPPORT_GRO_B},
 };
 
+static void
+hclge_comm_capability_to_bitmap(unsigned long *bitmap, __le32 *caps)
+{
+	const unsigned int words = HCLGE_COMM_QUERY_CAP_LENGTH;
+	u32 val[HCLGE_COMM_QUERY_CAP_LENGTH];
+	unsigned int i;
+
+	for (i = 0; i < words; i++)
+		val[i] = __le32_to_cpu(caps[i]);
+
+	bitmap_from_arr32(bitmap, val,
+			  HCLGE_COMM_QUERY_CAP_LENGTH * BITS_PER_TYPE(u32));
+}
+
 static void
 hclge_comm_parse_capability(struct hnae3_ae_dev *ae_dev, bool is_pf,
 			    struct hclge_comm_query_version_cmd *cmd)
@@ -178,11 +192,12 @@ hclge_comm_parse_capability(struct hnae3_ae_dev *ae_dev, bool is_pf,
 				is_pf ? hclge_pf_cmd_caps : hclge_vf_cmd_caps;
 	u32 size = is_pf ? ARRAY_SIZE(hclge_pf_cmd_caps) :
 				ARRAY_SIZE(hclge_vf_cmd_caps);
-	u32 caps, i;
+	DECLARE_BITMAP(caps, HCLGE_COMM_QUERY_CAP_LENGTH * BITS_PER_TYPE(u32));
+	u32 i;
 
-	caps = __le32_to_cpu(cmd->caps[0]);
+	hclge_comm_capability_to_bitmap(caps, cmd->caps);
 	for (i = 0; i < size; i++)
-		if (hnae3_get_bit(caps, caps_map[i].imp_bit))
+		if (test_bit(caps_map[i].imp_bit, caps))
 			set_bit(caps_map[i].local_bit, ae_dev->caps);
 }
 
-- 
2.39.2



