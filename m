Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A344D37B0;
	Wed, 30 Sep 2026 16:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785538; cv=none; b=XNReOs1wlURAmwg+Ip7iNsTIkQRI6QJnWDXgiIuOMoR8jRumEp/uFtQqIdLPkeee5SnZ/WVRUZgQZRZ5dwuvYet1UIDDs0XaGEgR51o7rlZYf91LYQBYgpeKJF0putc2NL1WgH523CEZTx26An373Q6/QaMA897Nsh/9b0A5/wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785538; c=relaxed/simple;
	bh=jMxl8qHwLvx3DnmYFyJ3UbdrK+J9frQw8pNXDlP0TAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gqf3Wtb6NKV1o+HUPAS6exDS3Vy0tzI3AuynyhsvGiPD/b8OX/X9OQQdfygBxgiKfSZqwvXO003b+/tTxwAu8kvWXLbn8Id81LCk/Qe4KNk1P5+It20l7RhhIBQzLk7S8t5PxK0BTf/MW+9RnKRg46leg1bv67KmHDpXpxaBtzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eApILOJm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eApILOJm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F761F000FF;
	Wed, 30 Sep 2026 16:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785529;
	bh=NJ2VM9GkEaANNUo3yH/WKqE+lpaYkKwOsBeDgRt3LAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eApILOJmbSPbiV1KQ8lkXnQIQn7+XYkzblQkVMuD46V8HLHNVYH9SnNdds0VV0ClE
	 z0BLkgHfjOd2tcc13MoHBz4foothUcrd8AmyQrXwB9RyrZWRHvUO7RuBwnK6LDS/+X
	 UmYV2twv7GOSwz5BxjZuensFwFaqHD/FjnKnwHJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot+sashiko@kernel.org>,
	Joe Damato <joe@dama.to>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 539/982] bnxt_en: Handle buffer allocation failure in bnxt_rx_ring_reset()
Date: Wed, 30 Sep 2026 17:21:15 +0200
Message-ID: <20260930152428.348324175@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Damato <joe@dama.to>

commit 961e2a17c5e3559b3f8654d2daabdd25a42e770a upstream.

bnxt_rx_ring_reset() frees the ring buffers and then reallocates them,
ignoring the result.

bnxt_alloc_one_rx_ring() can fail in bnxt_alloc_one_tpa_info_data(), which
returns -ENOMEM on the first failed allocation and leaves the remaining
rxr->rx_tpa[] entries zeroed.

The error isn't propagated up, so the loop in bnxt_rx_ring_reset
continues and at the end the code re-enables TPA with partially
unallocated rx_tpa array.

This means that when the agg_id from hardware is mapped to a SW index in
rxr->rx_tpa[], an uninitialized slot can be chosen which would hand a
zero DMA address to the device.

Fix this by falling back to a global reset, which is what the existing
code already does when other functions fail, but unlike the other
failure cases this particular failure has to return because TPA can't
be re-enabled since the allocation failed.

Fixes: 8fbf58e17dce ("bnxt_en: Implement RX ring reset in response to buffer errors.")
Reported-by: Sashiko <sashiko-bot+sashiko@kernel.org>
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260828190900.1767611-1-joe%40dama.to
Cc: stable@vger.kernel.org
Signed-off-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20260902015652.2421609-5-joe@dama.to
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11827,7 +11827,14 @@ static void bnxt_rx_ring_reset(struct bn
 		rxr->rx_sw_agg_prod = 0;
 		rxr->rx_next_cons = 0;
 		rxr->bnapi->in_reset = false;
-		bnxt_alloc_one_rx_ring(bp, i);
+		rc = bnxt_alloc_one_rx_ring(bp, i);
+		if (rc) {
+			netdev_warn(bp->dev, "RX ring reset failed to allocate buffers, rc = %d, falling back to global reset\n",
+				    rc);
+			bnxt_reset_task(bp, true);
+			bnxt_rtnl_unlock_sp(bp);
+			return;
+		}
 		cpr = &rxr->bnapi->cp_ring;
 		cpr->sw_stats.rx.rx_resets++;
 		if (bp->flags & BNXT_FLAG_AGG_RINGS)


