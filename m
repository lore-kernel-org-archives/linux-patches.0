Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9E63D9DCC;
	Thu, 17 Sep 2026 18:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668408; cv=none; b=cm/MpNYei0bTsTLjee3keXTGBsWcFv42zupOKATO4ST6962ov4aLV7gMDpis0dCLPH5h6uGoQem9IOuKmNIfiLJAPYg4bKc4YvaSmJPiD6+tNgQPgQ7+HzYNJ9T9vpPIjQlDA0XaF/pstSks1Dq3cUF2zDFIUiX+1AmbnHkcFHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668408; c=relaxed/simple;
	bh=S+LQnfZDztU5pN7VAMAXxaSFeA8RADhR4w760xhEj5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JM5eJRxibiHEo/xwvv/D/UzRA6t5WDG5qxm/ussSybh6dlqO8SmyIazy5/+stkSOiKukRCy8DPrC+GEwgmq++KqMPEjj3tNKsvrGDY7dLFICj7sdbgW6PCvhr/NTVORKcRsHH/rcMQmHPSSTZHZdR/NStN52CH9Epd04uHsZr0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vzx0NDE/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vzx0NDE/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C3271F000FF;
	Thu, 17 Sep 2026 18:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668407;
	bh=KBZXIVLiP4t5u0uFoXYZH0uFVqke9Q0FfO2bQqn/w+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vzx0NDE/a5EU0nz+qRywMlcRQ95fQHM7TtjbzxSNfAeeaTkH+FeUPu3PVnI0Kd0U7
	 /d1rd4DEA6/ixT5QX4dlESFo+Zpon5OCkQNpKJ1HgvuwGrt9yLdqPFgsn5AkvaefTJ
	 SEojvA6tXJZUnyLbQNzLOCDUv1bQwaXrR7+n//Q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0408/1102] ALSA: hda: cs35l56: Fail if wmfw file is missing
Date: Thu, 17 Sep 2026 16:05:51 +0100
Message-ID: <20260917151549.906559732@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 sound/pci/hda/cs35l56_hda.c | 30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

diff --git a/sound/pci/hda/cs35l56_hda.c b/sound/pci/hda/cs35l56_hda.c
index 5c0c4b79f5197..8663de44d97f7 100644
--- a/sound/pci/hda/cs35l56_hda.c
+++ b/sound/pci/hda/cs35l56_hda.c
@@ -521,20 +521,6 @@ static void cs35l56_hda_request_firmware_files(struct cs35l56_hda *cs35l56,
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
@@ -622,13 +608,15 @@ static void cs35l56_hda_fw_load(struct cs35l56_hda *cs35l56)
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



