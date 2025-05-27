Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B5223ED75;
	Tue, 27 May 2025 17:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365396; cv=none; b=o+ZhXvufmbT7G0HftJ5QJgyqDyYS6abiCu932MpQL0qNvLXA1164klkqbPTpwVA4T9P6tQzWwoQZ2h0F6qTXxAA4PiD+7oQ6Rn0gX1uHIz12SoHgSU5wYWu4iOxF0aB1G71IwcMwHCeM5sdvsgtdZJw/5jKI/t+veJ7FdLs+SB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365396; c=relaxed/simple;
	bh=6A4dFzSAlyJj13dh+dJzbl+lSBHUCMcZvuR5jPIxYQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aAMpUZ3QE3eQ34c99DqpKCylD6X5YIkJbDR/PdjJJag+ZnwJjJMvWaQ6jELVjg3Sipj/Vorr3a7R5oM8kI/pcBX7kfpJN7lnp7w3TQvf+rQvlh9USN2Sp8vIN3Ch3b0Xe3W8MBDkMrYvzngNGqD5TPFO07ishndGmjFdrFaMSoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y1QOHi3p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y1QOHi3p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD39BC4CEE9;
	Tue, 27 May 2025 17:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365396;
	bh=6A4dFzSAlyJj13dh+dJzbl+lSBHUCMcZvuR5jPIxYQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y1QOHi3pKvYOdd2vjqEa5axIa04oHcLWLY3EqYZoMXSWuzD+MFBd6tPtsuLruktxo
	 S+m/GB0CKnt/0ooWYI5RwhzdHC3qXYC4ZtfKruc6xfdqczaNc5MRE+TLFiZ2Ex9Ozn
	 5pOxdyF32t8AgYXd49u/YNT4yhR1FZiCnf767NNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 345/626] eth: mlx4: dont try to complete XDP frames in netpoll
Date: Tue, 27 May 2025 18:23:58 +0200
Message-ID: <20250527162459.043103107@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1ddb11cb25f91..6e077d202827a 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -450,6 +450,8 @@ int mlx4_en_process_tx_cq(struct net_device *dev,
 
 	if (unlikely(!priv->port_up))
 		return 0;
+	if (unlikely(!napi_budget) && cq->type == TX_XDP)
+		return 0;
 
 	netdev_txq_bql_complete_prefetchw(ring->tx_queue);
 
-- 
2.39.5



