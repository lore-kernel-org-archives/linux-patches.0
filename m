Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3195C497396;
	Thu, 17 Sep 2026 18:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671267; cv=none; b=FyRkZOb8XIzDY+qZOo4+uATMbxEZyIiqaWK/DgBOMh1FQrl76H5yiobgwUXANcw6SY25BPn4UeskObTXZgzTEmAavWQgZwW4vZXnKewTLPmgFIpHSEA3eBvv3FczFmlVMjlcK+1g9mKOj+k1ZPSQS9IyUhh6Y+hBzfed6MFlay4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671267; c=relaxed/simple;
	bh=VDmjD5J0L7uF6g2HH+3Nm+Os9lSXJX4Bjs86EHxbI5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ypf5daBNhyyeewHvbPwmRlkvfXnsZ+R3thqmYx0JU2oRYD+7kQRRJRo4DAuB03LrUOa1O/aLmWqrlW4XH9hJU2xxYujwqOqGCJdgK79qnQaWs91nz50sMudck16BfyNN8/O37c2qvuu5yQFn9sURDVGITChoCRDLnaFY0Nd+xtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cG+2e9VR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cG+2e9VR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A0C1F000FF;
	Thu, 17 Sep 2026 18:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671265;
	bh=id+eQGC+Xo7TgkLfvQlRDr2hTwkt4iYLaWylzzjYsno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cG+2e9VR/58R2GNwgk4UztyY1WncouF6Qlr4dMT3NgAxIww4J/0bdI853y07+AO3W
	 /EYws+TsJ1mvKgU+EqRJY7mFN1+pZ22+wdSCFai1pz6LBumEXN3M9EQunO/Uftk88N
	 qdfe1uqAxBT6u8ufdtgYtSuB0kx6BV0MmTEws5Jw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot+sashiko@kernel.org>,
	Joe Damato <joe@dama.to>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 0883/1102] bnxt_en: Handle buffer allocation failure in bnxt_rx_ring_reset()
Date: Thu, 17 Sep 2026 16:13:46 +0100
Message-ID: <20260917151602.737708339@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -13706,7 +13706,14 @@ static void bnxt_rx_ring_reset(struct bn
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
 		cpr->sw_stats->rx.rx_resets++;
 		if (bp->flags & BNXT_FLAG_AGG_RINGS)


