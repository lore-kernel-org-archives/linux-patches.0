Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5DD1D523
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:03:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F198DC433C7;
	Wed,  4 Oct 2023 18:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696442638;
	bh=Abpu5REp4KYZXTajoqG88Fn5gnqEXSF7rJ456mI8CcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MTmUqUm/M7QPdfZHOfuqhapcHjs8aPafBmtITlOrD8oyutkJqQhqzYdI6HO+Cdhx0
	 sU53+x5qRUcc4S9+ivye9E68RfGNrNW7zf01sFn3lVAerY/G7Ru3m5SHvT86ZjAfJE
	 DNGfLp4KUzWabfUYlFWfubUoN5zijibG7Rt+ptX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jijie Shao <shaojijie@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 056/183] net: hns3: fix fail to delete tc flower rules during reset issue
Date: Wed,  4 Oct 2023 19:54:47 +0200
Message-ID: <20231004175206.277397610@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175203.943277832@linuxfoundation.org>
References: <20231004175203.943277832@linuxfoundation.org>
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

From: Jijie Shao <shaojijie@huawei.com>

[ Upstream commit 1a7be66e4685b8541546222c305cce9710718a88 ]

Firmware does not respond driver commands during reset
Therefore, rule will fail to delete while the firmware is resetting

So, if failed to delete rule, set rule state to TO_DEL,
and the rule will be deleted when periodic task being scheduled.

Fixes: 0205ec041ec6 ("net: hns3: add support for hw tc offload of tc flower")
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 998ee681b1171..0f522daf8e3ab 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -7546,6 +7546,12 @@ static int hclge_del_cls_flower(struct hnae3_handle *handle,
 	ret = hclge_fd_tcam_config(hdev, HCLGE_FD_STAGE_1, true, rule->location,
 				   NULL, false);
 	if (ret) {
+		/* if tcam config fail, set rule state to TO_DEL,
+		 * so the rule will be deleted when periodic
+		 * task being scheduled.
+		 */
+		hclge_update_fd_list(hdev, HCLGE_FD_TO_DEL, rule->location, NULL);
+		set_bit(HCLGE_STATE_FD_TBL_CHANGED, &hdev->state);
 		spin_unlock_bh(&hdev->fd_rule_lock);
 		return ret;
 	}
-- 
2.40.1



