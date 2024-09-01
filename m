Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E0244393;
	Sun,  1 Sep 2024 16:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209548; cv=none; b=Fr7jPfpZm8GfX6KdwkCHvIYSSWPbXWxAaKYT7K9Gn7PxGRgVoZvghMm0ZlBuW91d3p/KRoLsnfwu/5aWsdFYjFQrDILF1zL1Zd3CU/WowhQGwPF7Qwq5IDrMREeffrBVeABmJfzFOqrakkxlBfZnoVyRZW8xku7SvMPMIKEaeoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209548; c=relaxed/simple;
	bh=EGLlrjWZUk/Iox/sBz4k0mmXd03SwEqpZPHhzdCMv34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rL67zrVnsM7xShMB16xIy+UhNyPCkMAQ+vzk4BKTvg94ZEyXpFcb2pfHR2QixaHb7BQEieu8lsFjW/R7w5erdQ4O/ahvj7I8ezfdduF1SbwFMcTpzyKqekBA8goHzI0ihxrLmxkwO0Vv5MCkaTo2NNq/zGAov+cCGN2njFpPCQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vHqd7YRw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vHqd7YRw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 176E2C4CEC3;
	Sun,  1 Sep 2024 16:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209547;
	bh=EGLlrjWZUk/Iox/sBz4k0mmXd03SwEqpZPHhzdCMv34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vHqd7YRwSpCaw1Vahw6sAYCoBIf7SjComPJeat6JbJLqy9PpVmBJQbT5uld6o90/R
	 BlmjotfFXeJmyP1IeM0Hg93et6DOdcMxqRKIBN9DQAfOoo5wbz5UrsQDSBZNR1m59e
	 t+y6UbZdZydkDUcETuNZLcnCjM6VR1WPG2/fXVVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Shen <shenjian15@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Sunil Goutham <sgoutham@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 071/151] net: hns3: add checking for vf id of mailbox
Date: Sun,  1 Sep 2024 18:17:11 +0200
Message-ID: <20240901160816.787219728@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 4e2969a0d6a7549bc0bc1ebc990588b622c4443d ]

Add checking for vf id of mailbox, in order to avoid array
out-of-bounds risk.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 51b7b46f2f309..9969714d1133d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -715,10 +715,11 @@ void hclge_mbx_handler(struct hclge_dev *hdev)
 		req = (struct hclge_mbx_vf_to_pf_cmd *)desc->data;
 
 		flag = le16_to_cpu(crq->desc[crq->next_to_use].flag);
-		if (unlikely(!hnae3_get_bit(flag, HCLGE_CMDQ_RX_OUTVLD_B))) {
+		if (unlikely(!hnae3_get_bit(flag, HCLGE_CMDQ_RX_OUTVLD_B) ||
+			     req->mbx_src_vfid > hdev->num_req_vfs)) {
 			dev_warn(&hdev->pdev->dev,
-				 "dropped invalid mailbox message, code = %u\n",
-				 req->msg.code);
+				 "dropped invalid mailbox message, code = %u, vfid = %u\n",
+				 req->msg.code, req->mbx_src_vfid);
 
 			/* dropping/not processing this invalid message */
 			crq->desc[crq->next_to_use].flag = 0;
-- 
2.43.0



