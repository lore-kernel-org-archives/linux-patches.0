Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3DDC1A072D;
	Tue, 27 Aug 2024 14:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769954; cv=none; b=a0Hh+UvWwy7k7zappjd2d8trjjeDflavWUKytNkKcUxIYP1Pk7JMKBnPxLLHDZEb/YnAaLjJ2aRo9vph17/YT1y/3/QG30C0RQ0mh3lhEHnZQcrYzgH4CG2eANovOKoU7zUw4DWBfJ+jWvcwHHWyrMlFVrWt/3omQ9SFqBO0KKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769954; c=relaxed/simple;
	bh=AjIMYj09psgi3C+66pJTcsWSdDROev9Ww6zrF7d5ZZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LhRNRMzgFYRjlqBpwMmrLuM0NVBK7VGU+q5lpJROtHCh7AM/8NYA8bRgpUVRI2cGza6ZhxnD95lbM6wqrxmAYlxKSmOz27ATzz7k1m14F7Qkm4xZ66pxbKVMpNr67t2AhE3dIpFysbgmL9yzC2XaUqlQEnNLOAVGd463UbVrPY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LrKqMUEw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LrKqMUEw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D837C61063;
	Tue, 27 Aug 2024 14:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769953;
	bh=AjIMYj09psgi3C+66pJTcsWSdDROev9Ww6zrF7d5ZZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LrKqMUEw3qgKi5OkZgFH/DQZTyYv3zcG2YxFkQWLn3B0l9wka5J7xxv++9c6z3HzC
	 XVs9wy8ZIWC5YeD6txHcKuC330YCk2oByHknEe/0INif2PJNRPyWNGb0wm37kUbT8w
	 nEixHtOt1EeHtz5EJElOWfaFbfwO81xDQhkHHATA=
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
Subject: [PATCH 6.6 052/341] net/mlx5e: Take state lock during tx timeout reporter
Date: Tue, 27 Aug 2024 16:34:43 +0200
Message-ID: <20240827143845.399132096@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ff8242f67c545..51a23345caa18 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -149,7 +149,9 @@ static int mlx5e_tx_reporter_timeout_recover(void *ctx)
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



