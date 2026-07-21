Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B410546C4DD;
	Tue, 21 Jul 2026 18:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659739; cv=none; b=ewQ545kxoLsz0hhN3m1DN1UUMOIeSqrdgyiKsKJuCJYzZMeTmuTpdyP8w8oPDaYTsiWsjmVdE5ZUQy0lU76CFxuArPoN1tlorcQhAQxoxHM8BpVqxDnH6OIpA7DQR0I2jmY8r05bmLzL293E+afTmf4DKa3ZHcetDl7lb73LFdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659739; c=relaxed/simple;
	bh=Sdb7Vcx/O5Jkd4anxIlMe8iYLWhL0ItazPNOgkCgFVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hc91OoTE0BYNqJO4i4ZlVlLbrKzcE5QB+Vs6AMAu3EvbSlmbh0rrJjFsfLQvEmxZrWVGCmgxc6X+CVDgAPFudHfZS2vS8wzxllzOky1H+Vk9uUGPv3JSz7bFvnPIvJL6pOU+If8ZAQpi4V8hgkCWiX0GQ8Fn8JN8gJoxLm6vUOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y+cu4cXS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y+cu4cXS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B8481F000E9;
	Tue, 21 Jul 2026 18:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659738;
	bh=rvm57IXujgc9t3upAcIKTNd5nS92jS2wXkAB5AbeeQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y+cu4cXSLMvjO3pwshkZJFUd7vrAkRLTKwjO5uThJljEK+vK/5riACe26edHCEf97
	 TQdpepfxMnPBsHvponQZbfaHvnTJdT6A22/CYdtvhkyeNVgIb5G+oDbr3wZNtpi5Jg
	 LJQduOSDNuOzg7Yr8eM6JAb+qjNH0koihihFvnHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmed Abdelmoemen <ahmedabdelmoumen05@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	David Wei <dw@davidwei.uk>,
	Bobby Eshleman <bobbyeshleman@meta.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0715/2077] net: Stop leased rxq before uninstalling its memory provider
Date: Tue, 21 Jul 2026 17:06:28 +0200
Message-ID: <20260721152609.665753542@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 37314c9dbe95b4d924c7b61aaf563cec4f4e4133 ]

netif_rxq_cleanup_unlease() tears down the memory provider that was
installed on a physical RX queue through a netkit queue lease. It
currently revokes the provider's DMA mappings before stopping the
physical queue:

  __netif_mp_uninstall_rxq(virt_rxq, p);            /* DMA unmap */
  __netif_mp_close_rxq(phys_rxq->dev, rxq_idx, p);  /* queue stop */

This inverts the ordering used by the regular teardown paths (normal
device unregister and the io_uring zcrx close path), which stop the
queue before revoking the provider's mappings.

With the physical queue still live, its NAPI can keep consuming
net_iov entries from the page_pool alloc cache after the
__netif_mp_uninstall_rxq() has already cleared their dma_addr,
opening a window for the device to DMA to a stale or zero address.

Fix it by swapping the two calls so the queue is stopped (and its
NAPI quiesced) before the provider is uninstalled. No functional
regression was observed across repeated runs of the nk_qlease.py
HW selftest, which exercises the lease teardown path; this was
tested against fbnic QEMU emulation.

Fixes: 5602ad61ebee ("net: Proxy netif_mp_{open,close}_rxq for leased queues")
Reported-by: Ahmed Abdelmoemen <ahmedabdelmoumen05@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: David Wei <dw@davidwei.uk>
Reviewed-by: Bobby Eshleman <bobbyeshleman@meta.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20260609212240.677889-1-daniel@iogearbox.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/netdev_rx_queue.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/netdev_rx_queue.c b/net/core/netdev_rx_queue.c
index de4dac4c88b366..00a7011eb4d578 100644
--- a/net/core/netdev_rx_queue.c
+++ b/net/core/netdev_rx_queue.c
@@ -338,12 +338,12 @@ void __netif_mp_uninstall_rxq(struct netdev_rx_queue *rxq,
 void netif_rxq_cleanup_unlease(struct netdev_rx_queue *phys_rxq,
 			       struct netdev_rx_queue *virt_rxq)
 {
-	struct pp_memory_provider_params *p = &phys_rxq->mp_params;
 	unsigned int rxq_idx = get_netdev_rx_queue_index(phys_rxq);
+	struct pp_memory_provider_params p = phys_rxq->mp_params;
 
-	if (!p->mp_ops)
+	if (!p.mp_ops)
 		return;
 
-	__netif_mp_uninstall_rxq(virt_rxq, p);
-	__netif_mp_close_rxq(phys_rxq->dev, rxq_idx, p);
+	__netif_mp_close_rxq(phys_rxq->dev, rxq_idx, &p);
+	__netif_mp_uninstall_rxq(virt_rxq, &p);
 }
-- 
2.53.0



