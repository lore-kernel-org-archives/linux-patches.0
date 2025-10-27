Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04EC327A47F;
	Mon, 27 Oct 2025 18:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591143; cv=none; b=pgLcLanqP8h0Ql9O5je9L2zH/Zv3X7es2htq1sA2DK1p1bVeazoyjKxDxtKu3DRNas+JiwyYUf7Zy6oVdQTV/Go3kgy8FW7I3wa2HOyB2SoBSS7GFxr5dJ5/D/FpxBAwrGXBidgOoDOj02h3DRRhE15WshcUJfNu37Cvt9vohkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591143; c=relaxed/simple;
	bh=FoQb3CsHKVaq3g1EJpe/c0+NoGUrb/pR/1MeIRY6uCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cxzTCTy3a5TbGQKWtzXOtM0ijfiRJjeH1axDDwuf+la3eumAGCqFq5UMqInz2t1Z1/L8lmHhT6CpQOz+ZtPOkqUp2VCJVLx01Zy1B+yjUmStO0tHVWpJ+bhb5JTBWwhyuskMv6c/rFlzfNJwgzzMzaXmqtb6ilbk+IG02QNb014=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2kpAh50M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2kpAh50M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4D0C4CEF1;
	Mon, 27 Oct 2025 18:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591142;
	bh=FoQb3CsHKVaq3g1EJpe/c0+NoGUrb/pR/1MeIRY6uCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2kpAh50MDvmdoh5NUfULMueOj2HvAg+5pny6sSGF5zxvFDAC8eGu/pESSqzheqi/6
	 aOObsFnirMLVGhtj8LQ/AOXjIs5TeDcSKKD3B07yyS50s2tAOgO0jSaw8V7vERJz7i
	 ZFl7mtWYnTWMjw9ZYkMPPu6Kpd9QBdtroLrHUPm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Enju <enjuk@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 084/332] nfp: fix RSS hash key size when RSS is not supported
Date: Mon, 27 Oct 2025 19:32:17 +0100
Message-ID: <20251027183526.839040041@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 311873ff57e33..3ffaa487be947 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -1012,7 +1012,7 @@ static u32 nfp_net_get_rxfh_key_size(struct net_device *netdev)
 	struct nfp_net *nn = netdev_priv(netdev);
 
 	if (!(nn->cap & NFP_NET_CFG_CTRL_RSS_ANY))
-		return -EOPNOTSUPP;
+		return 0;
 
 	return nfp_net_rss_key_sz(nn);
 }
-- 
2.51.0



