Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058DA4E2F3D;
	Wed, 30 Sep 2026 16:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784135; cv=none; b=ZLe2OQ+I/p2DyrH+Llm2VfYuAhGcoCothoAn52+6j2FT3/3BvHYeDrVzhd2zkO5flc9oenqU16CabuhzsDIplbwyU0Ob0yPAwcqi9auvuM7uGClLrb48CWdfdWVtjy9qoII8PkDTCwti1vt6Gg2DNa1kNTvIh6yiW0AcDkbsVwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784135; c=relaxed/simple;
	bh=3CdT8aBcAKBrEEM6Ovp9ZPcXzId4GgHg9z4LOyiySg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VFzbh5g+MqLzOveUmZ25FcGAqO0b3ONljMtuJbZXHYt7L8lqksRceJyd/3wikDumRytd3D5kvZ2s0plaPbkviq8TedZQCgKBHX+UENooN1RxS2eG3GEXaummIRGwOLDLR7FcQYBRNNsyYWNkiD5OaBeD8zKuSAnmwvPBs5zgcMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tJJe53sk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tJJe53sk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 447851F00899;
	Wed, 30 Sep 2026 16:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784133;
	bh=nxfpwT5boUd3FyrBmDkspXHPkCl0qo4GCxliYv/l0S8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tJJe53skec67W5MM5q5D0m3tK+p8/nyIs/GtRVnpgX+c8w/XCUZ9PWgiv6ujmAo5z
	 Z5TwrsLxDZq12kfoWg9Li+mYgxRGxbLVBXiDxVBOIrMLI4Owsbly1B5hAiJblt67i/
	 aSRkvREeJCcmUsCuexCLE3y+WbQORT4C0B47VptA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 048/982] RDMA/mlx5: Use QP port when decoding responder CQEs
Date: Wed, 30 Sep 2026 17:13:04 +0200
Message-ID: <20260930152417.827066004@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenguang Zhao <zhaochenguang@kylinos.cn>

[ Upstream commit 194762e6e436acde0f8f6aef44200b0058c36791 ]

The responder CQE path determines the link layer via
rdma_port_get_link_layer(). Use qp->port instead of
hardcoding port 1, which can mis-decode completions on
multi-port devices.

Signed-off-by: Chenguang Zhao <zhaochenguang@kylinos.cn>
Link: https://patch.msgid.link/20260410074046.2044595-1-zhaochenguang@kylinos.cn
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/cq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index a34bbe27bb76a..886e9560e913e 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -166,7 +166,8 @@ enum {
 static void handle_responder(struct ib_wc *wc, struct mlx5_cqe64 *cqe,
 			     struct mlx5_ib_qp *qp)
 {
-	enum rdma_link_layer ll = rdma_port_get_link_layer(qp->ibqp.device, 1);
+	enum rdma_link_layer ll =
+		rdma_port_get_link_layer(qp->ibqp.device, qp->port);
 	struct mlx5_ib_dev *dev = to_mdev(qp->ibqp.device);
 	struct mlx5_ib_srq *srq = NULL;
 	struct mlx5_ib_wq *wq;
-- 
2.53.0



