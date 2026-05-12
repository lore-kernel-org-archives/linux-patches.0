Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453173EDE5E;
	Tue, 12 May 2026 17:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608652; cv=none; b=WeS3Bo1IUsGhBBJr1aizzQm46OfnMr20r+a4iFFrPoJa+4oJ4wba4cxdkXf76kTlUepJc78UHaTSMemhQ9aAXVHbvyn69xKiFVvw9GLqdYBndcnVUrzgZYgjSgaI1ed0dNP50H9n+CLu27nhPJabILiriibwQxs9+tHoaH3Mwws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608652; c=relaxed/simple;
	bh=830RYLoXSESuE9sdMpQEShGZHfza82+IMiahQcRAXtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VyJOxgSaYIfMDLAQICaq6a8MYdYpfyHf3atEeXEBfxwKZU2lo8Zem01v4Q6i49tUwxHAZZQYuah2vEggudVmJ9wzYM6cJ8b8CG62YSvD15KHRgaCGbV/u9SPrCgI4LRVWH9bimFGVN9QbtF83KUtspY0HMbnE9/O/0ThXerf+Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1OVeDT8u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1OVeDT8u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6133C2BCB0;
	Tue, 12 May 2026 17:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608652;
	bh=830RYLoXSESuE9sdMpQEShGZHfza82+IMiahQcRAXtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1OVeDT8u02GZAceZ2nA7ImDu14cKtOCF6xzg9vs1le4hQG/dvz5WVjjnLJemHXNBC
	 o3cellto9RFcVj4d35NyI+5FBwwpzTMrBdGhJwSmM70HSDOhVVw2I40bTftPseFxw9
	 WhNRp/Whv8pkhUjQapubDo46qVcnUGOFDCLjEres=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian King <bjking1@linux.ibm.com>,
	Shaik Abdulla <shaik.abdulla1@ibm.com>,
	Naveed Ahmed <naveedaus@in.ibm.com>,
	Mingming Cao <mmc@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 125/270] ibmveth: Disable GSO for packets with small MSS
Date: Tue, 12 May 2026 19:38:46 +0200
Message-ID: <20260512173941.086899710@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

From: Mingming Cao <mmc@linux.ibm.com>

commit cc427d24ac6442ffdeafd157a63c7c5b73ed4de4 upstream.

Some physical adapters on Power systems do not support segmentation
offload when the MSS is less than 224 bytes. Attempting to send such
packets causes the adapter to freeze, stopping all traffic until
manually reset.

Implement ndo_features_check to disable GSO for packets with small MSS
values. The network stack will perform software segmentation instead.

The 224-byte minimum matches ibmvnic
commit <f10b09ef687f> ("ibmvnic: Enforce stronger sanity checks
on GSO packets")
which uses the same physical adapters in SEA configurations.

The issue occurs specifically when the hardware attempts to perform
segmentation (gso_segs > 1) with a small MSS. Single-segment GSO packets
(gso_segs == 1) do not trigger the problematic LSO code path and are
transmitted normally without segmentation.

Add an ndo_features_check callback to disable GSO when MSS < 224 bytes.
Also call vlan_features_check() to ensure proper handling of VLAN packets,
particularly QinQ (802.1ad) configurations where the hardware parser may
not support certain offload features.

Validated using iptables to force small MSS values. Without the fix,
the adapter freezes. With the fix, packets are segmented in software
and transmission succeeds. Comprehensive regression testing completedd
(MSS tests, performance, stability).

Fixes: 8641dd85799f ("ibmveth: Add support for TSO")
Cc: stable@vger.kernel.org
Reviewed-by: Brian King <bjking1@linux.ibm.com>
Tested-by: Shaik Abdulla <shaik.abdulla1@ibm.com>
Tested-by: Naveed Ahmed <naveedaus@in.ibm.com>
Signed-off-by: Mingming Cao <mmc@linux.ibm.com>
Link: https://patch.msgid.link/20260424162917.65725-1-mmc@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ibm/ibmveth.c |   22 ++++++++++++++++++++++
 drivers/net/ethernet/ibm/ibmveth.h |    1 +
 2 files changed, 23 insertions(+)

--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -1756,6 +1756,27 @@ static int ibmveth_set_mac_addr(struct n
 	return 0;
 }
 
+static netdev_features_t ibmveth_features_check(struct sk_buff *skb,
+						struct net_device *dev,
+						netdev_features_t features)
+{
+	/* Some physical adapters do not support segmentation offload with
+	 * MSS < 224. Disable GSO for such packets to avoid adapter freeze.
+	 * Note: Single-segment packets (gso_segs == 1) don't need this check
+	 * as they bypass the LSO path and are transmitted without segmentation.
+	 */
+	if (skb_is_gso(skb)) {
+		if (skb_shinfo(skb)->gso_size < IBMVETH_MIN_LSO_MSS) {
+			netdev_warn_once(dev,
+					 "MSS %u too small for LSO, disabling GSO\n",
+					 skb_shinfo(skb)->gso_size);
+			features &= ~NETIF_F_GSO_MASK;
+		}
+	}
+
+	return vlan_features_check(skb, features);
+}
+
 static const struct net_device_ops ibmveth_netdev_ops = {
 	.ndo_open		= ibmveth_open,
 	.ndo_stop		= ibmveth_close,
@@ -1767,6 +1788,7 @@ static const struct net_device_ops ibmve
 	.ndo_set_features	= ibmveth_set_features,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address    = ibmveth_set_mac_addr,
+	.ndo_features_check	= ibmveth_features_check,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller	= ibmveth_poll_controller,
 #endif
--- a/drivers/net/ethernet/ibm/ibmveth.h
+++ b/drivers/net/ethernet/ibm/ibmveth.h
@@ -37,6 +37,7 @@
 #define IBMVETH_ILLAN_IPV4_TCP_CSUM		0x0000000000000002UL
 #define IBMVETH_ILLAN_ACTIVE_TRUNK		0x0000000000000001UL
 
+#define IBMVETH_MIN_LSO_MSS		224	/* Minimum MSS for LSO */
 /* hcall macros */
 #define h_register_logical_lan(ua, buflst, rxq, fltlst, mac) \
   plpar_hcall_norets(H_REGISTER_LOGICAL_LAN, ua, buflst, rxq, fltlst, mac)


