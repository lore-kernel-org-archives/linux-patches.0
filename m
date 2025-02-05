Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C711C6BE;
	Wed,  5 Feb 2025 15:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768349; cv=none; b=jEYbTH16sg4Ir6t1dnvVAgnSzXms2jsCXwFULHjkkhHfQ6WX7o5vOWek1Uphyc0AdZZoPt3STxKaGu6Wlgcic0iGRAiTM+EH/c1o0Ez8F/XbgyjVSrf2Xm1FYn5CRbmsSFdVsVx6S9LjDdYzXhp4ZsqpWabnPNRDpKgZWjcUszI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768349; c=relaxed/simple;
	bh=D+hhcKfMGQ6eldCvIr47CaSGetVZG4eqNpWZ5KqYKoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YwqYW5SMovLTRfYIqaDOlvRaQl4kbJWzQDGqad371lRLyE3slDqv4+7X+uzn28jL6YVgyXy1Ob3FxCKiSqXJKI/1z4dsAtyqbCNhKLEGD05vKVT+XxtjG7cGbWmlbPRJsZUAJlgw3JXJnDq1U16VhlV0SGiwxAWLnin2sXgjeaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mFxsbNl4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mFxsbNl4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A60C4CED1;
	Wed,  5 Feb 2025 15:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768349;
	bh=D+hhcKfMGQ6eldCvIr47CaSGetVZG4eqNpWZ5KqYKoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mFxsbNl4TmsD3xLPVX0FwSvMJUOUEby+QrvrzbJiUQFWNht3kQXDRMIP3d7fvdUx9
	 pD+PbYCswAqpPa+DXbAgW9Q804DoazRWFKb1DWTcZMsZM0C40x5EjBUM69RCzCKjrw
	 26hdpjaIY9vdB53TpViN+ugpGN6PzHkWyKa5v+gY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmed Zaki <ahmed.zaki@intel.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Gal Pressman <gal@nvidia.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Edward Cree <ecree.xilinx@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 534/623] ethtool: Fix set RXNFC command with symmetric RSS hash
Date: Wed,  5 Feb 2025 14:44:36 +0100
Message-ID: <20250205134516.654282984@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit 4f5a52adeb1ad675ca33f1e1eacd9c0bbaf393d4 ]

The sanity check that both source and destination are set when symmetric
RSS hash is requested is only relevant for ETHTOOL_SRXFH (rx-flow-hash),
it should not be performed on any other commands (e.g.
ETHTOOL_SRXCLSRLINS/ETHTOOL_SRXCLSRLDEL).

This resolves accessing uninitialized 'info.data' field, and fixes false
errors in rule insertion:
  # ethtool --config-ntuple eth2 flow-type ip4 dst-ip 255.255.255.255 action -1 loc 0
  rmgr: Cannot insert RX class rule: Invalid argument
  Cannot insert classification rule

Fixes: 13e59344fb9d ("net: ethtool: add support for symmetric-xor RSS hash")
Cc: Ahmed Zaki <ahmed.zaki@intel.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Edward Cree <ecree.xilinx@gmail.com>
Reviewed-by: Ahmed Zaki <ahmed.zaki@intel.com>
Link: https://patch.msgid.link/20250126191845.316589-1-gal@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 7bb94875a7ec8..34bee42e12470 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -998,7 +998,7 @@ static noinline_for_stack int ethtool_set_rxnfc(struct net_device *dev,
 	    ethtool_get_flow_spec_ring(info.fs.ring_cookie))
 		return -EINVAL;
 
-	if (ops->get_rxfh) {
+	if (cmd == ETHTOOL_SRXFH && ops->get_rxfh) {
 		struct ethtool_rxfh_param rxfh = {};
 
 		rc = ops->get_rxfh(dev, &rxfh);
-- 
2.39.5



