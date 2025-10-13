Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5721430F936;
	Mon, 13 Oct 2025 15:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367873; cv=none; b=G+6odtms5MGnFhSgv66LY9cZJCbZ/Bk4nqD+30xHQtCw6FcnYuxbBcAa2BP20obut+fA4CqOMcipXpv5faeX+jB9RznTurh7t3ouhsnnVdAobDyPIeBruahYtNa5QAlRFdZiTwPkzqp/TaARn8OCDG8KEVGG3uFJhw+tNfl5Ia0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367873; c=relaxed/simple;
	bh=Vy3I7362oG7gB6rH9H7Zwjgz1tvlGxTWXgJHw7YOGG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c3HQLV9G+R6lhlN5S3OY0aLICE54+XmaxoPk9EYV2x5/6c7DnvhStspHj7ihbQruaBJQz7U2cfE4IJOCdpGTmHoyGXLfyEIC2Lox/N1B0r9sPHwzKCOcpWjM5f/8Hdp0RIt40wdnsA+Es8Pfv2Cgc9CoFROz2qW2Y/mKrAdVBSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xmsgXA+o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xmsgXA+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF4C2C4CEE7;
	Mon, 13 Oct 2025 15:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367873;
	bh=Vy3I7362oG7gB6rH9H7Zwjgz1tvlGxTWXgJHw7YOGG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xmsgXA+ocSKnYyobWNnOaWjBN35/1T4FOVEpxk0xjUPbfYZPdF42M0qkABs6i6Kx7
	 QLsN61D3zqLx0l8qCIqxdGa9PL6+DTVwrJzjjAzLhlYL4j2O4BJvc6Zt9Y4rd5Dxm3
	 EfGbBVVObVprWln8mZZx62Q3HaqCCNPnQ4ry43RU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Shay Drori <shayd@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 162/196] net/mlx5: Stop polling for command response if interface goes down
Date: Mon, 13 Oct 2025 16:45:53 +0200
Message-ID: <20251013144321.171850738@linuxfoundation.org>
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
index 5a2126679415c..336e0a54b3dc2 100644
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
@@ -1059,7 +1063,7 @@ static void cmd_work_handler(struct work_struct *work)
 		poll_timeout(ent);
 		/* make sure we read the descriptor after ownership is SW */
 		rmb();
-		mlx5_cmd_comp_handler(dev, 1ULL << ent->idx, (ent->ret == -ETIMEDOUT));
+		mlx5_cmd_comp_handler(dev, 1ULL << ent->idx, !!ent->ret);
 	}
 }
 
-- 
2.51.0



