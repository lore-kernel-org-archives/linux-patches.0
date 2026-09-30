Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022063D3323;
	Wed, 30 Sep 2026 17:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790237; cv=none; b=NT7IrkcogNyhRul0kJIHwqqELYk2KashEZz2MvFKvt0KOgH+FKv+0b1mNR81fnO/5cQeeCaQoMsgMOWciyF8A4kHSL8N3ayd0Pvq8S5FZG6vipamkRPXh8PaKgG+w0wJyxswgVlMDiE7dE3/+rJISPHGkdY59fb3Y29v8fzjdwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790237; c=relaxed/simple;
	bh=GdI30OGLMn3r1j1k5Fg6QWQEP6w8wd5Qaj5ghJFoVsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AV5oyZz5y5yc+wN2tuvGomvvkP1ozIpNj7iLlG/7O8QS8CWaWz2NBIbPujaOZg7ylYIjAmvmqIGGY9OXhay041i7cUn9Pt90TepqqE6qd+/lb5x8XW5Wjr0kEUOzZZ5Xtwcs1agbAYd6o0iqGZgUAXKp4wSlFIxjbsISDJ4mEL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c+lPUCJl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c+lPUCJl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D74A1F000FF;
	Wed, 30 Sep 2026 17:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790235;
	bh=RTBW251Sg4/5RyNDqaIkeDarZnSizzuyLsqtypTWz1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c+lPUCJlOtdBK3lHg280P3tjtEXIr80LQmzraN3rM/1Jnd5JBUTGnrIY56Gc/AjD1
	 rA11oYo/O9KhWTMs1WZcddIJPVVqOe/Cd9TA7Ra/Dpqycm1PSSwEM5chjEtT6KZtyc
	 X6RL2ZwC7w52m1nz/4QByyZtjWf9t6mA+Fle4+N0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot+sashiko@kernel.org>,
	Joe Damato <joe@dama.to>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 758/877] bnxt_en: Propagate TPA buffer allocation failures in bnxt_queue_mem_alloc()
Date: Wed, 30 Sep 2026 17:27:49 +0200
Message-ID: <20260930152431.056621717@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

[ Upstream commit b814dfbfeb0a68c9a52073f2caa05a2d5247a329 ]

bnxt_alloc_one_tpa_info_data() returns -ENOMEM as soon as one allocation
fails. This leaves the remaining rxr->rx_tpa[] entries zeroed.

bnxt_queue_mem_alloc() discards that return value, so the partially
initialized ring is installed by bnxt_queue_start().

Since the agg_id is picked by the hardware and bnxt_alloc_agg_idx maps
it to a SW index in rxr->rx_tpa[], it is possible that an uninitialized
slot can be chosen which would hand a zero DMA address to the device.

Fix this by checking the return value of bnxt_alloc_one_tpa_info_data
and unwinding, freeing the ring buffers.

Fixes: bd649c5cc958 ("bnxt_en: handle tpa_info in queue API implementation")
Reported-by: Sashiko <sashiko-bot+sashiko@kernel.org>
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260828190900.1767611-1-joe%40dama.to
Cc: stable@vger.kernel.org
Signed-off-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20260902015652.2421609-4-joe@dama.to
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ Retained bnxt_alloc_one_rx_ring_page() instead of upstream bnxt_alloc_one_rx_ring_netmem(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -15430,11 +15430,16 @@ static int bnxt_queue_mem_alloc(struct n
 	bnxt_alloc_one_rx_ring_skb(bp, clone, idx);
 	if (bp->flags & BNXT_FLAG_AGG_RINGS)
 		bnxt_alloc_one_rx_ring_page(bp, clone, idx);
-	if (bp->flags & BNXT_FLAG_TPA)
-		bnxt_alloc_one_tpa_info_data(bp, clone);
+	if (bp->flags & BNXT_FLAG_TPA) {
+		rc = bnxt_alloc_one_tpa_info_data(bp, clone);
+		if (rc)
+			goto err_free_rx_ring_skbs;
+	}
 
 	return 0;
 
+err_free_rx_ring_skbs:
+	bnxt_free_one_rx_ring_skbs(bp, clone);
 err_free_tpa_info:
 	bnxt_free_one_tpa_info(bp, clone);
 err_free_rx_agg_ring:


