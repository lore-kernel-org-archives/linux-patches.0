Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE5E28032F;
	Tue, 27 May 2025 17:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367543; cv=none; b=u7tqo202AwlrqZqa7lXy5RcCD7xuhzmYStDCsRDEjfdAV7C7xXI2EATRVzZ1/qokYC3PKiTWloAuWxMv2Haz+MF29KEcDj5lsj5wn17eAwgjXTbn3wzeVXGOc7uhrz7W0aNRhgBrA6q4//Ly8f2D8Ro7xmmEvy3R8R5he1wBT3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367543; c=relaxed/simple;
	bh=JYjOWCtS2jGsK6bB3fWHwaApNwvKJwYUYMY0/rzo8uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AGBJ1OMn00+EqRjhBmc0CHwIi02+GUcLx1s6cuujpvhe0yaUJ3hvcfShISacb1Zs9nYHiixWSaczb7mQMjuW6z31OWfBrNjAKhxCdm/evuWNDqK7emetI2Xu3Y0gia0JMihxM0TjDlrcgHPtBWDShlqn32h/vodbfIPqJ6cq5Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ie2dCAUB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ie2dCAUB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 901B3C4CEEA;
	Tue, 27 May 2025 17:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367543;
	bh=JYjOWCtS2jGsK6bB3fWHwaApNwvKJwYUYMY0/rzo8uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ie2dCAUBkiFU4SwOSckRXfwWB6TvUROBO3y62dHT5TKKfw7TegZJBmIBL0K9MiLok
	 zOrUEw0F/yJPG5Nf8XVus/hgyr+khVqkYh1/ofihpXclx0/0KPL+2OZ03NiHs/GG8D
	 PfWXR4MuxWkpj2TAwTrZRt4/mw/MNmHJVQO25mtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 422/783] eth: mlx4: dont try to complete XDP frames in netpoll
Date: Tue, 27 May 2025 18:23:39 +0200
Message-ID: <20250527162530.308549683@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



