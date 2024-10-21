Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E1B194C62;
	Mon, 21 Oct 2024 10:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506549; cv=none; b=ExKO3wV1L4LM4xEekdsyogrri6pCLK4Vi2o0JdF9AD39lLKO7g+8qfLh/n/l4xGv/SPd+/7hdVZAbDZH9W0zqyHEC3veQ8w8pVGKv4toj5FHFll0BElNTPrjIiDa1TaG2W5ndLTtGhSYPm4sUF8NFOSUsgwe0Mx316K3spiU2x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506549; c=relaxed/simple;
	bh=J0wLRFu88eM1hf71p/LNu2EMwNEPqFmMYMBcExTah8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FcuL4T6SCm2S7DrnnGiOqJL04/bZQ9OvihliHafQOlzke3gNGqItAj/FeEmiSJxMug0gVZrIyCG1ua98t3yPhJOKo9DqumQy5f1iAcz53n2egoyJ45MWhlcK++s4+G45d+7a5CES9GQwz1cJpwwnIWr6KVyGAjm6CcKP8NQtBdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EZbndWTo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EZbndWTo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9879CC4CEC3;
	Mon, 21 Oct 2024 10:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506549;
	bh=J0wLRFu88eM1hf71p/LNu2EMwNEPqFmMYMBcExTah8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EZbndWTo3o+SEAYoGRv+/SAjLmTgfrGJ4XkJ2pfukKc9CXURPOQ/4GBDz6FyZ8psT
	 V46XdU1Dyq+PKk/kx3yNhmJToIQo2nmguJ/74VJ0h+rjRRgP2m7WJvD9BMJk/0/B/A
	 iF/palGsDhcEFZ9/d6cYzQVAvHzWGAzJPkCbZVaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.11 010/135] net: enetc: disable NAPI after all rings are disabled
Date: Mon, 21 Oct 2024 12:22:46 +0200
Message-ID: <20241021102259.740024490@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

commit 6b58fadd44aafbbd6af5f0b965063e1fd2063992 upstream.

When running "xdp-bench tx eno0" to test the XDP_TX feature of ENETC
on LS1028A, it was found that if the command was re-run multiple times,
Rx could not receive the frames, and the result of xdp-bench showed
that the rx rate was 0.

root@ls1028ardb:~# ./xdp-bench tx eno0
Hairpinning (XDP_TX) packets on eno0 (ifindex 3; driver fsl_enetc)
Summary                      2046 rx/s                  0 err,drop/s
Summary                         0 rx/s                  0 err,drop/s
Summary                         0 rx/s                  0 err,drop/s
Summary                         0 rx/s                  0 err,drop/s

By observing the Rx PIR and CIR registers, CIR is always 0x7FF and
PIR is always 0x7FE, which means that the Rx ring is full and can no
longer accommodate other Rx frames. Therefore, the problem is caused
by the Rx BD ring not being cleaned up.

Further analysis of the code revealed that the Rx BD ring will only
be cleaned if the "cleaned_cnt > xdp_tx_in_flight" condition is met.
Therefore, some debug logs were added to the driver and the current
values of cleaned_cnt and xdp_tx_in_flight were printed when the Rx
BD ring was full. The logs are as follows.

[  178.762419] [XDP TX] >> cleaned_cnt:1728, xdp_tx_in_flight:2140
[  178.771387] [XDP TX] >> cleaned_cnt:1941, xdp_tx_in_flight:2110
[  178.776058] [XDP TX] >> cleaned_cnt:1792, xdp_tx_in_flight:2110

>From the results, the max value of xdp_tx_in_flight has reached 2140.
However, the size of the Rx BD ring is only 2048. So xdp_tx_in_flight
did not drop to 0 after enetc_stop() is called and the driver does not
clear it. The root cause is that NAPI is disabled too aggressively,
without having waited for the pending XDP_TX frames to be transmitted,
and their buffers recycled, so that xdp_tx_in_flight cannot naturally
drop to 0. Later, enetc_free_tx_ring() does free those stale, unsent
XDP_TX packets, but it is not coded up to also reset xdp_tx_in_flight,
hence the manifestation of the bug.

One option would be to cover this extra condition in enetc_free_tx_ring(),
but now that the ENETC_TX_DOWN exists, we have created a window at
the beginning of enetc_stop() where NAPI can still be scheduled, but
any concurrent enqueue will be blocked. Therefore, enetc_wait_bdrs()
and enetc_disable_tx_bdrs() can be called with NAPI still scheduled,
and it is guaranteed that this will not wait indefinitely, but instead
give us an indication that the pending TX frames have orderly dropped
to zero. Only then should we call napi_disable().

This way, enetc_free_tx_ring() becomes entirely redundant and can be
dropped as part of subsequent cleanup.

The change also refactors enetc_start() so that it looks like the
mirror opposite procedure of enetc_stop().

Fixes: ff58fda09096 ("net: enetc: prioritize ability to go down over packet processing")
Cc: stable@vger.kernel.org
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20241010092056.298128-5-wei.fang@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2477,8 +2477,6 @@ void enetc_start(struct net_device *ndev
 
 	enetc_setup_interrupts(priv);
 
-	enetc_enable_tx_bdrs(priv);
-
 	for (i = 0; i < priv->bdr_int_num; i++) {
 		int irq = pci_irq_vector(priv->si->pdev,
 					 ENETC_BDR_INT_BASE_IDX + i);
@@ -2487,6 +2485,8 @@ void enetc_start(struct net_device *ndev
 		enable_irq(irq);
 	}
 
+	enetc_enable_tx_bdrs(priv);
+
 	enetc_enable_rx_bdrs(priv);
 
 	netif_tx_start_all_queues(ndev);
@@ -2555,6 +2555,10 @@ void enetc_stop(struct net_device *ndev)
 
 	enetc_disable_rx_bdrs(priv);
 
+	enetc_wait_bdrs(priv);
+
+	enetc_disable_tx_bdrs(priv);
+
 	for (i = 0; i < priv->bdr_int_num; i++) {
 		int irq = pci_irq_vector(priv->si->pdev,
 					 ENETC_BDR_INT_BASE_IDX + i);
@@ -2564,10 +2568,6 @@ void enetc_stop(struct net_device *ndev)
 		napi_disable(&priv->int_vector[i]->napi);
 	}
 
-	enetc_wait_bdrs(priv);
-
-	enetc_disable_tx_bdrs(priv);
-
 	enetc_clear_interrupts(priv);
 }
 EXPORT_SYMBOL_GPL(enetc_stop);


