Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021713;
	b=NFNqI/hfpvyee6YzIYLPx8z9TqiL1GT3qMjdBUpR7DJN48J9GBZEV1f4xUzNS9W9VGqX
	 mdLNHDkoS5wqREJLgHme13TX6ANn3VUhbupIc0c+iLlyYqHUc/cbEyPZJyIHf70atlcWA
	 FrvF0DCZRNsyyvw4b50KXox+XKfecAIE5gHFxP/mMznipR9rwqASVRVK/q+bsf7iVgysa
	 jnJR/CNfjYMSTFZuDt9M297+83RX48taiMfj+oUc9WwQyCjOO6b58CfjLdL6Qo9l2Ll5P
	 HvD+yyLwVWV9KlOBf/IMHaDbkLNIjL8io3+KkJkqSPmyDNoXbSvCkqQlYVBhVee2Azg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021713;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xPUMmzCs/xn7isiyd/peFF9png/29xRHqLzD9D/5aKg=;
	b=zAUbqg4D9A1iwP2Qsh1nWyl/AnLJbLvV9zZt6qAW+l0DaQE9BjgGXkKI8LOnUsMoG7L8
	 2vvq5KFyONv9yOl8B+QmY5i+aOZxbKmbFglekyietvDVHX7Woh8tDow9V77Meq39yfily
	 QaDJSBJJ+fdZ5OPhfp+9TTqfDqijPzU2ttM6Q99VIxaPa4clN0mdyPkXZ0xtn6+BKinLD
	 zUn+EMNAuzVNPq5Hvrvn8uvE7NvcViUeI9hHBwlg7tDNjIb0ukKqiIAx6mekeV2n7Wb/1
	 I26A5jjdUNGUQjXnCnM4zW38YAJ8OkzGq8yDsh4AAcXsrJ73/2SykmgYWUffG5wb/bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AMjEercz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3ACF606A333;
	Wed, 18 Nov 2026 17:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AMjEercz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EEF61F000C4;
	Wed, 18 Nov 2026 17:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021712;
	bh=xPUMmzCs/xn7isiyd/peFF9png/29xRHqLzD9D/5aKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AMjEercz8WL+ZfiWb2eQedTQ0+pVSavc2YTn7L1eH/w4C4iPfL2vYk2YRC9AMdx4J
	 Ie+Hg2GhwQzaNDk3W+Pm+1T5R/TXCkPMaSQqg+TPdOttRO5gUJa6HsaQsHiZTMv48H
	 Ly1UoWD3WlrvoeYyU8AQCpXkeaUYFR4/5S/POQwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-reviews <sashiko-bot@kernel.org>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2364/2651] ASoC: amd: raven: Fix memory leak in acp3x_dma_close()
Date: Wed, 18 Nov 2026 16:00:04 +0100
Message-ID: <20261118150410.644319485@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit e0b17f84f6e3fa1201b8e2857094023c42ce5636 ]

acp3x_dma_open() allocates a struct i2s_stream_instance for
each substream, but acp3x_dma_close() never frees it, leaking
it on every open/close cycle.

Free it in acp3x_dma_close().

Fixes: 9f7041b71a2f ("ASoC: amd: closing specific instance.")
Reported-by: sashiko-reviews <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/sashiko-outbox-173760@kernel.org/
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261016085047.535265-1-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/raven/acp3x-pcm-dma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/amd/raven/acp3x-pcm-dma.c b/sound/soc/amd/raven/acp3x-pcm-dma.c
index 072f3dc35d402..01e6ac75f35bf 100644
--- a/sound/soc/amd/raven/acp3x-pcm-dma.c
+++ b/sound/soc/amd/raven/acp3x-pcm-dma.c
@@ -354,6 +354,8 @@ static int acp3x_dma_close(struct snd_soc_component *component,
 		}
 	}
 
+	kfree(ins);
+
 	return 0;
 }
 
-- 
2.53.0



