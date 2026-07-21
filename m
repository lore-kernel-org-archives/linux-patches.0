Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F623955F4;
	Tue, 21 Jul 2026 15:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649380; cv=none; b=HtsvycSNHkh2vISFMY7ax42EB9f7xFqimZUtexP7g/Rw2U6+8R2genP6cnJnLFcZZOWpOw4JLwar6NVgFojMBJ3qENQ16qgWOWiSijDij2QWaS6sLh/Cr91lI9wsByFLk/6SIqyMBllDOBBpaD0ZhxLSX02tu2LQVp5pYkGgai4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649380; c=relaxed/simple;
	bh=XG5QU4jcYx1vuMx+4xmiaMnYSqS/EVO97VzI4a/cxjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YmXMBB50B90fCbKOIJrVwM46phq1fi47vkqZyJN9b7HGjadddoKY6eP5UiK0JLMzYTXz3CQdHmYsp2naXJHYDZVuZrGkNazVa87WEuPI8ZqpzCk9Dfd7ieK4XZQxuRcEuY7gC0TmAoqDWuDZ4y7XovtzkapVIuXaHbJupsFAFIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p9DE+gOJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p9DE+gOJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDFDE1F000E9;
	Tue, 21 Jul 2026 15:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649379;
	bh=GHJFSSssa1Dst1t4kMKJMOlJpgS+iJ3dlapJy3ONba4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p9DE+gOJHIWqU9uWj+SGx24qD08UC/KnJEQ5R8064JC2KU4/obVUVRhsuiZJj6xbH
	 QybDyadMe447lweRRUZ1sc8tRMgtP02C/+xDmIkDaH4CQh1FgP5HH7s6BdM/5mA+lw
	 IxoWT6VdW5M/30Uz/dBNSYRCgJj5wys7Y8t/CawU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Ma <aaron.ma@canonical.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0557/2077] ASoC: amd: acp-sdw-sof: Bound DAI link iteration
Date: Tue, 21 Jul 2026 17:03:50 +0200
Message-ID: <20260721152605.953713997@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index a0fd8a6f997088..a423853f3a97d8 100644
--- a/sound/soc/amd/acp/acp-sdw-sof-mach.c
+++ b/sound/soc/amd/acp/acp-sdw-sof-mach.c
@@ -220,13 +220,14 @@ static int create_sdw_dailink(struct snd_soc_card *card,
 
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
@@ -334,7 +335,7 @@ static int sof_card_dai_links_create(struct snd_soc_card *card)
 	/* SDW */
 	if (sdw_be_num) {
 		ret = create_sdw_dailinks(card, &dai_links, &be_id,
-					  sof_dais, &codec_conf);
+					  sof_dais, num_ends, &codec_conf);
 		if (ret)
 			return ret;
 	}
-- 
2.53.0



