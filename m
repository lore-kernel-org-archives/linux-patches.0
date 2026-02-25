Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5EE24A05D;
	Wed, 25 Feb 2026 01:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983532; cv=none; b=KtJXViFIadorW5P/+kRUARnUnokboAZ+q5RmbKTze9ao8oUVx2HfCHXuHAw/qug2mTeNbyUGkxQolzWGosQDWP0EX+RH+liaOW+/V9yMHmftsZdBsg5XsZaIDDGMG1qIac31WLhBHp2BAhDkKiiiWm+0lqR2/WQS7sAjsorlBew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983532; c=relaxed/simple;
	bh=XR1MlU3poWCxzKjplDEosTMCXMhKu8vAqKpP8ByZ9Pw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TxI9UVmzUBPF+eQsdPdVlAHh0POqJJy4Mn+REmBKZ6iSL5g1P6wxxISoyEKiBZ32GhEGPHZv/sd6f2FnVSewJQE1jCpdgsVCxnGM7lyrSc4SVwrX5EVRKPY4iHcbgn/pSBD8XDZwYG2N6QVfIrRtRkIRYGGGEpG3TF7I9zRXrcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mdOYE7lG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mdOYE7lG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D72BC116D0;
	Wed, 25 Feb 2026 01:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983532;
	bh=XR1MlU3poWCxzKjplDEosTMCXMhKu8vAqKpP8ByZ9Pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mdOYE7lGTJQ21gM3+DMJDfLtPOVpJ/ZA49MwJLVSsowR0veJPbFDF0qR+RB5OW7a0
	 G0RtuUo6PaHiWvJ45Ef5S++3JUNXpqtBszj+eyG3UErx2aTDLdzwI7MVK4uYJid/7P
	 xLmKvKt1YmDG0MMjbWVRX+cbkO5uNONjE9sfvVjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jie Zhang <jie.zhang@analog.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 638/781] net: stmmac: fix oops when split header is enabled
Date: Tue, 24 Feb 2026 17:22:27 -0800
Message-ID: <20260225012415.454315638@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index a379221b96a34..f98fd254315f6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5023,13 +5023,27 @@ static unsigned int stmmac_rx_buf2_len(struct stmmac_priv *priv,
 	if (!priv->sph_active)
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
+	if (priv->plat->core_type != DWMAC_CORE_GMAC4 && (status & rx_not_ls))
 		return priv->dma_conf.dma_buf_sz;
 
+	/* GMAC4 or last descriptor */
 	plen = stmmac_get_rx_frame_len(priv, p, coe);
 
-	/* Last descriptor */
 	return plen - len;
 }
 
-- 
2.51.0



