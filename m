Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2096FAF;
	Tue,  5 Dec 2023 03:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I42Njhve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 544CCC433C8;
	Tue,  5 Dec 2023 03:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746860;
	bh=EGFZbAh+HVJCjdPTmZPb/UgXF7wgVs13mBAXL36p0KM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I42NjhvecncUrwKjmqMl7sOb56k+SqUJdqT9qH68umlaL7zXHrEdiw82scJ092zAg
	 cP1ZZ/5BvNKjY0BwK7qJTqZRqNcrA/55AQqORVKzx0uPwfQUBNPPOmqLd2ALd+rhsM
	 aWcggLcoYxdJhVKJmY8zTkTBDSPoi1W7gXCZCNEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Stephen Hemminger <stephen@networkplumber.org>,
	Dexuan Cui <decui@microsoft.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 4.19 23/71] hv_netvsc: Mark VF as slave before exposing it to user-mode
Date: Tue,  5 Dec 2023 12:16:21 +0900
Message-ID: <20231205031519.196443484@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031517.859409664@linuxfoundation.org>
References: <20231205031517.859409664@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Li <longli@microsoft.com>

commit c807d6cd089d2f4951baa838081ec5ae3e2360f8 upstream.

When a VF is being exposed form the kernel, it should be marked as "slave"
before exposing to the user-mode. The VF is not usable without netvsc
running as master. The user-mode should never see a VF without the "slave"
flag.

This commit moves the code of setting the slave flag to the time before
VF is exposed to user-mode.

Cc: stable@vger.kernel.org
Fixes: 0c195567a8f6 ("netvsc: transparent VF management")
Signed-off-by: Long Li <longli@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Acked-by: Stephen Hemminger <stephen@networkplumber.org>
Acked-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/hyperv/netvsc_drv.c |   32 +++++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 9 deletions(-)

--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2048,9 +2048,6 @@ static int netvsc_vf_join(struct net_dev
 		goto upper_link_failed;
 	}
 
-	/* set slave flag before open to prevent IPv6 addrconf */
-	vf_netdev->flags |= IFF_SLAVE;
-
 	schedule_delayed_work(&ndev_ctx->vf_takeover, VF_TAKEOVER_INT);
 
 	call_netdevice_notifiers(NETDEV_JOIN, vf_netdev);
@@ -2148,16 +2145,18 @@ static struct net_device *get_netvsc_bys
 			return hv_get_drvdata(ndev_ctx->device_ctx);
 	}
 
-	/* Fallback path to check synthetic vf with
-	 * help of mac addr
+	/* Fallback path to check synthetic vf with help of mac addr.
+	 * Because this function can be called before vf_netdev is
+	 * initialized (NETDEV_POST_INIT) when its perm_addr has not been copied
+	 * from dev_addr, also try to match to its dev_addr.
+	 * Note: On Hyper-V and Azure, it's not possible to set a MAC address
+	 * on a VF that matches to the MAC of a unrelated NETVSC device.
 	 */
 	list_for_each_entry(ndev_ctx, &netvsc_dev_list, list) {
 		ndev = hv_get_drvdata(ndev_ctx->device_ctx);
-		if (ether_addr_equal(vf_netdev->perm_addr, ndev->perm_addr)) {
-			netdev_notice(vf_netdev,
-				      "falling back to mac addr based matching\n");
+		if (ether_addr_equal(vf_netdev->perm_addr, ndev->perm_addr) ||
+		    ether_addr_equal(vf_netdev->dev_addr, ndev->perm_addr))
 			return ndev;
-		}
 	}
 
 	netdev_notice(vf_netdev,
@@ -2165,6 +2164,19 @@ static struct net_device *get_netvsc_bys
 	return NULL;
 }
 
+static int netvsc_prepare_bonding(struct net_device *vf_netdev)
+{
+	struct net_device *ndev;
+
+	ndev = get_netvsc_byslot(vf_netdev);
+	if (!ndev)
+		return NOTIFY_DONE;
+
+	/* set slave flag before open to prevent IPv6 addrconf */
+	vf_netdev->flags |= IFF_SLAVE;
+	return NOTIFY_DONE;
+}
+
 static int netvsc_register_vf(struct net_device *vf_netdev)
 {
 	struct net_device_context *net_device_ctx;
@@ -2481,6 +2493,8 @@ static int netvsc_netdev_event(struct no
 		return NOTIFY_DONE;
 
 	switch (event) {
+	case NETDEV_POST_INIT:
+		return netvsc_prepare_bonding(event_dev);
 	case NETDEV_REGISTER:
 		return netvsc_register_vf(event_dev);
 	case NETDEV_UNREGISTER:


