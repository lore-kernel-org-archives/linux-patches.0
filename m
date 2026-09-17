Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61BAA518141;
	Thu, 17 Sep 2026 17:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667355; cv=none; b=H5LrPuUtcURCvEN4FprSOQte29mK/NSG4ON9uLKNSgZFy/1jKPa5m+xR72mqNdz+NCeRwYISN0mmxRJVT/g3gXFipJ72/jiesfBDjSGtM6REMR7j4bwV0ygB8lSH7lScvV3AMTvtco7KvHk+vaai9H+8AnLTudy6dzl9Uk71pwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667355; c=relaxed/simple;
	bh=43/z/fh3Vi2impWOfkWM0LkVdk4S/e85+nbxJ+87Fyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mg2yoEEbCK2hRH2DmF8bjF+RnsId0OUYr5wHJcYAHzc5VLWVAMpPqE+wHbyt4Zw7kKKeluJpQprrkhiY8Mycf5bB5xnTslSaU/tZINRONoDir5HMsSFQx65mlm4EscmQ2K/5UaPYyOAzHoWU2J1cgUhoWk0YBpeRuPJmQHgzaMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DbjJZMCf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DbjJZMCf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 655CE1F000FF;
	Thu, 17 Sep 2026 17:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667351;
	bh=zBLAzz+xpMS3oGit54jPsGt9SG8xL7WWwG0AtXlSi4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DbjJZMCfmN+8lEwp00Mi/CM5FhjNojo47Lswr6dGOGZ/fUFUAIMr480gTvMhLFttL
	 Fbr+qYe5chIwiMEd/48Zc93ZfXDhzcRQKXRpchosEl5O0/WMypRjRcdUONzIXwSQ8u
	 LUtVNnvQyd0rI2vsckMRbnooT9hNg8gCj3IGlGmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erez Shitrit <erezsh@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0064/1102] net/mlx5: HWS, Handle destroying table that has a miss table
Date: Thu, 17 Sep 2026 16:00:07 +0100
Message-ID: <20260917151541.065003009@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

[ Upstream commit 60e9e82f162ab7399373ff2185119289e4f6dc06 ]

If a table has a miss table that was created by
'mlx5hws_table_set_default_miss' API function, its miss_tbl
keeps the table that points to it in a list.
If such table is deleted, we need to also remove it from the
miss_tbl list, otherwise the node in miss_tbl list will contain
garbage.

Signed-off-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260507173443.320465-3-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_table.c   | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_table.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_table.c
index 8c063a8d87d7d..9cbe3d71e6f3d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_table.c
@@ -275,6 +275,9 @@ int mlx5hws_table_destroy(struct mlx5hws_table *tbl)
 		goto unlock_err;
 	}
 
+	if (tbl->default_miss.miss_tbl)
+		list_del_init(&tbl->default_miss.next);
+
 	list_del_init(&tbl->tbl_list_node);
 	mutex_unlock(&ctx->ctrl_lock);
 
-- 
2.53.0



