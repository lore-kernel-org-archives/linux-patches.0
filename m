Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C29230CDB3;
	Mon, 13 Oct 2025 14:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367318; cv=none; b=EvImCfswtWEt1v2hHRx4us4UeIGCiD6CBkjt4pH91Ga2CZ2G7uqAM3U6kxPt5RTkFzcFY1GMTZsWNeQaT8L+FsuQNSb/Fmr1hhnI5yMpzZ9F4QT81slhPExbzOZkHxYNrXjD5dVOSx33Ec6I/SMrOS/hmEV/8owU89PZCW8dicM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367318; c=relaxed/simple;
	bh=GnKU+ZNBmaVfBRgnNAo+l6EXM4mR8k5kwUHLEcwZvhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QHAQZ37QHaH3O15AyKxe7ArvZzMz6Z76QiiX46cgSqdjS4mxn8aHnA+tJ/EYDXgR6hbX8Gr8kxARm4LYHma4AZ8ONdH4mJNL2GVhZ8jOWKRFwGMcpj/bti6Ettu9whzFokKStIILoJxA4kJVAkxc1VuWhVvP4gFAJNiPjYTjBMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SK1vrtnj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SK1vrtnj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4EFC4CEE7;
	Mon, 13 Oct 2025 14:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367318;
	bh=GnKU+ZNBmaVfBRgnNAo+l6EXM4mR8k5kwUHLEcwZvhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SK1vrtnjz6z8rCwH1mRfh3ZhCF1iyLKrrxxcBKTJIxACgVlFjdcAEOx4ppMcW8cWK
	 fzhJo1nLnbxLg8B7cApUbRTIAuF+MiYzyaVtH4EQdnfBhEF6LyBLrowpSZSOzyK6j9
	 f8lOmMrehoYcyQehRwp+L7lqK+MtEqClelN/YNxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Shay Drori <shayd@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 168/196] net/mlx5: Stop polling for command response if interface goes down
Date: Mon, 13 Oct 2025 16:45:41 +0200
Message-ID: <20251013144320.774631931@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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
index c83523395d5ee..4c614a256ee05 100644
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
@@ -1056,7 +1060,7 @@ static void cmd_work_handler(struct work_struct *work)
 		poll_timeout(ent);
 		/* make sure we read the descriptor after ownership is SW */
 		rmb();
-		mlx5_cmd_comp_handler(dev, 1ULL << ent->idx, (ent->ret == -ETIMEDOUT));
+		mlx5_cmd_comp_handler(dev, 1ULL << ent->idx, !!ent->ret);
 	}
 }
 
-- 
2.51.0



