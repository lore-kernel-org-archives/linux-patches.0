Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B494EC647;
	Thu, 17 Sep 2026 17:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664863; cv=none; b=B+uJpViuNWoXjw0LzKVTRif7Ih+sbxjYRkFjZnv1CbGJPFrFcvCdJC/t1eB6XuVXYh9Q3cKgZB4S6wM0+AVLMRwoNZZZZmzcKjH0JmAgpqMadkL4qSg8rLMPZWu4jdraAZOM6T1qQRra7cwVDLDTdi6tS8Y2lyw/S4Krw65XxpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664863; c=relaxed/simple;
	bh=GVi6u5tS06ZvntEUK8cTL1ZuEK59mxcKiBW0LMJYWFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FJy9cUnXUWKgHjuGUS+LaSlagg3EjkMHWaRTdjBOEcvUIRW8wT1CFWewayQJcPIECW8nSIwpVEKVBNyCw92x69wkGiy+fk/xq45cgO8O/GjVrAUkg0IgoHSqmWdNlHcJ1xf1S9kUvGt0iA8aZPLtrd3Y9bPRGZkzw2rvbqa4gX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uvgryDr1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uvgryDr1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336831F000FF;
	Thu, 17 Sep 2026 17:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664861;
	bh=fv57F43j0rEs3OcHcAhTwGZ0GByD+0+yeYgwVlbUEcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uvgryDr1v4i8L+3ns3tr2cot6aZ7VTqL90CYbLcnwsRm+xcaAveq80gz9eUPTd7Fm
	 11wJTrLJK8yAIvYQY+y17M+Eez4ktYY22yCbtRcFbwMM2cvZzejW3IVqX3r4PixP8x
	 aSTfLakBqcT3Vj2Jf3NYKyf7Ag55NRKQBSB+sFcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0511/1250] ALSA: hda: cs35l56: Fail if wmfw file is missing
Date: Thu, 17 Sep 2026 16:05:06 +0100
Message-ID: <20260917151605.806748286@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 07ae060d35900977a93d4a05ec995b06c85c2552 ]

Fail cs35l56_hda_fw_load() and log an error if it didn't find a wmfw file
and the BIOS didn't patch the firmware already. Also remove a section of
code from cs35l56_hda_request_firmware_files() that attempted to find a
.bin if a .wmfw was not found.

The CS35L56 ROM can only provide default audio in SoundWire mode. A wmfw
is needed to enable I2S audio. Also none of the customer-specific .bin
files are compatible with the ROM firmware. So a .wmfw file is always
required.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20260709161211.686498-1-rf@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/side-codecs/cs35l56_hda.c | 30 +++++++---------------
 1 file changed, 9 insertions(+), 21 deletions(-)

diff --git a/sound/hda/codecs/side-codecs/cs35l56_hda.c b/sound/hda/codecs/side-codecs/cs35l56_hda.c
index 1d25fe01066ee..baf286bf7ec83 100644
--- a/sound/hda/codecs/side-codecs/cs35l56_hda.c
+++ b/sound/hda/codecs/side-codecs/cs35l56_hda.c
@@ -516,20 +516,6 @@ static void cs35l56_hda_request_firmware_files(struct cs35l56_hda *cs35l56,
 								  NULL, "bin");
 			return;
 		}
-
-		/*
-		 * Check for system-specific bin files without wmfw before
-		 * falling back to generic firmware
-		 */
-		if (amp_name)
-			cs35l56_hda_request_firmware_file(cs35l56, coeff_firmware, coeff_filename,
-							  base_name, system_name, amp_name, "bin");
-		if (!*coeff_firmware)
-			cs35l56_hda_request_firmware_file(cs35l56, coeff_firmware, coeff_filename,
-							  base_name, system_name, NULL, "bin");
-
-		if (*coeff_firmware)
-			return;
 	}
 
 	ret = cs35l56_hda_request_firmware_file(cs35l56, wmfw_firmware, wmfw_filename,
@@ -615,13 +601,15 @@ static void cs35l56_hda_fw_load(struct cs35l56_hda *cs35l56)
 					   &wmfw_firmware, &wmfw_filename,
 					   &coeff_firmware, &coeff_filename);
 
-	/*
-	 * If the BIOS didn't patch the firmware a bin file is mandatory to
-	 * enable the ASP·
-	 */
-	if (!coeff_firmware && firmware_missing) {
-		dev_err(cs35l56->base.dev, ".bin file required but not found\n");
-		goto err_fw_release;
+	/* If the BIOS didn't patch the firmware a wmfw and bin file are mandatory */
+	if (firmware_missing) {
+		if (!wmfw_firmware) {
+			dev_err(cs35l56->base.dev, ".%s file required but not found\n", "wmfw");
+			goto err_fw_release;
+		} else if (!coeff_firmware) {
+			dev_err(cs35l56->base.dev, ".%s file required but not found\n", "bin");
+			goto err_fw_release;
+		}
 	}
 
 	mutex_lock(&cs35l56->base.irq_lock);
-- 
2.53.0



