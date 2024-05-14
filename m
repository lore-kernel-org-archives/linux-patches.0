Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E16B2D60A;
	Tue, 14 May 2024 11:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687114; cv=none; b=TwNruvN8elN3AmQYeQCYN32xcyk8t3S7r3EISSNHhr0ZlcCZYd3eidUi8MUFYAHuTVirOnPAoAalnITRZaFOrJl7P0Dfj/kgaovaNnu0FvKG0/c2W6w5eLB0V1s5gttQCg6szmg6lAbVI59l5q3q/dS2ENC60zosLeeDyimDCU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687114; c=relaxed/simple;
	bh=2GVZDEkK1Xvvd/+omkaAuHtgXqfh8j6iL7y2AKPXFKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8v0VbPMFoYvqFD2GK7eLINwC4j3pUBhJP1yXHnlfXDFUHBJEsZ9AFa7DvvtWWQI4ZIfB2ZLMG64b04gnWt0laWgPkhUfwvAdn47hscxG/FU4jHFmmQr/bd69j4lLQ/N/wZN2zRXacL1Ej6Xon6p6NQEK5l8L++jaAIxCUz4jvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YLZ5PcLe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YLZ5PcLe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFBFFC2BD10;
	Tue, 14 May 2024 11:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687114;
	bh=2GVZDEkK1Xvvd/+omkaAuHtgXqfh8j6iL7y2AKPXFKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YLZ5PcLeVbbPXnAPKN1OF6C3mT0eSerjeODFjx7tG8f4clKNcBM7jf4FW5hq2+FoP
	 Hk+rJ+xilVJrjpjzExsWYKBJ1UmDPTgIglHTq052kO3JoftqWmQyGZSa9ixzWw6o66
	 c+4FMisWpZjeSyGmnfymBMpJwz3l+QipgdkstLAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 28/84] net: dsa: mv88e6xxx: Add number of MACs in the ATU
Date: Tue, 14 May 2024 12:19:39 +0200
Message-ID: <20240514100952.756976661@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index c1655e5952220..9ee144c117267 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -4200,6 +4200,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6097,
 		.name = "Marvell 88E6085",
 		.num_databases = 4096,
+		.num_macs = 8192,
 		.num_ports = 10,
 		.num_internal_phys = 5,
 		.max_vid = 4095,
@@ -4222,6 +4223,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6095,
 		.name = "Marvell 88E6095/88E6095F",
 		.num_databases = 256,
+		.num_macs = 8192,
 		.num_ports = 11,
 		.num_internal_phys = 0,
 		.max_vid = 4095,
@@ -4242,6 +4244,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6097,
 		.name = "Marvell 88E6097/88E6097F",
 		.num_databases = 4096,
+		.num_macs = 8192,
 		.num_ports = 11,
 		.num_internal_phys = 8,
 		.max_vid = 4095,
@@ -4264,6 +4267,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6165,
 		.name = "Marvell 88E6123",
 		.num_databases = 4096,
+		.num_macs = 1024,
 		.num_ports = 3,
 		.num_internal_phys = 5,
 		.max_vid = 4095,
@@ -4286,6 +4290,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6185,
 		.name = "Marvell 88E6131",
 		.num_databases = 256,
+		.num_macs = 8192,
 		.num_ports = 8,
 		.num_internal_phys = 0,
 		.max_vid = 4095,
@@ -4306,6 +4311,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6341,
 		.name = "Marvell 88E6141",
 		.num_databases = 4096,
+		.num_macs = 2048,
 		.num_ports = 6,
 		.num_internal_phys = 5,
 		.num_gpio = 11,
@@ -4329,6 +4335,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6165,
 		.name = "Marvell 88E6161",
 		.num_databases = 4096,
+		.num_macs = 1024,
 		.num_ports = 6,
 		.num_internal_phys = 5,
 		.max_vid = 4095,
@@ -4352,6 +4359,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6165,
 		.name = "Marvell 88E6165",
 		.num_databases = 4096,
+		.num_macs = 8192,
 		.num_ports = 6,
 		.num_internal_phys = 0,
 		.max_vid = 4095,
@@ -4375,6 +4383,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6351,
 		.name = "Marvell 88E6171",
 		.num_databases = 4096,
+		.num_macs = 8192,
 		.num_ports = 7,
 		.num_internal_phys = 5,
 		.max_vid = 4095,
@@ -4397,6 +4406,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6352,
 		.name = "Marvell 88E6172",
 		.num_databases = 4096,
