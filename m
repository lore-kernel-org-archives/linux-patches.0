Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56301465A1;
	Mon,  2 Jun 2025 14:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875715; cv=none; b=Q7pl8MQax/mc/REJ96rA5FWZRaZxxfjOXhLfk1IIyiRQavlED4n+VvXj36f8xnfNz9OdomLBcNHJ38E48hSkAiTGXZ/YjEIOeCxreGghHL5eoTqqv4yCjxBRnxSErBlLSOqG4qgWiM/06tv8P/SJYrbsMOkVpEQ/2BgFdOT1aQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875715; c=relaxed/simple;
	bh=0Z4imrn6oSYk839Qvjlm5vDrkMdM0qdo/xUFbDRkwjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UqtHk1zf39PwFhqJXTSXIaiwDjNRuVp9a2IbO228lHZ0AH1Qpe52JSXoFh3tgTBeV7G8ryldzeTAOkiWuPmJ9Nqw1NZrjxyx4vOi7j4dYb3iAV3KsHQvIsDXYUhhZ7vpzuoY2bJVCuLHXgK/pCeq8cD8p2nPHSoz/OmACfgzwyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pwj0f0nS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pwj0f0nS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 176B0C4CEF2;
	Mon,  2 Jun 2025 14:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875715;
	bh=0Z4imrn6oSYk839Qvjlm5vDrkMdM0qdo/xUFbDRkwjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pwj0f0nSZZD7+CXNXYGakS+zdeAXPBNNJPD8CSyIMYWgEHjamGhT0Vsk+5YUHbs0Z
	 7Xamwl+zCfMUnDHzMskoc9bnu+ZmfClFmOR0ArrEmITmuLFrBWNR9lthUXkfa0jggn
	 PwMrJoo84/Rnp6Iz/sVoBzvv3RWG4xQw39c3EYqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 194/270] eth: mlx4: dont try to complete XDP frames in netpoll
Date: Mon,  2 Jun 2025 15:47:59 +0200
Message-ID: <20250602134315.130413245@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 59b097cda3278..6c52ddef88a62 100644
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



