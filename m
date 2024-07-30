Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8631A618F;
	Tue, 30 Jul 2024 16:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357912; cv=none; b=RlhxuAp9Lr3gB/pBO9Il+6UXgeLHbwFGku3nN/MQBqiKsZXCXTNpfA5AUHHbKNarOq2Wfeq3ciNZ0wXZ43podigV5uN+3L4bkJRALWciKiHdqSTPJsyY7MemEOALt9dwwPmw/QmNX4VoUcX2cuygwFmt9eemdw8/Pk2yLWmDQaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357912; c=relaxed/simple;
	bh=C7CpdqVBoL6NzpgFnlgRoH7EIGt2fbBzxEtmPEk3XYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TtXbUFsr1CqygNNEXFJ33l25va9VGGMJpcXN7b/yr0o4iDwapLvoQ4c6pMogls0oYRX7zoKGl+Me/MYDk98OuoHUnQR2rvUeRZfReV4IhsKYiJDdjlORCFHT4HgKPZNhj1yfhWkdZh4J34FXZS7498eqSINhAwRNFRWR3GlFAtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GK9rGkPi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GK9rGkPi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D35C32782;
	Tue, 30 Jul 2024 16:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357911;
	bh=C7CpdqVBoL6NzpgFnlgRoH7EIGt2fbBzxEtmPEk3XYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GK9rGkPiybI+G+w2s9A551P+l53epRt3+I5YZNFDJWzu3m5jHap3nzdw6ln+ndUlB
	 0bESSJSEqN+d0mZZm8s0LllJF5iSoPq0IcntNv+5x1ia3ilYFTPMsHc9/A5/Nm+XF9
	 GeispY3odOVt+y3z4tL7u7p9RKznSUR3gw2Bgc/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 303/568] RDMA/hns: Fix undifined behavior caused by invalid max_sge
Date: Tue, 30 Jul 2024 17:46:50 +0200
Message-ID: <20240730151651.717584334@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit 36397b907355e2fdb5a25a02a7921a937fd8ef4c ]

If max_sge has been set to 0, roundup_pow_of_two() in
set_srq_basic_param() may have undefined behavior.

Fixes: 9dd052474a26 ("RDMA/hns: Allocate one more recv SGE for HIP08")
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://lore.kernel.org/r/20240710133705.896445-7-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_srq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_srq.c b/drivers/infiniband/hw/hns/hns_roce_srq.c
index 6a4923c21cbc6..727f926500712 100644
--- a/drivers/infiniband/hw/hns/hns_roce_srq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_srq.c
@@ -296,7 +296,7 @@ static int set_srq_basic_param(struct hns_roce_srq *srq,
 
 	max_sge = proc_srq_sge(hr_dev, srq, !!udata);
 	if (attr->max_wr > hr_dev->caps.max_srq_wrs ||
-	    attr->max_sge > max_sge) {
+	    attr->max_sge > max_sge || !attr->max_sge) {
 		ibdev_err(&hr_dev->ib_dev,
 			  "invalid SRQ attr, depth = %u, sge = %u.\n",
 			  attr->max_wr, attr->max_sge);
-- 
2.43.0



