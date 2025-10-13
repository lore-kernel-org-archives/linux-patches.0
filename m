Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A5930DED7;
	Mon, 13 Oct 2025 15:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370083; cv=none; b=gDxZQujdEt/S1LGpIdKQLWgjyHZ3b4eaVI7O4xEkjbirY831l5VClIMhkCXkNfUQQLt3owmqtL6M3jcYDYq9jk6h12ni1Jhu1JF4KSSb94J17ILQHrAPRYg9AVbrP5jYvK4LakWL+FM4fqptOHYijYVESgtxsxYNhwgl0YBcN+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370083; c=relaxed/simple;
	bh=IjUWwrHdj2qPE9WWEIziR9Br9HuIhZvhVK3z3m6+DMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b4RXNsfCavb9eCguYkSwcvQsvl8klL+9G3zQNQEMJ7Y9uH5/sDmC16q7FSyPNTnyB+QIJyDEM/xWheKBpd1yt7/DGu7w1ClDloCtuB3eULOEvgeupUtilXInBeLn4rhUBdQq8GGntQXNZDo2M+c50Qc6HHf58Zm7KTrwwrNfTtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FNKupo4w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FNKupo4w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450F5C4CEE7;
	Mon, 13 Oct 2025 15:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370083;
	bh=IjUWwrHdj2qPE9WWEIziR9Br9HuIhZvhVK3z3m6+DMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FNKupo4wksaLyGf0cREmlvKYxiJOL0ulYGN58paz4RbMKe8Tk6wGu4fZsy9juWzYf
	 PZQGX7CtGVwbfpYlWMQvedLOXkcQ23XvF/R8fPWHyswf1BBgpZs+JytQmdj22Ju1ih
	 DXhwOXdgutnoU9RcoltCMDNdZAjf9nx7hjk1+GxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Enju <enjuk@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 472/563] nfp: fix RSS hash key size when RSS is not supported
Date: Mon, 13 Oct 2025 16:45:33 +0200
Message-ID: <20251013144428.389509138@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index a36215195923c..16c828dd5c1a3 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -1788,7 +1788,7 @@ static u32 nfp_net_get_rxfh_key_size(struct net_device *netdev)
 	struct nfp_net *nn = netdev_priv(netdev);
 
 	if (!(nn->cap & NFP_NET_CFG_CTRL_RSS_ANY))
-		return -EOPNOTSUPP;
+		return 0;
 
 	return nfp_net_rss_key_sz(nn);
 }
-- 
2.51.0



