Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72EC0446068;
	Thu, 30 Jul 2026 16:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427381; cv=none; b=DWqsDkqygcn+/0FxN0FdVDf6Re3lKkn56XpALw+KB/NXbrnwQ2m7i0KoNalpKSbfBnwHt+IsK3l3ZzpKEPdMeEBeBuniCCRUhoogfAGuBTSK7nBH2Rrcw338NdhuECKcEN8XGDQmapInbYMjlLzbh8xwMDc1f2tMf5a9HTARJVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427381; c=relaxed/simple;
	bh=VWPeh6QqMbEn1smoK5Ohsrzo8EdzxwflSoOe/tZLtF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MX/nGgaI9aM7U3nPeaJtlkGAVYz+VREK6MgkJgR0Slh8HWLViRts7xQPMwEsiwrzbaKAL+570zmPpP/RhSX3DStLgS7qhdagGv/zF0OSeKAE4sv1ykwa1zwNQENIXnyfSTL/KIHcl8byhiEC9fU33hT+00cwo1rlkv5qEM1U0i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FTL4VDqQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FTL4VDqQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E111F000E9;
	Thu, 30 Jul 2026 16:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427380;
	bh=QrpVNKkBaKVI8gH3NHCnryXyAxQ2EaOM0rqtufN7+Tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FTL4VDqQdl7ttg6+XAZw4NetB6u6u772QR/slKMDm6vOs6TsgQxvOOqanBD5t7tYM
	 ISvTIn2q2CXcj2ZzEL8djnKiFfKAY2n2u681ghJgickwxWaIWDDoHPrCUQGjBfVUzE
	 x8ZapEGEG5/HmWWyPQznCjya++Jkd6YhtvDpfA2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 150/484] dpaa2-eth: put MAC endpoint device on disconnect
Date: Thu, 30 Jul 2026 16:10:47 +0200
Message-ID: <20260730141426.722308249@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 61bd2389ef4b54..d77c22d1030a92 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4720,6 +4720,7 @@ static void dpaa2_eth_disconnect_mac(struct dpaa2_eth_priv *priv)
 		dpaa2_mac_disconnect(mac);
 
 	dpaa2_mac_close(mac);
+	put_device(&mac->mc_dev->dev);
 	kfree(mac);
 }
 
-- 
2.53.0



