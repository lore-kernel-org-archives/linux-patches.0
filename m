Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083162561D7;
	Tue, 25 Mar 2025 12:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905955; cv=none; b=MI71/CkgL9Sv4BqeTTL5GVrFARBfR4jFwLZUddv04J0ud6gtnmGosWFXaMKMenWK4IY/ZQs6eRSQrEUK9HYUWNCpYTbC3v2LyDaAL7mnrPQUjgCLbeQ8AFN4J+MKn/wVgKQjTwSgLF3WBzAsW5Au6wvm77Y/xO1XFYV8N/JVxzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905955; c=relaxed/simple;
	bh=6jEga7tE3ildlNeNG7shdR/wsPbun0jVZ5pn0wvBU1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MxkaRPWBhBN+jJQYk73f8wLzyEZ6abFMwbRj1OAw7jTwSbe5exYMibUlAH0OMfisBLEnKfmkTopAdEfVrUA9soQbH9n8RMQ6h/bl8GJzrIkS8WonlGgE8cpGKzL3af+95+45J2sYHFAYuzJQiUl5AxM5qXETKYlecFpENyDJBp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EaEQYqwH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EaEQYqwH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8B82C4CEE4;
	Tue, 25 Mar 2025 12:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905954;
	bh=6jEga7tE3ildlNeNG7shdR/wsPbun0jVZ5pn0wvBU1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EaEQYqwH0wjUHGff5RtZnt9CAgW7DcvKhIdKeqfSSx47Wze3qLZ1F9UJsMiFvZ+LU
	 w+thmbz2A8zElGmrdZtyMhpM+kxM9A0D7b5EFjk4OgHjwi0zKn+YtmWDDd149GTwjp
	 xXAPcopo6hQ28fMJX7MJIfgvsO4ixtYz0ejLKfGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 025/119] RDMA/hns: Fix invalid sq params not being blocked
Date: Tue, 25 Mar 2025 08:21:23 -0400
Message-ID: <20250325122149.710255107@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit 13c90c222049764bb7e6a1689bd785f424bd8bd5 ]

SQ params from userspace are checked in by set_user_sq_size(). But
when the check fails, the function doesn't return but instead keep
running and overwrite 'ret'. As a result, the invalid params will
not get blocked actually.

Add a return right after the failed check. Besides, although the
check result of kernel sq params will not be overwritten, to keep
coding style unified, move default_congest_type() before
set_kernel_sq_size().

Fixes: 6ec429d5887a ("RDMA/hns: Support userspace configuring congestion control algorithm with QP granularity")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20250311084857.3803665-5-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_qp.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index a97348a1c61f1..8408f9a5c309d 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -1121,24 +1121,23 @@ static int set_qp_param(struct hns_roce_dev *hr_dev, struct hns_roce_qp *hr_qp,
 						 ibucontext);
 		hr_qp->config = uctx->config;
 		ret = set_user_sq_size(hr_dev, &init_attr->cap, hr_qp, ucmd);
-		if (ret)
+		if (ret) {
 			ibdev_err(ibdev,
 				  "failed to set user SQ size, ret = %d.\n",
 				  ret);
+			return ret;
+		}
 
 		ret = set_congest_param(hr_dev, hr_qp, ucmd);
-		if (ret)
-			return ret;
 	} else {
 		if (hr_dev->pci_dev->revision >= PCI_REVISION_ID_HIP09)
 			hr_qp->config = HNS_ROCE_EXSGE_FLAGS;
+		default_congest_type(hr_dev, hr_qp);
 		ret = set_kernel_sq_size(hr_dev, &init_attr->cap, hr_qp);
 		if (ret)
 			ibdev_err(ibdev,
 				  "failed to set kernel SQ size, ret = %d.\n",
 				  ret);
-
-		default_congest_type(hr_dev, hr_qp);
 	}
 
 	return ret;
-- 
2.39.5



