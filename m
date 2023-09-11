Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D8511706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7097C433C9;
	Mon, 11 Sep 2023 14:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443901;
	bh=ErWRF+2BmIO3ASZjvUcRke36yOyO99nTR6XyY4VUXaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uW+cXoX4Ekn3AEJp7nCsXHsyZwFC/9Xmz/mZ2hYlFRyu9htKe4BV8+FfVl97I6Xcg
	 jA7VZj0aYaeTUzKdYbfOMzQn8KZsYNcKDFl0Gh8YKSO8WCUxbQEJ9Jr7B14HwfK/Kv
	 +SlFhVOVB97UZWjnPanHLTfEBdC71Y+ov6YV62Bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 540/737] RDMA/hns: Fix incorrect post-send with direct wqe of wr-list
Date: Mon, 11 Sep 2023 15:46:39 +0200
Message-ID: <20230911134705.645785605@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit 706efac4477cdb8be857f6322457de524acc02ff ]

Currently, direct wqe is not supported for wr-list. RoCE driver excludes
direct wqe for wr-list by judging whether the number of wr is 1.

For a wr-list where the second wr is a length-error atomic wr, the
post-send driver handles the first wr and adds 1 to the wr number counter
firstly. While handling the second wr, the driver finds out a length error
and terminates the wr handle process, remaining the counter at 1. This
causes the driver mistakenly judges there is only 1 wr and thus enters
the direct wqe process, carrying the current length-error atomic wqe.

This patch fixes the error by adding a judgement whether the current wr
is a bad wr. If so, use the normal doorbell process but not direct wqe
despite the wr number is 1.

Fixes: 01584a5edcc4 ("RDMA/hns: Add support of direct wqe")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://lore.kernel.org/r/20230804012711.808069-3-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index d4c6b9bc0a4ea..fe7908ed39022 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -757,7 +757,8 @@ static int hns_roce_v2_post_send(struct ib_qp *ibqp,
 		qp->sq.head += nreq;
 		qp->next_sge = sge_idx;
 
-		if (nreq == 1 && (qp->en_flags & HNS_ROCE_QP_CAP_DIRECT_WQE))
+		if (nreq == 1 && !ret &&
+		    (qp->en_flags & HNS_ROCE_QP_CAP_DIRECT_WQE))
 			write_dwqe(hr_dev, qp, wqe);
 		else
 			update_sq_db(hr_dev, qp);
-- 
2.40.1



