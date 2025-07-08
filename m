Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FDAA1E492;
	Tue,  8 Jul 2025 17:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994210; cv=none; b=ikML00NPYEsL2h67CQSSzANETBih/XXAxZppoRof9JWpPhn/rtlXtuGretuWPEE8nXsxswMyxfMCMQTQRbMY2Tx+dMykYiC6H62/voP08SuEeLnVVT2s/+r3LPxnHsRc8xz3O7CUNB/GnsP3KY8TuUN3IC2S03WAZEAK3kf1AWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994210; c=relaxed/simple;
	bh=7Lv2XjQ78P7yfK81Wf5HDja2y9A36bZKFvZFiQ2K45c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fOeLHeT0aT0wdqMtU2lJXaTmjJCKerOeg4IUyigvwuXqKiKGpDYVq4oT/IIVWzcRYCERTbva0jZyNd6aj+/B2O1T9qMgBu6dZ+8X/fKd+I+zVU4Fu42ffjlRzV7U96Sc9jjemNZUdedZ3FJq4bKkX+ReYN/LgKIyu6pMb82Lfng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XT6lz8Hr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XT6lz8Hr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E905C4CEED;
	Tue,  8 Jul 2025 17:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751994210;
	bh=7Lv2XjQ78P7yfK81Wf5HDja2y9A36bZKFvZFiQ2K45c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XT6lz8HrMjla/YGL8fZfI9attzEa0CIdOElv1Kw6HbKJM9jon/WFb9fVifiwczRW5
	 nzhDPMjLItsrqGm5i2YefqIZ0bIw/HRiezB243zCayovQ3xg7KTmwKDUqTLBdbPFG/
	 xXPzFYmrReZC8OYq8PKsaQTLu1cyPw8ujBVF8Iu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avri Altman <avri.altman@sandisk.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 137/160] mmc: core: sd: Apply BROKEN_SD_DISCARD quirk earlier
Date: Tue,  8 Jul 2025 18:22:54 +0200
Message-ID: <20250708162235.174239219@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avri Altman <avri.altman@sandisk.com>

[ Upstream commit 009c3a4bc41e855fd76f92727f9fbae4e5917d7f ]

Move the BROKEN_SD_DISCARD quirk for certain SanDisk SD cards from the
`mmc_blk_fixups[]` to `mmc_sd_fixups[]`. This ensures the quirk is
applied earlier in the device initialization process, aligning with the
reasoning in [1]. Applying the quirk sooner prevents the kernel from
incorrectly enabling discard support on affected cards during initial
setup.

[1] https://lore.kernel.org/all/20240820230631.GA436523@sony.com

Fixes: 07d2872bf4c8 ("mmc: core: Add SD card quirk for broken discard")
Signed-off-by: Avri Altman <avri.altman@sandisk.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250526114445.675548-1-avri.altman@sandisk.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/quirks.h | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/core/quirks.h b/drivers/mmc/core/quirks.h
index afe8d8c5fa8a2..2920633e2ae1e 100644
--- a/drivers/mmc/core/quirks.h
+++ b/drivers/mmc/core/quirks.h
@@ -14,6 +14,15 @@
 
 #include "card.h"
 
+static const struct mmc_fixup __maybe_unused mmc_sd_fixups[] = {
+	/*
+	 * Some SD cards reports discard support while they don't
+	 */
+	MMC_FIXUP(CID_NAME_ANY, CID_MANFID_SANDISK_SD, 0x5344, add_quirk_sd,
+		  MMC_QUIRK_BROKEN_SD_DISCARD),
+
+	END_FIXUP
+};
 static const struct mmc_fixup __maybe_unused mmc_blk_fixups[] = {
 #define INAND_CMD38_ARG_EXT_CSD  113
 #define INAND_CMD38_ARG_ERASE    0x00
@@ -112,13 +121,6 @@ static const struct mmc_fixup __maybe_unused mmc_blk_fixups[] = {
 	 */
 	MMC_FIXUP("Q2J54A", CID_MANFID_MICRON, 0x014e, add_quirk_mmc,
 		  MMC_QUIRK_TRIM_BROKEN),
-
-	/*
-	 * Some SD cards reports discard support while they don't
-	 */
-	MMC_FIXUP(CID_NAME_ANY, CID_MANFID_SANDISK_SD, 0x5344, add_quirk_sd,
-		  MMC_QUIRK_BROKEN_SD_DISCARD),
-
 	END_FIXUP
 };
 
-- 
2.39.5



