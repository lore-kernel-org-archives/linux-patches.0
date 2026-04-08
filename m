Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A1732A3FD;
	Wed,  8 Apr 2026 18:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673702; cv=none; b=E8a+g13D7f9XNPz7++90appKQ/zdldc9idT6xlzT3LCbmqIDQpBVZS1XM8R2YCFSm21+FS2QaKcE0WUjJlxXzRZjT+0BYv9F8TBrxmt3ogPiT01kSYWf3NnhS2kyjaaVxYAIGR4Yt2EzKu51bRIzQMDCZIjnJvEzolGfYGO/77E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673702; c=relaxed/simple;
	bh=UXqbeUKFOTNhVU7iD9BQ62evjbtMScdPj9pnXD5Et+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nwzlgpnKH+Q3udRHnEXApzjU62r/pSaSDPMlE5VFoNQrDxbte46fVgrSTOhOC1VT5+v0qjI5YNqEgpHU0ibvFfgfuw/OjrGliXhDGiyJQGyaZxCTtbNJhPwkvjboWJvfm0SzKMKDQ76wftsZQqTmNnb4fZw96CYwjmf7op1rMoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2iggNEXE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2iggNEXE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C97C2BCB2;
	Wed,  8 Apr 2026 18:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673701;
	bh=UXqbeUKFOTNhVU7iD9BQ62evjbtMScdPj9pnXD5Et+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2iggNEXEOUaYlExiYXwwVoAS8PJEZOrWOrjQ0LfSq5JPOnZsFcd3AXhcVj9fq7Fcs
	 m7Rt/6hmYlQ9sDFSiKT44Dg/ozrP7ZH3+rCJK1/zQabF3x2IIZKXFm6nA7cWSuti96
	 WfOU5zzuEvjmBfXnWgp8yqHwK/2J03ovn5JM0oeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Clark Wang <xiaoning.wang@nxp.com>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 056/242] net: enetc: check whether the RSS algorithm is Toeplitz
Date: Wed,  8 Apr 2026 20:01:36 +0200
Message-ID: <20260408175929.174690672@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit d389954a6cae7bf76b7b082ac3511d177b77ef2d ]

Both ENETC v1 and v4 only provide Toeplitz RSS support. This patch adds
a validation check to reject attempts to configure other RSS algorithms,
avoiding misleading configuration options for users.

Fixes: d382563f541b ("enetc: Add RFS and RSS support")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Clark Wang <xiaoning.wang@nxp.com>
Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Link: https://patch.msgid.link/20260326075233.3628047-2-wei.fang@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc_ethtool.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index 7ec6e4a54b8ec..0aac39e2acab1 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -731,6 +731,10 @@ static int enetc_set_rxfh(struct net_device *ndev,
 	struct enetc_hw *hw = &priv->si->hw;
 	int err = 0;
 
+	if (rxfh->hfunc != ETH_RSS_HASH_NO_CHANGE &&
+	    rxfh->hfunc != ETH_RSS_HASH_TOP)
+		return -EOPNOTSUPP;
+
 	/* set hash key, if PF */
 	if (rxfh->key && hw->port)
 		enetc_set_rss_key(hw, rxfh->key);
-- 
2.53.0



