Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533633502A7;
	Tue, 12 May 2026 18:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609731; cv=none; b=VHqBs9rKPrtzfeDGe0p2XVF+KJfkVpd7b+FyFnDLMnM5/I+gyCu91zpISZAr2m2X08hDNMBdK14ljPx08ROxwrYJD+a2eMVphFk1s39AdpjyI7/bhAsQUrnrsMbSWssP11C57nKuh+1tgzx/SbfcIOT+YCxJycPFocvPuk9djGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609731; c=relaxed/simple;
	bh=1/bferi5Gvu3mk/nz8kJkioY2OivZTSuY1EPs8GqdHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mRq1AxHnqLcDNpO+QVaK332eCXlfLJFrIRRZrHoVW7624hOJf1dZygc192oM6wF4R5/Rw4sRsSxDnRIwiwh2hX+O+7wxFGFBxnIhbYUL/3r8p63IAT6iLKDnHjYEkYbturi/pIpqTccuHKsHjUX5NpE2W9nlIy67n/dRJMNfXRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f7cNK2VE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f7cNK2VE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABAAEC2BCB0;
	Tue, 12 May 2026 18:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609731;
	bh=1/bferi5Gvu3mk/nz8kJkioY2OivZTSuY1EPs8GqdHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f7cNK2VEXTpT6+/ossZqUl7aWJ3S4HqsfAO8/otOrCLHBmTkAKjc8VOOQ1YTahsAK
	 3Db/tUAqChvSJqsQ8G7A6MQmqlzDSbCmQkS972G6pMAKcZXqFy4Y4IeIxaugIgKbW2
	 AtTBS0sUxYlv0H3UeMmKfdq3CXpXz5QnULUvc9i4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avri Altman <avri.altman@sandisk.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 294/307] mmc: core: Add quirk for incorrect manufacturing date
Date: Tue, 12 May 2026 19:41:29 +0200
Message-ID: <20260512173946.331671269@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avri Altman <avri.altman@sandisk.com>

[ Upstream commit 263ff314cc5602599d481b0912a381555fcbad28 ]

Some eMMC vendors need to report manufacturing dates beyond 2025 but are
reluctant to update the EXT_CSD revision from 8 to 9. Changing the
Updating the EXT_CSD revision may involve additional testing or
qualification steps with customers. To ease this transition and avoid a
full re-qualification process, a workaround is needed. This
patch introduces a temporary quirk that re-purposes the year codes
corresponding to 2010, 2011, and 2012 to represent the years 2026, 2027,
and 2028, respectively. This solution is only valid for this three-year
period.

After 2028, vendors must update their firmware to set EXT_CSD_REV=9 to
continue reporting the correct manufacturing date in compliance with the
JEDEC standard.

The `MMC_QUIRK_BROKEN_MDT` is introduced and enabled for all Sandisk
devices to handle this behavior.

Signed-off-by: Avri Altman <avri.altman@sandisk.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: d6bf2e64dec8 ("mmc: core: Optimize time for secure erase/trim for some Kingston eMMCs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/card.h   |    6 ++++++
 drivers/mmc/core/mmc.c    |    5 +++++
 drivers/mmc/core/quirks.h |    3 +++
 include/linux/mmc/card.h  |    1 +
 4 files changed, 15 insertions(+)

--- a/drivers/mmc/core/card.h
+++ b/drivers/mmc/core/card.h
@@ -89,6 +89,7 @@ struct mmc_fixup {
 #define CID_MANFID_MICRON       0x13
 #define CID_MANFID_SAMSUNG      0x15
 #define CID_MANFID_APACER       0x27
+#define CID_MANFID_SANDISK_MMC  0x45
 #define CID_MANFID_SWISSBIT     0x5D
 #define CID_MANFID_KINGSTON     0x70
 #define CID_MANFID_HYNIX	0x90
@@ -305,4 +306,9 @@ static inline int mmc_card_no_uhs_ddr50_
 	return c->quirks & MMC_QUIRK_NO_UHS_DDR50_TUNING;
 }
 
+static inline int mmc_card_broken_mdt(const struct mmc_card *c)
+{
+	return c->quirks & MMC_QUIRK_BROKEN_MDT;
+}
+
 #endif
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -676,6 +676,11 @@ static int mmc_decode_ext_csd(struct mmc
 			/* Adjust production date as per JEDEC JESD84-B51B September 2025 */
 			if (card->cid.year < 2023)
 				card->cid.year += 16;
+		} else {
+			/* Handle vendors with broken MDT reporting */
+			if (mmc_card_broken_mdt(card) && card->cid.year >= 2010 &&
+			    card->cid.year <= 2012)
+				card->cid.year += 16;
 		}
 	}
 
--- a/drivers/mmc/core/quirks.h
+++ b/drivers/mmc/core/quirks.h
@@ -170,6 +170,9 @@ static const struct mmc_fixup __maybe_un
 	MMC_FIXUP_EXT_CSD_REV(CID_NAME_ANY, CID_MANFID_NUMONYX,
 			      0x014e, add_quirk, MMC_QUIRK_BROKEN_HPI, 6),
 
+	MMC_FIXUP(CID_NAME_ANY, CID_MANFID_SANDISK_MMC, CID_OEMID_ANY, add_quirk_mmc,
+		  MMC_QUIRK_BROKEN_MDT),
+
 	END_FIXUP
 };
 
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -329,6 +329,7 @@ struct mmc_card {
 #define MMC_QUIRK_BROKEN_CACHE_FLUSH	(1<<16)	/* Don't flush cache until the write has occurred */
 #define MMC_QUIRK_BROKEN_SD_POWEROFF_NOTIFY	(1<<17) /* Disable broken SD poweroff notify support */
 #define MMC_QUIRK_NO_UHS_DDR50_TUNING	(1<<18) /* Disable DDR50 tuning */
+#define MMC_QUIRK_BROKEN_MDT    (1<<19) /* Wrong manufacturing year */
 
 	bool			written_flag;	/* Indicates eMMC has been written since power on */
 	bool			reenable_cmdq;	/* Re-enable Command Queue */


