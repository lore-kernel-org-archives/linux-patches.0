Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE584E0B63;
	Thu, 17 Sep 2026 17:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667538; cv=none; b=Fr3GRFUUYa+I8klyed9Bt3T+sCWfe/up9/vmqXAFahe4+UTWUtkHr/D37ikj+Wdno8zJse/qCpDdoXUpAaMlolIugCj2tevukcFIwzsrPqCjYfq2ogsxMNR0Ae8JVO3hiGo0B8WcyKEWCa3uLDIQGFbjmslVTG2jgypei/gLv5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667538; c=relaxed/simple;
	bh=GC1JcjAuO100DZpPN1qHAHfW5EIZ1e8Eu8ra2UeHRek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UmrrnHau8xmAF9JYoffh1ZE9vmYgX4CXqFyjfa4Y8LnlQ3PngHzh4SuQoIuzvpT9npxNaoFWAkXohcw5veieL+6jpioy10W6ztcywtUL+pmGa5SeKyve0hdVyMXGytkqj4vN8VUnyaTEYTr4BiAUXPPXQuBRujWpusrNg4G7RQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YFAyOUMy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YFAyOUMy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E661F000FF;
	Thu, 17 Sep 2026 17:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667536;
	bh=+3VhcD+48WY3cd1qxKIMJqFYdLvnn3Z7PNiNqTfIihI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YFAyOUMySfcEHdnn0aSUQhnj2OUwfJayi+Zhc4aQpyIdylpUHJPd6FdMmDF+bArzz
	 MOzQeYxGJhMWPLasq3ZXmq03K5g4Q7+eRpB9BMNrYluoff0Fuxju6BDbQnDYjFfqVa
	 ONpy+sjAokkUppx1maXgW2Ky93nIQ1RXDYFD9Nlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0089/1102] RDMA/mlx5: Use QP port when decoding responder CQEs
Date: Thu, 17 Sep 2026 16:00:32 +0100
Message-ID: <20260917151541.713219956@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1aa5311b03e9f..9e04b595c77fd 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -169,7 +169,8 @@ enum {
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



