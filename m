Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E30612FB36;
	Tue, 14 May 2024 11:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686857; cv=none; b=Mssrxyal0nqTspRW1shx1KVERQl7vta7J7It6Gd5u/E/o95ww7ygP2JjFN6Nn9uyWmHxXUMBmWQ71K/cvPjAsKpH1n38bPYBrXoyM63MAcXokMCaBT7Q/SHNfKSQzBqxjLVe4T/K0OIDj3GIfHc0RXN1eqy5rmmHq3pYC/awv4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686857; c=relaxed/simple;
	bh=nkaRn45UVUnHVEwpQacIDSGb+/F1ywKPQGxeWX2c/Lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a3Weu3JHniMKt0E3oHw53CfgGY0Y+qSJPplCD0mr2eNPETFkvCjlobAiWFdt2v+9fKoZGLXTiTuKnAlkuPIPnTGG2vlNmpffGsOrtEyGFTnnLHBuwOtJTnwU2vArLriv3HJryEPkV2E4r7VAgIygR3L89hGJbOIdxSMtvtNfxVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jb+ZJpyC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jb+ZJpyC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B88A7C2BD10;
	Tue, 14 May 2024 11:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686857;
	bh=nkaRn45UVUnHVEwpQacIDSGb+/F1ywKPQGxeWX2c/Lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jb+ZJpyCp/y2rYm64seuz1QMCFbbfoIBCZSDrD+0/h0szmYY8xBPYTYjnQbmT1xv/
	 L8c8CnznWFq5hY8EXfM2iqFxlh37+/rWO6+U2/G5qkPaM8Yv6npBplJ1czG3Vkle1U
	 leeSyTxMMd5T+4AnRnyjRyUgFYurp7myF1jPBSP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 18/63] net: dsa: mv88e6xxx: Add number of MACs in the ATU
Date: Tue, 14 May 2024 12:19:39 +0200
Message-ID: <20240514100948.703506636@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100948.010148088@linuxfoundation.org>
References: <20240514100948.010148088@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Lunn <andrew@lunn.ch>

[ Upstream commit d9ea56206c4df77175321874544eb4ca48c0bac8 ]

For each supported switch, add an entry to the info structure for the
number of MACs which can be stored in the ATU. This will later be used
to export the ATU as a devlink resource, and indicate its occupancy,
how full the ATU is.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: b9a61c20179f ("net: dsa: mv88e6xxx: Fix number of databases for 88E6141 / 88E6341")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 25 +++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/chip.h |  6 ++++++
 2 files changed, 31 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 792073a768ac0..a562ffd627191 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3933,6 +3933,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6097,
 		.name = "Marvell 88E6085",
 		.num_databases = 4096,
+		.num_macs = 8192,
 		.num_ports = 10,
 		.num_internal_phys = 5,
 		.max_vid = 4095,
@@ -3955,6 +3956,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6095,
 		.name = "Marvell 88E6095/88E6095F",
 		.num_databases = 256,
+		.num_macs = 8192,
 		.num_ports = 11,
 		.num_internal_phys = 0,
 		.max_vid = 4095,
@@ -3975,6 +3977,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6097,
 		.name = "Marvell 88E6097/88E6097F",
 		.num_databases = 4096,
+		.num_macs = 8192,
 		.num_ports = 11,
 		.num_internal_phys = 8,
 		.max_vid = 4095,
@@ -3997,6 +4000,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6165,
 		.name = "Marvell 88E6123",
 		.num_databases = 4096,
+		.num_macs = 1024,
 		.num_ports = 3,
 		.num_internal_phys = 5,
 		.max_vid = 4095,
@@ -4019,6 +4023,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6185,
 		.name = "Marvell 88E6131",
 		.num_databases = 256,
+		.num_macs = 8192,
 		.num_ports = 8,
 		.num_internal_phys = 0,
 		.max_vid = 4095,
@@ -4039,6 +4044,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6341,
 		.name = "Marvell 88E6141",
 		.num_databases = 4096,
+		.num_macs = 2048,
 		.num_ports = 6,
 		.num_internal_phys = 5,
 		.num_gpio = 11,
@@ -4062,6 +4068,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6165,
 		.name = "Marvell 88E6161",
 		.num_databases = 4096,
+		.num_macs = 1024,
 		.num_ports = 6,
 		.num_internal_phys = 5,
 		.max_vid = 4095,
@@ -4085,6 +4092,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6165,
 		.name = "Marvell 88E6165",
 		.num_databases = 4096,
+		.num_macs = 8192,
 		.num_ports = 6,
 		.num_internal_phys = 0,
 		.max_vid = 4095,
@@ -4108,6 +4116,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6351,
 		.name = "Marvell 88E6171",
 		.num_databases = 4096,
+		.num_macs = 8192,
 		.num_ports = 7,
 		.num_internal_phys = 5,
 		.max_vid = 4095,
@@ -4130,6 +4139,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6352,
 		.name = "Marvell 88E6172",
 		.num_databases = 4096,
