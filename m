Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5577014F9E
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:50:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A079C433CD;
	Wed,  9 Aug 2023 10:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578234;
	bh=IVLw9HovPgCuV1Tf/77/xhoIXai5GRjBQEuDX77P+64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b6wb8H27/ZWahmHGjmwxb1wfykxsnVrJ0Yw3qrVjLwHoY23v1mY+AIjtES0qWYQg/
	 mlLs7O30NpWYHkzZIBAXoEoKFMZDUHou3xVGoh85qyqHUq3ISbjnRDIzOFf3QNqjoH
	 W+nr+zjwqwTnXt+VdGhRsaJ7D7eS/aE99hB9SMmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Foley <pefoley2@pefoley.com>,
	Pedro Falcato <pedro.falcato@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Mark Brown <broonie@kernel.org>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 152/165] mtd: spi-nor: avoid holes in struct spi_mem_op
Date: Wed,  9 Aug 2023 12:41:23 +0200
Message-ID: <20230809103647.751896668@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 71c8f9cf2623d0db79665f876b95afcdd8214aec ]

gcc gets confused when -ftrivial-auto-var-init=pattern is used on sparse
bit fields such as 'struct spi_mem_op', which caused the previous false
positive warning about an uninitialized variable:

drivers/mtd/spi-nor/spansion.c: error: 'op' is used uninitialized [-Werror=uninitialized]

In fact, the variable is fully initialized and gcc does not see it being
used, so the warning is entirely bogus. The problem appears to be
a misoptimization in the initialization of single bit fields when the
rest of the bytes are not initialized.

A previous workaround added another initialization, which ended up
shutting up the warning in spansion.c, though it apparently still happens
in other files as reported by Peter Foley in the gcc bugzilla. The
workaround of adding a fake initialization seems particularly bad
because it would set values that can never be correct but prevent the
compiler from warning about actually missing initializations.

Revert the broken workaround and instead pad the structure to only
have bitfields that add up to full bytes, which should avoid this
behavior in all drivers.

I also filed a new bug against gcc with what I found, so this can
hopefully be addressed in future gcc releases. At the moment, only
gcc-12 and gcc-13 are affected.

Cc: Peter Foley <pefoley2@pefoley.com>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=110743
Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=108402
Link: https://godbolt.org/z/efMMsG1Kx
Fixes: 420c4495b5e56 ("mtd: spi-nor: spansion: make sure local struct does not contain garbage")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Mark Brown <broonie@kernel.org>
Acked-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20230719190045.4007391-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/spansion.c | 4 ++--
 include/linux/spi/spi-mem.h    | 4 ++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/spi-nor/spansion.c b/drivers/mtd/spi-nor/spansion.c
index 36876aa849ede..15f9a80c10b9b 100644
--- a/drivers/mtd/spi-nor/spansion.c
+++ b/drivers/mtd/spi-nor/spansion.c
@@ -361,7 +361,7 @@ static int cypress_nor_determine_addr_mode_by_sr1(struct spi_nor *nor,
  */
 static int cypress_nor_set_addr_mode_nbytes(struct spi_nor *nor)
 {
-	struct spi_mem_op op = {};
+	struct spi_mem_op op;
 	u8 addr_mode;
 	int ret;
 
@@ -492,7 +492,7 @@ s25fs256t_post_bfpt_fixup(struct spi_nor *nor,
 			  const struct sfdp_parameter_header *bfpt_header,
 			  const struct sfdp_bfpt *bfpt)
 {
-	struct spi_mem_op op = {};
+	struct spi_mem_op op;
 	int ret;
 
 	ret = cypress_nor_set_addr_mode_nbytes(nor);
diff --git a/include/linux/spi/spi-mem.h b/include/linux/spi/spi-mem.h
index 8e984d75f5b6c..6b0a7dc48a4b7 100644
--- a/include/linux/spi/spi-mem.h
+++ b/include/linux/spi/spi-mem.h
@@ -101,6 +101,7 @@ struct spi_mem_op {
 		u8 nbytes;
 		u8 buswidth;
 		u8 dtr : 1;
+		u8 __pad : 7;
 		u16 opcode;
 	} cmd;
 
@@ -108,6 +109,7 @@ struct spi_mem_op {
 		u8 nbytes;
 		u8 buswidth;
 		u8 dtr : 1;
+		u8 __pad : 7;
 		u64 val;
 	} addr;
 
@@ -115,12 +117,14 @@ struct spi_mem_op {
 		u8 nbytes;
 		u8 buswidth;
 		u8 dtr : 1;
+		u8 __pad : 7;
 	} dummy;
 
 	struct {
 		u8 buswidth;
 		u8 dtr : 1;
 		u8 ecc : 1;
+		u8 __pad : 6;
 		enum spi_mem_data_dir dir;
 		unsigned int nbytes;
 		union {
-- 
2.40.1



