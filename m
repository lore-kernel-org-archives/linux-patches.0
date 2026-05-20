Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE37409115;
	Wed, 20 May 2026 18:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302331; cv=none; b=fZmwDSn/uHeeAFDtJ4aRu0XuIqXY17ocAF6Y6xLx0oyt+X5jC2Cm+uXyO21LGUvzp8TlubU0uK4x7mLocWaozR7v+KbVNqpKKMkjMlcDqS9Q8AnykSshkvUQx9ccrGOsSnjBLda8egfbpW7+Wv1vjbtBu4tUwS7NCV0ioAoSUmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302331; c=relaxed/simple;
	bh=tF1XLe1cESm+YZ9q7qcZo+5+skX8oIyurQb8FhJIvGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Smw5h5GMr9e+ahTqgOBhmSVkG77xoXqzY+JaweovK9Wr95jnLFpGE2h01ZCi5ysW4KWmKyRvWNfr34H66YYtiVF/+kZLcZ1stj1y4+FNKXRD1lCfdTf2oaAYtGYGDJ5SMFL3Th5FJSzTtMWoGW26NsbbmNYuVKp6V87pMuYhmx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XcKD/bdg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XcKD/bdg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D2721F00896;
	Wed, 20 May 2026 18:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302330;
	bh=VxE5XmWmlkWOAtspSpkS2yqy1IZihWT2eMsT5WM1w5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XcKD/bdgxrDCoF/4TSz5RiOgGmrVBCR0znVOsJ3Ja0ZLjlw8IcjXgeW2X2NQoTBKK
	 yK2Ot+/oSQEuq8LFsPGhG5D5+Aku9cwVXuAXq9mjHVTVMZ1DRTIzqdidlTTp2wfLeu
	 LZNAVmXUK2e6rqg11Nft1hFkGthxFsepaHv9hdIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Takahiro Kuwano <Takahiro.Kuwano@infineon.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>
Subject: [PATCH 6.6 227/508] mtd: spi-nor: sfdp: introduce smpt_read_dummy fixup hook
Date: Wed, 20 May 2026 18:20:50 +0200
Message-ID: <20260520162103.567723445@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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
index 9217379b9cfef..a68cf82498ed8 100644
--- a/drivers/mtd/spi-nor/core.h
+++ b/drivers/mtd/spi-nor/core.h
@@ -416,6 +416,8 @@ struct spi_nor_flash_parameter {
  *                flash parameters when information provided by the flash_info
  *                table is incomplete or wrong.
  * @post_bfpt: called after the BFPT table has been parsed
+ * @smpt_read_dummy: called during SMPT table is being parsed. Used to fix the
+ *                   number of dummy cycles in read register ops.
  * @post_sfdp: called after SFDP has been parsed (is also called for SPI NORs
  *             that do not support RDSFDP). Typically used to tweak various
  *             parameters that could not be extracted by other means (i.e.
@@ -433,6 +435,7 @@ struct spi_nor_fixups {
 	int (*post_bfpt)(struct spi_nor *nor,
 			 const struct sfdp_parameter_header *bfpt_header,
 			 const struct sfdp_bfpt *bfpt);
+	void (*smpt_read_dummy)(const struct spi_nor *nor, u8 *read_dummy);
 	int (*post_sfdp)(struct spi_nor *nor);
 	int (*late_init)(struct spi_nor *nor);
 };
diff --git a/drivers/mtd/spi-nor/sfdp.c b/drivers/mtd/spi-nor/sfdp.c
index b3b11dfed7893..f1ec785628bfb 100644
--- a/drivers/mtd/spi-nor/sfdp.c
+++ b/drivers/mtd/spi-nor/sfdp.c
@@ -674,6 +674,17 @@ static u8 spi_nor_smpt_addr_nbytes(const struct spi_nor *nor, const u32 settings
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
@@ -686,8 +697,11 @@ static u8 spi_nor_smpt_read_dummy(const struct spi_nor *nor, const u32 settings)
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



