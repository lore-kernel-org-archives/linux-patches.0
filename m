Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B651D559
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I8GQysnL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C20C433C8;
	Wed,  4 Oct 2023 18:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443993;
	bh=U0fL5oWlLlJVw8xqfmTx8wzqt2U4d2ZQyBg9z8fKsF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I8GQysnLMSW87q+Vb2P0mjfQIqLRBGsS7jG8coG8t/a8y3kCQHn1qyl4PkWIw/4rU
	 c2PKwXxyRRhuI6vnBbrdj02wVPEqRXjZfQS+KOd7fj2vxBmL4PQ8GfxLZiYl/paVcS
	 Syl98qTnMWWX/iGZrRf0U/SuHbHxLFTT506aImfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jijie Shao <shaojijie@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 085/321] net: hns3: fix fail to delete tc flower rules during reset issue
Date: Wed,  4 Oct 2023 19:53:50 +0200
Message-ID: <20231004175233.150888655@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
index 26e9fa9cc2cd3..a4500abfa286f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -7348,6 +7348,12 @@ static int hclge_del_cls_flower(struct hnae3_handle *handle,
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



