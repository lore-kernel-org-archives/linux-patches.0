Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67CF9263F44;
	Sat, 30 May 2026 17:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161386; cv=none; b=qSAC0Afz7B70eIcAD9ugCqvrj2MMpPNWXGIfuFlLNGx9dp2IctPhWybf0IZXLHJio5/prR+SAOyCHZ6U7ql1SB3nktpmSn0tvFU2gLZW09ZBqepEpSrxFR2VuGk7fMwXJuy/kjF8tQQIx+s4nfl/gfCnp6FGNmqj6OoN/qjfgtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161386; c=relaxed/simple;
	bh=O9xxMjdpqM+QGYCLf5HLMNkDO2p4D+eJ7AQlctlrs30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a42ZTQKeJa7uld62szdto7YqxWNdbdoc6nUSd1S4d3eEkbvfOxvAyxz6wEFFF3TXY6hkJ1Z9wkF7cJBZ24E7UeO7PDj0L5G3etSE14xDp3OV7pJUV1tZj/k2hT5gdJetMdnMGKvMD5FS+8qH2jYSZ553u9LM4bAalvhRoJJ4sVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uyxxnzzC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uyxxnzzC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAFAD1F00893;
	Sat, 30 May 2026 17:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161385;
	bh=/5t7VNJ2fvAJIwvGdZY4UgnEM+iqjCK7BXWL0F39Ii4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uyxxnzzC8w+4UgxwGVwoJGdbrU81tUHBO/oiL37Tp9hJVJXIG9wdtW57+HPbrpICl
	 uYkG3lU96rr3y4fafpbjsi9mufYqlAT0ONd3sF8mFeDg3dJyyRHb88OXp6WEqLtS30
	 v5ntL4urERZ/9109oNJtPhHHoWH888aXNdntNclg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 609/969] mtd: spi-nor: Allow post_sfdp hook to return errors
Date: Sat, 30 May 2026 18:02:13 +0200
Message-ID: <20260530160317.245967752@linuxfoundation.org>
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

From: Tudor Ambarus <tudor.ambarus@linaro.org>

[ Upstream commit e570f7872a34dc290014c80c7bad365d6577836b ]

Multi die flashes like s25hl02gt need to determine the page_size at
run-time by querying a configuration register for each die. Since the
number of dice is determined in an optional SFDP table, SCCR MC, the
page size configuration must be done in the post_sfdp hook. Allow
post_sfdp to return errors, as reading the configuration register might
return errors.

Link: https://lore.kernel.org/r/924ab710f128448ec62537cfbb377336e390043c.1680849425.git.Takahiro.Kuwano@infineon.com
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Stable-dep-of: 3620d67b4849 ("mtd: spi-nor: update spi_nor_fixups::post_sfdp() documentation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/core.h      |  2 +-
 drivers/mtd/spi-nor/micron-st.c |  4 +++-
 drivers/mtd/spi-nor/sfdp.c      | 17 ++++++++++++-----
 drivers/mtd/spi-nor/spansion.c  | 12 +++++++++---
 4 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/drivers/mtd/spi-nor/core.h b/drivers/mtd/spi-nor/core.h
index 290613fd63ae7..cc70a2092494c 100644
--- a/drivers/mtd/spi-nor/core.h
+++ b/drivers/mtd/spi-nor/core.h
@@ -424,7 +424,7 @@ struct spi_nor_fixups {
 	int (*post_bfpt)(struct spi_nor *nor,
 			 const struct sfdp_parameter_header *bfpt_header,
 			 const struct sfdp_bfpt *bfpt);
-	void (*post_sfdp)(struct spi_nor *nor);
+	int (*post_sfdp)(struct spi_nor *nor);
 	void (*late_init)(struct spi_nor *nor);
 };
 
diff --git a/drivers/mtd/spi-nor/micron-st.c b/drivers/mtd/spi-nor/micron-st.c
index 3c9681a3f7a33..f8f6e14452d58 100644
--- a/drivers/mtd/spi-nor/micron-st.c
+++ b/drivers/mtd/spi-nor/micron-st.c
@@ -127,7 +127,7 @@ static void mt35xu512aba_default_init(struct spi_nor *nor)
 	nor->params->octal_dtr_enable = micron_st_nor_octal_dtr_enable;
 }
 
