Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148EF54F9B;
	Thu, 30 Nov 2023 16:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1df17WEb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 159D2C433C7;
	Thu, 30 Nov 2023 16:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361835;
	bh=l3+3dh4DZC9+MOAwdhXpGRiuMY8n0fsoNnrlm/NILeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1df17WEbQKPhOkAIILECWG0plINadg7q65ZoQzzh52hKLhd466Gza5TXXnXkPAnqg
	 zAnwjb1bqcywgz1mwv747XYbD4gqI/q9lx+PHjniARdLqtNS0JuUsMtDDfWtt5e7Uq
	 vg7UT01/Jpukl9lImkDFnY9Y85BZswI8h5Zml/30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Stephen Hemminger <stephen@networkplumber.org>,
	Dexuan Cui <decui@microsoft.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 66/82] hv_netvsc: Mark VF as slave before exposing it to user-mode
Date: Thu, 30 Nov 2023 16:22:37 +0000
Message-ID: <20231130162138.078531300@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162135.977485944@linuxfoundation.org>
References: <20231130162135.977485944@linuxfoundation.org>
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
@@ -2204,9 +2204,6 @@ static int netvsc_vf_join(struct net_dev
 		goto upper_link_failed;
 	}
 
-	/* set slave flag before open to prevent IPv6 addrconf */
-	vf_netdev->flags |= IFF_SLAVE;
-
 	schedule_delayed_work(&ndev_ctx->vf_takeover, VF_TAKEOVER_INT);
 
 	call_netdevice_notifiers(NETDEV_JOIN, vf_netdev);
@@ -2313,16 +2310,18 @@ static struct net_device *get_netvsc_bys
 
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
@@ -2330,6 +2329,19 @@ static struct net_device *get_netvsc_bys
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
@@ -2754,6 +2766,8 @@ static int netvsc_netdev_event(struct no
 		return NOTIFY_DONE;
 
 	switch (event) {
+	case NETDEV_POST_INIT:
+		return netvsc_prepare_bonding(event_dev);
 	case NETDEV_REGISTER:
 		return netvsc_register_vf(event_dev);
 	case NETDEV_UNREGISTER:


