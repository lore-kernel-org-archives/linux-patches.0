Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590604;
	b=e1O8KIzQV9JpemuulTYPbvs5Nk1krOfEA43ZL2rkohz0f9TlrQ7fg345sVZG8/zEE3v0
	 n3shFMuIy9urA6pGrXYjASh9NEfpXmgljucImn+jVFFCJ/w3GPMl6mTWqieqGkC4jzldz
	 WJlRo6CB5DR8O8ylYngLDnQzQiPvmOXnsNFTccbar+JVUZU4Ew4w1Jw7nGWKIEg8gOnwZ
	 inbXaPYrkR+Vp87YZXJ4UQGjQWhe+Bdqen3zswEwP4rsVfchuYiuZ5LLpK3DpHzUcZp6n
	 OuCTpKkqUxhw7MNTTuPD9WvY+UDzpyiHW5KWjp96GKrLdoCiKe4QCNmjQnDXjIGbDrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590604;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iIH4GZ1z9BVvFviYd5Mk1tN5rn4opfMt2SsUcvTNsLY=;
	b=X4kXRmR0bnceJ3WRegByzFsn/HPqX753YC7rtFN05dsR4qp6V+VLOj2aIwKYkiE7liEg
	 0kpcTaJBws9gky8I3bBgVtOJszVLWtHPYB4lIq8wXG19SHrigSx8nvWSl0kYLkXzBqHs+
	 5SC/BBcKIjiite0WPBTkxNmDtaKqsTlEFPE0Uo/lYvcQaBfqCYS4WKImPM0s5VOwAMuSc
	 Md+2TicYQ1NYgOnXlJcd1db2MmUreU3Uq/dDM8htNlYVm5+xkVKl96ITn9aDuLsciqRnb
	 yRgse/pJW7AAaJZc0FrE5LOn3Mu5xvzCVoqwI8rsnecdBkY56NwBCRlemxJrMpS7UJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ddiDdFmA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270BE6073FF3;
	Fri, 13 Nov 2026 17:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ddiDdFmA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C70C61F000C4;
	Fri, 13 Nov 2026 17:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590604;
	bh=iIH4GZ1z9BVvFviYd5Mk1tN5rn4opfMt2SsUcvTNsLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ddiDdFmADXMdZfmoZBwXx64G9FIi69+HyAIVm42uWa13PAWXXJ6eZFB0G34zeCVVJ
	 dbOsEvhLVf3SHBt+lgO4m0uSDiVnxwF3cuqz71BHto0hKNGIq7yXb6Z/acAvUacnrU
	 21NyRC+OFvwBNeIl+EblHO4K1t/sNBSBRNNnsHTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vaibhav Nagare <vnagare@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 532/686] bnxt_en: dont leave an XDP program installed when the open fails
Date: Fri, 13 Nov 2026 10:51:05 -0500
Message-ID: <20261113153839.216142918@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vaibhav Nagare <vnagare@redhat.com>

[ Upstream commit 78731b46967e3e7102b5cd5062bef185f3404b5c ]

bnxt_xdp_set() stores the new program and drops the reference on the old
one before reopening the NIC.  If bnxt_open_nic() then fails, ndo_bpf()
returns an error with the new program still in bp->xdp_prog.  The caller
treats the error as "nothing was installed" and drops its own reference,
so bp->xdp_prog is left pointing at a freed program and the next XDP
update dereferences it:

  BUG: unable to handle page fault for address: ff78ecc80ddd1038
  RIP: 0010:__bpf_prog_put+0x5/0x80
  Call Trace:
   bnxt_xdp_set+0xad/0x1b0 [bnxt_en]
   dev_xdp_propagate+0x36/0xa0
   bond_xdp_set+0xeb/0x2d0 [bonding]
   dev_xdp_install+0x1b1/0x350
   bpf_xdp_link_update+0xc5/0x1b0
   link_update+0x104/0x1e0
   __sys_bpf+0x662/0xcf0

Seen on a 6.12 based kernel after bnxt_alloc_mem() failed an order-4
allocation on a fragmented host:

  bnxt_en 0000:a0:00.1 ens4f1np1: nic open fail (rc: fffffff4)
  bond1: (slave ens4f1np1): Error -12 calling ndo_bpf