-static void mt35xu512aba_post_sfdp_fixup(struct spi_nor *nor)
+static int mt35xu512aba_post_sfdp_fixup(struct spi_nor *nor)
 {
 	/* Set the Fast Read settings. */
 	nor->params->hwcaps.mask |= SNOR_HWCAPS_READ_8_8_8_DTR;
@@ -145,6 +145,8 @@ static void mt35xu512aba_post_sfdp_fixup(struct spi_nor *nor)
 	 * disable it.
 	 */
 	nor->params->quad_enable = NULL;
+
+	return 0;
 }
 
 static const struct spi_nor_fixups mt35xu512aba_fixups = {
diff --git a/drivers/mtd/spi-nor/sfdp.c b/drivers/mtd/spi-nor/sfdp.c
index 78110387be0b5..6f47982105bd9 100644
--- a/drivers/mtd/spi-nor/sfdp.c
+++ b/drivers/mtd/spi-nor/sfdp.c
@@ -1239,14 +1239,21 @@ static int spi_nor_parse_sccr(struct spi_nor *nor,
  * Used to tweak various flash parameters when information provided by the SFDP
  * tables are wrong.
  */
-static void spi_nor_post_sfdp_fixups(struct spi_nor *nor)
+static int spi_nor_post_sfdp_fixups(struct spi_nor *nor)
 {
+	int ret;
+
 	if (nor->manufacturer && nor->manufacturer->fixups &&
-	    nor->manufacturer->fixups->post_sfdp)
-		nor->manufacturer->fixups->post_sfdp(nor);
+	    nor->manufacturer->fixups->post_sfdp) {
+		ret = nor->manufacturer->fixups->post_sfdp(nor);
+		if (ret)
+			return ret;
+	}
 
 	if (nor->info->fixups && nor->info->fixups->post_sfdp)
-		nor->info->fixups->post_sfdp(nor);
+		return nor->info->fixups->post_sfdp(nor);
+
+	return 0;
 }
 
 /**
@@ -1429,7 +1436,7 @@ int spi_nor_parse_sfdp(struct spi_nor *nor)
 		}
 	}
 
-	spi_nor_post_sfdp_fixups(nor);
+	err = spi_nor_post_sfdp_fixups(nor);
 exit:
 	kfree(param_headers);
 	return err;
diff --git a/drivers/mtd/spi-nor/spansion.c b/drivers/mtd/spi-nor/spansion.c
index 5914a6074a11e..af97e3741f987 100644
--- a/drivers/mtd/spi-nor/spansion.c
+++ b/drivers/mtd/spi-nor/spansion.c
@@ -258,7 +258,7 @@ s25fs256t_post_bfpt_fixup(struct spi_nor *nor,
 	return cypress_nor_set_page_size(nor);
 }
 
-static void s25fs256t_post_sfdp_fixup(struct spi_nor *nor)
+static int s25fs256t_post_sfdp_fixup(struct spi_nor *nor)
 {
 	struct spi_nor_flash_parameter *params = nor->params;
 
@@ -267,6 +267,8 @@ static void s25fs256t_post_sfdp_fixup(struct spi_nor *nor)
 	spi_nor_set_pp_settings(&params->page_programs[SNOR_CMD_PP_1_1_4],
 				SPINOR_OP_PP_1_1_4_4B,
 				SNOR_PROTO_1_1_4);
+
+	return 0;
 }
 
 static void s25fs256t_late_init(struct spi_nor *nor)
@@ -297,7 +299,7 @@ s25hx_t_post_bfpt_fixup(struct spi_nor *nor,
 	return cypress_nor_set_page_size(nor);
 }
 
-static void s25hx_t_post_sfdp_fixup(struct spi_nor *nor)
+static int s25hx_t_post_sfdp_fixup(struct spi_nor *nor)
 {
 	struct spi_nor_erase_type *erase_type =
 					nor->params->erase_map.erase_type;
@@ -319,6 +321,8 @@ static void s25hx_t_post_sfdp_fixup(struct spi_nor *nor)
 			break;
 		}
 	}
+
+	return 0;
 }
 
 static void s25hx_t_late_init(struct spi_nor *nor)
@@ -351,7 +355,7 @@ static int cypress_nor_octal_dtr_enable(struct spi_nor *nor, bool enable)
 			cypress_nor_octal_dtr_dis(nor);
 }
 
-static void s28hx_t_post_sfdp_fixup(struct spi_nor *nor)
+static int s28hx_t_post_sfdp_fixup(struct spi_nor *nor)
 {
 	/*
 	 * On older versions of the flash the xSPI Profile 1.0 table has the
@@ -377,6 +381,8 @@ static void s28hx_t_post_sfdp_fixup(struct spi_nor *nor)
 	 * actual value for that is 4.
 	 */
 	nor->params->rdsr_addr_nbytes = 4;
+
+	return 0;
 }
 
 static int s28hx_t_post_bfpt_fixup(struct spi_nor *nor,
-- 
2.53.0



