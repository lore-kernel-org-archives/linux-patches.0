Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2B31549F
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:12:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51A5FC4339B;
	Mon,  8 May 2023 10:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540750;
	bh=0y5fik3iuohyoHYC0Yzunl6vS+d3MfQ0KCVN9cPo5dE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oMHDwcT0w5Yi96hpkakn1wGHV0/9uFFlwV0ejSHKVS8iuckU9AR/mQTjBoXHxVbo1
	 cPNqP8VgUtOpLU9eJo1XUbiGoQPmBA9mkKNR5zV+GyIrJq/KTuJLm1vivpKLwxjPiz
	 GC+wnym/ctcdPNEEUgh47N3LCzebi0NL5D/yXogA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 482/611] RDMA/mlx4: Prevent shift wrapping in set_user_sq_size()
Date: Mon,  8 May 2023 11:45:24 +0200
Message-Id: <20230508094437.747231921@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit d50b3c73f1ac20dabc53dc6e9d64ce9c79a331eb ]

The ucmd->log_sq_bb_count variable is controlled by the user so this
shift can wrap.  Fix it by using check_shl_overflow() in the same way
that it was done in commit 515f60004ed9 ("RDMA/hns: Prevent undefined
behavior in hns_roce_set_user_sq_size()").

Fixes: 839041329fd3 ("IB/mlx4: Sanity check userspace send queue sizes")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Link: https://lore.kernel.org/r/a8dfbd1d-c019-4556-930b-bab1ded73b10@kili.mountain
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx4/qp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index b17d6ebc5b705..488c906c0432c 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -412,9 +412,13 @@ static int set_user_sq_size(struct mlx4_ib_dev *dev,
 			    struct mlx4_ib_qp *qp,
 			    struct mlx4_ib_create_qp *ucmd)
 {
+	u32 cnt;
+
 	/* Sanity check SQ size before proceeding */
-	if ((1 << ucmd->log_sq_bb_count) > dev->dev->caps.max_wqes	 ||
-	    ucmd->log_sq_stride >
+	if (check_shl_overflow(1, ucmd->log_sq_bb_count, &cnt) ||
+	    cnt > dev->dev->caps.max_wqes)
+		return -EINVAL;
+	if (ucmd->log_sq_stride >
 		ilog2(roundup_pow_of_two(dev->dev->caps.max_sq_desc_sz)) ||
 	    ucmd->log_sq_stride < MLX4_IB_MIN_SQ_STRIDE)
 		return -EINVAL;
-- 
2.39.2



