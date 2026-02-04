Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B46352937;
	Wed,  4 Feb 2026 15:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218895; cv=none; b=NOYsArcflGn2eWPB241UVVkI7LlbGDxD7CrJTvaHC2FNGZmkVuJAVjhVQiVv2pFpmZBPX47aDPNFs45GI/61RhTAf5m5+0qNpJe4HsGQ6KArOVWyc2bmHfA1OUMhoRTK8JveXBk1qAf1Ft+ypa8d2kn5NgtncxBlV2zt3j0gLLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218895; c=relaxed/simple;
	bh=quqLLKWChKEdqeKBbDzdMgQtuKmCE1b1Cf+N1zI6WBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NupIkL8Mi39jYq1/xlDPPfzbNw6od5Mg+NnYROGnYqj8ieuLUnff1os/YVE4qrfQx8KC0HORTsDHkZ5deWRSvqrEfpqiXERUDEPAf6CAV5GtEjFBFHStxcDQGsxA9Ev3stisRUTPHu5PWTBxdEKMdOFhxMZAUflWucCYnUhXOzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ofuqefuL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ofuqefuL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E2AC4CEF7;
	Wed,  4 Feb 2026 15:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218895;
	bh=quqLLKWChKEdqeKBbDzdMgQtuKmCE1b1Cf+N1zI6WBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ofuqefuLwv2KEP3oI1C+E9+njr/pugk+C4V6dldDmNY3pdRBrYcJY8D9PDd1Z4k+L
	 7rSkM0oDlGDtTbSfyBfGucIHAVzbXE9GmTarqMfYkdzh97W3zTIueiplIy5my/HCyl
	 1vRzpw0TmeRHuGih0ltnw9rUyrRz5lMB9NkeWGzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Leon Romanovsky <leon@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.12 86/87] RDMA/mana_ib: Handle net event for pointing to the current netdev
Date: Wed,  4 Feb 2026 15:41:24 +0100
Message-ID: <20260204143850.024294683@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
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

From: Long Li <longli@microsoft.com>

commit bee35b7161aaaed9831e2f14876c374b9c566952 upstream.

When running under Hyper-V, the master device to the RDMA device is always
bonded to this RDMA device. This is not user-configurable.

The master device can be unbind/bind from the kernel. During those events,
the RDMA device should set to the current netdev to reflect the change of
master device from those events.

Signed-off-by: Long Li <longli@microsoft.com>
Link: https://patch.msgid.link/1741821332-9392-2-git-send-email-longli@linuxonhyperv.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Fixes: 1df03a4b4414 ("RDMA/mana_ib: Set correct device into ib")
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mana/device.c  |   47 +++++++++++++++++++++++++++++++++--
 drivers/infiniband/hw/mana/mana_ib.h |    1 
 2 files changed, 46 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/hw/mana/device.c
+++ b/drivers/infiniband/hw/mana/device.c
@@ -51,6 +51,38 @@ static const struct ib_device_ops mana_i
 			   ib_ind_table),
 };
 
+static int mana_ib_netdev_event(struct notifier_block *this,
+				unsigned long event, void *ptr)
+{
+	struct mana_ib_dev *dev = container_of(this, struct mana_ib_dev, nb);
+	struct net_device *event_dev = netdev_notifier_info_to_dev(ptr);
+	struct gdma_context *gc = dev->gdma_dev->gdma_context;
+	struct mana_context *mc = gc->mana.driver_data;
+	struct net_device *ndev;
+
+	/* Only process events from our parent device */
+	if (event_dev != mc->ports[0])
+		return NOTIFY_DONE;
+
+	switch (event) {
+	case NETDEV_CHANGEUPPER:
+		ndev = mana_get_primary_netdev(mc, 0, &dev->dev_tracker);
+		/*
+		 * RDMA core will setup GID based on updated netdev.
+		 * It's not possible to race with the core as rtnl lock is being
+		 * held.
+		 */
+		ib_device_set_netdev(&dev->ib_dev, ndev, 1);
+
+		/* mana_get_primary_netdev() returns ndev with refcount held */
+		netdev_put(ndev, &dev->dev_tracker);
+
+		return NOTIFY_OK;
+	default:
+		return NOTIFY_DONE;
+	}
+}
+
 static int mana_ib_probe(struct auxiliary_device *adev,
 			 const struct auxiliary_device_id *id)
 {
@@ -108,17 +140,25 @@ static int mana_ib_probe(struct auxiliar
 	}
 	dev->gdma_dev = &mdev->gdma_context->mana_ib;
 
+	dev->nb.notifier_call = mana_ib_netdev_event;
+	ret = register_netdevice_notifier(&dev->nb);
+	if (ret) {
+		ibdev_err(&dev->ib_dev, "Failed to register net notifier, %d",
+			  ret);
+		goto deregister_device;
+	}
+
 	ret = mana_ib_gd_query_adapter_caps(dev);
 	if (ret) {
 		ibdev_err(&dev->ib_dev, "Failed to query device caps, ret %d",
 			  ret);
-		goto deregister_device;
+		goto deregister_net_notifier;
 	}
 
 	ret = mana_ib_create_eqs(dev);
 	if (ret) {
 		ibdev_err(&dev->ib_dev, "Failed to create EQs, ret %d", ret);
-		goto deregister_device;
+		goto deregister_net_notifier;
 	}
 
 	ret = mana_ib_gd_create_rnic_adapter(dev);
@@ -147,6 +187,8 @@ destroy_rnic:
 	mana_ib_gd_destroy_rnic_adapter(dev);
 destroy_eqs:
 	mana_ib_destroy_eqs(dev);
+deregister_net_notifier:
+	unregister_netdevice_notifier(&dev->nb);
 deregister_device:
 	mana_gd_deregister_device(dev->gdma_dev);
 free_ib_device:
@@ -162,6 +204,7 @@ static void mana_ib_remove(struct auxili
 	xa_destroy(&dev->qp_table_wq);
 	mana_ib_gd_destroy_rnic_adapter(dev);
 	mana_ib_destroy_eqs(dev);
+	unregister_netdevice_notifier(&dev->nb);
 	mana_gd_deregister_device(dev->gdma_dev);
 	ib_dealloc_device(&dev->ib_dev);
 }
--- a/drivers/infiniband/hw/mana/mana_ib.h
+++ b/drivers/infiniband/hw/mana/mana_ib.h
@@ -65,6 +65,7 @@ struct mana_ib_dev {
 	struct xarray qp_table_wq;
 	struct mana_ib_adapter_caps adapter_caps;
 	netdevice_tracker dev_tracker;
+	struct notifier_block nb;
 };
 
 struct mana_ib_wq {


