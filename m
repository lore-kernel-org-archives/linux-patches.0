Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A00A15B0E2;
	Mon,  6 Jan 2025 15:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178050; cv=none; b=XroFKMG/Utnz/HDUUd6RnL1RKBlSeWFF0VXx8l0A+QjrjlegqELPDj06GK0/G6+6fRzpaPC3oSE9ar9r6bPEEfvZAeRFy2QlWHnJFE0yLCHUAyqX59t1FAjUV6NJDjcYAsWJCxYCWB/RVjMOA+fbhv7FZTeiNEx/61NF2E5K5xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178050; c=relaxed/simple;
	bh=QSrENc8jtfykIgF19ETI++dh2oR71v8SvqiwNajIXL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t0tPn9sYeRy44k+m0oiToTpb3HuoN1DgeZvA3AL0SZnDbEb3oHkB72mbiyZLNIOq6XEnpQKBSZrPUWUYljIlxk+nMRAWflMH0GTfZcEbwRbrZRs6y/D8A+IZtHVYQL6/vJqwJBtK91Tvh5LB5NborYSvUcfX+cOWT26BpPsZDzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kRH7WoXR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kRH7WoXR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 566C6C4CED2;
	Mon,  6 Jan 2025 15:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178048;
	bh=QSrENc8jtfykIgF19ETI++dh2oR71v8SvqiwNajIXL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kRH7WoXRPcmQD7GVoJVp6RsBRnViQMKNJjtCttxLBSWpNJpwWLWIIx+4GgaVbagjT
	 qHuEHJlvwdlpBffwmY7QkWP4Q2vSc6PU5vUkFzGzIuoirA5mvzTXcbnQEZCz+HOOjW
	 26Dupg1yyPDQLxW/6A8uM70mpDDBW1KBY3o6Nx/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Washington <joshwash@google.com>,
	Praveen Kaligineedi <pkaligineedi@google.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.12 144/156] gve: clean XDP queues in gve_tx_stop_ring_gqi
Date: Mon,  6 Jan 2025 16:17:10 +0100
Message-ID: <20250106151147.152636217@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

From: Joshua Washington <joshwash@google.com>

commit 6321f5fb70d502d95de8a212a7b484c297ec9644 upstream.

When stopping XDP TX rings, the XDP clean function needs to be called to
clean out the entire queue, similar to what happens in the normal TX
queue case. Otherwise, the FIFO won't be cleared correctly, and
xsk_tx_completed won't be reported.

Fixes: 75eaae158b1b ("gve: Add XDP DROP and TX support for GQI-QPL format")
Cc: stable@vger.kernel.org
Signed-off-by: Joshua Washington <joshwash@google.com>
Signed-off-by: Praveen Kaligineedi <pkaligineedi@google.com>
Reviewed-by: Praveen Kaligineedi <pkaligineedi@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/google/gve/gve_tx.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -206,7 +206,10 @@ void gve_tx_stop_ring_gqi(struct gve_pri
 		return;
 
 	gve_remove_napi(priv, ntfy_idx);
-	gve_clean_tx_done(priv, tx, priv->tx_desc_cnt, false);
+	if (tx->q_num < priv->tx_cfg.num_queues)
+		gve_clean_tx_done(priv, tx, priv->tx_desc_cnt, false);
+	else
+		gve_clean_xdp_done(priv, tx, priv->tx_desc_cnt);
 	netdev_tx_reset_queue(tx->netdev_txq);
 	gve_tx_remove_from_block(priv, idx);
 }


