Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C141C8FDE;
	Tue, 27 Aug 2024 15:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772007; cv=none; b=dq6i8+6CLilfR7YRRrNJUb3iRcs+fPHRanZuNTKvne4kN2EeIIQfJI2oLNcfqKJyV9+AuSXaaJj/lalJbk0F1WdvvPYPqshScYJ/J/MMaWqbzonwvz292tYoQLQ/Ee/w8/n3pIe2Ai9A3v0bABuOx13n8cMU/ipjHNkIhETfpw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772007; c=relaxed/simple;
	bh=goU+5W0sQi0kOsTlUKAlBEJUJ8itLBTNFAh5+vkV5yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SO4knR89pZezqb/UapDR+PO0NKpOi2AzGAaLLF4AvxQdAHqJUgIza1Y1lzIjnDWTllWkv4UYnFgCY6bba4B71uMvrQU7ZkuoyPxV06GEE7lagD37IdLiyWgicFk67aY7CYK96+to83K7DLxUE4fDcfj4paCiqSASZhN8N9w5XbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2k+T2LwB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2k+T2LwB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8782AC4DDEB;
	Tue, 27 Aug 2024 15:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772007;
	bh=goU+5W0sQi0kOsTlUKAlBEJUJ8itLBTNFAh5+vkV5yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2k+T2LwB7nzxEbUAWJFJdR5mo7EeEOcU4AnRApPseix5iHjJjmHal5xKfFXpw8+FP
	 Mneh6TNtF3I8L8TX1VFHxrKtZTA67zbaTvkKEofEcEQqCHTWiHXtYmV2IBi23GeUiB
	 kJKxoUB1NeMdHrapG0zwTVIEeYEQq1DDfDgPnIWc=
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
Subject: [PATCH 6.1 085/321] net/mlx5e: Take state lock during tx timeout reporter
Date: Tue, 27 Aug 2024 16:36:33 +0200
Message-ID: <20240827143841.475396595@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 60bc5b577ab99..02d9fb0c5ec24 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -111,7 +111,9 @@ static int mlx5e_tx_reporter_timeout_recover(void *ctx)
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



