Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E532F24;
	Mon, 23 Jun 2025 13:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685698; cv=none; b=lAi+MJzafWEjQtkWYD6qXvqWuGvoE50kgBznZXwc4div2JZ4XZQ++EvdD1WDSWOCwj44KUvGSdmxU0TlsshhHZEnV318c4ar/hW/Bb8i9pN4C9yOJvEy0bALO4u8AAgikW5D+icLvetwsS3uCjvjE/ZYo24rNaydY8tXcrSmti8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685698; c=relaxed/simple;
	bh=5h3CFyCvXG7LbFjznuHQ875IQOwr91rqZ5IBuyZaowY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dh5STkA0eIpIkULDor5awfR436IKeceq3DzpO3aL6SiBFQje7QsHfr9h0kseVv9F3dXu+sISuiXJ9IGMTfZpAOvciFHp9fZKpjeZvb6+/vfwp6y0L5Oesca51gezjTWVJCpFAF+ZW/1JLS/COKfN5ZuQuR8nnQ3WMnp6rqqpDMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KVc4cIxA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KVc4cIxA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA666C4CEEA;
	Mon, 23 Jun 2025 13:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685698;
	bh=5h3CFyCvXG7LbFjznuHQ875IQOwr91rqZ5IBuyZaowY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KVc4cIxAdk2kXOQVLvV6MNAP5b31b3lTpwjaeW1VRhR/sTl5lyiozRhWOcj/3nn+L
	 mQw5jd4Ns5zZoUjPep8X4WHGnGUO/8wGf6k1qmVeK33tesBUkXDPgJg9QKuhp+fkia
	 55F40g7ch7keV/siWbHgqLap8qSXx1d9XqZkb7F4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neal Gompa <neal@gompa.dev>,
	Hector Martin <marcan@marcan.st>,
	James Calligeros <jcalligeros99@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 025/508] ASoC: tas2764: Enable main IRQs
Date: Mon, 23 Jun 2025 15:01:10 +0200
Message-ID: <20250623130645.868916583@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hector Martin <marcan@marcan.st>

[ Upstream commit dd50f0e38563f15819059c923bf142200453e003 ]

IRQ handling was added in commit dae191fb957f ("ASoC: tas2764: Add IRQ
handling") however that same commit masks all interrupts coming from
the chip. Unmask the "main" interrupts so that we can see and
deal with a number of errors including clock, voltage, and current.

Fixes: dae191fb957f ("ASoC: tas2764: Add IRQ handling")
Reviewed-by: Neal Gompa <neal@gompa.dev>
Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: James Calligeros <jcalligeros99@gmail.com>
Link: https://patch.msgid.link/20250406-apple-codec-changes-v5-4-50a00ec850a3@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2764.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/tas2764.c b/sound/soc/codecs/tas2764.c
index 10f0f07b90ff2..8baf92abcf000 100644
--- a/sound/soc/codecs/tas2764.c
+++ b/sound/soc/codecs/tas2764.c
@@ -542,7 +542,7 @@ static int tas2764_codec_probe(struct snd_soc_component *component)
 	tas2764_reset(tas2764);
 
 	if (tas2764->irq) {
-		ret = snd_soc_component_write(tas2764->component, TAS2764_INT_MASK0, 0xff);
+		ret = snd_soc_component_write(tas2764->component, TAS2764_INT_MASK0, 0x00);
 		if (ret < 0)
 			return ret;
 
-- 
2.39.5



