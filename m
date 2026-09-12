Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D827E18A93F;
	Sat, 12 Sep 2026 14:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223160; cv=none; b=AyVgZS0Kfnf7Bsw/7rJ2TS4YeODvz/qMJkr4cVHnlBOxTS6mT2H7IfJU6udS113C1JMi0BuRsAgW5uvTtQO4o4WRTCSgkJiBdv3gSb53MBLOU2iuYJXI+ZoPdYEh4EG6Qrwpq4pICkpD9uwte1ivrQUj3USGsk/hkFKw+RcImF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223160; c=relaxed/simple;
	bh=HzhyjUgBmFibDpkY3OrqPAOtCjEWWBs4dK6rVH3Yv24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AN9Td+s/XqBTGfrJkdc+U1SdukXkPsmk/qETFgm5FFDR8cPHfy7B+PTpDs5XItvSt1IpWv7WdMUgkyqGlmIxsNmETx0e49f1k3wSfdg4izxJqgnE5ORiA4BfFiOETYBiqwu5F5+o7yaCP475IaG+dCIPdPuEyqZk1vfRhdZt/9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wMEXfQH+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wMEXfQH+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D771F000FF;
	Sat, 12 Sep 2026 14:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223159;
	bh=isLdnANLs7NNzTr+Yh4NEN5EhqElS5qNGQ7ZkV27aK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wMEXfQH+r+4irABJgaZ0jdrS03ldd4hWo5gTwMgvh2/95cJAy4xla4ZbpiijeH6WS
	 HF/43CY25y39ehdevQw9FCWKiHC/V8Fq2LSPbM9pqYZYIodYehb5Aoh3f9yaFhN6Bo
	 D8U1PslwL1nrrJY5rHMhgDTtG1Rkm2MTRqwsAMIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Calligeros <jcalligeros99@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0734/1424] ASoC: apple: mca: increase SERDES reset delay
Date: Sat, 12 Sep 2026 08:52:46 +0200
Message-ID: <20260912065623.734703718@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Calligeros <jcalligeros99@gmail.com>

[ Upstream commit cccd721e5aab03e92234faee72b363c9ba60611c ]

The SERDES clusters in this peripheral take a long time to warm up.
We tried polling the reset bit until cleared, however this is not
a reliable signal of readiness to be configured. Only waiting
~25 us to give the cluster a chance to settle makes it work
reliably.

Increase the 2 us delay to 25 us and hope we never have to do this
again.

Fixes: d8b3e396088d ("ASoC: apple: mca: Fix SERDES reset sequence")
Signed-off-by: James Calligeros <jcalligeros99@gmail.com>
Link: https://patch.msgid.link/20260711-apple-audio-redux-v4-1-2994d87c2f24@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/apple/mca.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/apple/mca.c b/sound/soc/apple/mca.c
index 0e96caa607fb8..88d6de6bdbc43 100644
--- a/sound/soc/apple/mca.c
+++ b/sound/soc/apple/mca.c
@@ -210,10 +210,10 @@ static void mca_fe_early_trigger(struct snd_pcm_substream *substream, int cmd,
 			   SERDES_STATUS_EN | SERDES_STATUS_RST,
 			   SERDES_STATUS_RST);
 		/*
-		 * Experiments suggest that it takes at most ~1 us
-		 * for the bit to clear, so wait 2 us for good measure.
+		 * The SERDES cluster needs a bit of time to reset itself
+		 * and settle before we start poking it. This is... slow...
 		 */
-		udelay(2);
+		udelay(25);
 		WARN_ON(readl_relaxed(cl->base + serdes_unit + REG_SERDES_STATUS) &
 			SERDES_STATUS_RST);
 		mca_modify(cl, serdes_conf, SERDES_CONF_SYNC_SEL,
-- 
2.53.0



