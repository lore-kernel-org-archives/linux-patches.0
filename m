Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24BA141B8C6;
	Sat, 12 Sep 2026 15:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225767; cv=none; b=f22/Bv0zx+q7Qb7wkIk1gy2qBxC1C6uP/YlNLu7HdojdLeabCvGUPvwrKv34KPVG0epAVLc/EW5dLzjPQqx0GdWaCitVo1DqOXri4LFUdnHLliaqLbYmw/6Af2lvkHVA/NqfJU8BUZUFBaCMPCLykX4oV1FWRLyInZXGqHPZbQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225767; c=relaxed/simple;
	bh=QtJM7tGB7Ly8IvJ5e5oUAenPMWErFS027g5sJ+1wQLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=APSm5kIy5ZIpq8Eclilu2uVphOZUOZh/Ch9Y/BDk6crCzT1u4REk636Ru7RNVvC1ewS2bQt1di5oSQsoSvyOPqyD4ZZsmvJU+yeN1lusZm6Z/bQ1VSFarTHtDfb/YaGyegA77q/UFNihACvWXyF15jo9FcMwgSNtozRPrER8/Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lzGYZZDL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lzGYZZDL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F018E1F000FF;
	Sat, 12 Sep 2026 15:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225763;
	bh=jODLMbjp7ZX+QH8ejHWuCnCr4RwKAOaF1PDN+cbKzG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lzGYZZDLRp4bYPOJ8P93DE70lEjxVQBIpo66OVWHGjqry6PN1+sc/3FrmeleaCfly
	 ArFywZKlT9VCFNVYPLhi15oHUziuCDhAfw5TUS6yYZs5fGq6irUL/DHTlX+GPakyua
	 Mpar64/Vx1BToMpGP5j2in4fsjgdApFxD3h1Z+a4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1263/1424] octeontx2-af: initialize lmac_bmap in rvu_mcs_set_lmac_bmap()
Date: Sat, 12 Sep 2026 09:01:35 +0200
Message-ID: <20260912065635.565225678@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 4b92a3710d4a1d850ed6421c773e735cdca69b07 ]

rvu_mcs_set_lmac_bmap() declares lmac_bmap without initializing it and
only sets bits for valid lmacs with set_bit(), which ORs into the word
without clearing it first. Bits for invalid or skipped ports keep
whatever was on the stack, and the garbage is stored into
mcs->hw->lmac_bmap.

Initialize lmac_bmap to 0 so only valid lmacs are marked.

Found with Clang's -Wconditional-uninitialized.

Fixes: ca7f49ff8846 ("octeontx2-af: cn10k: Introduce driver for macsec block.")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Ratheesh Kannoth <rkannoth@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260812060730.6181-1-kmehltretter@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c b/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
index d39d86e694ccf..006d3258fd4e6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
@@ -854,7 +854,7 @@ int rvu_mbox_handler_mcs_ctrl_pkt_rule_write(struct rvu *rvu,
 static void rvu_mcs_set_lmac_bmap(struct rvu *rvu)
 {
 	struct mcs *mcs = mcs_get_pdata(0);
-	unsigned long lmac_bmap;
+	unsigned long lmac_bmap = 0;
 	int cgx, lmac, port;
 
 	for (port = 0; port < mcs->hw->lmac_cnt; port++) {
-- 
2.53.0



