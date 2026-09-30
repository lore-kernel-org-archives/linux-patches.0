Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBB44DDB23;
	Wed, 30 Sep 2026 16:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787315; cv=none; b=Ie3JRz15FabkpEMuov4PJ6rDbEgetMyuDddFdb9q/6NeOgof54G01oDNBU+5OlCBL1VZ7hdt8slqxpfgedzc/SaTvJJF7kaXK2A4TZMPpK2yNtwuV0h1c88KCGAjkMaDNHhecqEaOdQJ8WLVxV/vhme/iJ3jVidDUVu3i5YnaA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787315; c=relaxed/simple;
	bh=UtXLb5bKb829+apnIicayxLH2s5KA3W99hXhNpG92cs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qvcXQxn9ojgF+eHNKvASKv3L+ZErQUQU6SsgbBRU1MZILuh3cgCZdtEG2lLlw7bxdRfFiJ9MD8XuiPRxNphb+/tL7WIZEfPBwhWQCf2G4G3IF3afF9efUd7y98E8TPy5DU7IbY+0IXCTcKXSD7X8bMks/Em0++DodN3X4QCkyEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EAZNi2Ng; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EAZNi2Ng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF8D1F000FF;
	Wed, 30 Sep 2026 16:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787314;
	bh=t/sOwHUdVG4mlgPCRwHqkiF0vICPl5t2lwyu65JeqkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EAZNi2Ngr7YcjYMJiPmGDvvDqG1mnvGlQDHupdWFY4lTJvbkFkl9AZnG3ieXlw/0x
	 LZxxDp8BkA3B9Zhvqgtes/9MwoRlua8BylazziezKfg0oNiNVPmDq+hwGZZe3qwOpH
	 OH6DLRMwagNzStnQsDwAayCIJavTXc41Ug4tiIkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Nicolo Giuliani <nicolo.giuliani6@studio.unibo.it>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 186/457] net: dsa: mv88e6xxx: 88E6191X and 88E6193X have no PTP
Date: Wed, 30 Sep 2026 17:24:51 +0200
Message-ID: <20260930152350.065505744@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

From: Nicolo Giuliani <nicolo.giuliani6@studio.unibo.it>

[ Upstream commit 6b491af01aa5c0633a580e3b11bc7277adc903b2 ]

