Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13CB61422B4;
	Thu, 13 Jun 2024 12:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281619; cv=none; b=bDT6M7gBOVLQwHQ/O51P6Go4SjDxK+kWMW1wky4D6pHmzxuV4/9Db0A6+TW4V8gZ8ZVInE1lSHJuaorVYC00uhlMI8hU/TneYbmLZCbWNhHmwmf3lTuz1vuXeC6G8qEjWbkIU3gPbVJBjwGhMuf3bJ/mV0Kb5AcKE7XPh4t3r70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281619; c=relaxed/simple;
	bh=f00dbt03Hp7s6VQYfZVxjHfTvH1puHAIt5Qj0fAlzcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gDG7BpJQuwjEEXF2trSXN8nprzFvnY1K3K7GO1mAtVH8mKd6RQyR6nlLqATBQCXY9YM4zO6+Ab/MYWmqD36eR+Um2GTr8OpJ0cPegqgfE5d2cxVG9w+GXGlUJXPREeRbegFAnoaOkzjFNyZ7TNoe5loWXURvobx4ixe8dqOTp1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KYOglz6Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KYOglz6Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 321FDC2BBFC;
	Thu, 13 Jun 2024 12:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281618;
	bh=f00dbt03Hp7s6VQYfZVxjHfTvH1puHAIt5Qj0fAlzcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KYOglz6Zp5v2a0OlY5VVQQep/k+F6NMc4sgnOlcctO4X5Y2a2Mnma83u9cObTTzpm
	 bEUnJCqLkgFkXrKwg6+3nXY0S1bvQNSawYIScCMA6RGy15pUW8Qhc1wuHgbrgDFrFA
	 yTHqIeSSGq4pPVABHsMKlzO1LvvV3+RwmzJAYwJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangyang Li <liyangyang20@huawei.com>,
	Weihang Li <liweihang@huawei.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.10 316/317] RDMA/hns: Use mutex instead of spinlock for ida allocation
Date: Thu, 13 Jun 2024 13:35:34 +0200
Message-ID: <20240613113259.777391482@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

From: Yangyang Li <liyangyang20@huawei.com>

commit 9293d3fcb70583f2c786f04ca788af026b7c4c5c upstream.

GFP_KERNEL may cause ida_alloc_range() to sleep, but the spinlock covering
this function is not allowed to sleep, so the spinlock needs to be changed
to mutex.

As there is a certain chance of memory allocation failure, GFP_ATOMIC is
not suitable for QP allocation scenarios.

Fixes: 71586dd20010 ("RDMA/hns: Create QP with selected QPN for bank load balance")
Link: https://lore.kernel.org/r/1611048513-28663-1-git-send-email-liweihang@huawei.com
Signed-off-by: Yangyang Li <liyangyang20@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/hns/hns_roce_device.h |    2 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c     |   11 ++++++-----
 2 files changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -537,7 +537,7 @@ struct hns_roce_qp_table {
 	struct hns_roce_hem_table	sccc_table;
 	struct mutex			scc_mutex;
 	struct hns_roce_bank bank[HNS_ROCE_QP_BANK_NUM];
-	spinlock_t bank_lock;
+	struct mutex bank_mutex;
 };
 
 struct hns_roce_cq_table {
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -210,7 +210,7 @@ static int alloc_qpn(struct hns_roce_dev
 
 		hr_qp->doorbell_qpn = 1;
 	} else {
-		spin_lock(&qp_table->bank_lock);
+		mutex_lock(&qp_table->bank_mutex);
 		bankid = get_least_load_bankid_for_qp(qp_table->bank);
 
 		ret = alloc_qpn_with_bankid(&qp_table->bank[bankid], bankid,
@@ -218,12 +218,12 @@ static int alloc_qpn(struct hns_roce_dev
 		if (ret) {
 			ibdev_err(&hr_dev->ib_dev,
 				  "failed to alloc QPN, ret = %d\n", ret);
-			spin_unlock(&qp_table->bank_lock);
+			mutex_unlock(&qp_table->bank_mutex);
 			return ret;
 		}
 
 		qp_table->bank[bankid].inuse++;
-		spin_unlock(&qp_table->bank_lock);
+		mutex_unlock(&qp_table->bank_mutex);
 
 		hr_qp->doorbell_qpn = (u32)num;
 	}
@@ -409,9 +409,9 @@ static void free_qpn(struct hns_roce_dev
 
 	ida_free(&hr_dev->qp_table.bank[bankid].ida, hr_qp->qpn >> 3);
 
-	spin_lock(&hr_dev->qp_table.bank_lock);
+	mutex_lock(&hr_dev->qp_table.bank_mutex);
 	hr_dev->qp_table.bank[bankid].inuse--;
-	spin_unlock(&hr_dev->qp_table.bank_lock);
+	mutex_unlock(&hr_dev->qp_table.bank_mutex);
 }
 
 static int set_rq_size(struct hns_roce_dev *hr_dev, struct ib_qp_cap *cap,
@@ -1358,6 +1358,7 @@ int hns_roce_init_qp_table(struct hns_ro
 	unsigned int i;
 
 	mutex_init(&qp_table->scc_mutex);
+	mutex_init(&qp_table->bank_mutex);
 	xa_init(&hr_dev->qp_table_xa);
 
 	reserved_from_bot = hr_dev->caps.reserved_qps;


