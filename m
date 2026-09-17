Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2A64D4897;
	Thu, 17 Sep 2026 15:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658951; cv=none; b=tOJ/U1XvJbDNasuxYxrVZTdvZnvF4jkgrDRc17X/z26E9fJQ0sjagEBmz8U/ZuTw6QBuq8syEJSmpxjj2kjsadwj20/FMVdeE6zICgsK3VAmAEmk8zrg7vIjHp1uAYqABdOiJuzDn0+vjBW5dMkOPKCi0xA+E/Ii3cNoWC+BdU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658951; c=relaxed/simple;
	bh=A3DI6KydET+tGdPr2Ni7ipdSBdCyvrOsXVzJj2Tm5sk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LgHuS9f8ZYa98LC1/BdGqnZhe6l1UkNS+XBVK05TpQDnkOUJE0sDgyK5yQoFAvlpi/6PadfQGAasnZSBXor57UAr/grV0wM78nChHY7ZZEy0/SYoHLjICTd4T/B3EQvv6QKjrU7EAlTBofXy/04FmYK1TQC3CqIqRyJ0ayTsUeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TgeqK9Hw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TgeqK9Hw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE8FE1F00893;
	Thu, 17 Sep 2026 15:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658940;
	bh=tt2aiRlCGa01l2XWKAfosLLFWP2L8nBjSVDyF7wIM48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TgeqK9HwwKw40x3OvFA5W17jtjRAenHGbnvaWasAg18TlI3Gtjb8MdEp90eqrgTWq
	 TXzvwCiwQpalpMTfebnfBVrOmGOF0vJTPr38M42SkaAqwn1sI4dEbewCPLciD1GHVw
	 +SZiI+EadtxhEzDTF92wwNCbH6ilQLN11V7y4HEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran Kumar K <kirankumark@marvell.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 091/733] octeontx2-af: fix CN20K default MCAM rule removal on port cleanup
Date: Thu, 17 Sep 2026 16:06:39 +0100
Message-ID: <20260917151353.191154079@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kiran Kumar K <kirankumark@marvell.com>

[ Upstream commit 1376afc7660bad2a1a5ee0876898312a486cf8bd ]

npc_mcam_free_all_entries() disables every MCAM entry mapped to a
port before freeing it.  On CN20K, that also disables the default
broadcast, multicast, promiscuous, and unicast rules, which causes
packet drops when all rules are removed per port.

Only disable and free non-default entries.  Leave CN20K default rules
enabled when freeing the remaining port entries.

Fixes: 013717353c03 ("octeontx2-af: npc: cn20k: Tear down default MCAM rules explicitly on free")
Signed-off-by: Kiran Kumar K <kirankumark@marvell.com>
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 38554d51164e1..6f2e6bce164de 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -2957,10 +2957,9 @@ static void npc_mcam_free_all_entries(struct rvu *rvu, struct npc_mcam *mcam,
 			}
 		}
 
-		/* Disable the entry */
-		npc_enable_mcam_entry(rvu, mcam, blkaddr, index, false);
-
 		if (!cn20k_dft_rl) {
+			/* Disable the entry */
+			npc_enable_mcam_entry(rvu, mcam, blkaddr, index, false);
 			mcam->entry2pfvf_map[index] = NPC_MCAM_INVALID_MAP;
 			/* Free the entry in bitmap */
 			npc_mcam_clear_bit(mcam, index);
-- 
2.53.0



