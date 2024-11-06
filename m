Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB4C1EE03D;
	Wed,  6 Nov 2024 12:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896722; cv=none; b=CgQ2CiyPcDCm+iNGijCAyY2Fwkw5CIjwEbn0rzw5ixluaBoC5FFncV3AxzT36IcUZRIakLejQgVSU+eNyvMnEnE1tIqCbcrXS2L1CaMfs7nyOkbmBXSvw5mr/b8x6ZX/wSlQ1NR6d4ClBYG67W3eoDEvVnczMI1nFbyOe7HLzRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896722; c=relaxed/simple;
	bh=QHi052u74O7obAzswvrx1o9+ND5EU4Em6V9PEuwop48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lwm+z9u08B4UQ/DKnIVKonTgykorj/2u5FLQmKJKgdWLrt078dEc2dHHBkya5s+Vjn0ofdVfkwND/Ex3/I9v5JC/IFWcG+y95hQSH4RJFffJkAIj+9RppQ/QAVDmDOyJ2ntwiZDclrWjxlyBhVKGdS3sDO2OkdHF4JRrnhWT8C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nOO8JppH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nOO8JppH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E6FC4CED6;
	Wed,  6 Nov 2024 12:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896721;
	bh=QHi052u74O7obAzswvrx1o9+ND5EU4Em6V9PEuwop48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nOO8JppHowH5f0ZJBcF987mqZLdNNzNoA5NZ/yILVFHx76uyJdhWuMUggLibzoZ+U
	 RWWPLDZZxfWfZ4AV1cBV5n/bi6cFokV3Xil/6sleBuLher+BgCDBCdVWc5gJXISdOC
	 VS0w/+ycPoqDn9EX5ZVY06JaMmo4I7K0p+tCxiww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Hemminger <stephen@networkplumber.org>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 050/110] hv_netvsc: Fix VF namespace also in synthetic NIC NETDEV_REGISTER event
Date: Wed,  6 Nov 2024 13:04:16 +0100
Message-ID: <20241106120304.582807734@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haiyang Zhang <haiyangz@microsoft.com>

commit 4c262801ea60c518b5bebc22a09f5b78b3147da2 upstream.

The existing code moves VF to the same namespace as the synthetic NIC
during netvsc_register_vf(). But, if the synthetic device is moved to a
new namespace after the VF registration, the VF won't be moved together.

To make the behavior more consistent, add a namespace check for synthetic
NIC's NETDEV_REGISTER event (generated during its move), and move the VF
if it is not in the same namespace.

Cc: stable@vger.kernel.org
Fixes: c0a41b887ce6 ("hv_netvsc: move VF to same namespace as netvsc device")
Suggested-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/1729275922-17595-1-git-send-email-haiyangz@microsoft.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/hyperv/netvsc_drv.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2789,6 +2789,31 @@ static struct  hv_driver netvsc_drv = {
 	},
 };
 
+/* Set VF's namespace same as the synthetic NIC */
+static void netvsc_event_set_vf_ns(struct net_device *ndev)
+{
+	struct net_device_context *ndev_ctx = netdev_priv(ndev);
+	struct net_device *vf_netdev;
+	int ret;
+
+	vf_netdev = rtnl_dereference(ndev_ctx->vf_netdev);
+	if (!vf_netdev)
+		return;
+
+	if (!net_eq(dev_net(ndev), dev_net(vf_netdev))) {
+		ret = dev_change_net_namespace(vf_netdev, dev_net(ndev),
+					       "eth%d");
+		if (ret)
+			netdev_err(vf_netdev,
+				   "Cannot move to same namespace as %s: %d\n",
+				   ndev->name, ret);
+		else
+			netdev_info(vf_netdev,
+				    "Moved VF to namespace with: %s\n",
+				    ndev->name);
+	}
+}
+
 /*
  * On Hyper-V, every VF interface is matched with a corresponding
  * synthetic interface. The synthetic interface is presented first
@@ -2801,6 +2826,11 @@ static int netvsc_netdev_event(struct no
 	struct net_device *event_dev = netdev_notifier_info_to_dev(ptr);
 	int ret = 0;
 
+	if (event_dev->netdev_ops == &device_ops && event == NETDEV_REGISTER) {
+		netvsc_event_set_vf_ns(event_dev);
+		return NOTIFY_DONE;
+	}
+
 	ret = check_dev_is_matching_vf(event_dev);
 	if (ret != 0)
 		return NOTIFY_DONE;


