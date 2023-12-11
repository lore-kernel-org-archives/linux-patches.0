Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48995EEB8;
	Mon, 11 Dec 2023 18:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rHYsC52K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85E30C433C8;
	Mon, 11 Dec 2023 18:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319452;
	bh=Bac2qzB2IbLFzD9mQZ+J3egTzEG7LvlQx+J0ZhsVZNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rHYsC52KH5lhN6wxrMBOpvj+kfZvw01xaJRcL9kz4OL1EUWiTKUfPPImLiVMbJbAN
	 QqTt+jfmMWqY9uvKC+IrXqKo5LgVBc0vGm4DBylhXNUY0Q9frt2MNRF0iMMw2hgcmC
	 QnUCUTtTw++DjH1lDf/bI1FvF28wX6uyD7sZ/izE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 080/244] RDMA/hns: Fix unnecessary err return when using invalid congest control algorithm
Date: Mon, 11 Dec 2023 19:19:33 +0100
Message-ID: <20231211182049.381555828@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit efb9cbf66440482ceaa90493d648226ab7ec2ebf ]

Add a default congest control algorithm so that driver won't return
an error when the configured algorithm is invalid.

Fixes: f91696f2f053 ("RDMA/hns: Support congestion control type selection according to the FW")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://lore.kernel.org/r/20231028093242.670325-1-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 58d14f1562b9a..486d635b6e3ab 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4755,10 +4755,15 @@ static int check_cong_type(struct ib_qp *ibqp,
 		cong_alg->wnd_mode_sel = WND_LIMIT;
 		break;
 	default:
-		ibdev_err(&hr_dev->ib_dev,
-			  "error type(%u) for congestion selection.\n",
-			  hr_dev->caps.cong_type);
-		return -EINVAL;
+		ibdev_warn(&hr_dev->ib_dev,
+			   "invalid type(%u) for congestion selection.\n",
+			   hr_dev->caps.cong_type);
+		hr_dev->caps.cong_type = CONG_TYPE_DCQCN;
+		cong_alg->alg_sel = CONG_DCQCN;
+		cong_alg->alg_sub_sel = UNSUPPORT_CONG_LEVEL;
+		cong_alg->dip_vld = DIP_INVALID;
+		cong_alg->wnd_mode_sel = WND_LIMIT;
+		break;
 	}
 
 	return 0;
-- 
2.42.0



