Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4735F2F37;
	Tue,  8 Jul 2025 16:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993273; cv=none; b=iHOt5KQGpopb8GsHzXLQzwbsSVMGuCC6c0qEgh+kyAejzosMcNIwHrRwRc9QZd7ZrGJxjfGjszMrq+rkM++ivbDUKY1K5dO2St9HpAPfqPYaCSsLWLACrp/LmZ8BXRt2MTkWV+1Rkfdmmp6fpS2K0jyHVbrUaxwfIQ9QKndRoNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993273; c=relaxed/simple;
	bh=k9HZ5sTcf28S6qbuajTwnMdC1lM8FLzyPP4U0i3xF/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ol83pSu1K/fiVfqvg6HNT0RXvwPTIXrXrVimkpvaDmvdohoacF8N+W6MRQXQOKGnF3abXavL05jsKIDW5mUlYcQqmG1iWyyo8R1MX4Yevthv+kqWF9aY7cy1Bs9khFhY1smoRaqtcJUhZW1TuJFyWaSWZR+OcbG6uEX1dFXAfQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KZ2Dp19Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KZ2Dp19Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF6BC4CEED;
	Tue,  8 Jul 2025 16:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993273;
	bh=k9HZ5sTcf28S6qbuajTwnMdC1lM8FLzyPP4U0i3xF/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KZ2Dp19YbUMxqKhNYEKFjssgaA0sfIcxD6dAZ19Jt0gySQz9tJZ5kqGCkDDeGcKXJ
	 R86qQ8MIxuC0ZXV/BVkPgp4eRS3z5RqSeuE4zn51wx0nF+G0XPzIl9EIT62Kc+36SP
	 ftpMwlT6+WH6q3q6zU87Yt7iOay/oCTAxo54I6Jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avri Altman <avri.altman@sandisk.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.15 018/178] mmc: core: sd: Apply BROKEN_SD_DISCARD quirk earlier
Date: Tue,  8 Jul 2025 18:20:55 +0200
Message-ID: <20250708162237.025471192@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
 


