Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2631718E36C;
	Mon, 28 Oct 2024 06:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097362; cv=none; b=Y9FGJRWcWfKN7oCCoMKsofW/785SppY6ramMjtxNcMDm+HubCj9Qhopv5mJczcrjlbsFtuas8T6RVhKYxMOJrnH1zs2o7NsGcPEGWqh5Rqffoxk0COSwbOpm9WH8kMOH3EghcWJyjm8aJpq+pKB+Bo54BUy8O/CFYiH+Z02dJ5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097362; c=relaxed/simple;
	bh=8eeT/K6Zx1ebBcnEOkFTuqZ+Jujp1SYctmVDQ5LNogU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z2uJpJyZIixIgxPJldA9CgLLaClyphCR53HzVfKvLhnn7H9GLwiOlZDZrkpO68GqHKBeiyEkNTlH/2/fOT6JUostmqbzHLMaz4YhnVK9y0xql+Ed4tKzBmHw7T0YBsJcR3rIyjqVx4Dg954TZ21hRSY0guOqP53iEaEarq03PF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=asFJ7sZ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="asFJ7sZ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA61C4CEC3;
	Mon, 28 Oct 2024 06:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097362;
	bh=8eeT/K6Zx1ebBcnEOkFTuqZ+Jujp1SYctmVDQ5LNogU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=asFJ7sZ8Di9csJz069cDV5RHaGz32ibySbPX1xPJzHn0azZvBoiQNDI2m67v9ACn7
	 vu0nAVv031E+HyjezIpBLqoTL9xxNvxWusY6t8LzT1BN9SfvadLhVhwlS2haT1fA8/
	 0hwJ0TMIoBbRp8bRNxu5/GlZ2quicbBuwxeB+5+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 096/137] docs: net: reformat driver.rst from a list to sections
Date: Mon, 28 Oct 2024 07:25:33 +0100
Message-ID: <20241028062301.412308791@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit d2f5c68e3f7157e874a759e382a5eaffa775b869 ]

driver.rst had a historical form of list of common problems.
In the age os Sphinx and rendered documentation it's better
to use the more usual title + text format.

This will allow us to render kdoc into the output more naturally.

No changes to the actual text.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 95ecba62e2fd ("net: fix races in netdev_tx_sent_queue()/dev_watchdog()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/networking/driver.rst | 91 ++++++++++++++++++-----------
 1 file changed, 56 insertions(+), 35 deletions(-)

diff --git a/Documentation/networking/driver.rst b/Documentation/networking/driver.rst
index 64f7236ff10be..3040a74d421c7 100644
--- a/Documentation/networking/driver.rst
+++ b/Documentation/networking/driver.rst
@@ -4,15 +4,19 @@
 Softnet Driver Issues
 =====================
 
-Transmit path guidelines:
+Transmit path guidelines
+========================
 
-1) The ndo_start_xmit method must not return NETDEV_TX_BUSY under
-   any normal circumstances.  It is considered a hard error unless
-   there is no way your device can tell ahead of time when its
-   transmit function will become busy.
+Stop queues in advance
+----------------------
 
-   Instead it must maintain the queue properly.  For example,
-   for a driver implementing scatter-gather this means::
+The ndo_start_xmit method must not return NETDEV_TX_BUSY under
+any normal circumstances.  It is considered a hard error unless
+there is no way your device can tell ahead of time when its
+transmit function will become busy.
+
+Instead it must maintain the queue properly.  For example,
+for a driver implementing scatter-gather this means::
 
 	static netdev_tx_t drv_hard_start_xmit(struct sk_buff *skb,
 					       struct net_device *dev)
@@ -42,56 +46,73 @@ Transmit path guidelines:
 		return NETDEV_TX_OK;
 	}
 
-   And then at the end of your TX reclamation event handling::
+And then at the end of your TX reclamation event handling::
 
 	if (netif_queue_stopped(dp->dev) &&
 	    TX_BUFFS_AVAIL(dp) > (MAX_SKB_FRAGS + 1))
 		netif_wake_queue(dp->dev);
 
-   For a non-scatter-gather supporting card, the three tests simply become::
+For a non-scatter-gather supporting card, the three tests simply become::
 
 		/* This is a hard error log it. */
 		if (TX_BUFFS_AVAIL(dp) <= 0)
 
-   and::
+and::
 
 		if (TX_BUFFS_AVAIL(dp) == 0)
 
-   and::
+and::
 
 	if (netif_queue_stopped(dp->dev) &&
 	    TX_BUFFS_AVAIL(dp) > 0)
 		netif_wake_queue(dp->dev);
 
-2) An ndo_start_xmit method must not modify the shared parts of a
-   cloned SKB.
+No exclusive ownership
+----------------------
+
+An ndo_start_xmit method must not modify the shared parts of a
+cloned SKB.
+
+Timely completions
+------------------
+
+Do not forget that once you return NETDEV_TX_OK from your
+ndo_start_xmit method, it is your driver's responsibility to free
+up the SKB and in some finite amount of time.
 
-3) Do not forget that once you return NETDEV_TX_OK from your
-   ndo_start_xmit method, it is your driver's responsibility to free
-   up the SKB and in some finite amount of time.
+For example, this means that it is not allowed for your TX
+mitigation scheme to let TX packets "hang out" in the TX
+ring unreclaimed forever if no new TX packets are sent.
+This error can deadlock sockets waiting for send buffer room
+to be freed up.
 
-   For example, this means that it is not allowed for your TX
-   mitigation scheme to let TX packets "hang out" in the TX
-   ring unreclaimed forever if no new TX packets are sent.
-   This error can deadlock sockets waiting for send buffer room
-   to be freed up.
+If you return NETDEV_TX_BUSY from the ndo_start_xmit method, you
+must not keep any reference to that SKB and you must not attempt
+to free it up.
 
-   If you return NETDEV_TX_BUSY from the ndo_start_xmit method, you
-   must not keep any reference to that SKB and you must not attempt
-   to free it up.
+Probing guidelines
+==================
 
-Probing guidelines:
+Address validation
+------------------
+
+Any hardware layer address you obtain for your device should
+be verified.  For example, for ethernet check it with
+linux/etherdevice.h:is_valid_ether_addr()
+
+Close/stop guidelines
+=====================
 
-1) Any hardware layer address you obtain for your device should
-   be verified.  For example, for ethernet check it with
-   linux/etherdevice.h:is_valid_ether_addr()
+Quiescence
+----------
 
-Close/stop guidelines:
+After the ndo_stop routine has been called, the hardware must
+not receive or transmit any data.  All in flight packets must
+be aborted. If necessary, poll or wait for completion of
+any reset commands.
 
-1) After the ndo_stop routine has been called, the hardware must
-   not receive or transmit any data.  All in flight packets must
-   be aborted. If necessary, poll or wait for completion of
-   any reset commands.
+Auto-close
+----------
 
-2) The ndo_stop routine will be called by unregister_netdevice
-   if device is still UP.
+The ndo_stop routine will be called by unregister_netdevice
+if device is still UP.
-- 
2.43.0



