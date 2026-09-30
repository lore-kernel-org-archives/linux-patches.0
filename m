Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C124F4D08;
	Wed, 30 Sep 2026 15:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782404; cv=none; b=h4r9MG2tG2jRAUQCAmF0xR53KgjMVb9Ofc0RW7oFWadKYzzb06i9kfF5ppOgUNTwDRA94H/iRovNaHtz3xQJDKTECUg8eskLD2MbVtbBwBTJaY6qezk/JJRT2fbhT7XEY484NV6EIurNXS0kIRMkw3yxqyQiBvujplG7omafOlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782404; c=relaxed/simple;
	bh=o9LtYuIlQ1/jvqa6oGlOX0Vc1f7Vc70I081Pw22Rb/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rS0Pvj/l9Uw8A6nXEnBuCbd/afeK0bQYh82yfTUZ51h/jPPjuY37C7qOWN4x90wu8/3bkHzn3cyiq+RxrR7W9Zcpa1DBVvom4blsDu4s5JxOO0dMDG4hKf7UxHX3l3HG3MrVOX2oEUnihk7E1Jpt6WBWJucaYvsqA3hYPDA3tio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=amFdp077; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="amFdp077"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395F61F00898;
	Wed, 30 Sep 2026 15:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782385;
	bh=zNOz3PfbJXylxfQvrB/BUcca+SCZZt8rPGwvHs4oEys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=amFdp077Bq5p/6e4x/31pQ1wHVM4q5Hnqo5QQyuX66MJYcUVnLTi8Fg7kLlyTKhVq
	 A1cY2ZwoyXvfW8yy+DHu3x26xZtTKEJDJe85o4J4+zUYaxIhGnNB3h1KFt8LUT8UKo
	 AImXpoTquFK3MgnJD+z5wDRx/oz5DA2u+8weUzQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 029/595] RDMA/mlx5: Use QP port when decoding responder CQEs
Date: Wed, 30 Sep 2026 17:18:42 +0200
Message-ID: <20260930152348.355955908@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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
index e6d3ac4e10dc0..c505017a289ba 100644
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



