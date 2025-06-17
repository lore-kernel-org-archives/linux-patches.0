Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C48F204F73;
	Tue, 17 Jun 2025 16:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177451; cv=none; b=k8QK0npBQwtAtH4BkbV6PUMOo2nT30XJqLM/2ZGwrDhFm5DeSeJtMLBgb/KMdq8B0+1Zdt7NdwkgiCr4xKBKIE1xCd8jhxuCnYeXCEY4QQjX4ozsOtLrDA16VeDclhq2fYWs7AQyIhWQranFTy+EYuhwzitnIoYiCbNPomxuXm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177451; c=relaxed/simple;
	bh=rvSrbNKj9aHhZs1wGggKt3h/baEalyDefPWCUhzQ+LU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQPYq3KuLpZ/qi8B0xXbSJqiDT3w9FV66tXISOCSZ+htaW7tqnl/qY6hFiYPXL9F6pWBg0lYe87l8mS1rw4PF3R3aT/nQuLOQwoqBW3gT48Q/AAdN9k+jgqmgayVQPCJfN47RYSvhtPsEssy6UE5S7e9i1fF38cPaB4RXY3v9yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wHwY2OpB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wHwY2OpB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70CEEC4CEE3;
	Tue, 17 Jun 2025 16:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177450;
	bh=rvSrbNKj9aHhZs1wGggKt3h/baEalyDefPWCUhzQ+LU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wHwY2OpBQTbkDgSQTDXOxKNTfUluquSqW2LiAsriV4dGhc1FaF9dbqQa1856Ox8Zj
	 a4jlveVlcOlPk7KDhi3T0rlLxm+tjQ+5xo/HYWaG77joYN4qZESmmPqDj94AdNbjNg
	 4yoS58R+o3T6sAxTWgjA7CAvvqU3uKQMVCkRhG+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 348/512] gve: Fix RX_BUFFERS_POSTED stat to report per-queue fill_cnt
Date: Tue, 17 Jun 2025 17:25:14 +0200
Message-ID: <20250617152433.688323471@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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
index 862c4575701fe..14f39d1f59d36 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -2207,7 +2207,7 @@ void gve_handle_report_stats(struct gve_priv *priv)
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



