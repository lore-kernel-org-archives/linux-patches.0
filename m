Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A978223DD6;
	Tue, 30 Sep 2025 15:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245251; cv=none; b=lGC8TnDQHhvc8iilQZwg4sasxmhjRxgqMQBm+z8IDqhPSZQy/07xpiT1xp3asNjQwefUwBiwWWSmi2aKBtO2x3MyltsF8IRQkQ7T/+9DNy8lvdDAAbxs0Y5580oj2YsFtUBrmgZrivWUeYKtjWR/5EbWE9otSXFA9DRChr9I0So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245251; c=relaxed/simple;
	bh=p6ifjwVa30wCtKHMggI6MtGu4gbnXE/9jw+dzb++vIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ujQ/3VlY7idxwc1WbhDnTBDIASRHqp9oOo8cJoSwDi68n/GVgbidHqQ3v4vgtXHjdnrTHRHg0LtuoY6eHimWxj/PeNqwuTgcCAsNLqE495wzhgew7CBduNFrWOa1OsHWhmjezZibTuEFkubUuvKmS6qLxK5ZeJMG666im47oK1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LsErOW6i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LsErOW6i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C00F1C4CEF0;
	Tue, 30 Sep 2025 15:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245251;
	bh=p6ifjwVa30wCtKHMggI6MtGu4gbnXE/9jw+dzb++vIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LsErOW6iRyGGUsnmyG59N97gjurdY/oJalrrTJDKSyTPwwZT40+JzjNFR9tCahAF+
	 fSN4R2oMFcI/ABtFGcC0hWQyRTHo5FFUPk1EcvTbDvF9eNWr/+CzTCjLtgvDVXEHiP
	 ufjfx7iKeQnAUEzha9JJfXkQVMLHH9WHT2ooR/g8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Or Har-Toov <ohartoov@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 112/151] IB/mlx5: Fix obj_type mismatch for SRQ event subscriptions
Date: Tue, 30 Sep 2025 16:47:22 +0200
Message-ID: <20250930143832.069097300@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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
index cc351390b568c..b2d5e21dba26c 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -191,6 +191,7 @@ static u16 get_legacy_obj_type(u16 opcode)
 {
 	switch (opcode) {
 	case MLX5_CMD_OP_CREATE_RQ:
+	case MLX5_CMD_OP_CREATE_RMP:
 		return MLX5_EVENT_QUEUE_TYPE_RQ;
 	case MLX5_CMD_OP_CREATE_QP:
 		return MLX5_EVENT_QUEUE_TYPE_QP;
-- 
2.51.0



