Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC6919CC11;
	Mon, 23 Jun 2025 21:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714655; cv=none; b=OmNLJYRHtHnP3Ko5QsMYgm1+HPXyaO8iwVRufuCK5N6iEnVuCTYDXAmk7BdTyJNqoLwjF1wkDReB2qIuED7JA5b4wCpw75KL5RwvNVtvD1QXG8fHnBRrAa1aOcE0ZpfqCB+rZJMIxPuQhMnlWWWz+R0mBvUy+txLVrw5HRVa438=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714655; c=relaxed/simple;
	bh=PZU7SfMJrI3CvP2QfOmMN2CAWpaR22fF4tlB2ZPLUQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oGWpjYQUzigEx9HlvU/hTSiTeGPIUICwkUmsUtyEWUf4nsVCyfCSXOK3AfFMdrL4zi2gME7GMC0xufqTr/jHjsgT5xq/KIX7gDIs9nwJw5s2OLb1BZlc35o6iPPeYbNg5jnvPnLxfG+HNuA7+oNprC6kSUOIFN/cQvc2VNSjV1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ka6bBJaY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ka6bBJaY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B2B0C4CEEA;
	Mon, 23 Jun 2025 21:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714654;
	bh=PZU7SfMJrI3CvP2QfOmMN2CAWpaR22fF4tlB2ZPLUQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ka6bBJaYYgJSeVwCY4Ur+mjwjeb51BUlbyGbfT6agEa0MCFe86T2Aw7YivPexBMzm
	 4ZcdXg1CLgzGzhDGdZjE3njM33Q0u/NmGDYUP1xAuRAweu2kw4GUWA2j4a5ip5uwgU
	 b8QZ1Mwi1CC4lb3QRYWiNjsPgWzaFCNw/NnwCdyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 187/508] ASoC: codecs: hda: Fix RPM usage count underflow
Date: Mon, 23 Jun 2025 15:03:52 +0200
Message-ID: <20250623130649.874361566@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit ff0045de4ee0288dec683690f66f2f369b7d3466 ]

RPM manipulation in hda_codec_probe_complete()'s error path is
superfluous and leads to RPM usage count underflow if the
build-controls operation fails.

hda_codec_probe_complete() is called in:

1) hda_codec_probe() for all non-HDMI codecs
2) in card->late_probe() for HDMI codecs

Error path for hda_codec_probe() takes care of bus' RPM already.
For 2) if late_probe() fails, ASoC performs card cleanup what
triggers hda_codec_remote() - same treatment is in 1).

Fixes: b5df2a7dca1c ("ASoC: codecs: Add HD-Audio codec driver")
Reviewed-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20250530141025.2942936-2-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/hda.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/hda.c b/sound/soc/codecs/hda.c
index 61e8e9be6b8d7..bd81572a6775b 100644
--- a/sound/soc/codecs/hda.c
+++ b/sound/soc/codecs/hda.c
@@ -149,7 +149,7 @@ int hda_codec_probe_complete(struct hda_codec *codec)
 	ret = snd_hda_codec_build_controls(codec);
 	if (ret < 0) {
 		dev_err(&hdev->dev, "unable to create controls %d\n", ret);
-		goto out;
+		return ret;
 	}
 
 	/* Bus suspended codecs as it does not manage their pm */
@@ -157,7 +157,7 @@ int hda_codec_probe_complete(struct hda_codec *codec)
 	/* rpm was forbidden in snd_hda_codec_device_new() */
 	snd_hda_codec_set_power_save(codec, 2000);
 	snd_hda_codec_register(codec);
-out:
+
 	/* Complement pm_runtime_get_sync(bus) in probe */
 	pm_runtime_mark_last_busy(bus->dev);
 	pm_runtime_put_autosuspend(bus->dev);
-- 
2.39.5



