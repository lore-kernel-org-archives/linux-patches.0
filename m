Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042A4F9D4;
	Tue, 14 May 2024 11:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687833; cv=none; b=G0wSMQHCf3o0YnlgdWbqo+T+IEyOPlKgg3y8Op8wHs/6w0oD2MbOLsySYlNGbVeUAbVDbsn7PavWWBIngVtw+gmOhwZj2j33LyjvQOIIi2MpCdDIAmGfCO8ZW7Mf1ccTkyXhrmYRHKJ9mztp00kTX/R6ZjZ7i5gSNCPOazyxA0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687833; c=relaxed/simple;
	bh=mUifP0VmbJSDyIy/TngXR7fdJqBHdJxO7YsLqRmEEfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W4P1R4r4tEk0e79ga6tCHGBa2rDRJoaZCS4FNUnLZA5beYbOgORb+PdsBOf1qlej4IwK880BTOyuSHrk3SjsL6iFc8cz1PINDrg+5hhT8LtGsSEEDPIYivWrabkWv4Rqw2ymuilNw3PG1t1xK7sg4RoZCJOqFqckBtG3R4qHueE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vV2onAsR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vV2onAsR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E55CC2BD10;
	Tue, 14 May 2024 11:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687832;
	bh=mUifP0VmbJSDyIy/TngXR7fdJqBHdJxO7YsLqRmEEfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vV2onAsR8ORjg/WDm4t3j8Sli1cHAf967JiOq0wLDySlWczSA5xJ1+1xiD4vgheo6
	 NmOh1LbJEVG/RpOXCHVTDfV3OopSpVJpKrnY8Nzd6RbKxLAzfcnCPAVXjRvDW1VBzN
	 +tbiWyrI7QlCDUH/g62hFMNnxqszHYR94L0+WRlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Shen <shenjian15@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 121/168] net: hns3: direct return when receive a unknown mailbox message
Date: Tue, 14 May 2024 12:20:19 +0200
Message-ID: <20240514101011.251865580@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

[ Upstream commit 669554c512d2107e2f21616f38e050d40655101f ]

Currently, the driver didn't return when receive a unknown
mailbox message, and continue checking whether need to
generate a response. It's unnecessary and may be incorrect.

Fixes: bb5790b71bad ("net: hns3: refactor mailbox response scheme between PF and VF")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 39848bcd77c75..1bd3d6056163b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -1019,12 +1019,13 @@ static void hclge_mbx_request_handling(struct hclge_mbx_ops_param *param)
 
 	hdev = param->vport->back;
 	cmd_func = hclge_mbx_ops_list[param->req->msg.code];
-	if (cmd_func)
-		ret = cmd_func(param);
-	else
+	if (!cmd_func) {
 		dev_err(&hdev->pdev->dev,
 			"un-supported mailbox message, code = %u\n",
 			param->req->msg.code);
+		return;
+	}
+	ret = cmd_func(param);
 
 	/* PF driver should not reply IMP */
 	if (hnae3_get_bit(param->req->mbx_need_resp, HCLGE_MBX_NEED_RESP_B) &&
-- 
2.43.0



