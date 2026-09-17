Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978A33B27D8;
	Thu, 17 Sep 2026 18:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668766; cv=none; b=RM382djgdkVD4Ty6GFQWb6p9vvB7s7bcJQNfhxtZncncfoUPsXIQivUHuVBzHfANDgGhZMddDlAUXGllE+twgEZrHJRAbxMa4EsRL/MrxLX0u+wtSg9zYPvYe0rKgzm5sLgEAuNU0VsbEL1EnwfcjiA73vkCI9LsXHQYwvo/tP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668766; c=relaxed/simple;
	bh=aaz7WZBChKAVLQeB+QJHkLuRDjHzi5iq5qF3bjAZqm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VqbJZwtXwVUd4sHpBIkK4i7PYNgFYNPl1Z7em1lR+WFNpDlkjxuJh2T/+/5ehQ34I0wHlXG1qpzOjiVDuO4wPiZd5XkO1I57IW4j07fDyFAmb8Zs5hpLm9ujXkFxIpm8RaBwMq4Ob3Kt6R9Rfs3NX0veyUadJkyA+brMfKP6zlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vCKjf0nh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vCKjf0nh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C651F000FF;
	Thu, 17 Sep 2026 18:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668765;
	bh=+akG3yiQEtHN/J7/mVW0Hf2iwgoHptGDTX+KmDDX2b0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vCKjf0nhqZjJDaiz0lzZs463YbVpnUEq0H0CWFKXqNBt8npex+RUW8OqxYFIoVvxd
	 TJpiUl6gW56Ec02WP75mvlpeImz4PcS+U6PKmiN7I39KaGG1pW/hb1XHMSEE8G7nrw
	 Rt0HeVf4tekCvGeX0SgFiSxM3+xnzUbvOs3dtdWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Nugraha <aslan.jnn@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0534/1102] net: amd-xgbe: discard rx packets with bad FCS
Date: Thu, 17 Sep 2026 16:07:57 +0100
Message-ID: <20260917151553.214459880@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: James Nugraha <aslan.jnn@gmail.com>

[ Upstream commit ac8d6b28d48c5d951dcd923d33e461588e762a6d ]

amd-xgbe driver currently sets the MAC_RCR.DCRCC bit whenever
RX is enabled. This disables hardware FCS validation, causing packets
with bad FCS to be accepted unconditionally.

This change unsets DCRCC so that packets with bad FCS will be dropped,
in-line with typical behaviours of many other network controllers.

Tests:
- Verified that packets with bad FCS are now dropped.
- Verified that receiving packets with bad FCS will increment the
  `rx_crc_errors` counter.

Fixes: c5aa9e3b8156 ("amd-xgbe: Initial AMD 10GbE platform driver")
Signed-off-by: James Nugraha <aslan.jnn@gmail.com>
Link: https://patch.msgid.link/20260827232220.69907-1-aslan.jnn@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-dev.c b/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
index f1b0fb02b3cd1..811c817a2efc7 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
@@ -3438,7 +3438,7 @@ static void xgbe_enable_rx(struct xgbe_prv_data *pdata)
 	XGMAC_IOWRITE(pdata, MAC_RQC0R, reg_val);
 
 	/* Enable MAC Rx */
-	XGMAC_IOWRITE_BITS(pdata, MAC_RCR, DCRCC, 1);
+	XGMAC_IOWRITE_BITS(pdata, MAC_RCR, DCRCC, 0);
 	XGMAC_IOWRITE_BITS(pdata, MAC_RCR, CST, 1);
 	XGMAC_IOWRITE_BITS(pdata, MAC_RCR, ACS, 1);
 	XGMAC_IOWRITE_BITS(pdata, MAC_RCR, RE, 1);
@@ -3449,7 +3449,6 @@ static void xgbe_disable_rx(struct xgbe_prv_data *pdata)
 	unsigned int i;
 
 	/* Disable MAC Rx */
-	XGMAC_IOWRITE_BITS(pdata, MAC_RCR, DCRCC, 0);
 	XGMAC_IOWRITE_BITS(pdata, MAC_RCR, CST, 0);
 	XGMAC_IOWRITE_BITS(pdata, MAC_RCR, ACS, 0);
 	XGMAC_IOWRITE_BITS(pdata, MAC_RCR, RE, 0);
-- 
2.53.0



