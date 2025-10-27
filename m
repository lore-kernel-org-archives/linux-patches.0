Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA2631D377;
	Mon, 27 Oct 2025 18:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590579; cv=none; b=AFkDMFiiwGI4uhWq2EZbAKzH5T/LVMfKjkKAavpRmjcZMUQJuM3WtxWAs9nna71N/cupRzFpq9ggID5Vf61Gb+vRlZ145DfOghg7X6oSQa/djzv8ZT2zsDw2dPbXJzA+9lc8gun2kAl5UM5fXRInuSlDeaZrJ44xsdr8qXaCOEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590579; c=relaxed/simple;
	bh=TiZYc5FRCr3RYDjIRXE4HJmr4Ek7N8MFZH0ACMGcZSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BuJynSXhDaruZ4AU4gqsP5cjHjSrUGBuZ0QVJReVdYSsxqKLkiBmm0MGfUtKC/QuwH/HxjnaaFHP02jMgI8VcOHmJwcLN81d0KiHi543SKg6QP+6hDrT1rA1eLAIrzxYCi1ydYM0l6hERe2F9q0oLWD2W8mIR7P3bHiImd5VK5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LKHJvj6i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LKHJvj6i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DAB8C4CEFD;
	Mon, 27 Oct 2025 18:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590579;
	bh=TiZYc5FRCr3RYDjIRXE4HJmr4Ek7N8MFZH0ACMGcZSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LKHJvj6i717uDo/ZGbdFPhyd2ZkmDlJuuo/woYskYF1lYLL8Ci44FZ7AVPoJqaJ6w
	 vDYPySkwW2FoOdNeJtdYZncUU6VvQwtMToZCwCmMSBpU0/QLPMs9JFZEBhqk7H6ydx
	 6cAFMQxD1xj+lWz2qyQeTnjW2q0+jRS9HiSK0J3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Enju <enjuk@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 070/224] nfp: fix RSS hash key size when RSS is not supported
Date: Mon, 27 Oct 2025 19:33:36 +0100
Message-ID: <20251027183510.879030145@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index ff88103571819..6e1707ef391dd 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -914,7 +914,7 @@ static u32 nfp_net_get_rxfh_key_size(struct net_device *netdev)
 	struct nfp_net *nn = netdev_priv(netdev);
 
 	if (!(nn->cap & NFP_NET_CFG_CTRL_RSS_ANY))
-		return -EOPNOTSUPP;
+		return 0;
 
 	return nfp_net_rss_key_sz(nn);
 }
-- 
2.51.0



