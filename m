Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF0717E90E;
	Mon, 27 May 2024 19:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837060; cv=none; b=XOzXpMrKkLA4lQBZ2TBcvEx8kpjaVC6vzy8n799IsO5hNJlcoi1MwrkEww336rx6hNxwNU+Lb4+cRBNXuZoMcs7TqmNkrccPvc+VOQGUwzxH7AoOfPoAuTvcbIIrC2k6nw2qe7ov8Rb+zfIgA91NW0npxP5Z/DnXNXGbzQ6aKjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837060; c=relaxed/simple;
	bh=Y9T20/hfTeFu2lFne3ph2clbhV+xxjrw4f6hgl+LPLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a5ZNKY5wCxS75x5f46jAcc65EVbZ+BqP8Ufr5sMNvMqwP71yE6pILgT6DGWSEXvNbiim/N8ozBUp5UH+pyT7TkWhUIhbn14pOQj4LiMViIVNtqC3VXfauOCLXuspxKMRLRf7tHFB5NaWa08xB4kSJ890/JeIkPFKUChTBGFc+UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mJNSpLQE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mJNSpLQE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 571F2C2BBFC;
	Mon, 27 May 2024 19:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837060;
	bh=Y9T20/hfTeFu2lFne3ph2clbhV+xxjrw4f6hgl+LPLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mJNSpLQEBo0/RP++n0gH426xxFQIBu7zb2un99tqrmExOvoij3EYFSRDJvBLY5HnS
	 XJeayOGQC2I837jPug1sFfp4HOr/xiceKrOg0tg2tgTgLtVZheGo7KnetZUVUHrdUB
	 c+kcVjZWuHXovi2J5YVMrcudfMNJfzv/EQjIdKTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 295/427] ASoC: kirkwood: Fix potential NULL dereference
Date: Mon, 27 May 2024 20:55:42 +0200
Message-ID: <20240527185629.861677250@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit ea60ab95723f5738e7737b56dda95e6feefa5b50 ]

In kirkwood_dma_hw_params() mv_mbus_dram_info() returns NULL if
CONFIG_PLAT_ORION macro is not defined.
Fix this bug by adding NULL check.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: bb6a40fc5a83 ("ASoC: kirkwood: Fix reference to PCM buffer address")
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Link: https://msgid.link/r/20240328173337.21406-1-amishin@t-argos.ru
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/kirkwood/kirkwood-dma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/kirkwood/kirkwood-dma.c b/sound/soc/kirkwood/kirkwood-dma.c
index dd2f806526c10..ef00792e1d49a 100644
--- a/sound/soc/kirkwood/kirkwood-dma.c
+++ b/sound/soc/kirkwood/kirkwood-dma.c
@@ -182,6 +182,9 @@ static int kirkwood_dma_hw_params(struct snd_soc_component *component,
 	const struct mbus_dram_target_info *dram = mv_mbus_dram_info();
 	unsigned long addr = substream->runtime->dma_addr;
 
+	if (!dram)
+		return 0;
+
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
 		kirkwood_dma_conf_mbus_windows(priv->io,
 			KIRKWOOD_PLAYBACK_WIN, addr, dram);
-- 
2.43.0



