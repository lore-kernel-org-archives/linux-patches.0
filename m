Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86AF30ACF6;
	Mon, 13 Oct 2025 14:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367409; cv=none; b=XRz5cD+5Y6Nzyo3KIUjXZUrQreZ2AwtxFMYCgxDCq02OTUPK22ro96+YkiFhOF3WvO6oREFspRUAqq5WDEiXtJJTvIeczxKk5U4aMtd6VDMyZudPof5vd3jzcaV8QggmJyE4ZbdHys5SH8g5By5uNCB97plggwVYQFjocz3FG80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367409; c=relaxed/simple;
	bh=ynQfTQpppMfOdjERChb5buOrcBF+KI6y5Gu7lNKjVFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G3PdT92xOwFRJMo3j3HwQbFuBqC/dlM7/60yonnBe3MGaAZ1SLnS+wKn4y7/O8K4jW2NS5n5pm5Y6gAYMQRuYOZwCmZYOkokpU9pttY5ca5njG31O1MrUDUsIlPTIJeAxYWErUrTs9kMfjGXpb4xYFo8VdljJd8F9rKbSLATIl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ME6OnKQA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ME6OnKQA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76ECFC4CEE7;
	Mon, 13 Oct 2025 14:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367408;
	bh=ynQfTQpppMfOdjERChb5buOrcBF+KI6y5Gu7lNKjVFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ME6OnKQABQImct3QoFuX3Yur/ov/qPvrdd03RgasNaaawBeIV66rcncDkk2w8OI6V
	 1QYn1Cp8P2fLRMXChvWvfHdzy2NNtyMMjzygJYzBYrmylKaTqNKEa4fhGh/J4bW7Gj
	 Dp/a932i5hDCnjfmnGnGKepObbHG2BTEvaZNGWjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Enju <enjuk@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 165/196] nfp: fix RSS hash key size when RSS is not supported
Date: Mon, 13 Oct 2025 16:45:38 +0200
Message-ID: <20251013144320.667963234@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index af376b9000677..7ee919201985f 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -1409,7 +1409,7 @@ static u32 nfp_net_get_rxfh_key_size(struct net_device *netdev)
 	struct nfp_net *nn = netdev_priv(netdev);
 
 	if (!(nn->cap & NFP_NET_CFG_CTRL_RSS_ANY))
-		return -EOPNOTSUPP;
+		return 0;
 
 	return nfp_net_rss_key_sz(nn);
 }
-- 
2.51.0



