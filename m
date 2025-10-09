Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A052F3C03;
	Thu,  9 Oct 2025 15:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025597; cv=none; b=mrGusU9vDlZ3Lg/fCTL/qGyrOfsk3cQNyXCvNUigB/kqn7eW06OKN8mAzyS1PLR4AzDoF4ivUX5EwVtWzmCINDS47Endw10lrL2gZ+EdEHej/VsHLu8wOXssC2genTjL1yu6G+rMvPIJ9tqoPamZpotoKnifOX8Fo9pdSPsONXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025597; c=relaxed/simple;
	bh=WLdmCNtYS0oVxQKnJ3+KGrYys0exaEebQlzllpyVNzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MlkVeA/QBTc9NI4aLP1qVkCgI4JnI1lgRphjlcUaHESetUm1kjB8oRTLfHtsomS/n9vUP4No+6uqPissJGTzEyQYS39mtfp58VhKjCf2FlA3MijHAlsE3cuRTI7V7DUSQITl4WCYKozcguDN48sx4VWwhSfRmFHrOkn0nVEDH+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uWUKieIm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uWUKieIm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF2A2C4CEF7;
	Thu,  9 Oct 2025 15:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025597;
	bh=WLdmCNtYS0oVxQKnJ3+KGrYys0exaEebQlzllpyVNzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uWUKieImLex8WslorkP72hUvqvIkaDGcOan0RYCb3E8Q5rV3Nk2R5vBfqv5WjeGfW
	 epaxDcROLfVvpdJSkxmABJgqwidq7c75aqvFT/l358Xue6NT5TOhmIfUS5jexf5FDP
	 VOD3d077BFa9HzIJ0YrhhLp1KMjmckwXD2ZgPUkhfcv4BS36XGhiBoqpGrr7zerIEx
	 p+b62kQ7G7xUNsiwK9bJz2Hpn9CuhLllCYCnydShnHDzRPklo26rWYCq8gnL82HSD1
	 JLOKiTpiMl3DaU0cmY9t9IIZF6oK9BuUohKbJM3xZgFULrwx1PimbESsyqrfmCRNlJ
	 zalqMP3uadq7Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jens Kehne <jens.kehne@agilent.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	support.opensource@diasemi.com
Subject: [PATCH AUTOSEL 6.17-5.10] mfd: da9063: Split chip variant reading in two bus transactions
Date: Thu,  9 Oct 2025 11:55:32 -0400
Message-ID: <20251009155752.773732-66-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251009155752.773732-1-sashal@kernel.org>
References: <20251009155752.773732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jens Kehne <jens.kehne@agilent.com>

[ Upstream commit 9ac4890ac39352ccea132109e32911495574c3ec ]

We observed the initial probe of the da9063 failing in
da9063_get_device_type in about 30% of boots on a Xilinx ZynqMP based
board. The problem originates in da9063_i2c_blockreg_read, which uses
a single bus transaction to turn the register page and then read a
register. On the bus, this should translate to a write to register 0,
followed by a read to the target register, separated by a repeated
start. However, we found that after the write to register 0, the
controller sometimes continues directly with the register address of
the read request, without sending the chip address or a repeated start
in between, which makes the read request invalid.

To fix this, separate turning the page and reading the register into
two separate transactions. This brings the initialization code in line
with the rest of the driver, which uses register maps (which to my
knowledge do not use repeated starts after turning the page). This has
been included in our kernel for several months and was recently
included in a shipped product. For us, it reliably fixes the issue,
and we have not observed any new issues.

While the underlying problem is probably with the i2c controller or
its driver, I still propose a change here in the interest of
robustness: First, I'm not sure this issue can be fixed on the
controller side, since there are other issues related to repeated
start which can't (AR# 60695, AR# 61664). Second, similar problems
might exist with other controllers.

Signed-off-by: Jens Kehne <jens.kehne@agilent.com>
Link: https://lore.kernel.org/r/20250804133754.3496718-1-jens.kehne@agilent.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - Addresses intermittent probe failures (~30% boots) during early chip
    identification reads on some I2C controllers (e.g., ZynqMP) where a
    combined transaction with a repeated start is mishandled, causing
    the read to be invalid. This is a user‑visible reliability bug in
    device bring‑up, not a feature change.

- Precise change
  - Adds a separate 1‑message transfer for page selection, then a
    2‑message transfer for register address + read:
    - New `da9063_page_sel_msgs` for the standalone page select
      transfer: drivers/mfd/da9063-i2c.c:40–43
    - Adjusts `da9063_paged_read_msgs` to start at the register select
      phase: drivers/mfd/da9063-i2c.c:45–49
    - First transaction (page switch): set up
      `xfer[DA9063_PAGE_SEL_MSG]` then call `i2c_transfer(...,
      DA9063_PAGE_SEL_CNT)` with robust error checks:
      drivers/mfd/da9063-i2c.c:71–86
    - Second transaction (register select + read): set up
      `xfer[DA9063_PAGED_READ_MSG_REG_SEL]` and
      `xfer[DA9063_PAGED_READ_MSG_DATA]`, then `i2c_transfer(...,
      DA9063_PAGED_READ_MSG_CNT)`: drivers/mfd/da9063-i2c.c:88–111
  - The only user of this helper is the early device/variant read in
    `da9063_get_device_type()`: drivers/mfd/da9063-i2c.c:125–131

