Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045732528E4;
	Wed,  5 Mar 2025 18:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198740; cv=none; b=f90VeLgZOqWTlacO+UdpC3Y3/3RyPCZydNJ9MDyXf/ANsV3eC3Gk+qI8c5Ufg6P2lbeNoAJQdHtzUymALzOA5Pu4+/pdeIdxhYkuy7E6xjnocvBzvr6vyv4Acc9znDoUwR64k2zamYsDisPcZW9zi1sphM/a2GO7KtQRV7jPlfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198740; c=relaxed/simple;
	bh=UjdgYKl84kipd0d5iNEJDgAdUySG12P8fZWaAnn40AA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JMJeJCtCi2H65IcMQudoOu0OGPall0zv6R+3UaiK2x6lbtfmwM5pUzPKES6sBuijbu4DrmIXU5iEVaau3MLLU5dK9Tx6Uaiw1PD7cBzBNjfU5GGYGWojymhKU+I6Ip0Yzhk8QsRynQhdjb6TDsx5pU9Fdr63/uudE2txaGdOLMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o8TCPuWN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o8TCPuWN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BE3BC4CED1;
	Wed,  5 Mar 2025 18:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198739;
	bh=UjdgYKl84kipd0d5iNEJDgAdUySG12P8fZWaAnn40AA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o8TCPuWNtE/tGm5j+o9J383UUik5lEMe44VZbdSONp7gWMrqG7tE5aDCE8hw8asvg
	 b/BlEFtV5BOfgYLSENfQ1AFSMqlLYp7QXarEmrvnfw10J8VMWO1rI/7mxL0jHTuewY
	 3JjQCYrfyhZ5W5zu0elCl/XP7+PRkubnVXGIEOiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Praveen Kaligineedi <pkaligineedi@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.13 124/157] gve: unlink old napi when stopping a queue using queue API
Date: Wed,  5 Mar 2025 18:49:20 +0100
Message-ID: <20250305174510.289962948@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harshitha Ramamurthy <hramamurthy@google.com>

commit de70981f295e7eab86325db3bf349fa676f16c42 upstream.

When a queue is stopped using the ndo queue API, before
destroying its page pool, the associated NAPI instance
needs to be unlinked to avoid warnings.

Handle this by calling page_pool_disable_direct_recycling()
when stopping a queue.

Cc: stable@vger.kernel.org
Fixes: ebdfae0d377b ("gve: adopt page pool for DQ RDA mode")
Reviewed-by: Praveen Kaligineedi <pkaligineedi@google.com>
Signed-off-by: Harshitha Ramamurthy <hramamurthy@google.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20250226003526.1546854-1-hramamurthy@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/google/gve/gve_rx_dqo.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/google/gve/gve_rx_dqo.c b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
index 8ac0047f1ada..f0674a443567 100644
--- a/drivers/net/ethernet/google/gve/gve_rx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
@@ -109,10 +109,12 @@ static void gve_rx_reset_ring_dqo(struct gve_priv *priv, int idx)
 void gve_rx_stop_ring_dqo(struct gve_priv *priv, int idx)
 {
 	int ntfy_idx = gve_rx_idx_to_ntfy(priv, idx);
+	struct gve_rx_ring *rx = &priv->rx[idx];
 
 	if (!gve_rx_was_added_to_block(priv, idx))
 		return;
 
+	page_pool_disable_direct_recycling(rx->dqo.page_pool);
 	gve_remove_napi(priv, ntfy_idx);
 	gve_rx_remove_from_block(priv, idx);
 	gve_rx_reset_ring_dqo(priv, idx);
-- 
2.48.1



