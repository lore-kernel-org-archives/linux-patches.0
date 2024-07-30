Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87D71A76A1;
	Tue, 30 Jul 2024 17:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359469; cv=none; b=kl3FTj0VOSaRbgFGa306lE5ng5rCdNtknohpa9kXZ4Pcw8qjw/K0JYdCsr1kHumNb1yH3w6qQ65WrkLMJZu31UeTE646v5q7MqeMBClv+yF6S7Glx+zGUHsIvU7fP+9GXhVp/JW2fR0wiY6dEset5Taf2apq2ZZEQ6c67kjq4rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359469; c=relaxed/simple;
	bh=RAyXNsURkyGEj2sykbMg8dGBZdBHW/3lv0rGIFD8ejQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eIWAKqQ8YGHRFDfa2/9ClyzbWErPYCGQh9ZBbBpDJ4X0NZ7omfvWN4tg7gW/UpUUnsXVocy00oHfOurGlMYJQenFLkiQgzHwzHEytSlrsuPFskK2xbz7934Vj06KLD0UBgvyTrbw46F3ysttIZhtlgpqxNtXogdqPSrKMaUzmKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iyRJr7En; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iyRJr7En"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19077C32782;
	Tue, 30 Jul 2024 17:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359469;
	bh=RAyXNsURkyGEj2sykbMg8dGBZdBHW/3lv0rGIFD8ejQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iyRJr7EnMIEyUs7n9m1CCqljYR4A4D35/1Yjn0F8hCfznThvbXc1owAqRknqXi1Ko
	 q7jTOWAoIZ9siPzRTXlmc3+erQbz/vAmmyEAzLbxHSyUKxeifU/cw1SheV/fns+g/I
	 +xSanaZ87uU7CV7+lLO8dytcMfJJ8dFfvDAvuEH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 465/809] RDMA/hns: Fix undifined behavior caused by invalid max_sge
Date: Tue, 30 Jul 2024 17:45:41 +0200
Message-ID: <20240730151743.097479554@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index f1997abc97cac..c9b8233f4b057 100644
--- a/drivers/infiniband/hw/hns/hns_roce_srq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_srq.c
@@ -297,7 +297,7 @@ static int set_srq_basic_param(struct hns_roce_srq *srq,
 
 	max_sge = proc_srq_sge(hr_dev, srq, !!udata);
 	if (attr->max_wr > hr_dev->caps.max_srq_wrs ||
-	    attr->max_sge > max_sge) {
+	    attr->max_sge > max_sge || !attr->max_sge) {
 		ibdev_err(&hr_dev->ib_dev,
 			  "invalid SRQ attr, depth = %u, sge = %u.\n",
 			  attr->max_wr, attr->max_sge);
-- 
2.43.0



