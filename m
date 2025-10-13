Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AF7279DC9;
	Mon, 13 Oct 2025 15:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368695; cv=none; b=m1ACV6FuO19MDMIi0ei+KOcoIDUaQ4Y6Ziao/An8Zg+xbLdEBTHVrjk8+ht3srau/J7OyNy1W4QOT3nZ/C94iAysCXFY6lJHWyVxpFiD19Li5r/8jGbDCS4GDmNaFR/6shSvZ0nl6GD0+zmitR7PW4Vg0qV9nTLGDLxc/WnBthU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368695; c=relaxed/simple;
	bh=6iRYb/3vZcn7SQMp2BHBaQNkdlFw9RUXd6SOojfQXXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qtt+K4egmahu1i6LhAouYhFXkRXXAeteUL0Ot4bX+iMeZsLN18Zs8f1h6YyXYcfnGKBHQWj4LovyTRNh5VRou2Ks4NDiCT6XNP5JJDVMQocMEUx1nV2y1WYuO9QCNqpzxzocec8AkJGfO5w4PUDwu9s0fAdj+Yq+dE+n4eNM1Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X8ZKHu1Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X8ZKHu1Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09475C4CEE7;
	Mon, 13 Oct 2025 15:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368695;
	bh=6iRYb/3vZcn7SQMp2BHBaQNkdlFw9RUXd6SOojfQXXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X8ZKHu1QYMA/JNniVHfG2H3S7vVBe/tb2JjOGJ6m7yTwR6rxRecbR06vDVuC1VWj3
	 9YvxOyfqU23J3156gawyBILGzKxm+OMDAQnduvce6gj0BBIu0a/fs/L+ZLw5jOSN2S
	 7a8ApZfioOobuRAuyy0J3IaJ7P6gM+AhZlwnxg9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Shay Drori <shayd@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 217/262] net/mlx5: Stop polling for command response if interface goes down
Date: Mon, 13 Oct 2025 16:45:59 +0200
Message-ID: <20251013144334.059375025@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

From: Moshe Shemesh <moshe@nvidia.com>

[ Upstream commit b1f0349bd6d320c382df2e7f6fc2ac95c85f2b18 ]

Stop polling on firmware response to command in polling mode if the
command interface got down. This situation can occur, for example, if a
firmware fatal error is detected during polling.

This change halts the polling process when the command interface goes
down, preventing unnecessary waits.

Fixes: b898ce7bccf1 ("net/mlx5: cmdif, Avoid skipping reclaim pages if FW is not accessible")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 5bb4940da59d4..b51c006277598 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -289,6 +289,10 @@ static void poll_timeout(struct mlx5_cmd_work_ent *ent)
 			return;
 		}
 		cond_resched();
+		if (mlx5_cmd_is_down(dev)) {
+			ent->ret = -ENXIO;
+			return;
+		}
 	} while (time_before(jiffies, poll_end));
 
 	ent->ret = -ETIMEDOUT;
@@ -1066,7 +1070,7 @@ static void cmd_work_handler(struct work_struct *work)
 		poll_timeout(ent);
 		/* make sure we read the descriptor after ownership is SW */
 		rmb();
-		mlx5_cmd_comp_handler(dev, 1ULL << ent->idx, (ent->ret == -ETIMEDOUT));
+		mlx5_cmd_comp_handler(dev, 1ULL << ent->idx, !!ent->ret);
 	}
 }
 
-- 
2.51.0



