Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D9FA36C595;
	Wed,  3 Dec 2025 16:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779514; cv=none; b=h+0nC4MukgMpGYfqjwZfLwTnlQCqNDzh8kl4ApUHglVEsGiMuUaAEPLmhRvV+HAfbPIgCESVFY64MbE9TN2oTyBlA0Q+uldj1T3sE4xEH8x3GEuKLa7R/ru7YsSKLl61hYyBKuBw3si+4uFzM/8wqKuI6YqqiCupyIXYtfjUdVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779514; c=relaxed/simple;
	bh=u8+Nz44Sk8SrNdAZrLbcLcpqcWEhEUMymUzf5G4UtYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tnOl6Sb39QnYrabxvwLFIddApDs0DK7uK6c5RmGbq0cnn/NS7FPptxd8BckhrzuktreNRMtgLeMSZKxPxA2E9GGdh60iNI3KLSZk9hv/jig7DRCq1jiOSnhIm9bTHNxKIKbOawRoJC0QZ0biYSTkXriQraCj2QBY5VH06S5WPqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EOReKDbq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EOReKDbq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D12BC16AAE;
	Wed,  3 Dec 2025 16:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779514;
	bh=u8+Nz44Sk8SrNdAZrLbcLcpqcWEhEUMymUzf5G4UtYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EOReKDbqFo6ww8YhpQ/WrJavPIzEHKZoI9VSMHX9HJyRI9iAbEV0Bk00Z89N83KVe
	 7CPPlZY95Z3eHzGuERkUTlXtmM1cnuCQ4OHIZtsS2LktT9qocFgJ+s1D2fqLPKrHCF
	 lQKnJSVMPMaUkr1KPzFcDMcQk+KbyXICf9OVD8t8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wenglianfa <wenglianfa@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 278/568] RDMA/hns: Fix the modification of max_send_sge
Date: Wed,  3 Dec 2025 16:24:40 +0100
Message-ID: <20251203152450.891034792@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0f0351abe9b46..72787ff924f44 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -661,7 +661,6 @@ static int set_user_sq_size(struct hns_roce_dev *hr_dev,
 
 	hr_qp->sq.wqe_shift = ucmd->log_sq_stride;
 	hr_qp->sq.wqe_cnt = cnt;
-	cap->max_send_sge = hr_qp->sq.max_gs;
 
 	return 0;
 }
@@ -743,7 +742,6 @@ static int set_kernel_sq_size(struct hns_roce_dev *hr_dev,
 
 	/* sync the parameters of kernel QP to user's configuration */
 	cap->max_send_wr = cnt;
-	cap->max_send_sge = hr_qp->sq.max_gs;
 
 	return 0;
 }
-- 
2.51.0



