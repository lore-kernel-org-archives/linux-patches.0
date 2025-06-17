Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D35239E85;
	Tue, 17 Jun 2025 16:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177733; cv=none; b=uwNi7K5sqvpH1bR8gIR1orHSXxvhmWquUcWDGQMoj5ohoL9sHJBat06WYhbeGEEkq2DhGd5mfVZMdI8EPaHKcEWhHInsCSTaxfnbUCxajhbl+ifMlOrO5Cx4ADOrv9xpeNYKmpnjMJ/i1xAY6WH+VLg6BJdDPBqQ3RKeL1V0aD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177733; c=relaxed/simple;
	bh=tBMVdGS8+QKkJv/gcZbcfAu3ekgAjhguwMCt8LJYJoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hX85flvitAAyfitxape3pGOaQno4ZjKj+3t1VkeMrxXG5Cw26kUW+HBzWJ3nSmCdvBP/+w8ZXWaIv9aZ/VNfQL6kUjUMnTt6Gi/bWM0+PzcNCoOSWxkZ4nTePxx8p2dDUlw7Aam1cgDTRFNDsDPQCfDyXKWCXp8pM99lr30O5RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XMQx8LM6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XMQx8LM6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4894AC4CEF0;
	Tue, 17 Jun 2025 16:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177733;
	bh=tBMVdGS8+QKkJv/gcZbcfAu3ekgAjhguwMCt8LJYJoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XMQx8LM6kEaRWHxyYzY6u8Wvrs64ArdYB3JFdObqGvF4a9quJMXn7zvYNgObGxFW6
	 PNaNWFUSD6icVjcpgsQzsQvY6AFQ0PWy4SprK8QG02Vck0jrfd0MEe3KRWb/XrP1RC
	 xywkzL3DgkVCw4aai26EJkaI9y6ISPtTF0nZfZsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 388/512] ASoC: codecs: hda: Fix RPM usage count underflow
Date: Tue, 17 Jun 2025 17:25:54 +0200
Message-ID: <20250617152435.306347971@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ddc00927313cf..dc7794c9ac44c 100644
--- a/sound/soc/codecs/hda.c
+++ b/sound/soc/codecs/hda.c
@@ -152,7 +152,7 @@ int hda_codec_probe_complete(struct hda_codec *codec)
 	ret = snd_hda_codec_build_controls(codec);
 	if (ret < 0) {
 		dev_err(&hdev->dev, "unable to create controls %d\n", ret);
-		goto out;
+		return ret;
 	}
 
 	/* Bus suspended codecs as it does not manage their pm */
@@ -160,7 +160,7 @@ int hda_codec_probe_complete(struct hda_codec *codec)
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



