Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D3A1ACEDA;
	Mon, 23 Jun 2025 21:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713096; cv=none; b=kx4IkrytvtZaA//KMckxIXq1s8qv7G2gmNYKSEheRxO898akUtFGCZoHP9zmfPhn4YE1UoI17yQNpoaO5zJ6Rj5ILIWw3LPAA0Q6B6a/a3QMkzy/2b3fvmeVpvbr0cMOmJ3fUIRcU20CIaEGtFldO2Xh4aNWCXmGkpccifGy/5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713096; c=relaxed/simple;
	bh=W5MmjbucTmZq56PuiNNF1NL4loy/s6wpg6//qKOcXT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tn463Xw/JwcnUtqUV5voXkEcFO5OsKgnplYiQYSyYwPJ3h/sIcyaep/XvDTE4iyCAb5uDs7S3N01lEc/Jg3fGf24th6HddBCtKWm9iXfSu8k14lN+rHW9L1v9Be6OO85qgJE0mTJEarR8OmTdqS9hvn4Rr1LBb21VeitIhBdIUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ghbWr3t6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ghbWr3t6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0331AC4CEEA;
	Mon, 23 Jun 2025 21:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713096;
	bh=W5MmjbucTmZq56PuiNNF1NL4loy/s6wpg6//qKOcXT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ghbWr3t6cSErEFkaMPKzoiMm5SfDholoGwlld7jhXH/vil4eAr53G479GVbXyUgmu
	 UYnwxOz/DaI3KosCDB6iIZHBBb0gOgnStb0iSbO31LcBMQh6nK0EqgLhifHSPB2ccx
	 2wxSG5cXphI/I0u/MHSGzn7SLSNKVSW9jg7FCyfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Mina Almasry <almasrymina@google.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 124/411] gve: add missing NULL check for gve_alloc_pending_packet() in TX DQO
Date: Mon, 23 Jun 2025 15:04:28 +0200
Message-ID: <20250623130636.680864227@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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
index dfbb524bf7392..c6f1f4fddf8a7 100644
--- a/drivers/net/ethernet/google/gve/gve_tx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
@@ -462,6 +462,9 @@ static int gve_tx_add_skb_no_copy_dqo(struct gve_tx_ring *tx,
 	int i;
 
 	pkt = gve_alloc_pending_packet(tx);
+	if (!pkt)
+		return -ENOMEM;
+
 	pkt->skb = skb;
 	pkt->num_bufs = 0;
 	completion_tag = pkt - tx->dqo.pending_packets;
-- 
2.39.5



