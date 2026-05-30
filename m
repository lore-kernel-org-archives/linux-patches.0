Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC693BE620;
	Sat, 30 May 2026 17:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162617; cv=none; b=Dt+VG8ADL04nLM9LyoOSLfYVCtp3QQ2ZsDX+/6P/XircSCFSElEP5wvetXWxCNxFdwOuOVw6lsg4g3QwfvEu/hTa+uMeQQU0d+6yk/HEX7kAo55nhtzi2/XoOVXjdSG1JKawUtflsLIbKCTaENs83hn3bZIxQU5PRrj3dZ+RYx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162617; c=relaxed/simple;
	bh=n/CLvyBcoRQj9BVRtQCnd0rI4/IAlofPystjFoEz8VU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dkuL0EgtNICktBRE7fsWyJdF/KjUxAK8CbWSOuitvRGY8eOKTWnSSOPYRz4kh+Gxx4invEKKT74+NgwL8Sce3r+QrMUCICzDSKQYSMxyN4xsokUHS8gig2di0sjaSFPcED4qZV9nRelmEdQASuNPCuFJVViMrRgscne11b/CA08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jWzup/Dg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jWzup/Dg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE891F00899;
	Sat, 30 May 2026 17:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162616;
	bh=LD+SY7y91lWYPJ0Qf1E0wCr4PoxoSXeG92UTo6r84TQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jWzup/DgQzkY0T5Dq2et+3PqW6leddgJx2V1vsebDKVmlukyA0/FzYURcDnzKrqgK
	 FmWD3UV/WAix+Ejdsg+17wWo9t3qVSOT2bQe4p6OkOs+hTY+N/7eIc4uL3qB/oDaM+
	 we2AE1DRhXTrUdE5GvAbSEMWdNpOfqJipCKVnpEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	"Chester A. Unal" <chester.a.unal@arinc9.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 954/969] net: dsa: mt7530: preserve VLAN tags on trapped link-local frames
Date: Sat, 30 May 2026 18:07:58 +0200
Message-ID: <20260530160327.108779792@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit 3ac85bcfd404b588298c95c6fba8aad4ad334f57 ]

The BPC, RGAC1 and RGAC2 registers control the handling of link-local
frames with reserved MAC DAs (01:80:C2:00:00:0x). These frames are
correctly trapped to the CPU port, but the egress VLAN tag attribute was
set to MT7530_VLAN_EG_UNTAGGED which causes the switch to strip any
VLAN tags from trapped frames before they reach the CPU.

This causes VLAN-tagged link-local frames (STP BPDUs, LLDP, PTP Peer
Delay Requests) to arrive at the CPU without their VLAN tag, so they
are delivered to the base network interface instead of the VLAN
sub-interface. The DSA local_termination selftest confirms this: all
link-local protocol tests on VLAN upper interfaces fail.

Set the EG_TAG attribute to MT7530_VLAN_EG_DISABLED (system default)
so that the switch does not modify VLAN tags in trapped frames. This
way VLAN-tagged frames retain their original tag and are delivered to
the correct VLAN sub-interface, matching the behavior of non-trapped
frames which pass through without VLAN tag modification.

Fixes: 69ddba9d170b ("net: dsa: mt7530: fix handling of all link-local frames")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Acked-by: Chester A. Unal <chester.a.unal@arinc9.com>
Link: https://patch.msgid.link/891e0cd34db2a5fe20ceb73283a81fb5f71427ca.1778766629.git.daniel@makrotopia.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mt7530.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index fc3c97d0df4fc..73eeb6aeac5cc 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1187,37 +1187,40 @@ static void mt7530_setup_port5(struct dsa_switch *ds, phy_interface_t interface)
 static void
 mt753x_trap_frames(struct mt7530_priv *priv)
 {
-	/* Trap 802.1X PAE frames and BPDUs to the CPU port(s) and egress them
-	 * VLAN-untagged.
+	/* Trap 802.1X PAE frames and BPDUs to the CPU port(s) and egress
+	 * them with the EG_TAG attribute set to disabled (system default)
+	 * so that any VLAN tags in the frame are not modified by the
+	 * switch egress VLAN tag processing. This preserves VLAN tags
+	 * for reception on VLAN sub-interfaces.
 	 */
 	mt7530_rmw(priv, MT753X_BPC,
 		   PAE_BPDU_FR | PAE_EG_TAG_MASK | PAE_PORT_FW_MASK |
 			   BPDU_EG_TAG_MASK | BPDU_PORT_FW_MASK,
-		   PAE_BPDU_FR | PAE_EG_TAG(MT7530_VLAN_EG_UNTAGGED) |
+		   PAE_BPDU_FR | PAE_EG_TAG(MT7530_VLAN_EG_DISABLED) |
 			   PAE_PORT_FW(TO_CPU_FW_CPU_ONLY) |
-			   BPDU_EG_TAG(MT7530_VLAN_EG_UNTAGGED) |
+			   BPDU_EG_TAG(MT7530_VLAN_EG_DISABLED) |
 			   TO_CPU_FW_CPU_ONLY);
 
-	/* Trap frames with :01 and :02 MAC DAs to the CPU port(s) and egress
-	 * them VLAN-untagged.
+	/* Trap frames with :01 and :02 MAC DAs to the CPU port(s) and
+	 * egress them with EG_TAG disabled.
 	 */
 	mt7530_rmw(priv, MT753X_RGAC1,
 		   R02_BPDU_FR | R02_EG_TAG_MASK | R02_PORT_FW_MASK |
 			   R01_BPDU_FR | R01_EG_TAG_MASK | R01_PORT_FW_MASK,
-		   R02_BPDU_FR | R02_EG_TAG(MT7530_VLAN_EG_UNTAGGED) |
+		   R02_BPDU_FR | R02_EG_TAG(MT7530_VLAN_EG_DISABLED) |
 			   R02_PORT_FW(TO_CPU_FW_CPU_ONLY) | R01_BPDU_FR |
-			   R01_EG_TAG(MT7530_VLAN_EG_UNTAGGED) |
+			   R01_EG_TAG(MT7530_VLAN_EG_DISABLED) |
 			   TO_CPU_FW_CPU_ONLY);
 
-	/* Trap frames with :03 and :0E MAC DAs to the CPU port(s) and egress
-	 * them VLAN-untagged.
+	/* Trap frames with :03 and :0E MAC DAs to the CPU port(s) and
+	 * egress them with EG_TAG disabled.
 	 */
 	mt7530_rmw(priv, MT753X_RGAC2,
 		   R0E_BPDU_FR | R0E_EG_TAG_MASK | R0E_PORT_FW_MASK |
 			   R03_BPDU_FR | R03_EG_TAG_MASK | R03_PORT_FW_MASK,
-		   R0E_BPDU_FR | R0E_EG_TAG(MT7530_VLAN_EG_UNTAGGED) |
+		   R0E_BPDU_FR | R0E_EG_TAG(MT7530_VLAN_EG_DISABLED) |
 			   R0E_PORT_FW(TO_CPU_FW_CPU_ONLY) | R03_BPDU_FR |
-			   R03_EG_TAG(MT7530_VLAN_EG_UNTAGGED) |
+			   R03_EG_TAG(MT7530_VLAN_EG_DISABLED) |
 			   TO_CPU_FW_CPU_ONLY);
 }
 
-- 
2.53.0



