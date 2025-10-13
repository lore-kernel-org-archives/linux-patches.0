Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71EE830F818;
	Mon, 13 Oct 2025 15:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367876; cv=none; b=RwFdN8x+CbNgd28bk5q7R3FEfYAW7CD+Re781+LpjC5FVygfOVT7Yuk/GAa8O+jGN2D8xLITbJI+95DAcBkfbH5BHtC/AqgMv/DaWc4AdyQlUIEJ9qWM8668Q7rbOTL99JMsUZe/RZM/EY2cG4YdqzSrbYic95xK4hyTpfG7vAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367876; c=relaxed/simple;
	bh=42akdj8HUScdXPNot71D7Kz75kSZlBNYGbxQGJcvHRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RhiLYYY3qYFGdTULTxLR7zQRa5hOmK0aE8Xo6wCCgJCcXvQylFv+kaqylunW1DrHS6UtcTXfj5nKdbAfZEQA1VXo1ZKLdS/U/mY+xX7aQC8RqdfWo6op7zIGF0aTufm+Lfv4ZUJkdKJEVN1eL1Xdf1liozoxAXRu+R5Ymc9A3Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=APzOY3qV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="APzOY3qV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9727AC4CEE7;
	Mon, 13 Oct 2025 15:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367876;
	bh=42akdj8HUScdXPNot71D7Kz75kSZlBNYGbxQGJcvHRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=APzOY3qVd2M8QypCIR3LUUyXq4MzEzw5aprKkeuUviwhdDJGR6HNm3zcINUGiyp5j
	 i74S3o0+R5hzlB3ne99hYUCdol0i3LMyM3T0zk1nyMW6FMSQKtjVIdFShFr+0YxYIn
	 WJ+yFk5LHZWk7MbLicujpc/gCRubbXcz6Fbgr/BA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 163/196] net/mlx5: pagealloc: Fix reclaim race during command interface teardown
Date: Mon, 13 Oct 2025 16:45:54 +0200
Message-ID: <20251013144321.207799607@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 79a0e32b32ac4e4f9e4bb22be97f371c8c116c88 ]

The reclaim_pages_cmd() function sends a command to the firmware to
reclaim pages if the command interface is active.

A race condition can occur if the command interface goes down (e.g., due
to a PCI error) while the mlx5_cmd_do() call is in flight. In this
case, mlx5_cmd_do() will return an error. The original code would
propagate this error immediately, bypassing the software-based page
reclamation logic that is supposed to run when the command interface is
down.

Fix this by checking whether mlx5_cmd_do() returns -ENXIO, which mark
that command interface is down. If this is the case, fall through to
the software reclamation path. If the command failed for any another
reason, or finished successfully, return as before.

Fixes: b898ce7bccf1 ("net/mlx5: cmdif, Avoid skipping reclaim pages if FW is not accessible")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index e0581c6f9cecd..5df1472fe2be2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -489,9 +489,12 @@ static int reclaim_pages_cmd(struct mlx5_core_dev *dev,
 	u32 func_id;
 	u32 npages;
 	u32 i = 0;
+	int err;
 
-	if (!mlx5_cmd_is_down(dev))
-		return mlx5_cmd_do(dev, in, in_size, out, out_size);
+	err = mlx5_cmd_do(dev, in, in_size, out, out_size);
+	/* If FW is gone (-ENXIO), proceed to forceful reclaim */
+	if (err != -ENXIO)
+		return err;
 
 	/* No hard feelings, we want our pages back! */
 	npages = MLX5_GET(manage_pages_in, in, input_num_entries);
-- 
2.51.0



