Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9556D22F0F;
	Thu, 18 Jan 2024 10:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575374; cv=none; b=Q1M30D9baG1SajT1V8XuPa6YKvs9ddc3ZxY2OxXa947pxsDn8DVmgtqS0Jgnsat1Cbj2sOuVyA9EO8kEnFnae2gS6hnhOHjLDpXEiWbbb6TKMRnT0tckbHWII3oYg0sv6QrqFghvcvNZ0BMfMWwORpoWq+ZZ5rt6GYNPgRDUBs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575374; c=relaxed/simple;
	bh=jZLCjbF+okfUc53SxVYWdFaIjuSpMbI7cBIGf08EYJ0=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=UhNub1pgzILqEVEsMQECNtVHHNpudHU6xtJkNQzn3GayvBvnDWVy12LEO6/NSOOh37RGxMa9VSQkQuOBHCo9gVRMLpCyzOEoxSJyeaRSBNpLU9xPRYN5Ke4+50c04Y7hG9h7nUf/yrSvuQmveOjhiY1yBaa54Y75bUg1221Fiqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p62oCSFr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p62oCSFr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1568CC433F1;
	Thu, 18 Jan 2024 10:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575374;
	bh=jZLCjbF+okfUc53SxVYWdFaIjuSpMbI7cBIGf08EYJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p62oCSFr937v3kWXX0SNZt118DdPK/bv1CVkaTXAzXTRnxaHjPhB56SNfFk+jJJZV
	 r1T0hdt8/1V2ZEWJXkSJSx1so3+tUaA4T5r7NmHfGKp0MU+Skkip9KTaLmFVd9nZvw
	 Y7JkDOfZFxQIPyOwqbqCi4yOzG36IWcITzR/tNSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Rivera-Matos <rriveram@opensource.cirrus.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 092/150] ASoC: cs35l45: Prevents spinning during runtime suspend
Date: Thu, 18 Jan 2024 11:48:34 +0100
Message-ID: <20240118104324.201403187@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Rivera-Matos <rriveram@opensource.cirrus.com>

[ Upstream commit a0ffa8115e1ea9786b03edc3f431d2f4ef3e7a2e ]

Masks the "DSP Virtual Mailbox 2 write" interrupt when before
issuing the hibernate command to the DSP. The interrupt is
unmasked when exiting runtime suspend as it is required for
DSP operation.

Without this change the DSP fires an interrupt when hibernating
causing the system spin between runtime suspend and runtime
resume.

Signed-off-by: Ricardo Rivera-Matos <rriveram@opensource.cirrus.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20231206160318.1255034-4-rriveram@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l45.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/codecs/cs35l45.c b/sound/soc/codecs/cs35l45.c
index 310747b7689d..9b9fc2d49108 100644
--- a/sound/soc/codecs/cs35l45.c
+++ b/sound/soc/codecs/cs35l45.c
@@ -775,6 +775,8 @@ static int cs35l45_enter_hibernate(struct cs35l45_private *cs35l45)
 
 	cs35l45_setup_hibernate(cs35l45);
 
+	regmap_set_bits(cs35l45->regmap, CS35L45_IRQ1_MASK_2, CS35L45_DSP_VIRT2_MBOX_MASK);
+
 	// Don't wait for ACK since bus activity would wake the device
 	regmap_write(cs35l45->regmap, CS35L45_DSP_VIRT1_MBOX_1, CSPL_MBOX_CMD_HIBERNATE);
 
@@ -795,6 +797,8 @@ static int cs35l45_exit_hibernate(struct cs35l45_private *cs35l45)
 					  CSPL_MBOX_CMD_OUT_OF_HIBERNATE);
 			if (!ret) {
 				dev_dbg(cs35l45->dev, "Wake success at cycle: %d\n", j);
+				regmap_clear_bits(cs35l45->regmap, CS35L45_IRQ1_MASK_2,
+						 CS35L45_DSP_VIRT2_MBOX_MASK);
 				return 0;
 			}
 			usleep_range(100, 200);
-- 
2.43.0



