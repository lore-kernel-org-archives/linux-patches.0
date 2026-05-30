Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC3C3AB26B;
	Sat, 30 May 2026 17:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161389; cv=none; b=EG2aTv9ExKfcvJ7wb0/fua1xFLU8Cf9ckU87O1SHl4+Up8KNliuhkDu4vPtA/tCxIDfgz3jBWBVaMhy+Fmfq9s3Srot8BkZ981HRg2anrICSgnGqXUhyR/mpxqZTNSHBUTY1r8s890LT2ld/mmIDGn2wwoCgQz7bPsGRIv8Ae1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161389; c=relaxed/simple;
	bh=ib2JD1o2gz1GMwbLBCRUmlj/H1C8ruN0QN+OmE1yj58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=krRyn9me3/to2921tcnhDnhDdDMILUHuvHGnUNf6Eb5E8+PsvKB8h8WBAf+DegdpbhatVVMwkZrbtycdGKyROT4aUwU1wAWQI79e2zysWZbBKwWSh/1G7cAjn14ACP3Y9D1+aQqTdGHCAikDolQYneFbEDRgmelDxCkDQmHLC3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QXRXp8QE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QXRXp8QE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A3A1F00893;
	Sat, 30 May 2026 17:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161388;
	bh=plUBV/Z2e92EZ2o3bmLHFR21bbwsERBnlBeVeAxUOAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QXRXp8QEy/wTiDl1KxQeu3cZ8xu5mdm4Mb5xz0TGaNTXMdmvUhUxSAySFdL/rk8MX
	 epCks7t0dFogGPIbsi/hb43xqXDyw+RRzZ7DdQYCFqCv2gngH2enV5+jG5u8VDUnCw
	 AdWzP3C8cmQSg3X4vt+xAqbj3lXu9h5AJ75HH0Nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Takahiro Kuwano <Takahiro.Kuwano@infineon.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>
Subject: [PATCH 6.1 610/969] mtd: spi-nor: sfdp: introduce smpt_read_dummy fixup hook
Date: Sat, 30 May 2026 18:02:14 +0200
Message-ID: <20260530160317.276001739@linuxfoundation.org>
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

From: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>

[ Upstream commit 653f6def567c81f37302f9591ffd54df3e2a11eb ]

SMPT contains config detection info that describes opcode, address, and
dummy cycles to read sector map config. The dummy cycles parameter can
be SMPT_CMD_READ_DUMMY_IS_VARIABLE and in that case nor->read_dummy
(initialized as 0) is used. In Infineon flash chips, Read Any Register
command with variable dummy cycle is defined in SMPT. S25Hx/S28Hx flash
has 0 dummy cycle by default to read volatile regiters and
nor->read_dummy can work. S25FS-S flash has 8 dummy cycles so we need a
hook that can fix dummy cycles with actually used value.

Inroduce smpt_read_dummy() in struct spi_nor_fixups. It is called when
the dummy cycle field in SMPT config detection is 'varialble'.

Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Tested-by: Marek Vasut <marek.vasut+renesas@mailbox.org> # S25FS512S
Signed-off-by: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Stable-dep-of: 3620d67b4849 ("mtd: spi-nor: update spi_nor_fixups::post_sfdp() documentation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/core.h |  3 +++
 drivers/mtd/spi-nor/sfdp.c | 18 ++++++++++++++++--
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/spi-nor/core.h b/drivers/mtd/spi-nor/core.h
index cc70a2092494c..4aac34f06c7bb 100644
--- a/drivers/mtd/spi-nor/core.h
+++ b/drivers/mtd/spi-nor/core.h
@@ -407,6 +407,8 @@ struct spi_nor_flash_parameter {
  *                flash parameters when information provided by the flash_info
  *                table is incomplete or wrong.
  * @post_bfpt: called after the BFPT table has been parsed
+ * @smpt_read_dummy: called during SMPT table is being parsed. Used to fix the
+ *                   number of dummy cycles in read register ops.
  * @post_sfdp: called after SFDP has been parsed (is also called for SPI NORs
  *             that do not support RDSFDP). Typically used to tweak various
  *             parameters that could not be extracted by other means (i.e.
@@ -424,6 +426,7 @@ struct spi_nor_fixups {
 	int (*post_bfpt)(struct spi_nor *nor,
 			 const struct sfdp_parameter_header *bfpt_header,
 			 const struct sfdp_bfpt *bfpt);
+	void (*smpt_read_dummy)(const struct spi_nor *nor, u8 *read_dummy);
 	int (*post_sfdp)(struct spi_nor *nor);
 	void (*late_init)(struct spi_nor *nor);
 };
diff --git a/drivers/mtd/spi-nor/sfdp.c b/drivers/mtd/spi-nor/sfdp.c
index 6f47982105bd9..66c233db20e8e 100644
--- a/drivers/mtd/spi-nor/sfdp.c
+++ b/drivers/mtd/spi-nor/sfdp.c
@@ -659,6 +659,17 @@ static u8 spi_nor_smpt_addr_nbytes(const struct spi_nor *nor, const u32 settings
 	}
 }
 
+static void spi_nor_smpt_read_dummy_fixups(const struct spi_nor *nor,
+					   u8 *read_dummy)
+{
+	if (nor->manufacturer && nor->manufacturer->fixups &&
+	    nor->manufacturer->fixups->smpt_read_dummy)
+		nor->manufacturer->fixups->smpt_read_dummy(nor, read_dummy);
+
+	if (nor->info->fixups && nor->info->fixups->smpt_read_dummy)
+		nor->info->fixups->smpt_read_dummy(nor, read_dummy);
+}
+
 /**
  * spi_nor_smpt_read_dummy() - return the configuration detection command read
  *			       latency, in clock cycles.
@@ -671,8 +682,11 @@ static u8 spi_nor_smpt_read_dummy(const struct spi_nor *nor, const u32 settings)
 {
 	u8 read_dummy = SMPT_CMD_READ_DUMMY(settings);
 
-	if (read_dummy == SMPT_CMD_READ_DUMMY_IS_VARIABLE)
-		return nor->read_dummy;
+	if (read_dummy == SMPT_CMD_READ_DUMMY_IS_VARIABLE) {
+		read_dummy = nor->read_dummy;
+		spi_nor_smpt_read_dummy_fixups(nor, &read_dummy);
+	}
+
 	return read_dummy;
 }
 
-- 
2.53.0



