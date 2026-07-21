Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407F542DA53;
	Tue, 21 Jul 2026 19:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661981; cv=none; b=eTRBTGkIXffulHfwtkDOkJv7HhsdydEEG8qwaAyNWiueDYyoOm9BK7//sbjHRcAplsrRaEsyp0ZifYpn3pesgymzqH1Tuawa0IsK5tvt58+jz5Y77O3TQi0GH5m1yzXYN4XP+mrHENVKEO2CkwgqvglWaveeAqyq269Bx6R+ciU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661981; c=relaxed/simple;
	bh=ndAbPcYR8Du2TD4Hm4BehWTlmZUSbV/NocLHOyIvQ1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s6unkbKsE6SdgKfNfZSFAIYI0F8COfHdIrLUGqjtEcnEnI6wx+6RMauufaY4dFDa13t20DXxw6GTS3wayKG3Ub/fXvZXISIl0mJYG9E85ZaXRi7TgyQUnoThDpmQqJ1TEUrs40RMAzUjQ7JMMHJQQ4RfdQ/c7MrO5tYx0ino4ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nbhHW1+/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nbhHW1+/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7FB1F000E9;
	Tue, 21 Jul 2026 19:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661980;
	bh=bTVubFZzyuPqGfXoesHz83Uj9mOM0gg0bfqkjWS5+08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nbhHW1+/H1rrupSVAKMqShgBT+ArW940TCS2hzlvyKgcklaZ7Ilg8Jt56TxXtdr/Z
	 JDLmm0fY6YPP8+rCBdRoxtmWssG+c6zAg7RaV3RUWTeQpdWT2usrDDHHu3bFf+x1mL
	 Klizv8uzMMWYEgzNBkb/RERWyUP0gl27+UBd9h0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Ma <aaron.ma@canonical.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0269/1276] ASoC: amd: acp-sdw-sof: Bound DAI link iteration
Date: Tue, 21 Jul 2026 17:11:52 +0200
Message-ID: <20260721152452.099642715@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Aaron Ma <aaron.ma@canonical.com>

[ Upstream commit 4d992e63f52d58f52b724606c60ae7b37a1c582f ]

create_sdw_dailinks() walks sof_dais until it finds an entry with
initialised cleared, but sof_dais is allocated with exactly num_ends
entries. If all entries are initialised, the loop reads past the end of
the array.

Pass the allocated entry count to create_sdw_dailinks() and stop before
reading past the array.

Fixes: 6d8348ddc56e ("ASoC: amd: acp: refactor SoundWire machine driver code")
Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
Link: https://patch.msgid.link/20260528082110.915549-2-aaron.ma@canonical.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-sdw-sof-mach.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/sound/soc/amd/acp/acp-sdw-sof-mach.c b/sound/soc/amd/acp/acp-sdw-sof-mach.c
index 876f0b7fcd3dee..e169b33f65712c 100644
--- a/sound/soc/amd/acp/acp-sdw-sof-mach.c
+++ b/sound/soc/amd/acp/acp-sdw-sof-mach.c
@@ -260,13 +260,14 @@ static int create_sdw_dailink(struct snd_soc_card *card,
 
 static int create_sdw_dailinks(struct snd_soc_card *card,
 			       struct snd_soc_dai_link **dai_links, int *be_id,
-			       struct asoc_sdw_dailink *sof_dais,
+			       struct asoc_sdw_dailink *sof_dais, int num_dais,
 			       struct snd_soc_codec_conf **codec_conf)
 {
+	int i;
 	int ret;
 
 	/* generate DAI links by each sdw link */
-	while (sof_dais->initialised) {
+	for (i = 0; i < num_dais && sof_dais->initialised; i++) {
 		int current_be_id = 0;
 
 		ret = create_sdw_dailink(card, sof_dais, dai_links,
@@ -373,7 +374,7 @@ static int sof_card_dai_links_create(struct snd_soc_card *card)
 	/* SDW */
 	if (sdw_be_num) {
 		ret = create_sdw_dailinks(card, &dai_links, &be_id,
-					  sof_dais, &codec_conf);
+					  sof_dais, num_ends, &codec_conf);
 		if (ret)
 			goto err_end;
 	}
-- 
2.53.0



