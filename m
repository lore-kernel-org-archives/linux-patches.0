Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEBE24E0B68;
	Thu, 17 Sep 2026 16:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663850; cv=none; b=E3SKli8lDrSHFFQl1gtAi+Uft86TGvND6+PhDNL738y/rbAdzroqisSG3YVZJd+Y6n/M3g2Ei073Ukq18F7Smyl1g5u8R63CK4m/evlx3xKpvFpfFNdpfZQBHsF7cIH7ZlOg601NjNoeYPIxRcKYXyANlkE8vixjwtS17rClXrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663850; c=relaxed/simple;
	bh=LfHXrUne6J9Z2aT+tzlPDJFI8n13+yEkX6s90nnQnT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V01VcUB4yD3B0H3UE5k2sDcADxrQKcyiiPyLgYIhhn/VwJpHyjAX6Ds2v56f1nCeqHqtjoNlyKjAa5yYaQODDN3YuXO5p7BB1ZVCZwxxSp4iWu4pL1qd2YnC0gsrCmnREi250zfZX6H2EjvqUGj5vEucUsVa3lsfw+We+Wl/5Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vn/NtJxx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vn/NtJxx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D271F000FF;
	Thu, 17 Sep 2026 16:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789663848;
	bh=UpHXyUpKXued43DQgJqGTBqqiqY7y2IlC56aHOt7mOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vn/NtJxxVHi8OXC/zVNSWOm6umBEMX74oKqhAgpBx9XRyfGNhU/+OM6b7WBuy9SMU
	 Xj4zzrgu2O5cPPOq97oTEAgMRZchmGfPsxAe+MAKyczgI+zlA0qmwqoJKeyfVLg48p
	 zpt1Aw1fdtovJVTzExaBdtp87wBEA28TXTcgbBeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0126/1250] RDMA/mlx5: Use QP port when decoding responder CQEs
Date: Thu, 17 Sep 2026 15:58:41 +0100
Message-ID: <20260917151555.446816519@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 651d76bca114d..c6590dde68332 100644
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



