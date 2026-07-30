Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A66372ECB;
	Thu, 30 Jul 2026 15:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424051; cv=none; b=jc4jGfgPtrkCsfiPYi529E2pjZOVltcrKZ8UcGY+Uq+X+fn0EOnvLJqQRBwsxtnAub6sP5wXe2c7huinf+tOTOITtd+rDsnreMVcxaVGlvToI93OkKWpkO53tT4qS4AEosgkM8OwC4XDntgwgWBPNepCMQAJVrx+2vp2LizVRis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424051; c=relaxed/simple;
	bh=LvGn8mwYxF04ivZWkmGvIXtOHdUQuB0l4LNZBSJeK3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FvpNF4qdf0FvDzqmHu/Ch1JhdNMPJT6+D7oHhFu7lxbfDP06KnbVLmVTbsDD8H6M+Ko+vJnE8KTdfR9z8UZ0RabzXD4apRVg+tJ2Q+4xN++9oF4tnqzgape/vIs+4HCRiclcOPb8JJ071t6qRxXr2S890VVDHBscSxmin88pi1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kBWRB9H9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kBWRB9H9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF8E91F000E9;
	Thu, 30 Jul 2026 15:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424050;
	bh=weHtbOpzwsetFc2HyyK1kEG4czAx9KHJXgidNYFodaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kBWRB9H9OPMOg8v4T8cvfWAiaBhI70R2pwqK4FwT9WhPPyyU2PL5Z5+xU9pu0WlB9
	 EfS+SKHhRH4TgO28BsjacgN9251KX71rWFSQ67bCdnSkZpDFIvPnqZwjLFNil1/riO
	 zCPqWqWPLRb1psSqmF89nvPdbbuiHYM9G6OCWIXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 221/675] dpaa2-eth: put MAC endpoint device on disconnect
Date: Thu, 30 Jul 2026 16:09:11 +0200
Message-ID: <20260730141449.839637463@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit b4b201cc93ff70150853aba03e14d314d1980ca0 ]

fsl_mc_get_endpoint() returns the MAC endpoint device with a reference
taken through device_find_child(). The Ethernet connect path stores that
device in mac->mc_dev and keeps it for the lifetime of the connected MAC
object.

However, the disconnect path only disconnects and closes the MAC before
freeing the dpaa2_mac object. It does not drop the endpoint device
reference stored in mac->mc_dev, so every successful connect leaks that
device reference when the MAC is later disconnected.

Drop the endpoint device reference after closing the MAC and before
freeing the dpaa2_mac object.

Fixes: 719479230893 ("dpaa2-eth: add MAC/PHY support through phylink")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://patch.msgid.link/20260708111738.750391-1-lgs201920130244@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 18d86badd6ea73..6fd478572ef8ff 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4732,6 +4732,7 @@ static void dpaa2_eth_disconnect_mac(struct dpaa2_eth_priv *priv)
 		dpaa2_mac_disconnect(mac);
 
 	dpaa2_mac_close(mac);
+	put_device(&mac->mc_dev->dev);
 	kfree(mac);
 }
 
-- 
2.53.0



