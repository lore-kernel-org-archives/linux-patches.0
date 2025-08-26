Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002CE319849;
	Tue, 26 Aug 2025 11:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756209000; cv=none; b=eHLw8jph/2cbYKelU7Z39+PhkZ6ASnYXxseUvibw570+XPFvonsz34NkW+m8fXr6GXhf3Y4cvg4REOnYgHUCwqjf/W/T4mrWT4JhOBKkJ/45lQ9fTARMVCpBoSNevbMrwd60g0+TUBb1A7LxujKhMk2JoFL3JtSwlIPFT4zoqHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756209000; c=relaxed/simple;
	bh=3Vgu/4zceyD0b95lI7bNjrNO700ArC5QrycOETaribc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ORdxwJZfS91FrGypcaoHfXM/fjjmhn3prIbgjZdSmdYOWR2AFbjs64EO5cn5ETZSRa8wIupLhOUsen+FX2rn3vVpNsuiabBJD2bNXwASgPhgdtO2yL+8hVczxCkUMsP31waDFUzBjS9EU75up9T0dUd87Dx3r9eRDiLgPnafNRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q/Pwy528; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q/Pwy528"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C9FAC4CEF1;
	Tue, 26 Aug 2025 11:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208999;
	bh=3Vgu/4zceyD0b95lI7bNjrNO700ArC5QrycOETaribc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q/Pwy5289YSqIAWCn8CCGSxNC9qfKZv4aKtFu5flSD9ofL/f+jVq4l66qbso09avd
	 SA3KYVAp3w1PDsTMD4/+FjFHUyng++QIHXAAGLbCqoG4Z4K64CaE5SZC0mKxmmeyHG
	 g3BWU34ApvrCiTml88PW0ZAd6WdZTD33WdZh5VTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 312/322] Octeontx2-af: Skip overlap check for SPI field
Date: Tue, 26 Aug 2025 13:12:07 +0200
Message-ID: <20250826110923.598662779@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit 8c5d95988c34f0aeba1f34cd5e4ba69494c90c5f ]

Octeontx2/CN10K silicon supports generating a 256-bit key per packet.
The specific fields to be extracted from a packet for key generation
are configurable via a Key Extraction (MKEX) Profile.

The AF driver scans the configured extraction profile to ensure that
fields from upper layers do not overwrite fields from lower layers in
the key.

Example Packet Field Layout:
LA: DMAC + SMAC
LB: VLAN
LC: IPv4/IPv6
LD: TCP/UDP

Valid MKEX Profile Configuration:

LA   -> DMAC   -> key_offset[0-5]
LC   -> SIP    -> key_offset[20-23]
LD   -> SPORT  -> key_offset[30-31]

Invalid MKEX profile configuration:

LA   -> DMAC   -> key_offset[0-5]
LC   -> SIP    -> key_offset[20-23]
LD   -> SPORT  -> key_offset[2-3]  // Overlaps with DMAC field

In another scenario, if the MKEX profile is configured to extract
the SPI field from both AH and ESP headers at the same key offset,
the driver rejecting this configuration. In a regular traffic,
ipsec packet will be having either AH(LD) or ESP (LE). This patch
relaxes the check for the same.

Fixes: 12aa0a3b93f3 ("octeontx2-af: Harden rule validation.")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Link: https://patch.msgid.link/20250820063919.1463518-1-hkelam@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index 150635de2bd5..0c484120be79 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -606,8 +606,8 @@ static void npc_set_features(struct rvu *rvu, int blkaddr, u8 intf)
 		if (!npc_check_field(rvu, blkaddr, NPC_LB, intf))
 			*features &= ~BIT_ULL(NPC_OUTER_VID);
 
-	/* Set SPI flag only if AH/ESP and IPSEC_SPI are in the key */
-	if (npc_check_field(rvu, blkaddr, NPC_IPSEC_SPI, intf) &&
+	/* Allow extracting SPI field from AH and ESP headers at same offset */
+	if (npc_is_field_present(rvu, NPC_IPSEC_SPI, intf) &&
 	    (*features & (BIT_ULL(NPC_IPPROTO_ESP) | BIT_ULL(NPC_IPPROTO_AH))))
 		*features |= BIT_ULL(NPC_IPSEC_SPI);
 
-- 
2.50.1



