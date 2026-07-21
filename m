Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173AC3C1400;
	Tue, 21 Jul 2026 22:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673681; cv=none; b=iUQu4lp90FFHR5A+6MPeAV1ORl21Oa9n2MyBV3+aOT+tVp757zbVRdxW2u2pc4oaqTBbswAYP9Ayr32xnQeYf8xbX+/xYnl8Qed5tqhlaWhzVX3U8w8lH1TUQon1Kv6unEddHhrDtxqUluqrvW7viM+jzf35yPNvbeB4Mq9BGO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673681; c=relaxed/simple;
	bh=0m9PgNkXS+kttsj0chM7BM64TAo3gxn4/Y234JPIsrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZyW1rMKsU7nsfvRXdSvv7BeEgsLYBubNa9UOlqzyPI21MxsC8kjbBwAnxwkwMf3Ahk3Z3vRJx1NK+tE0TPrbED1752k6bvSwovdwyLQIF77rQLJJ3uquaprrG/HAewSs6EvePFpZqckKWrijw9hHJ0O5oT6fpgAv1gsW0CzPak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rUHyJzzg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rUHyJzzg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C70A1F000E9;
	Tue, 21 Jul 2026 22:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673680;
	bh=eep3ESqs4XmAaxBI5D19a9amnz0noNDyeFhNTGZUv6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rUHyJzzgsPFrjdukXkRpeQlqmt9f5p811tDMzFpe5b7rAYXhzm3U1+kVmIY9wg14C
	 5xNNt9vWJTo4EX1T97ATDX/y8qJiZ7NXKkFYQCL9VSwD4ZzdpX3z4D9TjAU0OTI9NA
	 6ZcgaoUq9W99vxR3bHIKd8NCDGZ6/3RnkgjNz8zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maher Sanalla <msanalla@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 253/699] RDMA/mlx5: Fix undefined shift of user RQ WQE size
Date: Tue, 21 Jul 2026 17:20:12 +0200
Message-ID: <20260721152401.403999875@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maher Sanalla <msanalla@nvidia.com>

[ Upstream commit d881d60223aac8fdc12b227d89c76e131e92a9cd ]

set_rq_size() computes the RQ WQE size as "1 << rq_wqe_shift" based on
the user-provided rq_wqe_shift, which is only checked to be greater than
32, so shifts of 32 are still accepted. A shift of 31 also overflows a
signed integer, leading to undefined behavior.

Use check_shl_overflow() to compute the RQ WQE size and reject any
invalid values.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Link: https://patch.msgid.link/r/20260611-maher-sec-fixes-v1-1-cd8eb2542869@nvidia.com
Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index a00dde2f3fd39f..8f83629ceb8af6 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -369,16 +369,13 @@ static int set_rq_size(struct mlx5_ib_dev *dev, struct ib_qp_cap *cap,
 
 		if (ucmd) {
 			qp->rq.wqe_cnt = ucmd->rq_wqe_count;
-			if (ucmd->rq_wqe_shift > BITS_PER_BYTE * sizeof(ucmd->rq_wqe_shift))
-				return -EINVAL;
 			qp->rq.wqe_shift = ucmd->rq_wqe_shift;
-			if ((1 << qp->rq.wqe_shift) /
-				    sizeof(struct mlx5_wqe_data_seg) <
-			    wq_sig)
+			if (check_shl_overflow(1, qp->rq.wqe_shift, &wqe_size))
+				return -EINVAL;
+			if (wqe_size / sizeof(struct mlx5_wqe_data_seg) < wq_sig)
 				return -EINVAL;
 			qp->rq.max_gs =
-				(1 << qp->rq.wqe_shift) /
-					sizeof(struct mlx5_wqe_data_seg) -
+				wqe_size / sizeof(struct mlx5_wqe_data_seg) -
 				wq_sig;
 			qp->rq.max_post = qp->rq.wqe_cnt;
 		} else {
-- 
2.53.0



