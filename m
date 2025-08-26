Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEDB63090E1;
	Tue, 26 Aug 2025 11:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208173; cv=none; b=VozRPto0lqVArCKLsFPhkTxpBe1CvYe/vMS2wVFkIbLNX9yNH1gMwzZK64ud/K3aeG/P2UxpPWID1GhdXyJ3xwAVOEtm97HD5LFauxxwwfXR23a+Ni49EslNvDYxkmMwwCQywWnqRb9O2D7BZ0FpDcpGpGsSyXD41XtQmG65WaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208173; c=relaxed/simple;
	bh=P2E8mxXKmL/zLHvA5axU9XtaC7GW3eYXV4wrVxc/K6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HlFLlqs646Cq6DLJuIZFw6RUS5BWRcCfVEWnbgsBS6JJPPX0L6JytTLIoGHAsid33hOvE9VeD24R5BtTeq2GuG1j7+p26eq+IGbRIl7ADUmI5yCAQTESPPUSuhGDbzRolzP99s9T45U+mI0mHDb/Quz6Mj5PnKp6vJWDjmfMxbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xN2AwFPo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xN2AwFPo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A914C4CEF1;
	Tue, 26 Aug 2025 11:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208173;
	bh=P2E8mxXKmL/zLHvA5axU9XtaC7GW3eYXV4wrVxc/K6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xN2AwFPo5IW74DqMaATS4TxKclJOdc9mhOd1slGRpuasMq9VNRODRiFFyWoTrlECi
	 ghcvnvqxok4D7Nspq++6355ikCRXHvvgdAP85h2GO2/nhW7UUbRVsn8JDkv6taUpFB
	 Os4YAwBYEmuVVhUWWZzwQ/vB3w9GMDJODQoLENtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 447/457] Octeontx2-af: Skip overlap check for SPI field
Date: Tue, 26 Aug 2025 13:12:11 +0200
Message-ID: <20250826110948.333385254@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 1b765045aa63..b56395ac5a74 100644
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



