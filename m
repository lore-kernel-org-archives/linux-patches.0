Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B2E34EEED;
	Fri, 21 Nov 2025 13:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732961; cv=none; b=ZObT6z/mvn0vc6Z9/pJp3+uJ2pRu5YguH1UxJX+k5PrvDP/UGuUQuL5Kv/T9dH+hyu08+1ekCHvwBaM1FrnyzcwRDcnOK/OfyNCZjP+sVUn2WNiKd/qbo6EdgFn2Tdkre//UK+XhjdyWVWmrCJxGGBlaSwR7/+U5FUuNZd6hT7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732961; c=relaxed/simple;
	bh=jU2RKbhet7f8VeMN/3D26b/fVP09mR3wBh81zcipOkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iWGuyQfSuNozVi9wtQGXc5e4Hops6qZxgL5BxwrmnGwCReoIYW5wGHw6HeiipgxuQx3gaE7ghaIR8tHVn+LpvXRmjaAUvNVVLUAZXK4XSi/xyC5ReDWtalaiwpiHz8xQbDFnkRyIvcfU0PqBD3/AbKkSwf/NRHRhTz4weZvFSmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hWACJpVw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hWACJpVw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D403DC4CEF1;
	Fri, 21 Nov 2025 13:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732961;
	bh=jU2RKbhet7f8VeMN/3D26b/fVP09mR3wBh81zcipOkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hWACJpVw5ZLSZv4m33I8lQga8TXi1obJKkGV5lNDuK4NnNs0RJzDQx7ugwBKCD0J4
	 /EYpCzWNY7omrXFBGJmPuNtVT8wn0Jahm9g2oVfdJZ4yej5Ji/5Zm+9pm8tWcwsW0W
	 gt+k9m0gE5elDwZGwSjYoycyvoTG/LSjLosoltdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wenglianfa <wenglianfa@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 303/529] RDMA/hns: Fix the modification of max_send_sge
Date: Fri, 21 Nov 2025 14:10:02 +0100
Message-ID: <20251121130241.805867353@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0cad6fc7bf32c..26784b296ffa6 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -654,7 +654,6 @@ static int set_user_sq_size(struct hns_roce_dev *hr_dev,
 
 	hr_qp->sq.wqe_shift = ucmd->log_sq_stride;
 	hr_qp->sq.wqe_cnt = cnt;
-	cap->max_send_sge = hr_qp->sq.max_gs;
 
 	return 0;
 }
@@ -736,7 +735,6 @@ static int set_kernel_sq_size(struct hns_roce_dev *hr_dev,
 
 	/* sync the parameters of kernel QP to user's configuration */
 	cap->max_send_wr = cnt;
-	cap->max_send_sge = hr_qp->sq.max_gs;
 
 	return 0;
 }
-- 
2.51.0