The 88E6191X and 88E6193X are 6393 family devices that share
mv88e6393x_ops with the 88E6393X and are marked as ptp_support. Marvell's
UMSD driver describes both as parts without AVB (88E6193X: "BGA package -
No AVB, No Routing, No Cut-through"), and the register access confirms it
on an 88E6193X: the whole indirect AVB register space behind Global 2
registers 0x16 and 0x17 reads zero, for every port, block and address,
with the 6390 and with the 6352 command encoding. Writes to the TAI
registers, including the clock period register and the TAI global
configuration register, read back as zero.

Since commit 7e3c18097a70 ("net: dsa: mv88e6xxx: read cycle counter
period from hardware") the PTP setup reads the TAI clock period, so the
switch fails to probe:

mv88e6xxx ...: unexpected cycle counter period of 0 ps

Add mv88e6191x_ops, a copy of mv88e6393x_ops without avb_ops and ptp_ops,
use it for the 88E6191X and the 88E6193X and stop setting ptp_support for
them. The 88E6393X is unchanged.

Tested on an 88E6193X (Sophos XGS 107w): the switch probes and the ports
work. I do not have an 88E6191X, it is changed because UMSD describes it
the same way.

Fixes: de776d0d316f ("net: dsa: mv88e6xxx: add support for mv88e6393x family")
Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Nicolo Giuliani <nicolo.giuliani6@studio.unibo.it>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260921-send-net-v2-1-031ad720f140@studio.unibo.it
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 68 ++++++++++++++++++++++++++++++--
 1 file changed, 64 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 7f68a0c558026..a4a8c7e11bf4f 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5639,6 +5639,68 @@ static const struct mv88e6xxx_ops mv88e6390x_ops = {
 	.pcs_ops = &mv88e6390_pcs_ops,
 };
 
+static const struct mv88e6xxx_ops mv88e6191x_ops = {
+	/* MV88E6XXX_FAMILY_6393 without AVB and PTP: 6191X and 6193X */
+	.irl_init_all = mv88e6390_g2_irl_init_all,
+	.get_eeprom = mv88e6xxx_g2_get_eeprom8,
+	.set_eeprom = mv88e6xxx_g2_set_eeprom8,
+	.set_switch_mac = mv88e6xxx_g2_set_switch_mac,
+	.phy_read = mv88e6xxx_g2_smi_phy_read_c22,
+	.phy_write = mv88e6xxx_g2_smi_phy_write_c22,
+	.phy_read_c45 = mv88e6xxx_g2_smi_phy_read_c45,
+	.phy_write_c45 = mv88e6xxx_g2_smi_phy_write_c45,
+	.port_set_link = mv88e6xxx_port_set_link,
+	.port_sync_link = mv88e6xxx_port_sync_link,
+	.port_set_rgmii_delay = mv88e6390_port_set_rgmii_delay,
+	.port_set_speed_duplex = mv88e6393x_port_set_speed_duplex,
+	.port_tag_remap = mv88e6390_port_tag_remap,
+	.port_set_policy = mv88e6393x_port_set_policy,
+	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
+	.port_set_ucast_flood = mv88e6352_port_set_ucast_flood,
+	.port_set_mcast_flood = mv88e6352_port_set_mcast_flood,
+	.port_set_ether_type = mv88e6393x_port_set_ether_type,
+	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
+	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
+	.port_pause_limit = mv88e6390_port_pause_limit,
+	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
+	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
+	.port_get_cmode = mv88e6352_port_get_cmode,
+	.port_set_cmode = mv88e6393x_port_set_cmode,
+	.port_setup_message_port = mv88e6xxx_setup_message_port,
+	.port_set_upstream_port = mv88e6393x_port_set_upstream_port,
+	.port_enable_tcam = mv88e6xxx_port_enable_tcam,
+	.stats_snapshot = mv88e6390_g1_stats_snapshot,
+	.stats_set_histogram = mv88e6390_g1_stats_set_histogram,
+	.stats_get_sset_count = mv88e6320_stats_get_sset_count,
+	.stats_get_strings = mv88e6320_stats_get_strings,
+	.stats_get_stat = mv88e6390_stats_get_stat,
+	/* .set_cpu_port is missing because this family does not support a global
+	 * CPU port, only per port CPU port which is set via
+	 * .port_set_upstream_port method.
+	 */
+	.set_egress_port = mv88e6393x_set_egress_port,
+	.watchdog_ops = &mv88e6393x_watchdog_ops,
+	.mgmt_rsvd2cpu = mv88e6393x_port_mgmt_rsvd2cpu,
+	.pot_clear = mv88e6xxx_g2_pot_clear,
+	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
+	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
+	.reset = mv88e6352_g1_reset,
+	.rmu_disable = mv88e6390_g1_rmu_disable,
+	.atu_get_hash = mv88e6165_g1_atu_get_hash,
+	.atu_set_hash = mv88e6165_g1_atu_set_hash,
+	.vtu_getnext = mv88e6390_g1_vtu_getnext,
+	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
+	.stu_getnext = mv88e6390_g1_stu_getnext,
+	.stu_loadpurge = mv88e6390_g1_stu_loadpurge,
+	.serdes_get_lane = mv88e6393x_serdes_get_lane,
+	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
+	/* TODO: serdes stats */
+	.gpio_ops = &mv88e6352_gpio_ops,
+	.phylink_get_caps = mv88e6393x_phylink_get_caps,
+	.pcs_ops = &mv88e6393x_pcs_ops,
+	.tcam_ops = &mv88e6393_tcam_ops,
+};
+
 static const struct mv88e6xxx_ops mv88e6393x_ops = {
 	/* MV88E6XXX_FAMILY_6393 */
 	.irl_init_all = mv88e6390_g2_irl_init_all,
@@ -6163,8 +6225,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.atu_move_port_mask = 0x1f,
 		.pvt = true,
 		.multi_chip = true,
-		.ptp_support = true,
-		.ops = &mv88e6393x_ops,
+		.ops = &mv88e6191x_ops,
 	},
 
 	[MV88E6193X] = {
@@ -6190,8 +6251,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.atu_move_port_mask = 0x1f,
 		.pvt = true,
 		.multi_chip = true,
-		.ptp_support = true,
-		.ops = &mv88e6393x_ops,
+		.ops = &mv88e6191x_ops,
 	},
 
 	[MV88E6220] = {
-- 
2.53.0



