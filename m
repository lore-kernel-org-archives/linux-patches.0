Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB85325C704;
	Tue, 25 Mar 2025 12:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906231; cv=none; b=mW4SF5a36tC8pc60xMtx5W7zvLMfzVD/MBqP5cZSVdbOZ6xMU8jzaA6FsVa4Oba2Tp3kEJZJxjSWgT6sKWFmvGhAK9mwBGBGAHU+WiJGb7Ef/0W7PoKzAaJMJ1ctTQ3sSLOhP/G84WDzKiuL+F6aiR2Znc919PjFZ/7WeGXJrGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906231; c=relaxed/simple;
	bh=d48tWPJTALppQeNJL28pzIsDCKSlip4k9if+zuWw6JU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rfBxQ9qPNaMF/5+xSiMVmLSwCApMKyq0BmZwaktZ0xKISAJys4za0X2/Qnt6p3Ry5DJiAyXY0GSMkQaAwJ6oR1ObB8FFKgFnC9bKJbkt4g5lEUdIU2n9HwR9CLGRiaT8fwvY/8VFgOkuizaTXUTGEqyRdNUO+GZZymXAlZ76F/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MD4YT2Yy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MD4YT2Yy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A4E4C4CEE4;
	Tue, 25 Mar 2025 12:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906230;
	bh=d48tWPJTALppQeNJL28pzIsDCKSlip4k9if+zuWw6JU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MD4YT2YyHUwsdYdNrtnfNKMu4c0OmNx0QY/NTkrjmZktxRtxOqoRGYARNd5VI5dbF
	 rwq/XEjdgnl6gCjeCQKjXsI4e71wI4IoW0Y87sovqZFPXmrlruiDhWf4ClHTWpoDzS
	 OV3yxT0MhavfbvCrOB0B65bPpCn9SbZuEweBtS20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Shravya KN <shravya.k-n@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jianqi Ren <jianqi.ren.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 6.6 74/77] bnxt_en: Fix receive ring space parameters when XDP is active
Date: Tue, 25 Mar 2025 08:23:09 -0400
Message-ID: <20250325122146.370811636@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122144.259256924@linuxfoundation.org>
References: <20250325122144.259256924@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shravya KN <shravya.k-n@broadcom.com>

commit 3051a77a09dfe3022aa012071346937fdf059033 upstream.

The MTU setting at the time an XDP multi-buffer is attached
determines whether the aggregation ring will be used and the
rx_skb_func handler.  This is done in bnxt_set_rx_skb_mode().

If the MTU is later changed, the aggregation ring setting may need
to be changed and it may become out-of-sync with the settings
initially done in bnxt_set_rx_skb_mode().  This may result in
random memory corruption and crashes as the HW may DMA data larger
than the allocated buffer size, such as:

BUG: kernel NULL pointer dereference, address: 00000000000003c0
PGD 0 P4D 0
Oops: 0000 [#1] PREEMPT SMP NOPTI
CPU: 17 PID: 0 Comm: swapper/17 Kdump: loaded Tainted: G S         OE      6.1.0-226bf9805506 #1
Hardware name: Wiwynn Delta Lake PVT BZA.02601.0150/Delta Lake-Class1, BIOS F0E_3A12 08/26/2021
RIP: 0010:bnxt_rx_pkt+0xe97/0x1ae0 [bnxt_en]
Code: 8b 95 70 ff ff ff 4c 8b 9d 48 ff ff ff 66 41 89 87 b4 00 00 00 e9 0b f7 ff ff 0f b7 43 0a 49 8b 95 a8 04 00 00 25 ff 0f 00 00 <0f> b7 14 42 48 c1 e2 06 49 03 95 a0 04 00 00 0f b6 42 33f
RSP: 0018:ffffa19f40cc0d18 EFLAGS: 00010202
RAX: 00000000000001e0 RBX: ffff8e2c805c6100 RCX: 00000000000007ff
RDX: 0000000000000000 RSI: ffff8e2c271ab990 RDI: ffff8e2c84f12380
RBP: ffffa19f40cc0e48 R08: 000000000001000d R09: 974ea2fcddfa4cbf
R10: 0000000000000000 R11: ffffa19f40cc0ff8 R12: ffff8e2c94b58980
R13: ffff8e2c952d6600 R14: 0000000000000016 R15: ffff8e2c271ab990
FS:  0000000000000000(0000) GS:ffff8e3b3f840000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000000003c0 CR3: 0000000e8580a004 CR4: 00000000007706e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 <IRQ>
 __bnxt_poll_work+0x1c2/0x3e0 [bnxt_en]

To address the issue, we now call bnxt_set_rx_skb_mode() within
bnxt_change_mtu() to properly set the AGG rings configuration and
update rx_skb_func based on the new MTU value.
Additionally, BNXT_FLAG_NO_AGG_RINGS is cleared at the beginning of
bnxt_set_rx_skb_mode() to make sure it gets set or cleared based on
the current MTU.

Fixes: 08450ea98ae9 ("bnxt_en: Fix max_mtu setting for multi-buf XDP")
Co-developed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Shravya KN <shravya.k-n@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3987,7 +3987,7 @@ int bnxt_set_rx_skb_mode(struct bnxt *bp
 	struct net_device *dev = bp->dev;
 
 	if (page_mode) {
-		bp->flags &= ~BNXT_FLAG_AGG_RINGS;
+		bp->flags &= ~(BNXT_FLAG_AGG_RINGS | BNXT_FLAG_NO_AGG_RINGS);
 		bp->flags |= BNXT_FLAG_RX_PAGE_MODE;
 
 		if (bp->xdp_prog->aux->xdp_has_frags)
@@ -12796,6 +12796,14 @@ static int bnxt_change_mtu(struct net_de
 		bnxt_close_nic(bp, true, false);
 
 	dev->mtu = new_mtu;
+
+	/* MTU change may change the AGG ring settings if an XDP multi-buffer
+	 * program is attached.  We need to set the AGG rings settings and
+	 * rx_skb_func accordingly.
+	 */
+	if (READ_ONCE(bp->xdp_prog))
+		bnxt_set_rx_skb_mode(bp, true);
+
 	bnxt_set_ring_params(bp);
 
 	if (netif_running(dev))


