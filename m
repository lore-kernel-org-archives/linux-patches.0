Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0EE2E06C8;
	Tue, 17 Jun 2025 16:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178813; cv=none; b=tK04bfTnurqXgQZwLFY3aoqmhxtlsWalixblEy8P4BVcK0G2NRldDUEo7XBMpJlNliA23ftlUB3nh9X9Pd4jqqQNf9lYTvYZTeA1U9I3gpKZizHlTXsh73+TIeHt19wGhCWg2BIu4OnGbCtiZ+hqb5H7LM6zXO9lkEANL20t7AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178813; c=relaxed/simple;
	bh=iE71t5hclpJhFqaqIv0wJaG0vbeE919mroyvW1ySfIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b//7FT5YswK+i3WLfQeLKiRz89kdPxR+u4WmbW8pt6opBM/2UIbu5h8NkbBXjVx6xrnC4Y0S7V8eXErDbFjj0uRiMBe8VEUsLbAfQ5FeJ5r18+N+AKJhm34H0gTiH+ViZCH9/GxjJv1FwmUNDE1vk/C6NHuzH5z4KV8T41K5LBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eq9zPdXX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eq9zPdXX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE03C4CEE3;
	Tue, 17 Jun 2025 16:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178813;
	bh=iE71t5hclpJhFqaqIv0wJaG0vbeE919mroyvW1ySfIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eq9zPdXXGR/Ar4NlP4J07KGAnupuZHFCZNsdaXT5ou87WXO7PKWhP7NYn1fPybAOD
	 RJ9SILaBWv0iVn4+RJk8I95FQz86+goQA57lUM4IqUcOw35yXMCNyTuWCpAguK8Xe/
	 loyTKv0wN3O/eZ3vnAYHDItihhU+DLxMRPfQ/yeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 561/780] gve: Fix RX_BUFFERS_POSTED stat to report per-queue fill_cnt
Date: Tue, 17 Jun 2025 17:24:29 +0200
Message-ID: <20250617152514.338387353@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit f41a94aade120dc60322865f363cee7865f2df01 ]

Previously, the RX_BUFFERS_POSTED stat incorrectly reported the
fill_cnt from RX queue 0 for all queues, resulting in inaccurate
per-queue statistics.
Fix this by correctly indexing priv->rx[idx].fill_cnt for each RX queue.

Fixes: 24aeb56f2d38 ("gve: Add Gvnic stats AQ command and ethtool show/set-priv-flags.")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Link: https://patch.msgid.link/20250527130830.1812903-1-alok.a.tiwari@oracle.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index c3791cf23c876..d561d45021a58 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -2153,7 +2153,7 @@ void gve_handle_report_stats(struct gve_priv *priv)
 			};
 			stats[stats_idx++] = (struct stats) {
 				.stat_name = cpu_to_be32(RX_BUFFERS_POSTED),
-				.value = cpu_to_be64(priv->rx[0].fill_cnt),
+				.value = cpu_to_be64(priv->rx[idx].fill_cnt),
 				.queue_id = cpu_to_be32(idx),
 			};
 		}
-- 
2.39.5



