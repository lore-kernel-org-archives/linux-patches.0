Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5076C2D7810;
	Wed, 25 Feb 2026 06:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002736; cv=none; b=dcpMasrKN6hjbaSPXLt/m02mCAhojBph8zA0fgpbmnUQ6uG9EOxrQpmJLaFO62usBGSPtpyrxsKDpawYdD3wLkieaMdprHEya1jhzaivy0xB0YN6iz8W6HdT7hZd/K7kszx0tCsOIc5Kn7TtsSc4sU/yfG0Q3jQMy5xCvUyx4eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002736; c=relaxed/simple;
	bh=KCcoex6YoynWzFwX2C7cbtT9uDl0Wrdq1H1fkgaD/aM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TFDrm8mNNREsKkB2L4RI9eVJja4DrLES2jqoz3yvrf/4Fhmx6a180A2iPr1cGxANCwMbSqdg5Xtis2EzDdTS//GSk7/N2NBR0xyB9KYavdix5VadXtY+zb4unJUMaSoMhT0gKLg/tyLv/VrYvyNoKopOBZZwA2Sz63g72izbxl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sdUBrwky; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sdUBrwky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C78C116D0;
	Wed, 25 Feb 2026 06:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002736;
	bh=KCcoex6YoynWzFwX2C7cbtT9uDl0Wrdq1H1fkgaD/aM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sdUBrwkypXibZvZI8jfGNyesMwjDKC4ghUjHwEoTSMNSF/FafaPuwfnFSBp6OBwU6
	 gR13IIWIfK31Jx4NIZlaMiFY/zhSkzxsmxv7El3nB3ZMGumLka/cJLM9vedwyeAJqg
	 Hx6mA/bhKy+8KNjigkwiTBv5ZzP0vbpFK7AEOJzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Dimitri Daskalakis <dimitri.daskalakis1@gmail.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 551/641] eth: fbnic: Add validation for MTU changes
Date: Tue, 24 Feb 2026 17:24:37 -0800
Message-ID: <20260225012401.874930165@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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
index e95be0e7bd9e0..5cbf3ad175a54 100644
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



