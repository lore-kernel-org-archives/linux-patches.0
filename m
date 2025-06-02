Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0635F224AF3;
	Mon,  2 Jun 2025 14:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876224; cv=none; b=ohop9SOPw5JYG69DSoXD2hxY4NEhU074AIn0Rb4Gz2JdbVZNxxmI6nQOcd9yN9cawO/U281yE7xRtsrdpWA5phQhXLmdtUaDCYJtQrI+aPJ4sC+CmCDDX7WmAlew2jrJ7zQ1yoTBV03r+5squUPQ0RRQRYgsoWeAF13tM66q7G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876224; c=relaxed/simple;
	bh=dyO1jfP2Z1vSy87KVzKyU7rKTrBVQWAxnhVM2k8VLeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aR5nQeX8VF50c/yh0FDPDmtya1FUEqR98WjNo7+NLIayxq4xz643KC802sALooG5zbCU5846Lf3EDrJnHaLodDP/sTxUHpViI9SUdBDmeREYNKwCuEWDjd3QNIUFy+J7HjXtIYDcz79csFH5wpeyxhsLAUAkf7mw+it8HPYMOUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XoW1aWrw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XoW1aWrw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA210C4CEEE;
	Mon,  2 Jun 2025 14:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876223;
	bh=dyO1jfP2Z1vSy87KVzKyU7rKTrBVQWAxnhVM2k8VLeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XoW1aWrwFoTpiqGejD7BgKcNsWuz9Sk8UeeUS0Rp/jr+rBfo7DkgjoBKs+aDTtNDK
	 WM5zWEBfviIJePVuGlwM79VFWeSWzahKLjn0geDe6RrBTo+1LRrotO1hSs4SlJvfB3
	 aKcmX0QPFelGKP01z+vUlMowEvr9nR/eEg205wSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 110/207] eth: mlx4: dont try to complete XDP frames in netpoll
Date: Mon,  2 Jun 2025 15:48:02 +0200
Message-ID: <20250602134303.037539566@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 8fdeafd66edaf420ea0063a1f13442fe3470fe70 ]

mlx4 doesn't support ndo_xdp_xmit / XDP_REDIRECT and wasn't
using page pool until now, so it could run XDP completions
in netpoll (NAPI budget == 0) just fine. Page pool has calling
context requirements, make sure we don't try to call it from
what is potentially HW IRQ context.

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20250213010635.1354034-3-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx4/en_tx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
index c56b9dba4c718..ed695f7443a83 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -445,6 +445,8 @@ int mlx4_en_process_tx_cq(struct net_device *dev,
 
 	if (unlikely(!priv->port_up))
 		return 0;
+	if (unlikely(!napi_budget) && cq->type == TX_XDP)
+		return 0;
 
 	netdev_txq_bql_complete_prefetchw(ring->tx_queue);
 
-- 
2.39.5



