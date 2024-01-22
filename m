Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F8762807;
	Tue, 23 Jan 2024 00:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971213; cv=none; b=VSGotXjcB/bv16ZwJF+tz5ZTUGAJFxB4YcGTs5Op8NVKe4uEz3co8DsWUjD8N8a2AtWl2zi0JzIwCH+bz60I+MaSIsdBn7C3R1lllTRYrTjDXDEHbERpIQcNpUim+z5YK2F6Gsfh1KTav02UzGJXB8RbG4UY9t58dQ+h+AUgm5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971213; c=relaxed/simple;
	bh=YOC1xYfbhCbM2QJsbKk0BU6OP8XBr70VecR5eIqrGdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l+Md4mqsvev7st8p+bwd3orEmKUiXfpuAoSrA5vVhYKuWKp3/JXe7OAqEaQWvW8LYgSU6N/b3Lk8McTqS1DqgiO+kMYIoqsUFFz4n8E6YLm/sTphM4k0ycUgiNfK+ZruAqy9Sr1xZfLWujkpPPgbz65tdg4eCrpuiOEzBrcrdJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cfDDhuAo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cfDDhuAo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C116DC433F1;
	Tue, 23 Jan 2024 00:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971212;
	bh=YOC1xYfbhCbM2QJsbKk0BU6OP8XBr70VecR5eIqrGdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cfDDhuAooJmq0sBHSyc+Cf1wItQrzmV55pThwPrA2M+B/wiKEORB27xMRh1396DOK
	 Phi7K3dCvu4TRmaA40O0bUsN79kVewzo3w+M4XwpPYbqv8lDad7CfHijMl73ChI/Zy
	 qnobebNDiuxnIlpUHyEe5TFB0XoSwpEb8RwdFrqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 192/417] RDMA/hns: Fix memory leak in free_mr_init()
Date: Mon, 22 Jan 2024 15:56:00 -0800
Message-ID: <20240122235758.574456568@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit 288f535951aa81ed674f5e5477ab11b9d9351b8c ]

When a reserved QP fails to be created, the memory of the remaining
created reserved QPs is leaked.

Fixes: 70f92521584f ("RDMA/hns: Use the reserved loopback QPs to free MR before destroying MPT")
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://lore.kernel.org/r/20231207114231.2872104-6-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 280a3458bb53..58fbb1d3b7f4 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -2819,6 +2819,10 @@ static int free_mr_alloc_res(struct hns_roce_dev *hr_dev)
 	return 0;
 
 create_failed_qp:
+	for (i--; i >= 0; i--) {
+		hns_roce_v2_destroy_qp(&free_mr->rsv_qp[i]->ibqp, NULL);
+		kfree(free_mr->rsv_qp[i]);
+	}
 	hns_roce_destroy_cq(cq, NULL);
 	kfree(cq);
 
-- 
2.43.0



