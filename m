Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C1512B93;
	Tue, 27 Aug 2024 15:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771119; cv=none; b=gcl9GMz4E2w0S0PFM+tmiWzwEvwQHW9pxelkzcMq9Nno+hnw3DG/JauGDUxXa9Fv/1gzzT5pe+l8qO3Ww0i5SsnOQrO1vNOX3arxET4P+uSBhO0TC/bLTvZrofqKK+/X6ixjFBSAlfB9ICHtDYOhCYyv2fBuEX+qkKPRvilhC0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771119; c=relaxed/simple;
	bh=GIIk5WEY2/vHnJw5hw6NlOeCP+NYu6zsuyneHaeeHfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Spe/pUk6vyUX1npfy5V25KX9TzSy26plfDdc1DsoLbwnFiJPVVUEiGtKYlAYTSPhasCKIINLp6M7go/vq81hNqM5GIZF1XUphcZXFtQEoyzoHDOLyrQejZgFZk9mnRlOGwiu8rEiAz6C4WdC7ABn54CcnPiIt0gMD+zAU9S/sQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W847VLfg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W847VLfg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A5D3C6105B;
	Tue, 27 Aug 2024 15:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771119;
	bh=GIIk5WEY2/vHnJw5hw6NlOeCP+NYu6zsuyneHaeeHfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W847VLfgWJVXcR8Gys0e5302ldkGyG56BMtoPZArs3MieV+54RCDw3I6UQPkq/Ier
	 T7Y9p9Q0DBdqsFNr0k19F7R6fkKXZOOEyj1/hMENwb/LKUWWmfhrKLG/lCko826SOt
	 H8GlMf5/JyLsOr5gL59XcIx7mSrTBlKQOXMMSFmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Breno Leitao <leitao@debian.org>,
	Moshe Shemesh <moshe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 091/273] net/mlx5e: Take state lock during tx timeout reporter
Date: Tue, 27 Aug 2024 16:36:55 +0200
Message-ID: <20240827143836.876372244@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dragos Tatulea <dtatulea@nvidia.com>

[ Upstream commit e6b5afd30b99b43682a7764e1a74a42fe4d5f4b3 ]

mlx5e_safe_reopen_channels() requires the state lock taken. The
referenced changed in the Fixes tag removed the lock to fix another
issue. This patch adds it back but at a later point (when calling
mlx5e_safe_reopen_channels()) to avoid the deadlock referenced in the
Fixes tag.

Fixes: eab0da38912e ("net/mlx5e: Fix possible deadlock on mlx5e_tx_timeout_work")
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Link: https://lore.kernel.org/all/ZplpKq8FKi3vwfxv@gmail.com/T/
Reviewed-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20240808144107.2095424-4-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 22918b2ef7f12..09433b91be176 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -146,7 +146,9 @@ static int mlx5e_tx_reporter_timeout_recover(void *ctx)
 		return err;
 	}
 
+	mutex_lock(&priv->state_lock);
 	err = mlx5e_safe_reopen_channels(priv);
+	mutex_unlock(&priv->state_lock);
 	if (!err) {
 		to_ctx->status = 1; /* all channels recovered */
 		return err;
-- 
2.43.0



