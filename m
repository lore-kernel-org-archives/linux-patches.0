Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E044B51C060;
	Wed, 30 Sep 2026 17:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790806; cv=none; b=CSw/pvb3loq5imW5bkK9vHtXrGIJ+/glpH9MH7x20NuV6g/75Zdmh8eE5Y+ESQPWhP8Qvtnj/uoYKIrwoRkp9q7UKgSMzIrX2iG2kqeNGPHQWXfevf+N9qAjGbZW5BJfrap25ck9eD8ySCewbj+xaUyDRn6sxRz6Y82+/Ed4cN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790806; c=relaxed/simple;
	bh=iQKdUieLyLE9DraIE1faQZkIqktLpE+fEwu5pgdALT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X6qi0uqL0+TCCInDsPZ22vOY7NEux9BkAsG3AXltbFrDx/9W2ZXo0w7xTbGQCtAqpbx2CT0NbOqUcvC8ULrl6OvWGJ2dCG1xvYla3/sWosjMO2CAJ6qxkedqoTIk6Xkdo6cRKI8r49Ro8Ggs5GqgGOx/lITYtBrerPfcdHwAiqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h3RFIydk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h3RFIydk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B5E1F000FF;
	Wed, 30 Sep 2026 17:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790804;
	bh=g8+qNm/0b/GRCFJftsB+PDVw6zMT47EK4p4xOzJZELE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h3RFIydkt50/yVaRy7PgnKEkFoLJbuslTQrlBLgXIg9Pb8FieSbPpS3yMmh8IOEkz
	 5/77dtNptDr0PqohQbjEbZenNLu2MIXoSHgedUCKrfH74NODbjTUzwHWdqizuTVhsZ
	 3PZFUD5ShztGiMmbPUq9iLBDkZFjpHcRm8nV5nho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 035/752] RDMA/mlx5: Use QP port when decoding responder CQEs
Date: Wed, 30 Sep 2026 17:18:25 +0200
Message-ID: <20260930152358.911904804@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f3becb506125e..305c1640fde66 100644
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



