Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48251DB148;
	Thu, 17 Apr 2025 18:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913316; cv=none; b=f/CWDBTl4nQJkluBu6pRwAiQTOaOMj3aWL1EzHehGJTw9smIcr/s6YapMYHX7SxnlTnL1Vk/r1dCvi+bS7NJin6rEzo2omz8tPOHqklBMn2LIv+bJZsXKGf/JCevPPEZRm/7zCBpVtj021/0RODuvZe3FUdIhkCwAc6rdKqmDJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913316; c=relaxed/simple;
	bh=nYdtyk0iRVnZlSFNPIxZ7j3EvPfxhEtVP4tROVHBXXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GnGBSKWha4lbuzualKT2GC0un/PK7pieuYcXlsfwYVM5qahGFB7krOnYu8A566KkTu9YU6mxkSPkUPMZCkm4g23qei3RFZiG/sBnmnwXAEujQVifpmnjqulYUNqkXx44TXGMFf9MgMdNTvVwY6hoAdccSiUcfgX1U3wTy9ISN/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SxKVXUiq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SxKVXUiq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E8DAC4CEE4;
	Thu, 17 Apr 2025 18:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913316;
	bh=nYdtyk0iRVnZlSFNPIxZ7j3EvPfxhEtVP4tROVHBXXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SxKVXUiqoQFg9vd7iZz7YhPeF2sJunZPtq/jH9Qnt2NSB4XqTJIXZ9cphlelk9X9F
	 hI1Vbq8i+Dliu7t0nFNk40riqkYH1jcFzzS/iUxis7ADin89+tzYU/ZoAi1JG8J2IR
	 HzpDaJdOcJZTv8rY+o6FMI3kKbjl1Xw1fbyDUrTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Washington <joshwash@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.14 268/449] gve: unlink old napi only if page pool exists
Date: Thu, 17 Apr 2025 19:49:16 +0200
Message-ID: <20250417175128.814610511@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

From: Harshitha Ramamurthy <hramamurthy@google.com>

commit 81273eb87af86d4a43244b553762348e364b2df7 upstream.

Commit de70981f295e ("gve: unlink old napi when stopping a queue using
queue API") unlinks the old napi when stopping a queue. But this breaks
QPL mode of the driver which does not use page pool. Fix this by checking
that there's a page pool associated with the ring.

Cc: stable@vger.kernel.org
Fixes: de70981f295e ("gve: unlink old napi when stopping a queue using queue API")
Reviewed-by: Joshua Washington <joshwash@google.com>
Signed-off-by: Harshitha Ramamurthy <hramamurthy@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250317214141.286854-1-hramamurthy@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/google/gve/gve_rx_dqo.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/google/gve/gve_rx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
@@ -114,7 +114,8 @@ void gve_rx_stop_ring_dqo(struct gve_pri
 	if (!gve_rx_was_added_to_block(priv, idx))
 		return;
 
-	page_pool_disable_direct_recycling(rx->dqo.page_pool);
+	if (rx->dqo.page_pool)
+		page_pool_disable_direct_recycling(rx->dqo.page_pool);
 	gve_remove_napi(priv, ntfy_idx);
 	gve_rx_remove_from_block(priv, idx);
 	gve_rx_reset_ring_dqo(priv, idx);


