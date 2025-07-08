Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A252E5412;
	Tue,  8 Jul 2025 16:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992212; cv=none; b=fgZwSP9sRJ25KWrbyvZ1r8mt/e1WOox1mCUxSO4z+E+JPPZLlsQKsWbKVCWCV+BPmJE3TSy/W4JD54ju2S8ua98A8JMwKmJsWhp1bn/bu8xmgtViKzR4xoodrD1IzFnnOIbbQ+dbW/pAXfPMD0KnJAGKQN8FIw5AvsjbS+wd+Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992212; c=relaxed/simple;
	bh=hgInrWKyyj+lApTTBRZvbySfcgam013YfI4A5GJgsE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UgPUZzVn23luJ0dPQQllHbC/l8Kul1OQJ1BpR9mCaDm68XRpz25MPI9jfzeqgRbn39aJtl09Yau770E6H2vpY8s+vuUXiLXU7DnTVFXwnORcANNiuIpj79n98qVRsjkS23HmKoXI8ye29yQJFGqA9KC+DU8xdzSWNX454kR0NMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cx/t7N/A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cx/t7N/A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C676C4CEED;
	Tue,  8 Jul 2025 16:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992211;
	bh=hgInrWKyyj+lApTTBRZvbySfcgam013YfI4A5GJgsE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cx/t7N/ApvziQtYZx6QYu5+M5LUcvO8Bn4z9vOB4P+GpjKiTFEOUlJc+n0Li3SSi2
	 ClOc4ZIN3Pm6zsKLBb0/QfGJZjg/sUBkjZWTJeda4nDXUqgozUsi48A3YtpkACGntp
	 9+ur0/1yLJaYJ5dtmWPs9LSB/QZyzObDFxWQLDI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avri Altman <avri.altman@sandisk.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 009/132] mmc: core: sd: Apply BROKEN_SD_DISCARD quirk earlier
Date: Tue,  8 Jul 2025 18:22:00 +0200
Message-ID: <20250708162231.027153364@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


