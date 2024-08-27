Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873591C57AB;
	Tue, 27 Aug 2024 15:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771298; cv=none; b=XR2AxSh0HeZKysBgTbwWnUWZPdt8wflEtwcuSPilkzOmf11//Uoe9s8Z+CCc3R8YB6qwQ20qYf9DqPc1UjRuNIVYftatwE7z0wNLnmw0qyOri0PElaP8avatETVT4dAEb2Kp4CaBULcla0lPX5qB/kfLr5rFSehxEgJqR+eY/qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771298; c=relaxed/simple;
	bh=dYtMNhw1cswOCTUGzihN0ztJQ96FDjhyRXnAEAAyYEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iwqYPFPl+nsfHX9ycC1cBcCI0JPUQwUPO+6x93nOsn5uWPFJWqzFIoFE0/r8Xz6/TK/MSjF3HRwDw75alzkS44TOxWxBDN8L+LEYUFC9t0gkFBoU0B0+bf5fFrUlvfMSSPV0HMpKqe5K+LXWaEQckpwgPsV+d9hqD3HTislCzc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bc8AaY9c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bc8AaY9c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 053F0C61074;
	Tue, 27 Aug 2024 15:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771298;
	bh=dYtMNhw1cswOCTUGzihN0ztJQ96FDjhyRXnAEAAyYEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bc8AaY9c5yWOPW/AIlql/OHdgbt/BRAuBeqciSE9F8vvQWWFJziqo8itXhLdGEIOi
	 UVDw/Oqlg8p6z/VsMbxA2fojCI4pLrbBOIwyYvfpooutn3FMd51w+bZvVEiOCEPY/v
	 MI+2+QM6/fq4kqmQNHJurob3lGVPeCfSuRRls6Wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 147/273] ALSA: hda/tas2781: Use correct endian conversion
Date: Tue, 27 Aug 2024 16:37:51 +0200
Message-ID: <20240827143839.000060908@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 829e2a23121fb36ee30ea5145c2a85199f68e2c8 ]

The data conversion is done rather by a wrong function.  We convert to
BE32, not from BE32.  Although the end result must be same, this was
complained by the compiler.

Fix the code again and align with another similar function
tas2563_apply_calib() that does already right.

Fixes: 3beddef84d90 ("ALSA: hda/tas2781: fix wrong calibrated data order")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202408141630.DiDUB8Z4-lkp@intel.com/
Link: https://patch.msgid.link/20240814100500.1944-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/tas2781_hda_i2c.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/tas2781_hda_i2c.c b/sound/pci/hda/tas2781_hda_i2c.c
index 1d4b044b78410..9e88d39eac1e2 100644
--- a/sound/pci/hda/tas2781_hda_i2c.c
+++ b/sound/pci/hda/tas2781_hda_i2c.c
@@ -527,8 +527,8 @@ static void tas2781_apply_calib(struct tasdevice_priv *tas_priv)
 
 	for (i = 0; i < tas_priv->ndev; i++) {
 		for (j = 0; j < CALIB_MAX; j++) {
-			data = get_unaligned_be32(
-				&tas_priv->cali_data.data[offset]);
+			data = cpu_to_be32(
+				*(uint32_t *)&tas_priv->cali_data.data[offset]);
 			rc = tasdevice_dev_bulk_write(tas_priv, i,
 				TASDEVICE_REG(0, page_array[j], rgno_array[j]),
 				(unsigned char *)&data, 4);
-- 
2.43.0