+		.num_macs = 8192,
 		.num_ports = 7,
 		.num_internal_phys = 5,
 		.num_gpio = 15,
@@ -4153,6 +4163,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6351,
 		.name = "Marvell 88E6175",
 		.num_databases = 4096,
+		.num_macs = 8192,
 		.num_ports = 7,
 		.num_internal_phys = 5,
 		.max_vid = 4095,
@@ -4175,6 +4186,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6352,
 		.name = "Marvell 88E6176",
 		.num_databases = 4096,
+		.num_macs = 8192,
 		.num_ports = 7,
 		.num_internal_phys = 5,
 		.num_gpio = 15,
@@ -4198,6 +4210,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6185,
 		.name = "Marvell 88E6185",
 		.num_databases = 256,
+		.num_macs = 8192,
 		.num_ports = 10,
 		.num_internal_phys = 0,
 		.max_vid = 4095,
@@ -4218,6 +4231,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6390,
 		.name = "Marvell 88E6190",
 		.num_databases = 4096,
+		.num_macs = 16384,
 		.num_ports = 11,	/* 10 + Z80 */
 		.num_internal_phys = 9,
 		.num_gpio = 16,
@@ -4241,6 +4255,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6390,
 		.name = "Marvell 88E6190X",
 		.num_databases = 4096,
+		.num_macs = 16384,
 		.num_ports = 11,	/* 10 + Z80 */
 		.num_internal_phys = 9,
 		.num_gpio = 16,
@@ -4264,6 +4279,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6390,
 		.name = "Marvell 88E6191",
 		.num_databases = 4096,
+		.num_macs = 16384,
 		.num_ports = 11,	/* 10 + Z80 */
 		.num_internal_phys = 9,
 		.max_vid = 8191,
@@ -4287,6 +4303,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6352,
 		.name = "Marvell 88E6240",
 		.num_databases = 4096,
+		.num_macs = 8192,
 		.num_ports = 7,
 		.num_internal_phys = 5,
 		.num_gpio = 15,
@@ -4335,6 +4352,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6320,
 		.name = "Marvell 88E6320",
 		.num_databases = 4096,
+		.num_macs = 8192,
 		.num_ports = 7,
 		.num_internal_phys = 5,
 		.num_gpio = 15,
@@ -4359,6 +4377,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6320,
 		.name = "Marvell 88E6321",
 		.num_databases = 4096,
+		.num_macs = 8192,
 		.num_ports = 7,
 		.num_internal_phys = 5,
 		.num_gpio = 15,
@@ -4382,6 +4401,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6341,
 		.name = "Marvell 88E6341",
 		.num_databases = 4096,
+		.num_macs = 2048,
 		.num_internal_phys = 5,
 		.num_ports = 6,
 		.num_gpio = 11,
@@ -4406,6 +4426,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6351,
 		.name = "Marvell 88E6350",
 		.num_databases = 4096,
+		.num_macs = 8192,
 		.num_ports = 7,
 		.num_internal_phys = 5,
 		.max_vid = 4095,
@@ -4428,6 +4449,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6351,
 		.name = "Marvell 88E6351",
 		.num_databases = 4096,
+		.num_macs = 8192,
 		.num_ports = 7,
 		.num_internal_phys = 5,
 		.max_vid = 4095,
@@ -4450,6 +4472,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6352,
 		.name = "Marvell 88E6352",
 		.num_databases = 4096,
+		.num_macs = 8192,
 		.num_ports = 7,
 		.num_internal_phys = 5,
 		.num_gpio = 15,
@@ -4473,6 +4496,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6390,
 		.name = "Marvell 88E6390",
 		.num_databases = 4096,
+		.num_macs = 16384,
 		.num_ports = 11,	/* 10 + Z80 */
 		.num_internal_phys = 9,
 		.num_gpio = 16,
@@ -4496,6 +4520,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6390,
 		.name = "Marvell 88E6390X",
 		.num_databases = 4096,
+		.num_macs = 16384,
 		.num_ports = 11,	/* 10 + Z80 */
 		.num_internal_phys = 9,
 		.num_gpio = 16,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 546651d8c3e1f..a2697d9b89175 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -105,6 +105,7 @@ struct mv88e6xxx_info {
 	u16 prod_num;
 	const char *name;
 	unsigned int num_databases;
+	unsigned int num_macs;
 	unsigned int num_ports;
 	unsigned int num_internal_phys;
 	unsigned int num_gpio;
@@ -559,6 +560,11 @@ static inline unsigned int mv88e6xxx_num_databases(struct mv88e6xxx_chip *chip)
 	return chip->info->num_databases;
 }
 
+static inline unsigned int mv88e6xxx_num_macs(struct  mv88e6xxx_chip *chip)
+{
+	return chip->info->num_macs;
+}
+
 static inline unsigned int mv88e6xxx_num_ports(struct mv88e6xxx_chip *chip)
 {
 	return chip->info->num_ports;
-- 
2.43.0



