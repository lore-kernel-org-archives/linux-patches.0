Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960855349B3;
	Thu, 17 Sep 2026 17:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666273; cv=none; b=okZZEhnw+juxv4OJjkOcoBpkE3KMSTs5QuhMAyLLiwhvmVkZWKAX4m8ecsx1eJ3+NMDtwmbXGsi/sb+xV5eD/uNP+Bi6ANcrme90PDqqfU+0o0FnkPFtP3e7NDxxC/5wJS70hSMy+JFmbD4PzdWdLCzdT8ykZfSLS+lemM0Mfjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666273; c=relaxed/simple;
	bh=/5gdaIpTrh6XCkKoJMgbj1pD8sRPrJaQvhnvCyon3uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S22SXh/F/lRKrMY93VishKX/wOaTYYVFOFqERVeeZtje8YAqat84XkVC2XQnaP3FxggMB+O3L7bs5WncSoSbp5tlTiKR8uoLVLfeC2igQZnenOjfyEOQh98gmFhFWwVdU6SdA9Z5wZCGMpkQJbz5Avbw+gKEHwh7EbKUnuMfe38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FnsWH45R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FnsWH45R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B46AA1F000FF;
	Thu, 17 Sep 2026 17:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666272;
	bh=OlbmD45526MyXtl1aaUeYIrvi1J7pMSnhaUGuJv8EqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FnsWH45Rs4XC7+wB61s9Pq6BJqVKSWywENmwudskervQuc7Cve6GzZnobUcWQhfrm
	 qH+E4JxTxdNz8YnU8NvKQVeBzi4sjiHtnnspkuWgnAfQnNTYvGTdlFcOui16/0Oik8
	 eaKgvrkUguqEKTLZKFYZOjL+zq+mCGkc8if+Q9a8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	MD Danish Anwar <danishanwar@ti.com>,
	Simon Horman <horms@kernel.org>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0944/1250] net: hsr: enable promiscuous mode on interlink port with fwd offload
Date: Thu, 17 Sep 2026 16:12:19 +0100
Message-ID: <20260917151617.610912843@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 474f44f1ee88c..63df9ee5cacd3 100644
--- a/net/hsr/hsr_slave.c
+++ b/net/hsr/hsr_slave.c
@@ -149,9 +149,12 @@ static int hsr_portdev_setup(struct hsr_priv *hsr, struct net_device *dev,
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
@@ -176,7 +179,7 @@ static int hsr_portdev_setup(struct hsr_priv *hsr, struct net_device *dev,
 fail_rx_handler:
 	netdev_upper_dev_unlink(dev, hsr_dev);
 fail_upper_dev_link:
-	if (!port->hsr->fwd_offloaded)
+	if (!port->hsr->fwd_offloaded || port->type == HSR_PT_INTERLINK)
 		dev_set_promiscuity(dev, -1);
 
 	return res;
@@ -240,7 +243,7 @@ void hsr_del_port(struct hsr_port *port)
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



