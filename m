Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35222E041C;
	Tue,  8 Jul 2025 16:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992660; cv=none; b=hupSJaEKA/Nn+eZt5bb5gmw6MgqdvcigpEFmt2OaNmQiE57IIYa+4ORJgoyLKloOMMcHmXD2dBkDyTaGHspC6+C/Gcv/4MaKYxH4Dqvr/9h8SsBsBdcEXcvJ528P+GziZv399/UkPwKIIij+q48/lt8H5kYpyLikUHZrrQ+gCSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992660; c=relaxed/simple;
	bh=mTT3Y/+6aRBBWEMtaKUDL9ZAIZIJcz6NgMOceqKV4pQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H/Cu+fqE/LfAE9bRpkXX791FKGJEy+FdGV5PZXKXFfwAkFRCrzBc86mv6AEEvzLK6OsQRacGkHQ8laefJwwaWa604sFVYpuuyUYy+oREZMM4NSaCetCcFqjOMHDkighFXUxtIXFtEazTnnxwbPlduWwAdqHYn73TbS7w1E+nlhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rfZ78RYG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rfZ78RYG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 312F2C4CEED;
	Tue,  8 Jul 2025 16:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992659;
	bh=mTT3Y/+6aRBBWEMtaKUDL9ZAIZIJcz6NgMOceqKV4pQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rfZ78RYGKWfxuTb1dFHBHtPOuPIa3e67V4/ByvwRqXgzkYnlX1ufO7EtB8qUSS5/R
	 qTwmAVYYvlzNzqoc31DDGRSF/N+VPm/2kBViCjWW8C/EFWGs+esVQPtYwEWWm3c4uj
	 AIEEE3hdrugEfT7x3PPPtgWlogEas+peEzbzWEi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avri Altman <avri.altman@sandisk.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.12 013/232] mmc: core: sd: Apply BROKEN_SD_DISCARD quirk earlier
Date: Tue,  8 Jul 2025 18:20:09 +0200
Message-ID: <20250708162241.781792465@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avri Altman <avri.altman@sandisk.com>

commit 009c3a4bc41e855fd76f92727f9fbae4e5917d7f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/quirks.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/mmc/core/quirks.h
+++ b/drivers/mmc/core/quirks.h
@@ -44,6 +44,12 @@ static const struct mmc_fixup __maybe_un
 		   0, -1ull, SDIO_ANY_ID, SDIO_ANY_ID, add_quirk_sd,
 		   MMC_QUIRK_NO_UHS_DDR50_TUNING, EXT_CSD_REV_ANY),
 
+	/*
+	 * Some SD cards reports discard support while they don't
+	 */
+	MMC_FIXUP(CID_NAME_ANY, CID_MANFID_SANDISK_SD, 0x5344, add_quirk_sd,
+		  MMC_QUIRK_BROKEN_SD_DISCARD),
+
 	END_FIXUP
 };
 
@@ -147,12 +153,6 @@ static const struct mmc_fixup __maybe_un
 	MMC_FIXUP("M62704", CID_MANFID_KINGSTON, 0x0100, add_quirk_mmc,
 		  MMC_QUIRK_TRIM_BROKEN),
 
-	/*
-	 * Some SD cards reports discard support while they don't
-	 */
-	MMC_FIXUP(CID_NAME_ANY, CID_MANFID_SANDISK_SD, 0x5344, add_quirk_sd,
-		  MMC_QUIRK_BROKEN_SD_DISCARD),
-
 	END_FIXUP
 };
 


