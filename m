Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F4986347;
	Tue, 27 May 2025 17:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365888; cv=none; b=uh4XMV2q3+BRtV1t0PyVDm0iLx3rPCPJfCicavYADYZdPBJCSgV7PBVmKKq5UvHgGI9Fzx3OLSiETfZTudQzu4XHb3SfgE2+cYqLQCZpSDpm3TvrFuPS2+NmEX/Xdfw0psIbipIZ/7HQfZLrNpXSmsNPRpITXBpn1F2xL9trMsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365888; c=relaxed/simple;
	bh=JgSy6Iv9QceHbyEElQtcO0ZIZjtyTLrEHswQqHySQIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V+G0ddiqvMXpHxVx48UncMzsEKuHKJd0UFacu0GkIjmtgIW0oAXLOY7CaV4OYPxXEavaVV4khvH/VmF3GFHrKiue7MtdUlhedopqocA7XDUgR+y7nRucid8y6jWfCRLsgu56ED4u+nnxWcdyKCcG0y20v0C+4TqjHd/epBPWG3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SSHFHC0F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SSHFHC0F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9F4C4CEE9;
	Tue, 27 May 2025 17:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365887;
	bh=JgSy6Iv9QceHbyEElQtcO0ZIZjtyTLrEHswQqHySQIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SSHFHC0FaF1sH03El8uVsb5JSn5PIcKE4z5C07TnLQuXJYjYbyl/7Qfa48GEbKtj8
	 2kG4qvcfD4NJbHU0cQCBWwGI6mm1+aqh3wTslx+5SCKARAZuBS60JN38mYgnhYBGZo
	 xXOzxoake0zjUFuhyfCW+Qonls9qxUPT06DCjyAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 522/626] ASoC: intel/sdw_utils: Add volume limit to cs42l43 speakers
Date: Tue, 27 May 2025 18:26:55 +0200
Message-ID: <20250527162506.193187924@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Stefan Binding <sbinding@opensource.cirrus.com>

[ Upstream commit 02b44a2b2bdcee03cbb92484d31e9ca1b91b2a38 ]

The volume control for cs42l43 speakers has a maximum gain of +31.5 dB.
However, for many use cases, this can cause distorted audio, depending
various factors, such as other signal-processing elements in the chain,
for example if the audio passes through a gain control before reaching
the codec or the signal path has been tuned for a particular maximum
gain in the codec.

In the case of systems which use the soc_sdw_cs42l43 driver, audio will
likely be distorted in all cases above 0 dB, therefore add a volume
limit of 128, which is 0 dB maximum volume inside this driver.

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20250430103134.24579-2-sbinding@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdw_utils/soc_sdw_cs42l43.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/soc/sdw_utils/soc_sdw_cs42l43.c b/sound/soc/sdw_utils/soc_sdw_cs42l43.c
index adb1c008e871d..2dc7787234c36 100644
--- a/sound/soc/sdw_utils/soc_sdw_cs42l43.c
+++ b/sound/soc/sdw_utils/soc_sdw_cs42l43.c
@@ -20,6 +20,8 @@
 #include <sound/soc-dapm.h>
 #include <sound/soc_sdw_utils.h>
 
+#define CS42L43_SPK_VOLUME_0DB	128 /* 0dB Max */
+
 static const struct snd_soc_dapm_route cs42l43_hs_map[] = {
 	{ "Headphone", NULL, "cs42l43 AMP3_OUT" },
 	{ "Headphone", NULL, "cs42l43 AMP4_OUT" },
@@ -117,6 +119,14 @@ int asoc_sdw_cs42l43_spk_rtd_init(struct snd_soc_pcm_runtime *rtd, struct snd_so
 			return -ENOMEM;
 	}
 
+	ret = snd_soc_limit_volume(card, "cs42l43 Speaker Digital Volume",
+				   CS42L43_SPK_VOLUME_0DB);
+	if (ret)
+		dev_err(card->dev, "cs42l43 speaker volume limit failed: %d\n", ret);
+	else
+		dev_info(card->dev, "Setting CS42L43 Speaker volume limit to %d\n",
+			 CS42L43_SPK_VOLUME_0DB);
+
 	ret = snd_soc_dapm_add_routes(&card->dapm, cs42l43_spk_map,
 				      ARRAY_SIZE(cs42l43_spk_map));
 	if (ret)
-- 
2.39.5



