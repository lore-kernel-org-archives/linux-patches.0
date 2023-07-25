Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF258F59
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:49:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1391C433C7;
	Tue, 25 Jul 2023 10:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282157;
	bh=iOCKfKU9VocYP1j5M+M3Voq4yNGshaueuJowx5mVEuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gAsGi4K3AA4S5lo3YA1f3ozRfojgPJVayLjRS/umnRVnsWzRuejq5fRgZxv4WZamY
	 HmHBxKGUfRlpm7z7ZNOXnIrac3IEpx976Uua3vrsYTwnGHlFwGeAo8lo02dgqg8vlm
	 uB49zfjcmRFauDkGbMe2Ch95A7IIPGlUN4peMyxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Xu Yilun <yilun.xu@intel.com>,
	stable@kernel.org
Subject: [PATCH 6.4 028/227] regmap: Drop initial version of maximum transfer length fixes
Date: Tue, 25 Jul 2023 12:43:15 +0200
Message-ID: <20230725104515.986422469@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mark Brown <broonie@kernel.org>

commit bc64734825c59e18a27ac266b07e14944c111fd8 upstream.

When problems were noticed with the register address not being taken
into account when limiting raw transfers with I2C devices we fixed this
in the core.  Unfortunately it has subsequently been realised that a lot
of buses were relying on the prior behaviour, partly due to unclear
documentation not making it obvious what was intended in the core.  This
is all more involved to fix than is sensible for a fix commit so let's
just drop the original fixes, a separate commit will fix the originally
observed problem in an I2C specific way

Fixes: 3981514180c9 ("regmap: Account for register length when chunking")
Fixes: c8e796895e23 ("regmap: spi-avmm: Fix regmap_bus max_raw_write")
Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Xu Yilun <yilun.xu@intel.com>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20230712-regmap-max-transfer-v1-1-80e2aed22e83@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/regmap/regmap-spi-avmm.c |    2 +-
 drivers/base/regmap/regmap.c          |    6 ++----
 2 files changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/base/regmap/regmap-spi-avmm.c
+++ b/drivers/base/regmap/regmap-spi-avmm.c
@@ -660,7 +660,7 @@ static const struct regmap_bus regmap_sp
 	.reg_format_endian_default = REGMAP_ENDIAN_NATIVE,
 	.val_format_endian_default = REGMAP_ENDIAN_NATIVE,
 	.max_raw_read = SPI_AVMM_VAL_SIZE * MAX_READ_CNT,
-	.max_raw_write = SPI_AVMM_REG_SIZE + SPI_AVMM_VAL_SIZE * MAX_WRITE_CNT,
+	.max_raw_write = SPI_AVMM_VAL_SIZE * MAX_WRITE_CNT,
 	.free_context = spi_avmm_bridge_ctx_free,
 };
 
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -2082,8 +2082,6 @@ int _regmap_raw_write(struct regmap *map
 	size_t val_count = val_len / val_bytes;
 	size_t chunk_count, chunk_bytes;
 	size_t chunk_regs = val_count;
-	size_t max_data = map->max_raw_write - map->format.reg_bytes -
-			map->format.pad_bytes;
 	int ret, i;
 
 	if (!val_count)
@@ -2091,8 +2089,8 @@ int _regmap_raw_write(struct regmap *map
 
 	if (map->use_single_write)
 		chunk_regs = 1;
-	else if (map->max_raw_write && val_len > max_data)
-		chunk_regs = max_data / val_bytes;
+	else if (map->max_raw_write && val_len > map->max_raw_write)
+		chunk_regs = map->max_raw_write / val_bytes;
 
 	chunk_count = val_count / chunk_regs;
 	chunk_bytes = chunk_regs * val_bytes;


