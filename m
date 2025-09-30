Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C889205E3B;
	Tue, 30 Sep 2025 15:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245750; cv=none; b=F915ZcgTBJywUQo66M4TZPZ9tLGZehREH8tDF/FhTVo9OuA0wdbk/zsJ2QFWtcDhY59XG0B/PpbJxgpXiJMDma1yAbg9aNCBfZGUgjNyIUiIRrCOd7Qk4dEYRqzlo67m80qaHPa54lUsW812Ll1222nl8+3XsOydTluyNrAVn4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245750; c=relaxed/simple;
	bh=FPxUO3uo0EqRUkxWpkQbQH28xiT4mWo8A7V+lx/S4SI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lscqXOT6C1QFoXo8sfVNw8AdJ9Z7DmMeLd5kqrf4YlGVP35dmLoZFBjVO42KpbYCor9fjvMQlpKiNeB9eaFSJwoyPtDBhGv3AkfVllGTYysVqpJulq8NuuuNviVS6KuyMCxu6TtkwfEIMJIqF00SpBhjJDtxYEIdY8ASf0C+fP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dTzQA4P2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dTzQA4P2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4327C4CEF0;
	Tue, 30 Sep 2025 15:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245749;
	bh=FPxUO3uo0EqRUkxWpkQbQH28xiT4mWo8A7V+lx/S4SI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dTzQA4P23q8x2dDmNXR9cd/Gul7jSE9ddBbOi0Z49WUu8f/zf8yTVx4oa0cwxI0qg
	 G0JJ4A5phsYlVeLLfQ7Yykw2HWC9XAo72Hi9QOLbHCQ1OEJRc4qGGxwNtKb6uVumeP
	 03y41TgJs8hlw5L72tmOq0+Pxu5tETntDcCUOqzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Or Har-Toov <ohartoov@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 21/91] IB/mlx5: Fix obj_type mismatch for SRQ event subscriptions
Date: Tue, 30 Sep 2025 16:47:20 +0200
Message-ID: <20250930143822.014889115@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
References: <20250930143821.118938523@linuxfoundation.org>
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
index 3f1fa45d93682..388c95562a927 100644
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



