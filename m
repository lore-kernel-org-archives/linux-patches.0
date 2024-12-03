Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FAE11F669E;
	Tue,  3 Dec 2024 14:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237796; cv=none; b=QBCeW6t0eTQ0Sqi6EFSIJVnXNFl6ezeSiY+nRE3OkDeMcuzO6Qu3Ok3wm1XulZWAp7Bsky4U8aGv+xbutLfiJNjfGgB+Aw/nl3AjT19PTEDXV3ez98DHVVSzrnYaNTQtl4iOQ81bm0NaMz934+hDVrKF722/z7SSojNbE1qcMOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237796; c=relaxed/simple;
	bh=o29tiPNEIHXJ2Nkn1mslYGc2s6+naJYd1QK5EpLf4Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V6k50q8hDNXxLpl4PIEYbMsDZ71tAWpksDGJLUTM5Gz58WAk5h5bSt8gFahItk4pLdoeK9C8C9MLa7XRJlljvI59ZxeI9TCxQ+nqnu+t5QKcbNBsLfIj1hP42q3ONngKYp8BXTSmFunylm5ZVwC6p6JXsp9PaHqsaEvTiZinXOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SWPQBl7d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SWPQBl7d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BEF3C4CECF;
	Tue,  3 Dec 2024 14:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237795;
	bh=o29tiPNEIHXJ2Nkn1mslYGc2s6+naJYd1QK5EpLf4Rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SWPQBl7dmFuSRBnUK43Dikvtr0G9fwEXI5CdoxNUClPo+Rr7fanNDfkflFxthoyyE
	 bI2XS5bfHe+tD5HaJmy7q+ZoYQpQMDsZ7o+3HE35PJFghre0HHwqb1u9Xe6bGImH3O
	 LXKSq+BMPMmOLdMbJAVR0GOskEKTLYaPfvHr4TaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 041/817] ASoC: max9768: Fix event generation for playback mute
Date: Tue,  3 Dec 2024 15:33:33 +0100
Message-ID: <20241203143957.263245924@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 2ae6da569e34e1d26c5275442d17ffd75fd343b3 ]

The max9768 has a custom control for playback mute which unconditionally
returns 0 from the put() operation, rather than returning 1 on change to
ensure notifications are generated to userspace. Check to see if the value
has changed and return appropriately.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://patch.msgid.link/20241112-asoc-max9768-event-v1-1-ba5d50599787@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max9768.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/max9768.c b/sound/soc/codecs/max9768.c
index e4793a5d179ef..8af3c7e5317fb 100644
--- a/sound/soc/codecs/max9768.c
+++ b/sound/soc/codecs/max9768.c
@@ -54,10 +54,17 @@ static int max9768_set_gpio(struct snd_kcontrol *kcontrol,
 {
 	struct snd_soc_component *c = snd_soc_kcontrol_component(kcontrol);
 	struct max9768 *max9768 = snd_soc_component_get_drvdata(c);
+	bool val = !ucontrol->value.integer.value[0];
+	int ret;
 
-	gpiod_set_value_cansleep(max9768->mute, !ucontrol->value.integer.value[0]);
+	if (val != gpiod_get_value_cansleep(max9768->mute))
+		ret = 1;
+	else
+		ret = 0;
 
-	return 0;
+	gpiod_set_value_cansleep(max9768->mute, val);
+
+	return ret;
 }
 
 static const DECLARE_TLV_DB_RANGE(volume_tlv,
-- 
2.43.0



