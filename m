Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF3F3C467;
	Tue, 14 May 2024 11:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686526; cv=none; b=buJOv9S88Q8YSpVUB4XVFKUrGvRcHM9lqHYnI+PtzpradsPjjfQd26avcLQnMZg+WWbD7Fe8UTARcLqYohusolPsBCbxAOG/HCO1nQEz0gWgBeAvTaxEUJBvmwVzmwsQZJJbNMl6fK5H158Cq5wGBcA9NOoYmurnJjSban/bMqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686526; c=relaxed/simple;
	bh=G0LJjG2S5LKK8u73f0xJBJPpX4J4dCHjKHQs2YB8hDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F0jEW1YAPBvmIpw7mW/YVS5VXFNGDrgBszvBsA4PfdQN2Lg65UkF53ASnvPgzaLms+RScpU/Zz8OtZ+sm83FNsyCjexG5myvrlhbYOGFclSZW5c9wM++C1EskDaY6wF9vFes8nEBRdxVqG3pwphtyx0NIigLKXvQq0KKm+YbqCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=doKVufjM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="doKVufjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145E4C2BD10;
	Tue, 14 May 2024 11:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686526;
	bh=G0LJjG2S5LKK8u73f0xJBJPpX4J4dCHjKHQs2YB8hDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=doKVufjMYE5det3Ha0nFRTUz0OIRvNmnFdgZ+iT6Kc4g/5B/1APvGe4yaqlD9VwTb
	 jz2Lwd2rZV9U75lFWE3q1K0UpvnTzvwUclq1EsGr2t/PLLrmIQWIPPHiNmtOh3hP5j
	 hirrmnLi0DFwt0XymB2JykBgY+nANaMvPJJ1XSX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Shen <shenjian15@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 168/236] net: hns3: direct return when receive a unknown mailbox message
Date: Tue, 14 May 2024 12:18:50 +0200
Message-ID: <20240514101026.738022481@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 04ff9bf121853..877feee53804f 100644
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



