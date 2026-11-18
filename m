Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027556;
	b=rE2BhBFbXXZJQewD5q6sMD4TByLriVUp3wYkYq0OH6fIvRkGUBBeMu6kAE73FAcozMtG
	 9BT7JLdhGij+Kc1d9KcUBL3yfmIH1qlqVLIbBxuVdCxOi7PxwrWjRCF8a9DrHSNT+NAzw
	 JOcz0vccV+HuuyIMQEGRDVpuH9IVxktfpncbChHJNlaQOzv+RKzHLf1eFlZ58U117KQqP
	 gvdwldYzDaZl/zwB/98qckrCrakZJhkjdHRoRRLmbtz1YLQa6YJL8R7gCq3Aky8R6ucDx
	 ocHCvKET94KrcAFkcRh6MNdwdngcpBXhc3w5zShPkQJ81O0qbUQUgQoQLj8hNh2cm6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027556;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Evdf39T5nRn+hSZDgj62KMQ9SrxbOSal4ScwFgOpLzA=;
	b=ht7mn40yoNBNqJNTzPnUwMsKlmYNmBBPfuE5q3pwLNBDhp/ycF2mBFi2p10sOkM4UDJc
	 lMcceqTE+w/e9wKR2TArTRjfOGqNR463ZWX59Ce7OBRDiM1sR0Zz+ricsGE1zb5bpJBdr
	 JJKpuF/64xdygQwOQsdviNQh161NFw31QYvmPlbKJ558xfd0YL1jXHj76imk7jQCGlq/J
	 DDtVP6O0ga+hVczAbnjSFLIVXFeMFq8cfZ0f18nFpK5b6UPLTTVIXXd/3et5uUpgSHzL2
	 1Z/1LFpiU7vvotU9SGqxAiIld2IKiO77yxM9fblt5D7aj8IZdPC2+Ue0l5F78sbp4Xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Gs/JaZdh";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC54606A332;
	Wed, 18 Nov 2026 18:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gs/JaZdh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 031781F000C7;
	Wed, 18 Nov 2026 18:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027556;
	bh=Evdf39T5nRn+hSZDgj62KMQ9SrxbOSal4ScwFgOpLzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gs/JaZdhzZrVKGQ9JgKX1LU0W+UT+DnZUOgLjzOC5bf2HSqRJa+4nMppnMZZn+6o4
	 OWATcTumUUztGBOl7W0RTPiye+0RygWmeE8mJ+IOT9+vbVijYPEn8bZUY8QBA3DT5y
	 b2Hl8fuMN4T8cLGIqh8voZ5Aj+SjBNEEvrgWEq4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingming Cao <mmc@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1832/2151] ibmveth: do not close twice after a failed reopen
Date: Wed, 18 Nov 2026 15:59:27 +0100
Message-ID: <20261118150228.538534615@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Mingming Cao <mmc@linux.ibm.com>

[ Upstream commit 95811c873d1b97c424a7e6e731730cbf6656ab7e ]

ibmveth_change_mtu(), veth_pool_store(), ibmveth_set_csum_offload()
and ibmveth_set_tso() call close() and open() directly. If open() fails,
NAPI is left disabled while IFF_UP stays set, so the next close()
(ifdown, unregister or another reconfiguration) calls napi_disable()
again and waits forever with RTNL held. Networking and shutdown
hang; only a reboot recovers. ethtool -L in that state also wakes
queues that have no TX buffer and dereferences NULL in
ibmveth_start_xmit().

Any open() failure on those paths triggers it, for example an
allocation failure on an MTU change to jumbo frames.

Track a successful open in adapter->opened. close() returns early
when it is clear, and set_channels() checks it instead of IFF_UP.

