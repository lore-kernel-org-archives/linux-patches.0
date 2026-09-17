Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3E34398F5;
	Thu, 17 Sep 2026 18:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670874; cv=none; b=XTwZAiQFXetoA5FEU1r7gnBOIF+n8uuegEQodzeN/3khDrw4pmYdIbRjimNElHjOBfLb8ldD6Pnw1GK2WY5ZuxqJp+/ATwILh2BPJ62aR8EbjszihOMtm1gzXcHEusgSJZl9WPQoT3wJQXl3tjowDfxtdSfo0V7CwnKRUiVMr+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670874; c=relaxed/simple;
	bh=o666wxS/Kk23+ik0si2nof8MpqjHTqyu0fGXtYcl7Uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T6IPeJKRq+lHEZbSroQo6gW1YRHNJ6eMjkAotFQ5KEv/rVaue90iX7pPJMGhshIQDpmvaShzw6rfaVGu5FVKYxEiNYVNxy2xI7DxsYV15morAGjp6RAHUOEKUK6taJPNecesiYFKirwqBdBzLlPbYKqkIhz8GqVy389rXfjzt1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LAE2HyCv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LAE2HyCv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DCDD1F000FF;
	Thu, 17 Sep 2026 18:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670872;
	bh=mF47+3uI9OunmtChKTnsLEkXkFrm7BGEvQmbqQ9Twos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LAE2HyCvE2RbDqRKSISkIIYG3BKY4GbbaS2Kby255C9I/A9nNuN3qjC6T1cDxqbe7
	 9pkg6SZ99LYYzdNB9j8RAygNSTnBbXQGjfa/R9jupTWAFK/j+RXEUhWMv6dkPLUSRN
	 Xhl5F4vXABaNtS9RKIr8o7jdRkdb5mix5KAXyFbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	MD Danish Anwar <danishanwar@ti.com>,
	Simon Horman <horms@kernel.org>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0796/1102] net: hsr: enable promiscuous mode on interlink port with fwd offload
Date: Thu, 17 Sep 2026 16:12:19 +0100
Message-ID: <20260917151600.456031180@linuxfoundation.org>
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

From: MD Danish Anwar <danishanwar@ti.com>

[ Upstream commit a2dc179481d18f6df7274522571b64dd50f31e81 ]

hsr_portdev_setup() skips promiscuous mode on non-master ports when
hsr->fwd_offloaded is set. fwd_offloaded is derived only from the ring
slaves' NETIF_F_HW_HSR_FWD bit, so this also skips it for the interlink
port, which never gets forwarding offload. Without promiscuous mode,
the interlink NIC drops unicast frames addressed to hsr_dev's MAC
(e.g. SAN traffic to the RedBox), breaking RedBox whenever the ring is
HW-offloaded.

Fixes: 5055cccfc2d1 ("net: hsr: Provide RedBox support (HSR-SAN)")
Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Link: https://patch.msgid.link/20260908090856.2876114-1-danishanwar@ti.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_slave.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/hsr/hsr_slave.c b/net/hsr/hsr_slave.c
index ffc7259729527..e22694b727b28 100644
--- a/net/hsr/hsr_slave.c
+++ b/net/hsr/hsr_slave.c
@@ -148,9 +148,12 @@ static int hsr_portdev_setup(struct hsr_priv *hsr, struct net_device *dev,
 	int res;
 
 	/* Don't use promiscuous mode for offload since L2 frame forward
-	 * happens at the offloaded hardware.
+	 * happens at the offloaded hardware. The interlink port never
+	 * gets forwarding offload (RedBox forwarding to/from it is done
+	 * by this driver), so it still needs promiscuous mode to receive
+	 * frames addressed to hsr_dev's MAC rather than its own.
 	 */
-	if (!port->hsr->fwd_offloaded) {
+	if (!port->hsr->fwd_offloaded || port->type == HSR_PT_INTERLINK) {
 		res = dev_set_promiscuity(dev, 1);
 		if (res)
 			return res;
@@ -173,7 +176,7 @@ static int hsr_portdev_setup(struct hsr_priv *hsr, struct net_device *dev,
 fail_rx_handler:
 	netdev_upper_dev_unlink(dev, hsr_dev);
 fail_upper_dev_link:
-	if (!port->hsr->fwd_offloaded)
+	if (!port->hsr->fwd_offloaded || port->type == HSR_PT_INTERLINK)
 		dev_set_promiscuity(dev, -1);
 
 	return res;
@@ -236,7 +239,7 @@ void hsr_del_port(struct hsr_port *port)
 		netdev_update_features(master->dev);
 		dev_set_mtu(master->dev, hsr_get_max_mtu(hsr));
 		netdev_rx_handler_unregister(port->dev);
-		if (!port->hsr->fwd_offloaded)
+		if (!port->hsr->fwd_offloaded || port->type == HSR_PT_INTERLINK)
 			dev_set_promiscuity(port->dev, -1);
 		if (port->type == HSR_PT_SLAVE_A || port->type == HSR_PT_SLAVE_B)
 			vlan_vids_del_by_dev(port->dev, master->dev);
-- 
2.53.0



