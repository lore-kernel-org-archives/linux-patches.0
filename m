Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CDA51F152D;
	Tue, 30 Sep 2025 15:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244528; cv=none; b=tl/L+4+CT/+RyZoZIGtCUSh0ZT2X0t3mlvQxjps748FzHQqc2hd+eO022AiASnhibdbSqF/i7cNcfLsZbtQ9UlCGusRPPv362JL+sVwuu0M73aHWSw9mkuMmchXbT5jQfoXee/+CRFxsvdd5nnOCydYbbZX+MiySaDH4YtGTgPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244528; c=relaxed/simple;
	bh=nAHaC4lFmHhqKAWujhZzuIPKYSZTP/M2cHb9AMizF2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+r98HrCCAfJONkN/srX5OL/asXwKBy9o/Z96WsrNrYiA8vw4ZvNalnlwXJXY2M0+K5D5j7MwfyLABCLrL08L+ERodhdvPmuOYAd2kNVpjbjjGS3Jcnn0fogYj2qgCi0XHKyXXzqTIMRdO20frDBPvD81jO1CVphNFhdF6yAQMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o70NwOLo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o70NwOLo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB19C4CEF0;
	Tue, 30 Sep 2025 15:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244528;
	bh=nAHaC4lFmHhqKAWujhZzuIPKYSZTP/M2cHb9AMizF2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o70NwOLonDymKC+sANwqyMroPr/o92G6RViZrrvusQ4X9P4zWe8rFny4EMsmtIZeo
	 KvJ29oKhZePoYd39zWrPDgzhjvkKEd2EwPzMC4p7f5AvoKr2c6idSB629dcrxzIUQX
	 lbkBxn8Ha2hI7LcEdgWpVwV3ZP3ycmd5mQoNvsII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Or Har-Toov <ohartoov@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 035/143] IB/mlx5: Fix obj_type mismatch for SRQ event subscriptions
Date: Tue, 30 Sep 2025 16:45:59 +0200
Message-ID: <20250930143832.640760363@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Or Har-Toov <ohartoov@nvidia.com>

[ Upstream commit 85fe9f565d2d5af95ac2bbaa5082b8ce62b039f5 ]

Fix a bug where the driver's event subscription logic for SRQ-related
events incorrectly sets obj_type for RMP objects.

When subscribing to SRQ events, get_legacy_obj_type() did not handle
the MLX5_CMD_OP_CREATE_RMP case, which caused obj_type to be 0
(default).
This led to a mismatch between the obj_type used during subscription
(0) and the value used during notification (1, taken from the event's
type field). As a result, event mapping for SRQ objects could fail and
event notification would not be delivered correctly.

This fix adds handling for MLX5_CMD_OP_CREATE_RMP in get_legacy_obj_type,
returning MLX5_EVENT_QUEUE_TYPE_RQ so obj_type is consistent between
subscription and notification.

Fixes: 759738537142 ("IB/mlx5: Enable subscription for device events over DEVX")
Link: https://patch.msgid.link/r/8f1048e3fdd1fde6b90607ce0ed251afaf8a148c.1755088962.git.leon@kernel.org
Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Edward Srouji <edwards@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/devx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index c369fee335621..00727472c8738 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -233,6 +233,7 @@ static u16 get_legacy_obj_type(u16 opcode)
 {
 	switch (opcode) {
 	case MLX5_CMD_OP_CREATE_RQ:
+	case MLX5_CMD_OP_CREATE_RMP:
 		return MLX5_EVENT_QUEUE_TYPE_RQ;
 	case MLX5_CMD_OP_CREATE_QP:
 		return MLX5_EVENT_QUEUE_TYPE_QP;
-- 
2.51.0



