Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9B39446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:41:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA719C433C7;
	Sun, 13 Aug 2023 21:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962904;
	bh=Xn4wft8C5bKjuHLMzVzPBIvTfjdZS7z9V64uGcytKQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QGN7eTBljeuUiErpCL7yUxBsM/IV5sS0s4ArkKT908P3MSLgBhMlMQ7C2H9n6EOJt
	 8fJy6cneZma9nuLsdhD/dMZknmMQvmmiSBemyxRPsRTWuQ4p/AHEwu65eLqyM7gpXT
	 hICqMbk9jwozbhQUM2iZQ8g7PjvaECoKRymBuAdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Wang <wangjie125@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 49/68] net: hns3: add wait until mac link down
Date: Sun, 13 Aug 2023 23:19:50 +0200
Message-ID: <20230813211709.641792836@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211708.149630011@linuxfoundation.org>
References: <20230813211708.149630011@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jie Wang <wangjie125@huawei.com>

commit 6265e242f7b95f2c1195b42ec912b84ad161470e upstream.

In some configure flow of hns3 driver, for example, change mtu, it will
disable MAC through firmware before configuration. But firmware disables
MAC asynchronously. The rx traffic may be not stopped in this case.

So fixes it by waiting until mac link is down.

Fixes: a9775bb64aa7 ("net: hns3: fix set and get link ksettings issue")
Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/20230807113452.474224-4-shaojijie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -6560,6 +6560,8 @@ static void hclge_enable_fd(struct hnae3
 
 static void hclge_cfg_mac_mode(struct hclge_dev *hdev, bool enable)
 {
+#define HCLGE_LINK_STATUS_WAIT_CNT  3
+
 	struct hclge_desc desc;
 	struct hclge_config_mac_mode_cmd *req =
 		(struct hclge_config_mac_mode_cmd *)desc.data;
@@ -6584,9 +6586,15 @@ static void hclge_cfg_mac_mode(struct hc
 	req->txrx_pad_fcs_loop_en = cpu_to_le32(loop_en);
 
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-	if (ret)
+	if (ret) {
 		dev_err(&hdev->pdev->dev,
 			"mac enable fail, ret =%d.\n", ret);
+		return;
+	}
+
+	if (!enable)
+		hclge_mac_link_status_wait(hdev, HCLGE_LINK_STATUS_DOWN,
+					   HCLGE_LINK_STATUS_WAIT_CNT);
 }
 
 static int hclge_config_switch_param(struct hclge_dev *hdev, int vfid,


