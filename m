Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2214517BED0;
	Sat, 17 Oct 2026 17:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258648; cv=none; b=EzektaDromeYhjI8E3VT1RQgg/oRS0rENKiScnIe2trzM5WTa8wqtAHkIGK7oKML4Kl+sPTsSVO33/lBLkv9SpbfB+RR/q3awf690pOIuXpHfuS/cD3/BwK5rVxOkx+HhVmueFbopFG4VI3IwUpLhzpHrjPTK4N9hip4foIb2Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258648; c=relaxed/simple;
	bh=o85s+bHstggSZdL/h1r0NMLYvbv4G7/yt0nwzNUECjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hqhE6VfiLLYuNUI1UQb+rdstaUfn9tZ0ZXlSdz6SSAy83b4b9N1uKNE93wxImG5bfUrb0kF8ELP2MKPbH7CxQDp6+0YQWtm6U7UvkF1DDTX/5w4+x0VWRAj+gJEPWk1n23Oz2HYoC6FJax6cp9lnOoKnp3a/2xGVFBM9xU9TVp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sq05LhEr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sq05LhEr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 157DB1F000C4;
	Sat, 17 Oct 2026 17:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258646;
	bh=h3WWMFNk+sZTzSf5Xb39moOfQ9QAOfs4vdS7G1iu+s4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sq05LhEr7gEkWzUqbaSlurm8Jn17JomMSel4i6wnfq0LCocZcmjy6JPtw2hHKnuOl
	 93n0tuQYppVRIzP9LB3ov4mW2GVH4HtwJ6OVea9W19MsosGAGxda9Q+UJvage4//FC
	 TpLiNifcHFfPEYJE0cEzHAFlpUL5+YlmhIjnPsgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jie Zhang <jie.zhang@analog.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0953/1674] net: stmmac: fix oops when split header is enabled
Date: Sat, 17 Oct 2026 17:53:45 +0200
Message-ID: <20261017160455.589635475@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Jie Zhang <jzhang918@gmail.com>

[ Upstream commit babab1b42ed68877ef669a08384becf281ad2582 ]

For GMAC4, when split header is enabled, in some rare cases, the
hardware does not fill buf2 of the first descriptor with payload.
Thus we cannot assume buf2 is always fully filled if it is not
the last descriptor. Otherwise, the length of buf2 of the second
descriptor will be calculated wrong and cause an oops:

Unable to handle kernel paging request at virtual address ffff00019246bfc0
...
x2 : 0000000000000040 x1 : ffff00019246bfc0 x0 : ffff00009246c000
Call trace:
 dcache_inval_poc+0x28/0x58 (P)
 dma_direct_sync_single_for_cpu+0x38/0x6c
 __dma_sync_single_for_cpu+0x34/0x6c
 stmmac_napi_poll_rx+0x8f0/0xb60
 __napi_poll.constprop.0+0x30/0x144
 net_rx_action+0x160/0x274
 handle_softirqs+0x1b8/0x1fc
...

To fix this, the PL bit-field in RDES3 register is used for all
descriptors, whether it is the last descriptor or not.

Fixes: ec222003bd94 ("net: stmmac: Prepare to add Split Header support")
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Jie Zhang <jie.zhang@analog.com>
Link: https://patch.msgid.link/20260209225037.589130-1-jie.zhang@analog.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 20 ++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 435189e35b8ad..96d97b209af9c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4728,13 +4728,27 @@ static unsigned int stmmac_rx_buf2_len(struct stmmac_priv *priv,
 	if (!priv->sph)
 		return 0;
 
-	/* Not last descriptor */
-	if (status & rx_not_ls)
+	/* For GMAC4, when split header is enabled, in some rare cases, the
+	 * hardware does not fill buf2 of the first descriptor with payload.
+	 * Thus we cannot assume buf2 is always fully filled if it is not
+	 * the last descriptor. Otherwise, the length of buf2 of the second
+	 * descriptor will be calculated wrong and cause an oops.
+	 *
+	 * If this is the last descriptor, 'plen' is the length of the
+	 * received packet that was transferred to system memory.
+	 * Otherwise, it is the accumulated number of bytes that have been
+	 * transferred for the current packet.
+	 *
+	 * Thus 'plen - len' always gives the correct length of buf2.
+	 */
+
+	/* Not GMAC4 and not last descriptor */
+	if (!priv->plat->has_gmac4 && (status & rx_not_ls))
 		return priv->dma_conf.dma_buf_sz;
 
+	/* GMAC4 or last descriptor */
 	plen = stmmac_get_rx_frame_len(priv, p, coe);
 
-	/* Last descriptor */
 	return plen - len;
 }
 
-- 
2.53.0