+		.num_macs = 8192,
 		.num_ports = 7,
 		.num_internal_phys = 5,
 		.num_gpio = 15,
@@ -4420,6 +4430,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6351,
 		.name = "Marvell 88E6175",
 		.num_databases = 4096,
+		.num_macs = 8192,
 		.num_ports = 7,
 		.num_internal_phys = 5,
 		.max_vid = 4095,
@@ -4442,6 +4453,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6352,
 		.name = "Marvell 88E6176",
 		.num_databases = 4096,
+		.num_macs = 8192,
 		.num_ports = 7,
 		.num_internal_phys = 5,
 		.num_gpio = 15,
@@ -4465,6 +4477,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6185,
 		.name = "Marvell 88E6185",
 		.num_databases = 256,
+		.num_macs = 8192,
 		.num_ports = 10,
 		.num_internal_phys = 0,
 		.max_vid = 4095,
@@ -4485,6 +4498,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6390,
 		.name = "Marvell 88E6190",
 		.num_databases = 4096,
+		.num_macs = 16384,
 		.num_ports = 11,	/* 10 + Z80 */
 		.num_internal_phys = 9,
 		.num_gpio = 16,
@@ -4508,6 +4522,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6390,
 		.name = "Marvell 88E6190X",
 		.num_databases = 4096,
+		.num_macs = 16384,
 		.num_ports = 11,	/* 10 + Z80 */
 		.num_internal_phys = 9,
 		.num_gpio = 16,
@@ -4531,6 +4546,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6390,
 		.name = "Marvell 88E6191",
 		.num_databases = 4096,
+		.num_macs = 16384,
 		.num_ports = 11,	/* 10 + Z80 */
 		.num_internal_phys = 9,
 		.max_vid = 8191,
@@ -4581,6 +4597,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6352,
 		.name = "Marvell 88E6240",
 		.num_databases = 4096,
+		.num_macs = 8192,
 		.num_ports = 7,
 		.num_internal_phys = 5,
 		.num_gpio = 15,
@@ -4651,6 +4668,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6320,
 		.name = "Marvell 88E6320",
 		.num_databases = 4096,
+		.num_macs = 8192,
 		.num_ports = 7,
 		.num_internal_phys = 5,
 		.num_gpio = 15,
@@ -4675,6 +4693,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6320,
 		.name = "Marvell 88E6321",
 		.num_databases = 4096,
+		.num_macs = 8192,
 		.num_ports = 7,
 		.num_internal_phys = 5,
 		.num_gpio = 15,
@@ -4698,6 +4717,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6341,
 		.name = "Marvell 88E6341",
 		.num_databases = 4096,
+		.num_macs = 2048,
 		.num_internal_phys = 5,
 		.num_ports = 6,
 		.num_gpio = 11,
@@ -4722,6 +4742,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6351,
 		.name = "Marvell 88E6350",
 		.num_databases = 4096,
+		.num_macs = 8192,
 		.num_ports = 7,
 		.num_internal_phys = 5,
 		.max_vid = 4095,
@@ -4744,6 +4765,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6351,
 		.name = "Marvell 88E6351",
 		.num_databases = 4096,
+		.num_macs = 8192,
 		.num_ports = 7,
 		.num_internal_phys = 5,
 		.max_vid = 4095,
@@ -4766,6 +4788,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6352,
 		.name = "Marvell 88E6352",
 		.num_databases = 4096,
+		.num_macs = 8192,
 		.num_ports = 7,
 		.num_internal_phys = 5,
 		.num_gpio = 15,
@@ -4789,6 +4812,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6390,
 		.name = "Marvell 88E6390",
 		.num_databases = 4096,
+		.num_macs = 16384,
 		.num_ports = 11,	/* 10 + Z80 */
 		.num_internal_phys = 9,
 		.num_gpio = 16,
@@ -4812,6 +4836,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6390,
 		.name = "Marvell 88E6390X",
 		.num_databases = 4096,
+		.num_macs = 16384,
 		.num_ports = 11,	/* 10 + Z80 */
 		.num_internal_phys = 9,
 		.num_gpio = 16,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index e9b1a1ac9a8e2..24dd73be37040 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -94,6 +94,7 @@ struct mv88e6xxx_info {
 	u16 prod_num;
 	const char *name;
 	unsigned int num_databases;
+	unsigned int num_macs;
 	unsigned int num_ports;
 	unsigned int num_internal_phys;
 	unsigned int num_gpio;
@@ -609,6 +610,11 @@ static inline unsigned int mv88e6xxx_num_databases(struct mv88e6xxx_chip *chip)
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



