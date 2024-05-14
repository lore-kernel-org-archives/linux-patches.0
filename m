Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A270243AD7;
	Tue, 14 May 2024 11:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687256; cv=none; b=KWZ8aEtDcPHX4KEjb6cZO+qUR5YihF0G4vF6uabGbI2Fi14kDHPjyr3Hd3HBt5PXe8M9xbGfqLe3PauMX6/wm5K/V7zRuxB8F1Hua7NgLLBtIwdsCcbt2PvZsBfQ3mKpxY6g0ij/DzJQ5xzwpzVsMv1pE/W+K9BsZaLn/pfLNaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687256; c=relaxed/simple;
	bh=+xBs4Sv0n4+fDXITo9sZ0x37e1z2R07ry4iwh15GOiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cHY1PrTSkx7bfcG+qbVy5en2p9fumi0szZt/cpgcGJmYtvSZe6l/4xQoZFQzT5qubK6AOVQJdeVwmU6I2Bvh75yBA2WL058iPLsp5/ZQ/W1wlCYcTsHwRIWn/nM1OR843DNmT0ioGIvJjRVyHwFH6WRggPuXkcoaPILIBniw/co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bSYkVj9Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bSYkVj9Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FADBC2BD10;
	Tue, 14 May 2024 11:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687256;
	bh=+xBs4Sv0n4+fDXITo9sZ0x37e1z2R07ry4iwh15GOiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bSYkVj9ZdgGf0Ha+F+r9wEs0SmPqU6T6dIM0v1Xxx01+YrYxV95o1jLMGgLfFey3I
	 zObj+BdMH4EaTurBePWo1HhWveiSvW0EZXpIC+TPU3Uob52DuYfMqLHrvHjR1d56MZ
	 hz+nzxSc9QSLztNCNnSBphzqgLXBhdQSFomneV9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 034/111] ASoC: meson: cards: select SND_DYNAMIC_MINORS
Date: Tue, 14 May 2024 12:19:32 +0200
Message-ID: <20240514100958.422870175@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 6db26f9ea4edd8a17d39ab3c20111e3ccd704aef ]

Amlogic sound cards do create a lot of pcm interfaces, possibly more than
8. Some pcm interfaces are internal (like DPCM backends and c2c) and not
exposed to userspace.

Those interfaces still increase the number passed to snd_find_free_minor(),
which eventually exceeds 8 causing -EBUSY error on card registration if
CONFIG_SND_DYNAMIC_MINORS=n and the interface is exposed to userspace.

select CONFIG_SND_DYNAMIC_MINORS for Amlogic cards to avoid the problem.

Fixes: 7864a79f37b5 ("ASoC: meson: add axg sound card support")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20240426134150.3053741-1-jbrunet@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/meson/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/meson/Kconfig b/sound/soc/meson/Kconfig
index b93ea33739f29..6458d5dc4902f 100644
--- a/sound/soc/meson/Kconfig
+++ b/sound/soc/meson/Kconfig
@@ -99,6 +99,7 @@ config SND_MESON_AXG_PDM
 
 config SND_MESON_CARD_UTILS
 	tristate
+	select SND_DYNAMIC_MINORS
 
 config SND_MESON_CODEC_GLUE
 	tristate
-- 
2.43.0



