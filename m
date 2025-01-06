Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E914ADF71;
	Mon,  6 Jan 2025 15:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178028; cv=none; b=rT1jsQODZjhxr0QT1TCFtbQi5DVcQSqfHwJA7wPHaV3V+heLdMFkKJF02jqQWBfcXzZaxfepF9tPBgdol1seQka7JHQDKouES8h+9rnSRgrTuQONN+Ks/sLF8YqAlqLOGUVOh89bxUjbuLAAgK1jx8YB+nb/GhNAtjQ8HQkkKlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178028; c=relaxed/simple;
	bh=hbUjQs9WEST0neNprZLT+qjQFqkmfAQyccocnMDJxcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I5yY1R0+18atbptJT3Gc5Rkrq9WoQJaq+TW4zZLr3cVzaQ2I++bh+j6zWy1tRCBQPZuingcwLZHu6m8yfJl4+/k0+Xqvt54wdLm+UZVmx1QMxc166UrTd6NtY5tVbp1uzj/QvnS+IHhkSxbX+7QFzsy5qolhsDd5lswl7kOoMFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1IRa/18t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1IRa/18t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F306C4CED2;
	Mon,  6 Jan 2025 15:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178027;
	bh=hbUjQs9WEST0neNprZLT+qjQFqkmfAQyccocnMDJxcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1IRa/18tUzOpTjvkc2PT/2XkSWHTTUJ2GVMzeP1re/XKAzKZFtGoYHlnFv2WjaQtd
	 2YHKkAaFAkZgQ14BtLT9xUK0BKK0sGdhaM+Og6NyOct+QR0vdmtKscx/7qrgKBrFx6
	 VJ1YiEZ5qQknJhdC26K1NGT1K1TaS4/l/BZLXG2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 137/156] net: ethernet: ti: am65-cpsw: default to round-robin for host port receive
Date: Mon,  6 Jan 2025 16:17:03 +0100
Message-ID: <20250106151146.892191682@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siddharth Vadapalli <s-vadapalli@ti.com>

commit 4a4d38ace1fb0586bffd2aab03caaa05d6011748 upstream.

The Host Port (i.e. CPU facing port) of CPSW receives traffic from Linux
via TX DMA Channels which are Hardware Queues consisting of traffic
categorized according to their priority. The Host Port is configured to
dequeue traffic from these Hardware Queues on the basis of priority i.e.
as long as traffic exists on a Hardware Queue of a higher priority, the
traffic on Hardware Queues of lower priority isn't dequeued. An alternate
operation is also supported wherein traffic can be dequeued by the Host
Port in a Round-Robin manner.

Until commit under Fixes, the am65-cpsw driver enabled a single TX DMA
Channel, due to which, unless modified by user via "ethtool", all traffic
from Linux is transmitted on DMA Channel 0. Therefore, configuring
the Host Port for priority based dequeuing or Round-Robin operation
is identical since there is a single DMA Channel.

Since commit under Fixes, all 8 TX DMA Channels are enabled by default.
Additionally, the default "tc mapping" doesn't take into account
the possibility of different traffic profiles which various users
might have. This results in traffic starvation at the Host Port
due to the priority based dequeuing which has been enabled by default
since the inception of the driver. The traffic starvation triggers
NETDEV WATCHDOG timeout for all TX DMA Channels that haven't been serviced
due to the presence of traffic on the higher priority TX DMA Channels.

Fix this by defaulting to Round-Robin dequeuing at the Host Port, which
shall ensure that traffic is dequeued from all TX DMA Channels irrespective
of the traffic profile. This will address the NETDEV WATCHDOG timeouts.
At the same time, users can still switch from Round-Robin to Priority
based dequeuing at the Host Port with the help of the "p0-rx-ptype-rrobin"
private flag of "ethtool". Users are expected to setup an appropriate
"tc mapping" that suits their traffic profile when switching to priority
based dequeuing at the Host Port.

Fixes: be397ea3473d ("net: ethernet: am65-cpsw: Set default TX channels to maximum")
Cc: <stable@vger.kernel.org>
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Link: https://patch.msgid.link/20241220075618.228202-1-s-vadapalli@ti.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -3525,7 +3525,7 @@ static int am65_cpsw_nuss_probe(struct p
 	init_completion(&common->tdown_complete);
 	common->tx_ch_num = AM65_CPSW_DEFAULT_TX_CHNS;
 	common->rx_ch_num_flows = AM65_CPSW_DEFAULT_RX_CHN_FLOWS;
-	common->pf_p0_rx_ptype_rrobin = false;
+	common->pf_p0_rx_ptype_rrobin = true;
 	common->default_vlan = 1;
 
 	common->ports = devm_kcalloc(dev, common->port_num,


