Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50B23E008C;
	Fri, 15 May 2026 16:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861614; cv=none; b=PlMvO+Sh09CR1+rQA3rX3iXKGuCevMPCihNuBerrMDTQ+3+VdZqT6dorzBKhkdkv5NYzVzdJJSDIx2VgJiN7XoPWPnxhksTaDoIih1+BX4kB+OIK3WKnhUzegGkaqDHynLqhDr9OwewIZVkcJdTCr3styxsjA+n/n2WNxEpbV7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861614; c=relaxed/simple;
	bh=eEsfv3YqyeKh9umxlp5QNGnVcguT4X7OSf9RlS7hrU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TiWvudvZnjIgQp0RWobo92+zDkzWLrjfV0iQYpGPSLrGEGeeSNSZPRG51G2hYBMm0DtPZ4864IfjWycf+GBLs+7SRNpi34gg5QMtgtbQMZRWvwaZUGaXXp1Aw2qufVMAMr3xUVak0bS324nwzLVcPK0Mt/wg6+4ZnH1bqEnvPe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=No5DG8Ze; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="No5DG8Ze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BFE8C2BCB3;
	Fri, 15 May 2026 16:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861613;
	bh=eEsfv3YqyeKh9umxlp5QNGnVcguT4X7OSf9RlS7hrU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=No5DG8ZeMb+FmiuPR9kuk83VFws0R43iv4oxs64Pab0ZcukC+Ga6wYyojxDfKhnrq
	 VBYoJxDv86kGn+9l/30M3/RalBhTUP1ltkIRxXQJgmvgdnCqEvpH7w+dNrkBNwiBj4
	 MhM1wmVn5jZDdudqqBngJT40/d0LERFCbbPrd7nY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luke Wang <ziniu.wang_1@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 397/474] mmc: core: Optimize time for secure erase/trim for some Kingston eMMCs
Date: Fri, 15 May 2026 17:48:26 +0200
Message-ID: <20260515154723.637015300@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

From: Luke Wang <ziniu.wang_1@nxp.com>

[ Upstream commit d6bf2e64dec87322f2b11565ddb59c0e967f96e3 ]

Kingston eMMC IY2964 and IB2932 takes a fixed ~2 seconds for each secure
erase/trim operation regardless of size - that is, a single secure
erase/trim operation of 1MB takes the same time as 1GB. With default
calculated 3.5MB max discard size, secure erase 1GB requires ~300 separate
operations taking ~10 minutes total.

Add a card quirk, MMC_QUIRK_FIXED_SECURE_ERASE_TRIM_TIME, to set maximum
secure erase size for those devices. This allows 1GB secure erase to
complete in a single operation, reducing time from 10 minutes to just 2
seconds.

Signed-off-by: Luke Wang <ziniu.wang_1@nxp.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
[ adapted `lim->max_secure_erase_sectors =` assignment to `blk_queue_max_secure_erase_sectors(q, ...)` setter and used pre-rename `mmc_can_secure_erase_trim`/`mmc_can_trim` helpers ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/card.h   |    5 +++++
 drivers/mmc/core/queue.c  |    8 ++++++--
 drivers/mmc/core/quirks.h |    9 +++++++++
 include/linux/mmc/card.h  |    1 +
 4 files changed, 21 insertions(+), 2 deletions(-)

--- a/drivers/mmc/core/card.h
+++ b/drivers/mmc/core/card.h
@@ -297,4 +297,9 @@ static inline int mmc_card_no_uhs_ddr50_
 	return c->quirks & MMC_QUIRK_NO_UHS_DDR50_TUNING;
 }
 
+static inline int mmc_card_fixed_secure_erase_trim_time(const struct mmc_card *c)
+{
+	return c->quirks & MMC_QUIRK_FIXED_SECURE_ERASE_TRIM_TIME;
+}
+
 #endif
--- a/drivers/mmc/core/queue.c
+++ b/drivers/mmc/core/queue.c
@@ -188,8 +188,12 @@ static void mmc_queue_setup_discard(stru
 	/* granularity must not be greater than max. discard */
 	if (card->pref_erase > max_discard)
 		q->limits.discard_granularity = SECTOR_SIZE;
-	if (mmc_can_secure_erase_trim(card))
-		blk_queue_max_secure_erase_sectors(q, max_discard);
+	if (mmc_can_secure_erase_trim(card)) {
+		if (mmc_card_fixed_secure_erase_trim_time(card))
+			blk_queue_max_secure_erase_sectors(q, UINT_MAX >> card->erase_shift);
+		else
+			blk_queue_max_secure_erase_sectors(q, max_discard);
+	}
 	if (mmc_can_trim(card) && card->erased_byte == 0)
 		blk_queue_max_write_zeroes_sectors(q, max_discard);
 }
--- a/drivers/mmc/core/quirks.h
+++ b/drivers/mmc/core/quirks.h
@@ -153,6 +153,15 @@ static const struct mmc_fixup __maybe_un
 	MMC_FIXUP("M62704", CID_MANFID_KINGSTON, 0x0100, add_quirk_mmc,
 		  MMC_QUIRK_TRIM_BROKEN),
 
+	/*
+	 * On Some Kingston eMMCs, secure erase/trim time is independent
+	 * of erase size, fixed at approximately 2 seconds.
+	 */
+	MMC_FIXUP("IY2964", CID_MANFID_KINGSTON, 0x0100, add_quirk_mmc,
+		  MMC_QUIRK_FIXED_SECURE_ERASE_TRIM_TIME),
+	MMC_FIXUP("IB2932", CID_MANFID_KINGSTON, 0x0100, add_quirk_mmc,
+		  MMC_QUIRK_FIXED_SECURE_ERASE_TRIM_TIME),
+
 	END_FIXUP
 };
 
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -298,6 +298,7 @@ struct mmc_card {
 #define MMC_QUIRK_BROKEN_CACHE_FLUSH	(1<<16)	/* Don't flush cache until the write has occurred */
 #define MMC_QUIRK_BROKEN_SD_POWEROFF_NOTIFY	(1<<17) /* Disable broken SD poweroff notify support */
 #define MMC_QUIRK_NO_UHS_DDR50_TUNING	(1<<18) /* Disable DDR50 tuning */
+#define MMC_QUIRK_FIXED_SECURE_ERASE_TRIM_TIME	(1<<20) /* Secure erase/trim time is fixed regardless of size */
 
 	bool			written_flag;	/* Indicates eMMC has been written since power on */
 	bool			reenable_cmdq;	/* Re-enable Command Queue */


