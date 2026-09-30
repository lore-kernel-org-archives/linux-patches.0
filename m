Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C5823D7FF;
	Wed, 30 Sep 2026 18:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794133; cv=none; b=Jixrb6tCrsAqWS5uYsYjux+7d5bRQLJoPIEToBMCjTl0CvUBxfmC8mDM6o9bg/JVdsrj6Vh0yjlCbOxn5vd/dxrrzQpLIXfS16lkMHOZIYA9X5eUJUod1W1noaww3XFOmJ7D/m0qxvWTH+hCxCCC2UiV09FKhrrunmtwb4vFJ6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794133; c=relaxed/simple;
	bh=AgSGXWdV7l5tmVwJ3fNVNLc0au4zXr8+QJScFVD5nzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gOOddgp3xzk3C+B3d1mJFIxVEThj9iKFxbWPg3jGw3e+RfuCs0pvLIujLqjd7egT2qk1tkPr6ARneJRVraTDuE6aHEfRskq8A/quU/Q1QC5SZT1otsIWTGZcG+99/QlRFqy/mYbMG9MtLi1T5MSDKpn4BLwk8orPzAS42QF+Ki0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ddJYkXbG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ddJYkXbG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49AC21F000FF;
	Wed, 30 Sep 2026 18:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794131;
	bh=6RhMBUIeCkpr6oPzCY5D4OWHsdgnW1vu+S2RDYGX2gQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ddJYkXbGQbG7+Ym3mo4SyrJ116P7CwkDNLaZNi24wjzBdj4Kg0N3IMphE570LDG3j
	 HbyjdRnxTCidgIByNK65b8fna9bVaY0apGNk9qhWNeD72Njz3KrlAPAWN4HEIsjrQ2
	 nKJHdx+r/a7tMBcp+v0OE79RoN1LOpRmQFN9kb3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0058/1193] RDMA/mlx5: Use QP port when decoding responder CQEs
Date: Wed, 30 Sep 2026 17:12:22 +0200
Message-ID: <20260930152435.568342026@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ee9acd58c5121..51194137ef6de 100644
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