The open() error-path leaks were fixed separately in net by
commit af0524bf4ce1 ("ibmveth: h_free logical LAN on open-fail after
register") and commit 84bec0bf0352 ("ibmveth: fix TX LTB and filter
unwind on open-fail"), which are now in net-next too, so a failed
open() no longer leaves TX buffers or the logical LAN registration
behind for the early return to skip.

Found in review of the ibmveth multi-queue RX series and confirmed by
code inspection. Tested on a POWER10 LPAR with ibmveth_open() forced to
fail by a test-only module parameter (not part of this patch): 'ip link
set dev eth1 mtu 9000' fails, then 'ip link set dev eth1 down' returns
at once and 'ip link set dev eth1 up' recovers the interface. No kernel
selftests cover ibmveth.

Fixes: 860f242eb534 ("[PATCH] ibmveth change buffer pools dynamically")
Signed-off-by: Mingming Cao <mmc@linux.ibm.com>
Link: https://patch.msgid.link/20261013182926.30417-3-mmc@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmveth.c | 24 +++++++++++++++++-------
 drivers/net/ethernet/ibm/ibmveth.h |  2 ++
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 7fdf0c5c2f9c4..bf0e0dc5eb516 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -739,6 +739,7 @@ static int ibmveth_open(struct net_device *netdev)
 
 	netif_tx_start_all_queues(netdev);
 
+	adapter->opened = true;
 	netdev_dbg(netdev, "open complete\n");
 
 	return 0;
@@ -781,6 +782,14 @@ static int ibmveth_close(struct net_device *netdev)
 	long lpar_rc;
 	int i;
 
+	/* change_mtu, pool sysfs, set_csum and set_tso call close() and
+	 * open() directly. If that open() fails, IFF_UP stays set and
+	 * NAPI is disabled; a second close() would hang in napi_disable().
+	 */
+	if (!adapter->opened)
+		return 0;
+	adapter->opened = false;
+
 	netdev_dbg(netdev, "close starting\n");
 
 	napi_disable(&adapter->napi);
@@ -832,10 +841,10 @@ static int ibmveth_close(struct net_device *netdev)
  *
  * @w: pointer to work_struct embedded in adapter structure
  *
- * Context: This routine acquires rtnl_mutex and disables its NAPI through
- *          ibmveth_close. It can't be called directly in a context that has
- *          already acquired rtnl_mutex or disabled its NAPI, or directly from
- *          a poll routine.
+ * Context: This routine acquires rtnl_mutex and, if the device is open,
+ *          disables its NAPI through ibmveth_close. It can't be called
+ *          directly in a context that has already acquired rtnl_mutex or
+ *          disabled its NAPI, or directly from a poll routine.
  *
  * Return: void
  */
@@ -1129,10 +1138,11 @@ static int ibmveth_set_channels(struct net_device *netdev,
 		     goal = channels->tx_count;
 	int rc, i;
 
-	/* If ndo_open has not been called yet then don't allocate, just set
-	 * desired netdev_queue's and return
+	/* If the device is not open (including a failed close/open with
+	 * IFF_UP still set) then don't allocate, just set desired
+	 * netdev_queue's and return
 	 */
-	if (!(netdev->flags & IFF_UP))
+	if (!adapter->opened)
 		return netif_set_real_num_tx_queues(netdev, goal);
 
 	/* We have IBMVETH_MAX_QUEUES netdev_queue's allocated
diff --git a/drivers/net/ethernet/ibm/ibmveth.h b/drivers/net/ethernet/ibm/ibmveth.h
index d87713668ed30..3f2240823f6a3 100644
--- a/drivers/net/ethernet/ibm/ibmveth.h
+++ b/drivers/net/ethernet/ibm/ibmveth.h
@@ -172,6 +172,8 @@ struct ibmveth_adapter {
 	int rx_csum;
 	int large_send;
 	bool is_active_trunk;
+	/* Set by a successful ibmveth_open(), cleared by ibmveth_close(). */
+	bool opened;
 	unsigned int rx_buffers_per_hcall;
 
 	u64 fw_ipv6_csum_support;
-- 
2.53.0



