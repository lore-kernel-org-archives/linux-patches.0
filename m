Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BDE81DF98B;
	Mon, 23 Jun 2025 21:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713253; cv=none; b=iF9uyo4qGzaMqkb3LifueWvXY2dA8guV9hCpB8QsB91EPKm264L3BZTZcpaEV9Q5Omnm/wI2/+IcKAsniEDdQdga0h+DzG7kO2jOoROENVaFISzhs3XkNtFoEuGfSPA5dDYL99mSVFc8LUj0WLXrtu/EaK1ULnD7+qrE4pun6gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713253; c=relaxed/simple;
	bh=R8qlonhhIzWXDzx2Pv3eVLUWzvbX3zRqMfcMxj8szmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cuvJKqOQIgbiqiQR+0PR0ZIcFcxXFZQR6v4CAQChcZlYZHNTVX0wm3zcQky9IgAcC8Vg8kN2djO5JWXjDqSpPc15xiI30+/+k3NCCS5jl+SwKASAJvSyyQ9iq3krsQ9xpbSiFpTqSt41N2wH9i3xOup7vvbJzSeGmCXR9mKbiOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DSBkyioo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DSBkyioo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBDC2C4CEEA;
	Mon, 23 Jun 2025 21:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713253;
	bh=R8qlonhhIzWXDzx2Pv3eVLUWzvbX3zRqMfcMxj8szmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DSBkyiooG3aupyH7Y5QkNn9ZfFjzKpFeToqqGl+/TGWTOE40JZpyVyjAK05hGIxMT
	 XA0I7Sw5G+bB+ie0xmI/3yu0r0GQF19vg07B+kFwt3tP92OzYWctbbW7mbw08sf2dV
	 ujCklRYOgVpipvM9h61beyeYFQRH0jAg0lHld81g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 113/411] gve: Fix RX_BUFFERS_POSTED stat to report per-queue fill_cnt
Date: Mon, 23 Jun 2025 15:04:17 +0200
Message-ID: <20250623130636.375409639@linuxfoundation.org>
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
index 2e2069e8130b2..f014b7230e256 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -1299,7 +1299,7 @@ void gve_handle_report_stats(struct gve_priv *priv)
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



