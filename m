Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617073A961E;
	Fri,  4 Sep 2026 05:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499158; cv=none; b=iiwHCDllr6wlS05uwrjy/80o7u94HP1Z7WaKYVbUSAkvAc1tXWMwbCY4YnfUX/3msUc3QpzIrS0lCBMfu4OgdeDdHAjV9nV4FeQroJOM5sI6DYHGlxOoYOAddaUGTZIQclmVXL2pyvmoBQqfenmJYcHSDapcWopvHncNa0axox4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499158; c=relaxed/simple;
	bh=dA+fc51cFfWJkzSPqSXtPXyD6elRtWxmiPCd+lndNBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MrQyK++gYbW0kwh4YlWgCmFaMJ9lfHTiITr6wJLY5m+OdfiEvDurxE9eWNGZJA+ScIXFVYLNKW5Ff0PRAKAVJZXA7gpilVBQmMVXP0g4EeSUE/MNMARcAO9sA8WYJlvpG1q9Nz6z5PMKfvySQSer+hTrWtPYWfZku9LlPgV2ZdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zrcDo/hG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zrcDo/hG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2821F00A3D;
	Fri,  4 Sep 2026 05:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499157;
	bh=7YBUPdf+6CIYiQhezXKDi8c4Y9cDrEyeNahaHXRtzVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zrcDo/hGD0/IOc1xapNtlWKDJqCu5g44ojJbn/hIh/S1SZrzHCFNlIuvhc4cniTiG
	 5vSUNDwSU5DqmDUUgVYdu5gOb+fcDEquddLj2bIZ8p5CPB3QuOP6fyu2j0X12OlZke
	 6o6HvQ0D3CnAmS5hvDiMFnTTw8M9geQzj3NPjSgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <joe@dama.to>,
	Michael Chan <michael.chan@broadcom.com>,
	Andy Gospodarek <gospo@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.2 319/713] bnxt_en: Write doorbell when linearizing skb fails
Date: Fri,  4 Sep 2026 06:54:47 +0200
Message-ID: <20260904045810.981719756@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Damato <joe@dama.to>

commit 00eeab0c644a881a1dc86fbffb7e6047a6ce8ecd upstream.

When the driver is handed a burst of packets, the doorbell is deferred
until the end. If the last packet has a huge number of frags, but fails
to linearize, the doorbell will not be written adding latency on TX for
any packets in the ring and holding their DMA mappings until the next
TX. Note that the queue is not stopped, so this issue would delay
pending BDs until the next TX.

This issue was discovered by Sashiko and reading the code verifies that,
while unlikely, it is possible.

Fix this by jumping to tx_free, which replicates the same pre-existing
logic but also writes the doorbell.

Fixes: b91e82129400 ("bnxt_en: Linearize TX SKB if the fragments exceed the max")
Cc: stable@vger.kernel.org
Signed-off-by: Joe Damato <joe@dama.to>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Andy Gospodarek <gospo@broadcom.com>
Link: https://patch.msgid.link/20260826000234.2031564-1-joe@dama.to
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -501,11 +501,8 @@ static netdev_tx_t bnxt_start_xmit(struc
 	if (skb_shinfo(skb)->nr_frags > TX_MAX_FRAGS) {
 		netdev_warn_once(dev, "SKB has too many (%d) fragments, max supported is %d.  SKB will be linearized.\n",
 				 skb_shinfo(skb)->nr_frags, TX_MAX_FRAGS);
-		if (skb_linearize(skb)) {
-			dev_kfree_skb_any(skb);
-			dev_core_stats_tx_dropped_inc(dev);
-			return NETDEV_TX_OK;
-		}
+		if (skb_linearize(skb))
+			goto tx_free;
 	}
 #endif
 	if (skb_is_gso(skb) &&


