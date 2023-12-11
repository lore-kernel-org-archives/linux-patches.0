Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290944437B;
	Mon, 11 Dec 2023 18:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eiGG4FPi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2C68C433C8;
	Mon, 11 Dec 2023 18:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320444;
	bh=YYIWtuXxNzQNxT+uq0VL6ifwso9C5kmJSNayBK9nbko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eiGG4FPi3WQgT3tjz2GWShwWB7F4SjbbBrpOCBtWeDfDrFq8OSsL2sEgU97F0Qwo+
	 6Knm1ZWluwXHC0Wek9ykY88n8FEPAgp5Khj0WpHWSmrbSW4mblTu9C2NIwoseZFuPc
	 cf3B0sLy2OI7lWh12So7eNall+KbisK+uwSAOV/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 064/194] RDMA/hns: Fix unnecessary err return when using invalid congest control algorithm
Date: Mon, 11 Dec 2023 19:20:54 +0100
Message-ID: <20231211182039.358780126@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8a9d28f81149a..c2ee80546d120 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4913,10 +4913,15 @@ static int check_cong_type(struct ib_qp *ibqp,
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



