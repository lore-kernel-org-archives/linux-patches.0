Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5AE25228D;
	Thu, 15 Jan 2026 16:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496173; cv=none; b=h9GqhLZ38scI1VAc+SAH7qZyyRz79pmD1JMRPvkRHwEFYlHS734w24a/vVtT/lVs2ToBYafT9x6DIUmwVFj/Y5vf7G163aCV4fi10EXSv3euci1lKr893izDz62NDN9PG5AG4tXDjojrbVlqoIt+vIFQlFyYHA0NGqqeRTfkbiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496173; c=relaxed/simple;
	bh=Nko+aIr0tn1MT8yAQk69t7mahGPNDxeM2Lw1Yd6awR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lC6GzvJIHDCSWKgK5m1rhJseTQ2DOZDxKatMcZ8LN6PVMNOIErFzU/vAG01d44gFZ3xg1EzxFnRvQojuA/Obkrm1hgtZLD1uE2l9ezdu2oUH82Mk3zcDqZjC+e0gtK080pWpsxZ2HZLtNgTXWx1qa5F9n8ya20uhG8RTfZWHj2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nFORO4Td; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nFORO4Td"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2608FC16AAE;
	Thu, 15 Jan 2026 16:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496173;
	bh=Nko+aIr0tn1MT8yAQk69t7mahGPNDxeM2Lw1Yd6awR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nFORO4TdKb6wrkd6kMKz2JAiSnVlpR6ZvM1BJrCzDyL2paOAcQEDdE8pQ2RWpDLlr
	 zsyjsfEH80P84YMZdaZqTjE/DuWs3X8S08Nq6QozienELCdP3v1CwiRVJajOFsZNZS
	 mnKh8ZXF5ncGc6FaNnxI1O+cSW1UjxSrZSRy0q9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 102/181] net/mlx5: Lag, multipath, give priority for routes with smaller network prefix
Date: Thu, 15 Jan 2026 17:47:19 +0100
Message-ID: <20260115164206.002097620@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Patrisious Haddad <phaddad@nvidia.com>

[ Upstream commit 31057979cdadfee9f934746fd84046b43506ba61 ]

Today multipath offload is controlled by a single route and the route
controlling is selected if it meets one of the following criteria:
        1. No controlling route is set.
        2. New route destination is the same as old one.
        3. New route metric is lower than old route metric.

This can cause unwanted behaviour in case a new route is added
with a smaller network prefix which should get the priority.

Fix this by adding a new criteria to give priority to new route with
a smaller network prefix.

Fixes: ad11c4f1d8fd ("net/mlx5e: Lag, Only handle events from highest priority multipath entry")
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Link: https://patch.msgid.link/20251225132717.358820-2-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
index aee17fcf3b36c..cdc99fe5c9568 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
@@ -173,10 +173,15 @@ static void mlx5_lag_fib_route_event(struct mlx5_lag *ldev, unsigned long event,
 	}
 
 	/* Handle multipath entry with lower priority value */
-	if (mp->fib.mfi && mp->fib.mfi != fi &&
+	if (mp->fib.mfi &&
 	    (mp->fib.dst != fen_info->dst || mp->fib.dst_len != fen_info->dst_len) &&
-	    fi->fib_priority >= mp->fib.priority)
+	    mp->fib.dst_len <= fen_info->dst_len &&
+	    !(mp->fib.dst_len == fen_info->dst_len &&
+	      fi->fib_priority < mp->fib.priority)) {
+		mlx5_core_dbg(ldev->pf[idx].dev,
+			      "Multipath entry with lower priority was rejected\n");
 		return;
+	}
 
 	nh_dev0 = mlx5_lag_get_next_fib_dev(ldev, fi, NULL);
 	nh_dev1 = mlx5_lag_get_next_fib_dev(ldev, fi, nh_dev0);
-- 
2.51.0