- Why this is safer
  - Many I2C controllers have quirks with repeated starts across a
    write‑then‑read sequence targeting different internal device
    behaviors (here, page register write followed by a read). Splitting
    the sequence issues a STOP between page switch and read address
    selection, avoiding controller bugs while remaining compliant with
    the device’s register paging model.
  - Matches how the rest of the driver operates via regmap, which uses
    page windows and does not rely on a repeated start immediately after
    page switching (see `selector_reg = DA9063_REG_PAGE_CON` and range
    config): drivers/mfd/da9063-i2c.c:341–351

- Scope and risk
  - Change is small, self‑contained to one function used only during
    probe; no architectural changes.
  - Adds clearer error logging for page switch failures without altering
    normal data paths.
  - Potential concern (atomicity between page set and read) is minimal
    here: this path runs during probe, before other clients of the
    device exist; typical single‑master systems are unaffected. Even on
    multi‑master, the benefit of avoiding known controller bugs
    outweighs the negligible race risk at probe time.

- Backport considerations
  - Older stable trees (e.g., v6.10, v6.6, v6.1) still use the single
    `i2c_transfer` with 3 messages for this path; applying this patch is
    straightforward and does not depend on other recent infrastructure
    changes. The change only introduces a new small enum and splits the
    existing message sequence with added error checks.
  - No ABI changes, no feature additions, no cross‑subsystem
    dependencies.

- Stable policy fit
  - Fixes a real, observed boot‑time reliability bug.
  - Minimal, localized patch with low regression risk.
  - No new features or behavior changes beyond making the transaction
    sequence more robust.
  - Although there’s no explicit “Cc: stable”, the nature and scope make
    it an appropriate stable backport.

 drivers/mfd/da9063-i2c.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/da9063-i2c.c b/drivers/mfd/da9063-i2c.c
index c6235cd0dbdc4..1ec9ab56442df 100644
--- a/drivers/mfd/da9063-i2c.c
+++ b/drivers/mfd/da9063-i2c.c
@@ -37,9 +37,13 @@ enum da9063_page_sel_buf_fmt {
 	DA9063_PAGE_SEL_BUF_SIZE,
 };
 
+enum da9063_page_sel_msgs {
+	DA9063_PAGE_SEL_MSG = 0,
+	DA9063_PAGE_SEL_CNT,
+};
+
 enum da9063_paged_read_msgs {
-	DA9063_PAGED_READ_MSG_PAGE_SEL = 0,
-	DA9063_PAGED_READ_MSG_REG_SEL,
+	DA9063_PAGED_READ_MSG_REG_SEL = 0,
 	DA9063_PAGED_READ_MSG_DATA,
 	DA9063_PAGED_READ_MSG_CNT,
 };
@@ -65,10 +69,21 @@ static int da9063_i2c_blockreg_read(struct i2c_client *client, u16 addr,
 		(page_num << DA9063_I2C_PAGE_SEL_SHIFT) & DA9063_REG_PAGE_MASK;
 
 	/* Write reg address, page selection */
-	xfer[DA9063_PAGED_READ_MSG_PAGE_SEL].addr = client->addr;
-	xfer[DA9063_PAGED_READ_MSG_PAGE_SEL].flags = 0;
-	xfer[DA9063_PAGED_READ_MSG_PAGE_SEL].len = DA9063_PAGE_SEL_BUF_SIZE;
-	xfer[DA9063_PAGED_READ_MSG_PAGE_SEL].buf = page_sel_buf;
+	xfer[DA9063_PAGE_SEL_MSG].addr = client->addr;
+	xfer[DA9063_PAGE_SEL_MSG].flags = 0;
+	xfer[DA9063_PAGE_SEL_MSG].len = DA9063_PAGE_SEL_BUF_SIZE;
+	xfer[DA9063_PAGE_SEL_MSG].buf = page_sel_buf;
+
+	ret = i2c_transfer(client->adapter, xfer, DA9063_PAGE_SEL_CNT);
+	if (ret < 0) {
+		dev_err(&client->dev, "Page switch failed: %d\n", ret);
+		return ret;
+	}
+
+	if (ret != DA9063_PAGE_SEL_CNT) {
+		dev_err(&client->dev, "Page switch failed to complete\n");
+		return -EIO;
+	}
 
 	/* Select register address */
 	xfer[DA9063_PAGED_READ_MSG_REG_SEL].addr = client->addr;
-- 
2.51.0