Bonding is not required to hit this; a plain XDP attach on a bnxt
interface takes the same path.

Restore the previous program when an attach or a replace fails, and
recompute the page-mode and XDP TX ring configuration from it.  The
configuration matters because bnxt_init_one_rx_ring() only assigns
rxr->xdp_prog in page mode, and __bnxt_set_rx_skb_mode() derives
dev->max_mtu from the installed program.  Release the old program only
once the change has been committed.

A detach is not undone.  dev_xdp_detach_link() clears the core's record
of the program even when the driver returns an error, so putting the
program back would leave the driver running a program the core has
already dropped.  If the reopen fails during a detach, bnxt_xdp_set()
therefore returns 0 with the device closed; bnxt_open_nic() has already
logged the failure.

Found in a crash dump; the change was not tested on hardware.

Fixes: c6d30e8391b8 ("bnxt_en: Add basic XDP support.")
Cc: stable@vger.kernel.org
Signed-off-by: Vaibhav Nagare <vnagare@redhat.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261012072802.2153706-1-vnagare@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c | 49 +++++++++++++------
 1 file changed, 33 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index bebe37e139c94..2db8cfcf922f3 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -381,11 +381,31 @@ int bnxt_xdp_xmit(struct net_device *dev, int num_frames,
 	return nxmit;
 }
 
+static void bnxt_xdp_apply_cfg(struct bnxt *bp, int tx_xdp)
+{
+	struct net_device *dev = bp->dev;
+	int tc = bp->num_tc ? : 1;
+
+	if (bp->xdp_prog) {
+		bnxt_set_rx_skb_mode(bp, true);
+		xdp_features_set_redirect_target_locked(dev, true);
+	} else {
+		xdp_features_clear_redirect_target_locked(dev);
+		bnxt_set_rx_skb_mode(bp, false);
+	}
+	bp->tx_nr_rings_xdp = tx_xdp;
+	bp->tx_nr_rings = bp->tx_nr_rings_per_tc * tc + tx_xdp;
+	bnxt_set_cp_rings(bp, true);
+	bnxt_set_tpa_flags(bp);
+	bnxt_set_ring_params(bp);
+}
+
 static int bnxt_xdp_set(struct bnxt *bp, struct bpf_prog *prog)
 {
 	struct net_device *dev = bp->dev;
 	int tx_xdp = 0, rc, tc;
 	struct bpf_prog *old;
+	int old_tx_xdp;
 
 	netdev_assert_locked(dev);
 
@@ -418,25 +438,22 @@ static int bnxt_xdp_set(struct bnxt *bp, struct bpf_prog *prog)
 	if (netif_running(dev))
 		bnxt_close_nic(bp, true, false);
 
+	old_tx_xdp = bp->tx_nr_rings_xdp;
 	old = xchg(&bp->xdp_prog, prog);
-	if (old)
-		bpf_prog_put(old);
-
-	if (prog) {
-		bnxt_set_rx_skb_mode(bp, true);
-		xdp_features_set_redirect_target_locked(dev, true);
-	} else {
-		xdp_features_clear_redirect_target_locked(dev);
-		bnxt_set_rx_skb_mode(bp, false);
+	bnxt_xdp_apply_cfg(bp, tx_xdp);
+
+	if (netif_running(dev)) {
+		rc = bnxt_open_nic(bp, true, false);
+		/* a detach cannot be undone, only an attach */
+		if (rc && prog) {
+			WRITE_ONCE(bp->xdp_prog, old);
+			bnxt_xdp_apply_cfg(bp, old_tx_xdp);
+			return rc;
+		}
 	}
-	bp->tx_nr_rings_xdp = tx_xdp;
-	bp->tx_nr_rings = bp->tx_nr_rings_per_tc * tc + tx_xdp;
-	bnxt_set_cp_rings(bp, true);
-	bnxt_set_tpa_flags(bp);
-	bnxt_set_ring_params(bp);
 
-	if (netif_running(dev))
-		return bnxt_open_nic(bp, true, false);
+	if (old)
+		bpf_prog_put(old);
 
 	return 0;
 }
-- 
2.53.0



