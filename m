Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072DF2AF07;
	Mon, 28 Oct 2024 06:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098449; cv=none; b=DaEnrkCut0rE/TDI+y527dC5qkRrjiyjYT/L6CsGMV2ahqBEjl03qycXNzP1/Oc9pvP7HQMZrJDm0LnbUCsVjNNWgXMZN/83XhNdKrLUJB1+FxlMoxMmbvRQbDa5xFY1BtS3zkD1pEp1QDXpL/18q7kn26YOvqidS8VOjTX4iEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098449; c=relaxed/simple;
	bh=xzEAn5x6UcaQZHUatRM5lNK5uVSIYeQIkTKW3J6bGtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BXrvarFGjygUsLdw3SYhlflPl04Gixu+LOhCr5MGmIQRn4DCb0mNifu8WKu0Q7TLKTlrK66lBqeEg4yglrkveEPZFnZ2MKvpsxDkjFaSvIac0MGLyF6lSFw9cBb4h34iE9xEHAGhGjrPuFASisXINkDNL3RpXH7JR06aaxQDFhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VIyNamZR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VIyNamZR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5521DC4CEC3;
	Mon, 28 Oct 2024 06:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098448;
	bh=xzEAn5x6UcaQZHUatRM5lNK5uVSIYeQIkTKW3J6bGtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VIyNamZRkJhxWv+TclqyMb1OTwX03bmm/l9LjGi+H95eZ3A6lCKJuVqHVWFtAgKBy
	 oCpynyiGpqyMswhEMuQsQ4Sbd0elmWGTFj4bMZKRzM2RiAvTqu6zULq6ty1aqRKKzK
	 C9qfFvv5w+QhMe58RNAjVr1Vl+glIEZ5cnPfXZ6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Hemminger <stephen@networkplumber.org>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.11 231/261] hv_netvsc: Fix VF namespace also in synthetic NIC NETDEV_REGISTER event
Date: Mon, 28 Oct 2024 07:26:13 +0100
Message-ID: <20241028062317.905185371@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2797,6 +2797,31 @@ static struct  hv_driver netvsc_drv = {
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
@@ -2809,6 +2834,11 @@ static int netvsc_netdev_event(struct no
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


