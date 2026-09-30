Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580F74E234D;
	Wed, 30 Sep 2026 15:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783208; cv=none; b=S5DqTOS9wSTCsg0qL/y/OHUhlalOR3Bjfubzar2HgFSmCUW7XairP0JzOhx6DIyiw2/1zwm0O8tDxHFcJNldec/BIHpjosZ08nr3h4li/l3QVaENVC0aHqXrmv/+98AVz7aphpiSbSZ1Wl9MPkOI3bG4IRKMr+0rR5AxXfw4srE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783208; c=relaxed/simple;
	bh=ayCqvE+8rFIonTbU+YIN8fAE3olFlc92t/ZBpogQv7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JZHi8FgMxLBVTKpy9R6oGyGnNrGU91ITOqJ5JqFj5J8tl6M3GQ55U2thxFehkR0azJvfTGmlXeIrZc8UrrteA5cpjxTo4KkbJtHTDR1U4JAy3kZQAiGiFfeF0ahP2s0uvjd5U6855gJpopwPS4+oigK9d3ma53zCQhMrnmE5jDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tf56Oifm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tf56Oifm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA091F000FF;
	Wed, 30 Sep 2026 15:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783202;
	bh=aLG7Se/ZxC14zqwEidzRCChl46LJ3WhU49QCC/qNKKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tf56OifmhiSc/PMYGRpCjt3BGpTZ+DgfFDWNb4ao89EUvD03MKtRAWI5fQjs0aOHY
	 E/CgqBA+4rm00HyqwFQ1EYUFLp8SPSbyCQSLfQuuXW+30fTO1kEfW1dwVhWZvCaj0X
	 SXl8jaSK4JidIfIfDuwt5yi4Zy+8M/ld3/Q3Bj9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot+sashiko@kernel.org>,
	Joe Damato <joe@dama.to>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 317/595] bnxt_en: Handle buffer allocation failure in bnxt_rx_ring_reset()
Date: Wed, 30 Sep 2026 17:23:30 +0200
Message-ID: <20260930152354.506570642@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -10923,7 +10923,14 @@ static void bnxt_rx_ring_reset(struct bn
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


