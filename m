Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A9A1F1302;
	Tue, 30 Sep 2025 15:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245435; cv=none; b=fIQ9gIUg5dgqpqhQLiflV+9Wwah/GC73AgheXePWwuZRcrWZutrwkrv1GqN3bRlOcy5O3wZsOYCrQCf4RgLISYk3uawyYszX+JFABM35n5MRra1T6Ua9VFgqZV0q6mGbYmowwjgXOKFmReIvccseKoxPU7RKE33iF+wQaJKcbnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245435; c=relaxed/simple;
	bh=Qlo20GS8Wv816rwYLtY4URzGcjDFbW5Ja0fJTA6UjCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=atXfdzferHD3vzPbl6dBKNrO8TE/ZkVCZAHihl+EHFZ8jq8FZvN0T3GNLGXaCZL1Z91tXDyv9Pb14BQntjZSSfJYdpR6WSoDNqoWGdNGgnqHygSoqvyps11ZFYHHNLZpEGUK4e1r1yO/QfBxwvnhJbUov2HnV3MWiBHu2wZKNpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AjeNTwjj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AjeNTwjj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 394AEC4CEF0;
	Tue, 30 Sep 2025 15:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245432;
	bh=Qlo20GS8Wv816rwYLtY4URzGcjDFbW5Ja0fJTA6UjCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AjeNTwjjCWA5/QM9zkwF7ievyAObLvwPTo/ASDdw9sgvlNXfcHGCIfBHjI8FaazK2
	 H23XIko/T6GgxxBJo7zBwqnX2C7HYgAZjGU1vHLwPGLK8XRv7qZZgaifbzCw1I4Nbi
	 JidXUhUVZPV6PLfRAaGvTBAAfByEKw3pHSRWlb6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Or Har-Toov <ohartoov@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 17/73] IB/mlx5: Fix obj_type mismatch for SRQ event subscriptions
Date: Tue, 30 Sep 2025 16:47:21 +0200
Message-ID: <20250930143821.276004258@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143820.537407601@linuxfoundation.org>
References: <20250930143820.537407601@linuxfoundation.org>
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
index cc126e62643a0..80c26551564fb 100644
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



