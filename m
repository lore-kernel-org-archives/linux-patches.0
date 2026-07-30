Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9635042E8C9;
	Thu, 30 Jul 2026 14:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421850; cv=none; b=pheEEKVXyVGTeNfq8ZsQqziADANxdoND+Kkpws03uV+3Dl6acUguVXGGBENIFHrKoStAbDVeSC6ucRjnkwBhyv8EZdBlJ1UnGfXjQLO4+EmvCHK2taTGJYuRB96VlTgRgeUo86iCOU6it9GEqNKDH+4B/LNz5ZRE9+hCGVfvye0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421850; c=relaxed/simple;
	bh=vrNsN32Cp/yEYxCUxK0g8kOqHBgPUFXZ7kn5kOvM248=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k4IsZ97eTxt6dGQaGhGeuHVd33qlNALKnxHq1pJ3jE3dAhjnQDr2aO/edYzRZHWSmR09llknQz8XreKB4JGV5QVJnNb2eK4041ICc18W1jO4VZ3vfL7r2qVDLGIZ5I/FIJkkohnfae9nBad4vI2bJDy+htkLtbxqsSdTwGffsYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UkkGvvCh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UkkGvvCh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86491F000E9;
	Thu, 30 Jul 2026 14:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421849;
	bh=0zIldc+Kq5m8R+MhXXP/uNlOjgtTMv7NTsgO3ajnMRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UkkGvvChUp6lk/WYsmA8pHBAtHDT1M8bZPB+WvyQnCeg2/2p1271xXquRbLDumFtC
	 bo/c37ha2YdSFgw2AxfrfceHA9Ocy6dZzmegT56R4/dg9sqquzxBj3X5CUPC8z0wzR
	 bep6kIbDnI3E20NdYIwjEpc0muEjq/G8dZ4wz/pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 241/744] dpaa2-eth: put MAC endpoint device on disconnect
Date: Thu, 30 Jul 2026 16:08:34 +0200
Message-ID: <20260730141449.415517013@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9335703768a9b6..764d2a09668f56 100644
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



