Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399AF30DED7;
	Mon, 13 Oct 2025 15:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370092; cv=none; b=pzBllwNB3ad4V6K5kdVdu/Daq2OOfyEsv52lgHd3cm/nwuh1ioAVHK4QZiPZfC6nxWyCzS1m6IJip4e5ut5/SBGrn2+OZFCzW4xEu5pUwLYudZceMk8TOg7ElvyO/K+z0+QfvoOvRDscpgSeK2VA1YZzdLNK/1w7FK/X5w/TGkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370092; c=relaxed/simple;
	bh=HDKQBV715n0tGbUbB1czpTsLxoUL1a+SoYir1me4zpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QPz398md9vKlTUAatU3Hr3ZjOTApbXP/xQjYqIsIalbQX8BM/rA4Q5kzrVHTXnMRujKMHaDVmtjzhzRG+4eqRejoKpfC0oL3KIaFJ3em5Ia3BityPZcgo+Xkef8x9euwOP5X/3rWNpocxW3WtJOD1JhD2cnQsRQFzeSys3URXZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GeJOcjZP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GeJOcjZP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE031C116B1;
	Mon, 13 Oct 2025 15:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370092;
	bh=HDKQBV715n0tGbUbB1czpTsLxoUL1a+SoYir1me4zpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GeJOcjZPqXwtMX0ba5XHLjgxBmlmu7pT4Fz0/9p5dW9nVOa989tuXd0vsKECesw+9
	 Pzw2/oGgD4kImHXvyLGU4Xz43bzIhAJyU7ZBpBkXFxrVW5r6sFel2uv2BEk16ZOFQS
	 JsMXwGO+En6tVNfMjeYHWtrR5hd4DKqRn3cV3S9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Shay Drori <shayd@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 475/563] net/mlx5: Stop polling for command response if interface goes down
Date: Mon, 13 Oct 2025 16:45:36 +0200
Message-ID: <20251013144428.495859951@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index e395ef5f356eb..722282cebce9a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -294,6 +294,10 @@ static void poll_timeout(struct mlx5_cmd_work_ent *ent)
 			return;
 		}
 		cond_resched();
+		if (mlx5_cmd_is_down(dev)) {
+			ent->ret = -ENXIO;
+			return;
+		}
 	} while (time_before(jiffies, poll_end));
 
 	ent->ret = -ETIMEDOUT;
@@ -1070,7 +1074,7 @@ static void cmd_work_handler(struct work_struct *work)
 		poll_timeout(ent);
 		/* make sure we read the descriptor after ownership is SW */
 		rmb();
-		mlx5_cmd_comp_handler(dev, 1ULL << ent->idx, (ent->ret == -ETIMEDOUT));
+		mlx5_cmd_comp_handler(dev, 1ULL << ent->idx, !!ent->ret);
 	}
 }
 
-- 
2.51.0



