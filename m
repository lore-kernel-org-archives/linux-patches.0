Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F83C13CA9B;
	Tue, 14 May 2024 10:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683489; cv=none; b=nLWYw7D4/6LBwfHkdRTm5ElwOlyTgqSJworNqerXqI5tlAgJJPSuaR6zQc+BqATNbaQFENtuZLLZvX8wXmr+6KD5kt0bCFW+yeCgVGiMM5MgeQxoAxmjnRP/WoEDTCX4zeSP8/3rI+1lWW1uhMRj5Hs9ZW6zMqkKOdcMSiu60e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683489; c=relaxed/simple;
	bh=b3d3TAcbFiDN4QEh1uJqweYF7uyfu3EYxXoLC11gAMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lgKFElaejlmwhpKqbWQiQnTlJqK4YDxYd/EQHJLGJ2FcMfHcAmEyaHe2WmIh7l/oVMEwzp4EDF4XfAiXZSElk9/zu4H+l7x95d1V/FOQPCwb+rcncAvXY97sntc7uUY4MPRa9EBHrVL1OlR7hTvYCdtSehxnPk6v4yft53SMpao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YJMR5U+Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YJMR5U+Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D30C2BD10;
	Tue, 14 May 2024 10:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683489;
	bh=b3d3TAcbFiDN4QEh1uJqweYF7uyfu3EYxXoLC11gAMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YJMR5U+Yk+OLmhAekb1/09o3InDBpm7H938kYKAfEz8i6hLGI4HC8QnuS/fp9teuL
	 NmzMxQzNI/m6bxnQioV1FOWU+O6TJa2zMUiiyn155ft3qvrQGMx64Mis56BT0JS6IO
	 xevtGGZCljhBfi+A84WmRlNwAlV6Lv0bWAh5ciBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Shen <shenjian15@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 227/336] net: hns3: direct return when receive a unknown mailbox message
Date: Tue, 14 May 2024 12:17:11 +0200
Message-ID: <20240514101047.186185510@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 4b0d07ca2505e..a44659906ca0e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -1077,12 +1077,13 @@ static void hclge_mbx_request_handling(struct hclge_mbx_ops_param *param)
 
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



