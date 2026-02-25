Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FFA31D5141;
	Wed, 25 Feb 2026 01:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983576; cv=none; b=OyIo1+cIB+J9yjUVWuk/xMqL1D0FeLl7nZWRQfBYmGdR8Bfjwskwd8mWQGEz2/X43jUFJ4MT5Zv+b+q4aDapXqN7lZzo/hNbABWsNn5a0B/Ss6CrmN3BXzwy2FNQncVqs3y1XydEi9ZrCACNuCdk8ICJkvJJHvJxLF/45dEX5wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983576; c=relaxed/simple;
	bh=yrZzVO85BeTYbQzaXUl4hBVJIwNG4l+14dNJZh82IJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ex+QCWFkn/v3Emey6t/BdEkPw2GDx/IDtK42IhAqlrXBGn0WC+axOWYGgMcBxiinYU+4P/Xwyxqo3ojnvUMHhILirhWhvTC1raT2yekgkRSXBvFu9naNfs5y3LMM2DIj8N9E8TfJ5snpxLg6WYgGt+rXI52wYQh9H+No0V2EnzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TaLuEo3W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TaLuEo3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46573C116D0;
	Wed, 25 Feb 2026 01:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983576;
	bh=yrZzVO85BeTYbQzaXUl4hBVJIwNG4l+14dNJZh82IJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TaLuEo3W18javHSOLiFjfuDN3pYhtJq0XyEkoysKhNGczaw1ekRxozavZUHVNl8PN
	 vW0u3DQfmi9tqyZG+fdGMBAiDpP54q1T5OGcpR8o8BMcBCdiquajc/uejix+vNHxN1
	 fDgnbFf+FJ/AeW193kcPffkBeZRlPHrCdisjAXWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Dimitri Daskalakis <dimitri.daskalakis1@gmail.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 677/781] eth: fbnic: Add validation for MTU changes
Date: Tue, 24 Feb 2026 17:23:06 -0800
Message-ID: <20260225012416.384277539@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dimitri Daskalakis <dimitri.daskalakis1@gmail.com>

[ Upstream commit ccd8e87748ad083047d6c8544c5809b7f96cc8df ]

Increasing the MTU beyond the HDS threshold causes the hardware to
fragment packets across multiple buffers. If a single-buffer XDP program
is attached, the driver will drop all multi-frag frames. While we can't
prevent a remote sender from sending non-TCP packets larger than the MTU,
this will prevent users from inadvertently breaking new TCP streams.

Traditionally, drivers supported XDP with MTU less than 4Kb
(packet per page). Fbnic currently prevents attaching XDP when MTU is too high.
But it does not prevent increasing MTU after XDP is attached.

Fixes: 1b0a3950dbd4 ("eth: fbnic: Add XDP pass, drop, abort support")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Dimitri Daskalakis <dimitri.daskalakis1@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_netdev.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c b/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c
index 81c9d5c9a4b2c..e3ca5fcfabef3 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c
@@ -262,6 +262,23 @@ static int fbnic_set_mac(struct net_device *netdev, void *p)
 	return 0;
 }
 
+static int fbnic_change_mtu(struct net_device *dev, int new_mtu)
+{
+	struct fbnic_net *fbn = netdev_priv(dev);
+
+	if (fbnic_check_split_frames(fbn->xdp_prog, new_mtu, fbn->hds_thresh)) {
+		dev_err(&dev->dev,
+			"MTU %d is larger than HDS threshold %d in XDP mode\n",
+			new_mtu, fbn->hds_thresh);
+
+		return -EINVAL;
+	}
+
+	WRITE_ONCE(dev->mtu, new_mtu);
+
+	return 0;
+}
+
 void fbnic_clear_rx_mode(struct fbnic_dev *fbd)
 {
 	struct net_device *netdev = fbd->netdev;
@@ -533,6 +550,7 @@ static const struct net_device_ops fbnic_netdev_ops = {
 	.ndo_start_xmit		= fbnic_xmit_frame,
 	.ndo_features_check	= fbnic_features_check,
 	.ndo_set_mac_address	= fbnic_set_mac,
+	.ndo_change_mtu		= fbnic_change_mtu,
 	.ndo_set_rx_mode	= fbnic_set_rx_mode,
 	.ndo_get_stats64	= fbnic_get_stats64,
 	.ndo_bpf		= fbnic_bpf,
-- 
2.51.0



