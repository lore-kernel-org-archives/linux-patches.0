Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A34546D08F;
	Tue, 21 Jul 2026 18:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659787; cv=none; b=GIKDEoxH6BiDWRxjMSr6zCCFtPZV4gj2Oc5gH8uy0S1FzbgOtDolGqN+DFDGlNru7AM1mmguYp3EFQTkNQKqFynkBuSYz93SZcyVeKLerACFsd/s2pZQSZRxqz9POa3VTW/Em0qX6xnvRKnHqUmAwZIabMZNoc3R+yiIOtzXXcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659787; c=relaxed/simple;
	bh=0LRRKoSKEuz0K0ByHVUFfUVStZwtncSdSWOddF/4/zU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q101VnLz5lQ4tZKDg9b0W53ECZRgT6kgmD4I3wCXSYqQQyxNVZRz6DMwOZpo6k/1RvC5+NwukyFMgi5V0aERiJV5wbdoqKjQJyFtUc1p17yiRC1m9D2zE1TS9Yc7tp/2BSqMw/zdCXLqSlgzn2YrOb1NNwo8l0H5kveBgjwPnbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EFSwo7d3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EFSwo7d3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5AB51F000E9;
	Tue, 21 Jul 2026 18:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659786;
	bh=u+1zr3k/SmqHRiTlD8/0SYA7SxmOw7fpHKNGgxEp4gU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EFSwo7d3mo855Ru7hnW+grZxc+04viUiUJ3iBe4y6J/EQO39CP/WPFm9v2vLZTzeG
	 OcfYkdQ20nyODMlE+zCsaQPpGlIsnuUGgDlyoMhgQg+OVokOSntODPUQ8Vc/ifm6ye
	 Jw2t+rw5auy0ONMmZBU8zswZgGxv8mk//9EZv3kA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0731/2077] ASoC: sdw_utils: fix missing component_name for cs42l43 part_id 0x2A3B
Date: Tue, 21 Jul 2026 17:06:44 +0200
Message-ID: <20260721152610.039424539@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>

[ Upstream commit c429fbea6174a7dd40c4215288589a50e8a33ff6 ]

commit 87a3f5c8ac20 ("ASoC: sdw_utils: cs42l43: allow spk component names
to be combined") moved spk:cs42l43-spk generation from rtd_init() into
the asoc_sdw_rtd_init() generic path by adding component_name to
codec_info_list entries. However, only the 0x4243 cs42l43 entry was
updated; the 0x2A3B entry (vendor_id 0x01fa, Cirrus Logic cs42l43 with
sidecar bridge) was missed.

Without component_name on the 0x2A3B dp6 DAI, asoc_sdw_rtd_init() never
accumulates spk_components and never appends 'spk:cs42l43-spk' (or its
sidecar alias 'spk:cs35l56-bridge') to card->components. The sof-soundwire
UCM regex ' spk:([a-z0-9]+...)' then fails to match, causing WirePlumber
to mark all HiFi profiles as unavailable=no and fall back to the Off
profile — resulting in Dummy Output in GNOME.

The existing sidecar redirect in asoc_sdw_rtd_init() already handles the
SOC_SDW_SIDECAR_AMPS case: when component_name is 'cs42l43-spk' and
sidecar amps are active, it substitutes 'cs35l56-bridge' into
card->components, which matches the existing cs35l56-bridge.conf UCM file.

Fixes: 87a3f5c8ac20 ("ASoC: sdw_utils: cs42l43: allow spk component names to be combined")
Signed-off-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
Link: https://patch.msgid.link/20260610041753.1151088-1-acelan.kao@canonical.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdw_utils/soc_sdw_utils.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/sdw_utils/soc_sdw_utils.c b/sound/soc/sdw_utils/soc_sdw_utils.c
index e440c23271001c..4e8646d231c4ff 100644
--- a/sound/soc/sdw_utils/soc_sdw_utils.c
+++ b/sound/soc/sdw_utils/soc_sdw_utils.c
@@ -818,6 +818,7 @@ struct asoc_sdw_codec_info codec_info_list[] = {
 			{
 				.direction = {true, false},
 				.codec_name = "cs42l43-codec",
+				.component_name = "cs42l43-spk",
 				.dai_name = "cs42l43-dp6",
 				.dai_type = SOC_SDW_DAI_TYPE_AMP,
 				.dailink = {SOC_SDW_AMP_OUT_DAI_ID, SOC_SDW_UNUSED_DAI_ID},
-- 
2.53.0



