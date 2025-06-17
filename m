Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FAF42F2343;
	Tue, 17 Jun 2025 16:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176285; cv=none; b=J/DpcBYUk5Ev3vnjybs0Zrnx1iiIOwj+A2UCcA1ubCvg+DnexNa/dCgLN3acKj4cfciAT2dqVlsTkOKzCUUNbxh9XW40RrrH4eEeXKgsc6df1ih5Tdps5UaHe69H+nPEPxivA6WN4DAf4gwL6VIFrqsgbOqhLCKQJX4Imv54NBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176285; c=relaxed/simple;
	bh=9X2azqvEAKsu+LwKXQ0fjWER52+/Q/JubWi5sqBcokY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DGk+gguoYm3uBlDedbVw7bZGEKRUAtdIgm5t8rF1uuu8bTsS6SkK+63xPtpDe6jepN9E3vACKy2lwTedp72++Ot92a6hnPvBMBtZXHN0OfZ5fXEgn22lkCWgEM+xcAcA655ixstVX0Zlmq5611Zl7DFj80fsJmwEWQ/Qt0CLOJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eOUeJf5g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eOUeJf5g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9934EC4CEF1;
	Tue, 17 Jun 2025 16:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176285;
	bh=9X2azqvEAKsu+LwKXQ0fjWER52+/Q/JubWi5sqBcokY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eOUeJf5gXJfDR6YLdJJ0VAx2hIXxNw+4NvV1E3WCl+QinhTr8Te8sap9zHOn4YkXD
	 0Zd0lC1qeqU1u/owfjxl/2C2pf2jl5coEc7BCQKY9/UBf+jToJe0YOG+H+Aclm96rO
	 pfQavjLF2boyf+OA50KHByyDLsyF3uWrFqbC8U/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Mina Almasry <almasrymina@google.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 262/356] gve: add missing NULL check for gve_alloc_pending_packet() in TX DQO
Date: Tue, 17 Jun 2025 17:26:17 +0200
Message-ID: <20250617152348.751362645@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 12c331b29c7397ac3b03584e12902990693bc248 ]

gve_alloc_pending_packet() can return NULL, but gve_tx_add_skb_dqo()
did not check for this case before dereferencing the returned pointer.

Add a missing NULL check to prevent a potential NULL pointer
dereference when allocation fails.

This improves robustness in low-memory scenarios.

Fixes: a57e5de476be ("gve: DQO: Add TX path")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_tx_dqo.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/google/gve/gve_tx_dqo.c b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
index 89b62b8d16e14..857749fef37cf 100644
--- a/drivers/net/ethernet/google/gve/gve_tx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
@@ -716,6 +716,9 @@ static int gve_tx_add_skb_dqo(struct gve_tx_ring *tx,
 	s16 completion_tag;
 
 	pkt = gve_alloc_pending_packet(tx);
+	if (!pkt)
+		return -ENOMEM;
+
 	pkt->skb = skb;
 	completion_tag = pkt - tx->dqo.pending_packets;
 
-- 
2.39.5



