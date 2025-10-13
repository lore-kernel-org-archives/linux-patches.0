Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED0130F928;
	Mon, 13 Oct 2025 15:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367864; cv=none; b=KfIysyhO3hnscMZLwr5pYmSM8w0iFYQCGZrCwB1brgqvX4+uCsj90EO5K/ptErfnfMWpRg95TRSzjTOCa1jkT2NZxnSL4L1UmSsODXslcOnKhM1bxQ2GNacLY8OMSWrqLwOxp30waAoJ7/4ZBdrWirP5wbeHTi4lyUugs3C6CnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367864; c=relaxed/simple;
	bh=xeumYXNmw8DpOFXH3G27ju8KQ7Jat/QBAyZLvZe0Nds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mgMKZrUVxS0knqrIQvJpZONDStx9CmWB+aqwtQTFYJwuN3pW+fcmBV3+JDFogWxTbzIzNOlcW0VH8BoA7pIQ0dneip2jhCH2KPaU6UPYJ/TtVXDlhjnVsIKQmk9Z7CjGed6/lataMuofTxZC2UAqYkGYsBAMnOtpo4lChXFNxsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v3le9NN9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v3le9NN9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D96A1C4CEFE;
	Mon, 13 Oct 2025 15:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367864;
	bh=xeumYXNmw8DpOFXH3G27ju8KQ7Jat/QBAyZLvZe0Nds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v3le9NN9QQthoJpX++98C3ek6vKprldPki90q+YkSmaxrZjlHPQzNXLPwlyPfZPQH
	 H1Bq9FN+z1b0I0+rg2OdcjxwCZlYrnAo/ka3g8F2iY+g1Cg3/hpko5B/wbnR/eVc2D
	 RWDsDrf3hXNqos6RvdvjM1cYfohLwK0bypIAmi0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Enju <enjuk@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 159/196] nfp: fix RSS hash key size when RSS is not supported
Date: Mon, 13 Oct 2025 16:45:50 +0200
Message-ID: <20251013144321.063485781@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

From: Kohei Enju <enjuk@amazon.com>

[ Upstream commit 8425161ac1204d2185e0a10f5ae652bae75d2451 ]

The nfp_net_get_rxfh_key_size() function returns -EOPNOTSUPP when
devices don't support RSS, and callers treat the negative value as a
large positive value since the return type is u32.

Return 0 when devices don't support RSS, aligning with the ethtool
interface .get_rxfh_key_size() that requires returning 0 in such cases.

Fixes: 9ff304bfaf58 ("nfp: add support for reporting CRC32 hash function")
Signed-off-by: Kohei Enju <enjuk@amazon.com>
Link: https://patch.msgid.link/20250929054230.68120-1-enjuk@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index e75cbb287625f..87383f9d09ce3 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -1413,7 +1413,7 @@ static u32 nfp_net_get_rxfh_key_size(struct net_device *netdev)
 	struct nfp_net *nn = netdev_priv(netdev);
 
 	if (!(nn->cap & NFP_NET_CFG_CTRL_RSS_ANY))
-		return -EOPNOTSUPP;
+		return 0;
 
 	return nfp_net_rss_key_sz(nn);
 }
-- 
2.51.0



