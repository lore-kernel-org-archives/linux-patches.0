Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3708914B075;
	Wed,  5 Mar 2025 18:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197619; cv=none; b=fVEo6I0sWTj5fzgvlv8iTdyii2qTtZ5TC+gtvV0b1wNidOjY6iBBVIk0SOygrAPcfUSQCqjHf9mlvxrBKpgU78Jd8RI6bXf1HylEBBiBVjXVnW6yNtlTlgCHjQTcN5i+CirR/pju2XQSUO5z4Zy3hat1U0gf71evqlD4pZrOOwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197619; c=relaxed/simple;
	bh=kzqmIqKvmm4Opol2UpqtTJXBCcKJpkQKf6sSc11J020=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JtgTTPVGYCy5zu/vlNoH66RyP4xivMNqdZcT4AX03CvOAu7Qf+4HFbfa0uVLyTYcZ3ME2/vDqGAvAZbVEUQZSXGE84X0JgflsTxQqctdZwbBCqJgxeiNFRRW1jH1IWUqaDbkNXjUSk7VSmbMnq64meIH0wSiaGosYde8KHPDNmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FqR1O2oQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FqR1O2oQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B18C4CED1;
	Wed,  5 Mar 2025 18:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197618;
	bh=kzqmIqKvmm4Opol2UpqtTJXBCcKJpkQKf6sSc11J020=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FqR1O2oQAgqNZ9GsYclzfI9Ea72iQEM3JzB/5a7IY3uDqCQEESzbPHQ4WcArJ8/YV
	 5RHl9Nz3IsIaSQzD9otm1KU4GC+iRkVlfW0bApMnyn4T1jZeIt+tbvMmIn44GNMzVR
	 v0BlOssFayshDHdKshKwtX2QqUXvieQ0ECbqj+gU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Zhang <markzhang@nvidia.com>,
	Maher Sanalla <msanalla@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 001/142] IB/mlx5: Set and get correct qp_num for a DCT QP
Date: Wed,  5 Mar 2025 18:47:00 +0100
Message-ID: <20250305174500.392526271@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Mark Zhang <markzhang@nvidia.com>

[ Upstream commit 12d044770e12c4205fa69535b4fa8a9981fea98f ]

When a DCT QP is created on an active lag, it's dctc.port is assigned
in a round-robin way, which is from 1 to dev->lag_port. In this case
when querying this QP, we may get qp_attr.port_num > 2.
Fix this by setting qp->port when modifying a DCT QP, and read port_num
from qp->port instead of dctc.port when querying it.

Fixes: 7c4b1ab9f167 ("IB/mlx5: Add DCT RoCE LAG support")
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Reviewed-by: Maher Sanalla <msanalla@nvidia.com>
Link: https://patch.msgid.link/94c76bf0adbea997f87ffa27674e0a7118ad92a9.1737290358.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 71a856409cee2..3df863c88b31d 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -4555,6 +4555,8 @@ static int mlx5_ib_modify_dct(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 
 		set_id = mlx5_ib_get_counters_id(dev, attr->port_num - 1);
 		MLX5_SET(dctc, dctc, counter_set_id, set_id);
+
+		qp->port = attr->port_num;
 	} else if (cur_state == IB_QPS_INIT && new_state == IB_QPS_RTR) {
 		struct mlx5_ib_modify_qp_resp resp = {};
 		u32 out[MLX5_ST_SZ_DW(create_dct_out)] = {};
@@ -5045,7 +5047,7 @@ static int mlx5_ib_dct_query_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *mqp,
 	}
 
 	if (qp_attr_mask & IB_QP_PORT)
-		qp_attr->port_num = MLX5_GET(dctc, dctc, port);
+		qp_attr->port_num = mqp->port;
 	if (qp_attr_mask & IB_QP_MIN_RNR_TIMER)
 		qp_attr->min_rnr_timer = MLX5_GET(dctc, dctc, min_rnr_nak);
 	if (qp_attr_mask & IB_QP_AV) {
-- 
2.39.5



