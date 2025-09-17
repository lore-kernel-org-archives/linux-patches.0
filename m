Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59468330D3C;
	Wed, 17 Sep 2025 12:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113549; cv=none; b=oNIyJJf6VXQrul+Trzg+7ZJLMcKMM4gMEdZgV8v6HHMcWTx/EWOlZ+BEzK/xPG2UFdQWt/apKAtdvuoOzZ+w5dfKx0rKXv8gmDmmbgIe9HWTFzTsHTKlEkKhZrcovejkysmHwx6vu8v+DtsjVA0wLVid1QZBPYNGww0MaPdWId4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113549; c=relaxed/simple;
	bh=q6A4KVoUqegyizFtFXCv2xaI8PVZs1GVltdyBscrsBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qmh+oRTeUHtRzQUbv0D1EL8r1ut0jeRtG5y8aqRVHmU4rHOAw8pEVmEBP7uoL2zdm82lWL1NaAVacsRJGMQoTLQU2W39xvNbaImNztu0R5TwtcZIAuAhjqjpxxWSxJGGFZPGlibky3CYWnDDvnfSGFKDnlKxuc8QPr9Sbd3gPHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D/yq+nAr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D/yq+nAr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39BFC4CEF0;
	Wed, 17 Sep 2025 12:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113549;
	bh=q6A4KVoUqegyizFtFXCv2xaI8PVZs1GVltdyBscrsBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D/yq+nArCYkHfH99gR4QIYT/LfbZfHzpQyIc8D3Nz/7SWXkhpBrAqQArIWJluiCIi
	 swPuWavXsI5RpZGtbnHKvjBHU9vv3VSsEQeci1GrzjjU+CNCww3y54s+eI7nshgE/y
	 7EYto1t3BpscTmPuEJprqIQ0IWFp/GH+1qMuyWqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 118/140] hsr: use rtnl lock when iterating over ports
Date: Wed, 17 Sep 2025 14:34:50 +0200
Message-ID: <20250917123347.191160653@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 8884c693991333ae065830554b9b0c96590b1bb2 ]

hsr_for_each_port is called in many places without holding the RCU read
lock, this may trigger warnings on debug kernels. Most of the callers
are actually hold rtnl lock. So add a new helper hsr_for_each_port_rtnl
to allow callers in suitable contexts to iterate ports safely without
explicit RCU locking.

This patch only fixed the callers that is hold rtnl lock. Other caller
issues will be fixed in later patches.

Fixes: c5a759117210 ("net/hsr: Use list_head (and rcu) instead of array for slave devices.")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250905091533.377443-2-liuhangbin@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_device.c | 18 +++++++++---------
 net/hsr/hsr_main.c   |  2 +-
 net/hsr/hsr_main.h   |  3 +++
 3 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 9f1106bdd4f09..56b49d477bec0 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -49,7 +49,7 @@ static bool hsr_check_carrier(struct hsr_port *master)
 
 	ASSERT_RTNL();
 
-	hsr_for_each_port(master->hsr, port) {
+	hsr_for_each_port_rtnl(master->hsr, port) {
 		if (port->type != HSR_PT_MASTER && is_slave_up(port->dev)) {
 			netif_carrier_on(master->dev);
 			return true;
@@ -105,7 +105,7 @@ int hsr_get_max_mtu(struct hsr_priv *hsr)
 	struct hsr_port *port;
 
 	mtu_max = ETH_DATA_LEN;
-	hsr_for_each_port(hsr, port)
+	hsr_for_each_port_rtnl(hsr, port)
 		if (port->type != HSR_PT_MASTER)
 			mtu_max = min(port->dev->mtu, mtu_max);
 
@@ -139,7 +139,7 @@ static int hsr_dev_open(struct net_device *dev)
 
 	hsr = netdev_priv(dev);
 
-	hsr_for_each_port(hsr, port) {
+	hsr_for_each_port_rtnl(hsr, port) {
 		if (port->type == HSR_PT_MASTER)
 			continue;
 		switch (port->type) {
@@ -172,7 +172,7 @@ static int hsr_dev_close(struct net_device *dev)
 	struct hsr_priv *hsr;
 
 	hsr = netdev_priv(dev);
-	hsr_for_each_port(hsr, port) {
+	hsr_for_each_port_rtnl(hsr, port) {
 		if (port->type == HSR_PT_MASTER)
 			continue;
 		switch (port->type) {
@@ -205,7 +205,7 @@ static netdev_features_t hsr_features_recompute(struct hsr_priv *hsr,
 	 * may become enabled.
 	 */
 	features &= ~NETIF_F_ONE_FOR_ALL;
-	hsr_for_each_port(hsr, port)
+	hsr_for_each_port_rtnl(hsr, port)
 		features = netdev_increment_features(features,
 						     port->dev->features,
 						     mask);
@@ -483,7 +483,7 @@ static void hsr_set_rx_mode(struct net_device *dev)
 
 	hsr = netdev_priv(dev);
 
-	hsr_for_each_port(hsr, port) {
+	hsr_for_each_port_rtnl(hsr, port) {
 		if (port->type == HSR_PT_MASTER)
 			continue;
 		switch (port->type) {
@@ -505,7 +505,7 @@ static void hsr_change_rx_flags(struct net_device *dev, int change)
 
 	hsr = netdev_priv(dev);
 
-	hsr_for_each_port(hsr, port) {
+	hsr_for_each_port_rtnl(hsr, port) {
 		if (port->type == HSR_PT_MASTER)
 			continue;
 		switch (port->type) {
@@ -533,7 +533,7 @@ static int hsr_ndo_vlan_rx_add_vid(struct net_device *dev,
 
 	hsr = netdev_priv(dev);
 
-	hsr_for_each_port(hsr, port) {
+	hsr_for_each_port_rtnl(hsr, port) {
 		if (port->type == HSR_PT_MASTER ||
 		    port->type == HSR_PT_INTERLINK)
 			continue;
@@ -579,7 +579,7 @@ static int hsr_ndo_vlan_rx_kill_vid(struct net_device *dev,
 
 	hsr = netdev_priv(dev);
 
-	hsr_for_each_port(hsr, port) {
+	hsr_for_each_port_rtnl(hsr, port) {
 		switch (port->type) {
 		case HSR_PT_SLAVE_A:
 		case HSR_PT_SLAVE_B:
diff --git a/net/hsr/hsr_main.c b/net/hsr/hsr_main.c
index d7ae32473c41a..e1afa54b3fba8 100644
--- a/net/hsr/hsr_main.c
+++ b/net/hsr/hsr_main.c
@@ -22,7 +22,7 @@ static bool hsr_slave_empty(struct hsr_priv *hsr)
 {
 	struct hsr_port *port;
 
-	hsr_for_each_port(hsr, port)
+	hsr_for_each_port_rtnl(hsr, port)
 		if (port->type != HSR_PT_MASTER)
 			return false;
 	return true;
diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
index e26244456f639..f066c9c401c60 100644
--- a/net/hsr/hsr_main.h
+++ b/net/hsr/hsr_main.h
@@ -231,6 +231,9 @@ struct hsr_priv {
 #define hsr_for_each_port(hsr, port) \
 	list_for_each_entry_rcu((port), &(hsr)->ports, port_list)
 
+#define hsr_for_each_port_rtnl(hsr, port) \
+	list_for_each_entry_rcu((port), &(hsr)->ports, port_list, lockdep_rtnl_is_held())
+
 struct hsr_port *hsr_port_get_hsr(struct hsr_priv *hsr, enum hsr_port_type pt);
 
 /* Caller must ensure skb is a valid HSR frame */
-- 
2.51.0



