Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6B333B6F1;
	Wed, 30 Sep 2026 15:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783468; cv=none; b=YxGSTJeUrCwjmG2z07DlxRt6Mvg1lKUl+ebzJK67r9PUAdMPsdeH0uSIqIm+iHVo/gRLX4e9GcFSCS4/cMDkQw6EWazPJnpOsSA1bvh0W5di7VLGvanX+HTziPXoJn31JYqqVVVC4vdWkYztdyv7SSy8k++Wv99iXUOUqgZmswI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783468; c=relaxed/simple;
	bh=Y3J4ved8nuS5R2bpChCqNoirmvdUk90Zi0HI1IIz2ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RwQ4ICh4pkIfu0mCuHBdm2Sd6q7+uFzMNNWslhlznhRhucfkXuHYVOhWkjmJ2EkrdIEqJbFt9smIxC7n4mnXMWI20MhB3LzpcPhxE8jaMIcEVwheA5Nv3Xz4oxpFR7hMjnWYTTiJ4F4wSrnkG9Gtrhul/gtFeX9Y/l4iK3cVbZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l5HsIxSF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l5HsIxSF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC951F000FF;
	Wed, 30 Sep 2026 15:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783461;
	bh=z8Gr5cr8QYWpk3bYMqCTEaO+c5sgj1VE01ZrSmj6XH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l5HsIxSFJqHaTCle/LBIKl0RCfYOlTyv5BApdwW7oZK+t0ginyYsTcIfcWOgRJQsn
	 ZnMEdycs1qvhKTJ+39lIcdhkvxBKkF5rShMya+wP99fGMucYDjJNdbPTSBdHMk4Y7j
	 KNCh2RDfD99nsXMBIR3bMSG8D9IvrF218noDbAh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hohyun Sim <tlaghgus0425@korea.ac.kr>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 400/595] net: fddi: skfp: fix NULL deref when setting the MAC address while down
Date: Wed, 30 Sep 2026 17:24:53 +0200
Message-ID: <20260930152356.274869744@linuxfoundation.org>
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

From: Hohyun Sim <tlaghgus0425@korea.ac.kr>

[ Upstream commit 7c8810c2e69c3d9ca6df870b40ae9218e50b4fb1 ]

skfp_ctl_set_mac_address() calls ResetAdapter() unconditionally, without
checking netif_running(). ResetAdapter() first calls card_stop(), which
sets smc->hw.hw_state to STOPPED, and then mac_drv_clear_tx_queue(),
which walks the two transmit queues:

	for (i = QUEUE_S; i <= QUEUE_A0; i++) {
		queue = smc->hw.fp.tx[i] ;
		...
		t = queue->tx_curr_get ;

smc->hw.fp.tx[] is only populated by init_tx(), which is reached from
skfp_open() through init_smt() -> init_fddi_driver() -> init_fplus() ->
init_mac() -> init_tx(). The private area is allocated and zeroed by
alloc_fddidev(), so on an interface that has never been brought up both
queue pointers are still NULL. The hw_state test at the top of
mac_drv_clear_tx_queue() does not catch this, because card_stop() has
just set STOPPED; the function proceeds into the loop and dereferences
NULL. ResetAdapter() does call init_smt() itself, but only after the
queues have been cleared.

Setting the MAC address on a down interface therefore oopses:

  ip link set dev fddi0 address 02:00:00:00:00:01

  BUG: KASAN: null-ptr-deref in mac_drv_clear_tx_queue+0x68/0x2c0 [skfp]
  Read of size 8 at addr 0000000000000010 by task ip/302
  Call Trace:
   <TASK>
   mac_drv_clear_tx_queue+0x68/0x2c0 [skfp 6c01d4bab63c36978bd0a7d7e90837adb44cc37b]
   ResetAdapter+0x29/0x100 [skfp 6c01d4bab63c36978bd0a7d7e90837adb44cc37b]
   skfp_ctl_set_mac_address+0x57/0x80 [skfp 6c01d4bab63c36978bd0a7d7e90837adb44cc37b]
   netif_set_mac_address+0x1e4/0x2c0
   do_setlink+0x684/0x2680
   </TASK>

Address 0x10 is the offset of tx_curr_get, the third pointer in
struct s_smt_tx_queue, on 64-bit. mac_drv_clear_rx_queue(), which
ResetAdapter() calls immediately afterwards, dereferences
smc->hw.fp.rx[QUEUE_R1] in the same way behind the same ineffective
hw_state test; the transmit queue merely crashes first. Both are
covered by the guard below.

Skip the adapter reset when the interface is down. dev_addr_set() is
left unconditional, so the new address is still recorded in
dev->dev_addr. Nothing is lost by not resetting the adapter here:
skfp_open() deliberately re-reads the factory address on every open,

	read_address(smc, NULL);
	eth_hw_addr_set(dev, smc->hw.fddi_canon_addr.a);

and the comment above it states this is done to discard exactly such an
address override across a close/open cycle. An address set while the
interface is down could not have survived the following open even
before this change, so the guard removes no working behaviour. Guarding
the hardware side of ndo_set_mac_address() with netif_running() is
established practice; skge_set_mac_address() has done so since commit
2eb3e621c4e0 ("skge: set mac address bonding fix").

Guarding the reset as a whole, rather than NULL-checking the queues, is
also what the rest of the driver expects. After a previous open/close
the queue pointers are stale but non-NULL, so there is no crash, yet
ResetAdapter() goes on to call smt_online() and STI_FBI() ("Enable
Board Interrupts") while skfp_close() has already called free_irq() -
the adapter would be brought back online with no handler installed. The
only other ResetAdapter() caller is skfp_interrupt(), which by
construction runs only while the device is open.

Found by automated driver testing against an emulated SysKonnect FDDI
adapter under a KASAN-enabled 7.0.0 kernel. Triggering it requires
CAP_NET_ADMIN.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Assisted-by: LLM KASAN
Signed-off-by: Hohyun Sim <tlaghgus0425@korea.ac.kr>
Link: https://patch.msgid.link/20260910063743.110747-1-tlaghgus0425@korea.ac.kr
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/fddi/skfp/skfddi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/fddi/skfp/skfddi.c b/drivers/net/fddi/skfp/skfddi.c
index 69c29a2ef95db..ab03cdb536eb4 100644
--- a/drivers/net/fddi/skfp/skfddi.c
+++ b/drivers/net/fddi/skfp/skfddi.c
@@ -924,7 +924,8 @@ static int skfp_ctl_set_mac_address(struct net_device *dev, void *addr)
 
 	memcpy(dev->dev_addr, p_sockaddr->sa_data, FDDI_K_ALEN);
 	spin_lock_irqsave(&bp->DriverLock, Flags);
-	ResetAdapter(smc);
+	if (netif_running(dev))
+		ResetAdapter(smc);
 	spin_unlock_irqrestore(&bp->DriverLock, Flags);
 
 	return 0;		/* always return zero */
-- 
2.53.0



