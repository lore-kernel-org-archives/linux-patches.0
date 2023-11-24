Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769271A5A4;
	Fri, 24 Nov 2023 19:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t9PD9rxH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8949DC433C8;
	Fri, 24 Nov 2023 19:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853289;
	bh=pTh2y9HaRBkry3WNbg2nbYPMBxLnf/agbA6BQhArCJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t9PD9rxHQJQkHPXpBcWXLhMknWXg4MDEyFB8MXRVvKcOzqLIgWZ3FKN/zR5peFQ5p
	 Amk2NRcIPecOVYT2Ujw3LqKUbw1M+iGFdjq7K98aMdNYCUwZp8qpYWXgIAs+UkQDtA
	 QJ26QqsMPN7dRWt6fxXa4W5Q4RSEeog+Pe3XhMu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Shen <shenjian15@huawei.com>,
	Guangbin Huang <huangguangbin2@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 105/297] net: hns3: refine the definition for struct hclge_pf_to_vf_msg
Date: Fri, 24 Nov 2023 17:52:27 +0000
Message-ID: <20231124172003.946568433@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
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

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 6fde96df0447a29ab785de4fcb229e5543f0cbf7 ]

The struct hclge_pf_to_vf_msg is used for mailbox message from
PF to VF, including both response and request. But its definition
can only indicate respone, which makes the message data copy in
function hclge_send_mbx_msg() unreadable. So refine it by edding
a general message definition into it.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: ac92c0a9a060 ("net: hns3: add barrier in vf mailbox reply process")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h | 17 +++++++++++++----
 .../ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c  |  2 +-
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
index c2bd2584201f8..c4603a70ed60b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
@@ -132,10 +132,19 @@ struct hclge_vf_to_pf_msg {
 
 struct hclge_pf_to_vf_msg {
 	u16 code;
-	u16 vf_mbx_msg_code;
-	u16 vf_mbx_msg_subcode;
-	u16 resp_status;
-	u8 resp_data[HCLGE_MBX_MAX_RESP_DATA_SIZE];
+	union {
+		/* used for mbx response */
+		struct {
+			u16 vf_mbx_msg_code;
+			u16 vf_mbx_msg_subcode;
+			u16 resp_status;
+			u8 resp_data[HCLGE_MBX_MAX_RESP_DATA_SIZE];
+		};
+		/* used for general mbx */
+		struct {
+			u8 msg_data[HCLGE_MBX_MAX_MSG_SIZE];
+		};
+	};
 };
 
 struct hclge_mbx_vf_to_pf_cmd {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 4a5b11b6fed3f..dac4ac425481c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -108,7 +108,7 @@ static int hclge_send_mbx_msg(struct hclge_vport *vport, u8 *msg, u16 msg_len,
 	resp_pf_to_vf->msg_len = msg_len;
 	resp_pf_to_vf->msg.code = mbx_opcode;
 
-	memcpy(&resp_pf_to_vf->msg.vf_mbx_msg_code, msg, msg_len);
+	memcpy(resp_pf_to_vf->msg.msg_data, msg, msg_len);
 
 	trace_hclge_pf_mbx_send(hdev, resp_pf_to_vf);
 
-- 
2.42.0



