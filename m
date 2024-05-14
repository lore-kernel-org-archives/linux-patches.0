Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82094F9D4;
	Tue, 14 May 2024 11:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687775; cv=none; b=YUVwQ9EF+xvZ+6OacvYhpnEgFjsjAK4KjoyAYxbiqw+RWG3KGMW/gRaBaN3ohp/tc2fhY7gRCo8n4/LJk2nwWn+AYPUkht83ogWniY9EDBwltyWBXD6ucb6gBCI+tX2onXU4+D+dhJiO6bQeh7Y0FI6V5oLYjYWrpi1KbRtaySQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687775; c=relaxed/simple;
	bh=pKBLYQkJ5jKDZO1AZ/UnchoAln9q4Jlq/V7uL+24LPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KTSZjA8+ZqXYPW0rffLhFTdHCgk3BAQfzQTmFfzHsqKrq7zZfPyWT9Oz2oo2SoDZaSjO8Zz2riGAxmnz/AHtAzqmZFsgfcrd8hZgvv2va0dwDJRQkI7vPR+t33kC1bUrhDcEdo8e4GD+GD++lYDui5aQIGM6EhRdiyuAXyXJWxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yxhRMhaw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yxhRMhaw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A0CEC2BD10;
	Tue, 14 May 2024 11:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687775;
	bh=pKBLYQkJ5jKDZO1AZ/UnchoAln9q4Jlq/V7uL+24LPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yxhRMhawqjIQfL6EW9qh2WtlD7soclQatKf60g6LP8F1fAoC8nla4UhxwsOUo9Z8Z
	 UTbgBXYu7icRxX7zECDGX6PXW/0ym2t8kYoRrVFz+v2QVNMJ4TGaXLbKrKTZcrFIcu
	 5sTduL2bdLTgGDO1d7iAOcvmBXVWEDoKt3FBFrdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Shmidt <dimitrysh@google.com>,
	Neil Armstrong <narmstrong@baylibre.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 100/168] ASoC: meson: axg-card: Fix nonatomic links
Date: Tue, 14 May 2024 12:19:58 +0200
Message-ID: <20240514101010.464612719@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Armstrong <narmstrong@baylibre.com>

[ Upstream commit 0c9b152c72e53016e96593bdbb8cffe2176694b9 ]

This commit e138233e56e9829e65b6293887063a1a3ccb2d68 causes the
following system crash when using audio on G12A/G12B & SM1 systems:

 BUG: sleeping function called from invalid context at kernel/locking/mutex.c:282
  in_atomic(): 1, irqs_disabled(): 128, non_block: 0, pid: 0, name: swapper/0
 preempt_count: 10001, expected: 0
 RCU nest depth: 0, expected: 0
 Preemption disabled at:
 schedule_preempt_disabled+0x20/0x2c

 mutex_lock+0x24/0x60
 _snd_pcm_stream_lock_irqsave+0x20/0x3c
 snd_pcm_period_elapsed+0x24/0xa4
 axg_fifo_pcm_irq_block+0x64/0xdc
 __handle_irq_event_percpu+0x104/0x264
 handle_irq_event+0x48/0xb4
 ...
 start_kernel+0x3f0/0x484
 __primary_switched+0xc0/0xc8

Revert this commit until the crash is fixed.

Fixes: e138233e56e9829e65b6 ("ASoC: meson: axg-card: make links nonatomic")
Reported-by: Dmitry Shmidt <dimitrysh@google.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Acked-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20220421155725.2589089-2-narmstrong@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/meson/axg-card.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/meson/axg-card.c b/sound/soc/meson/axg-card.c
index cbbaa55d92a66..2b77010c2c5ce 100644
--- a/sound/soc/meson/axg-card.c
+++ b/sound/soc/meson/axg-card.c
@@ -320,7 +320,6 @@ static int axg_card_add_link(struct snd_soc_card *card, struct device_node *np,
 
 	dai_link->cpus = cpu;
 	dai_link->num_cpus = 1;
-	dai_link->nonatomic = true;
 
 	ret = meson_card_parse_dai(card, np, &dai_link->cpus->of_node,
 				   &dai_link->cpus->dai_name);
-- 
2.43.0



