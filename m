Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB0D233985;
	Tue, 11 Nov 2025 01:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825168; cv=none; b=mSeV2XVVAHtbIAEfCGKoD+NLx76HOYQKHS/GsNm4VLfXLl4PrMK9C+Q55RUy7kNbGw1DQ/gK19apvDzcm6dTGpEZxunBHPl8Yf3TmrwlSaODZaUVpdpCXUhF4Z0ORb5l9DYKw6CAdgjyzjNp/FLPJ4uKHQswvx3LXzHdWm0W3Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825168; c=relaxed/simple;
	bh=D8KB6ciNirck97086CaGYrYscS74+OtWT5AKCmlwZQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d+UqwUfpsr4vDAq7U5VaaExx48cNpWyt+wPgqfJmBs1t0pMwvZ4sdJ4SdsGyf9Igto8gHUoLWTd+EeKb5R/tjHEDJTe6HJSjdeZ5Ic7jKt24/4VyM+YbsbUaXLzMuwPLLM0HghWdXnh2/4FeUOMGQxIO0+yIUe9DMJCciY6rjbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VL8HEt3+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VL8HEt3+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DBC9C116B1;
	Tue, 11 Nov 2025 01:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825167;
	bh=D8KB6ciNirck97086CaGYrYscS74+OtWT5AKCmlwZQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VL8HEt3+4/EheGpWljPxXbIYGeffdi0VJIL7hqAs9yT7TUrGKgb1GNmhmoRhkonNB
	 DiYc+8pLOevkLwO9VMDg+wBjcn+fXjWFYPMhI5QxW7BClYlN4bdLc92t4oZUjz0R3r
	 LFW/dAl0h4shGXH3SCQAmc9+gRRvHqyU586usZqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wenglianfa <wenglianfa@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 689/849] RDMA/hns: Fix the modification of max_send_sge
Date: Tue, 11 Nov 2025 09:44:19 +0900
Message-ID: <20251111004553.083227533@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 6ff1b8ce580c5..bdd879ac12dda 100644
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



