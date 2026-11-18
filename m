Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056763;
	b=BX6ZVVjvGXRTJsVrM1cDfCvOcJvdDQIDJNGqHCPEgeKir+jwRtCUDoyoLlNKb/QMSi4B
	 rmKB6gO+PiQ31Qm7W+jOjqN4eCqYRXy8AKuf1OgQ2WNpRWQD9X+Hc452aUrclkAzgEq6N
	 YN6azntdC9oK+JYrredS7CqrBAt4/zE2CJn88U2IPXYsz2RrkQeAhkpG+1rokviAL3elB
	 wyu3+OUecwThTH2agv0/rQJeGYfLiGOII8NLaUmCDuFrU27Etm7S97EBaKS8z4lwsEo2g
	 nL6qHtZXT/Ye40pcui8T507MaRRUJ1Po7cGTmtwDpWCyzLlu+Ve6Cfcqzjjl+V+g7hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056763;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=svUC9osj2OXZ5o7nhhTB+ZxJEc6YBjF6KVJjY0LT7CM=;
	b=a8/gZvSYmVnfp66oszKXM6q8kEd14WmqduSm6XXcC8ifjikxGPjmMreGcXPESQTW0Jmm
	 dmb+1rkuHrOioGti8rvOTq6mCjUA74/cLQGZmCOgt81A8w5VZgREN41Pyqq1mFdHo9f7k
	 Ew+XM+oiNwNFXvteWQEV9kBnNqBq1lhhTdtYyfW0jYkl5M6/MC53MhTXq6pWPCwbVH0IZ
	 49yVVgWsp37C9G03AYlQDDy9LAE1fmxTaEsr+EgqdUw6tYxTTXvmwD8hjQdXgm/UX1eZ9
	 4+6vjclZKoy2zxE0oCSmnGV/hX4p9QtCF4r2a+l06VizibgG2MgNtN+9IXSXMxKK6nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gmjP+bWd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E89606A32C;
	Thu, 19 Nov 2026 02:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gmjP+bWd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D54791F000C4;
	Thu, 19 Nov 2026 02:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056763;
	bh=svUC9osj2OXZ5o7nhhTB+ZxJEc6YBjF6KVJjY0LT7CM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gmjP+bWdE21ogPSeLcLvU0TYushZ0rNx/vwpDXQ+2OgydNfgVohGmtij0HujAYHl+
	 BAuBFUWL0lhmQL73o4KmrV8Im91U/hhWkPcTgXcMZFxf0NWouDoSItkFisyGDVz9uH
	 QLO/OgbzIMMXJ8xX09vy1aJ4kGJquVdMZdDgFryM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-reviews <sashiko-bot@kernel.org>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2104/2214] ASoC: amd: raven: Fix memory leak in acp3x_dma_close()
Date: Wed, 18 Nov 2026 16:03:00 +0100
Message-ID: <20261118150134.813152206@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 57ba07d918eb3..800cb3279b510 100644
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



