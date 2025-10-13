Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3A0313536;
	Mon, 13 Oct 2025 15:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368687; cv=none; b=CAaiAlYrsV0Rj9yePsJC57mbIAWonDw3rNo3vZLoMJvoGwqdyeP+vJiBGYnbOupZ2518aAiGPnRcTzMbl+lBUkPUQnk2/tSQ0AACj1D6PeKt/Dg37uPhJQkFspCtLsHQChzjO2BZCNQGutXJDFLKjqyH5G9mKp5548pdJdwdyVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368687; c=relaxed/simple;
	bh=I/BT/54XkTh3ScBCx9ujDJBgbR74HE0Ii7Dj4T4sU2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uUv+1Gy/zdbRL/oYf3UnDVoF+SSjFs2ChtYbTQepOXncCuiSOEakrQgRNLPwL1EqHISeb4hc/jrU4UvUrOX0hICi9gokETUHJ0TpR3r87JjUhO/hV1eKLzNfO624ZDoJ22t/YDkLQBW3qB4st1Qxe596dmrhSQxiWQ4rxbvvZlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x/o0Q2pP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x/o0Q2pP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 578BEC4CEE7;
	Mon, 13 Oct 2025 15:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368686;
	bh=I/BT/54XkTh3ScBCx9ujDJBgbR74HE0Ii7Dj4T4sU2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x/o0Q2pPr/TOiglytfc3R1Tv03qdDU4n0udFwMNIkdKWBPZXmnQ3IWXLbNOITOPoU
	 d8ZN3Ihdj0EzmafVUjk7Km0zyCnEX0fZI9gExDJaVLxIhfZx5gpnVc2T6SfsHU3i7z
	 Am3PP2hygrksWkQuGE9jkkFlSRhOYUGAi94lBOJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Enju <enjuk@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 214/262] nfp: fix RSS hash key size when RSS is not supported
Date: Mon, 13 Oct 2025 16:45:56 +0200
Message-ID: <20251013144333.952441228@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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
index fbca8d0efd858..37a46596268a0 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -1789,7 +1789,7 @@ static u32 nfp_net_get_rxfh_key_size(struct net_device *netdev)
 	struct nfp_net *nn = netdev_priv(netdev);
 
 	if (!(nn->cap & NFP_NET_CFG_CTRL_RSS_ANY))
-		return -EOPNOTSUPP;
+		return 0;
 
 	return nfp_net_rss_key_sz(nn);
 }
-- 
2.51.0



