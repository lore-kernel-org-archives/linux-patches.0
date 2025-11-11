Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC9C30BF66;
	Tue, 11 Nov 2025 01:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824506; cv=none; b=bvsIXbez+yDY2joxnFgOQ6PhHPmbPg5LSihPuFeat3dP5KEAXIOG+DW1AWWeOxVgNVRhN/OYS/zFaWD0E34Yk2cuNSqj1548H7dSlBYbYmIHBzCZn0XkiA569NJBeKpiYdbLh7BmrI+JBckjbhD27JCySPE3TAAaW5huTBHKZpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824506; c=relaxed/simple;
	bh=GJDjOwl/RLse9PcpjRrx5BmgzJADvk3ZAPwDO8ioO9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=An19mhz+ptzobS44oAFpsNtmd+tb1nqRBMgkQYDGomeBFy+4TlmgtIt9a0Ll9wft8OSCrwqqZIzV42WMhfS5X9jljSKaiqhsUw6hUcDgFtue3W+TolChVb4mql3CFFBBXTuF9TnP//MSjdxBSN/F4aIbQ3RHjK4ZT8WR2L/NArQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ywLaJghn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ywLaJghn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27146C4CEFB;
	Tue, 11 Nov 2025 01:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824506;
	bh=GJDjOwl/RLse9PcpjRrx5BmgzJADvk3ZAPwDO8ioO9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ywLaJghn9Smak+Qhiz/lGfVKDtFBlkEqvcrdNM9Puf+DkJNa2H1wlLGeFJjvv5F/G
	 Vev9lcBrlYMnvWeFsOl+dHtVWBPHvmwFXo6Fioo7GIvin9nuMm7JE6ts5yFaomt9vi
	 8ClnmXc7nZXOfGSkp8vEMY7qN1rWFPwkqGgVw+kY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wenglianfa <wenglianfa@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 459/565] RDMA/hns: Fix the modification of max_send_sge
Date: Tue, 11 Nov 2025 09:45:15 +0900
Message-ID: <20251111004537.223227930@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: wenglianfa <wenglianfa@huawei.com>

[ Upstream commit f5a7cbea5411668d429eb4ffe96c4063fe8dac9e ]

The actual sge number may exceed the value specified in init_attr->cap
when HW needs extra sge to enable inline feature. Since these extra
sges are not expected by ULP, return the user-specified value to ULP
instead of the expanded sge number.

Fixes: 0c5e259b06a8 ("RDMA/hns: Fix incorrect sge nums calculation")
Signed-off-by: wenglianfa <wenglianfa@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20251016114051.1963197-3-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_qp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index 8901c142c1b65..66d4c693694e9 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -662,7 +662,6 @@ static int set_user_sq_size(struct hns_roce_dev *hr_dev,
 
 	hr_qp->sq.wqe_shift = ucmd->log_sq_stride;
 	hr_qp->sq.wqe_cnt = cnt;
-	cap->max_send_sge = hr_qp->sq.max_gs;
 
 	return 0;
 }
@@ -744,7 +743,6 @@ static int set_kernel_sq_size(struct hns_roce_dev *hr_dev,
 
 	/* sync the parameters of kernel QP to user's configuration */
 	cap->max_send_wr = cnt;
-	cap->max_send_sge = hr_qp->sq.max_gs;
 
 	return 0;
 }
-- 
2.51.0



