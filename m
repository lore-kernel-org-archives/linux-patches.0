Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAF42B9AD;
	Tue, 14 May 2024 11:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687708; cv=none; b=ZkQCW6P9MWySk8gL0zaFkmJ4NCej7AWut0nFtpaTsRSc3CMUh1/t7Lcmwdit1LleMeBp+qkZJaB1grQ3kdt5zIQzTlRqvLyF7EX1lQszzjw8QYyoafNGqMjRH4Kv2tdTiB4eGm59/Ev2941kt463h/aP3JGmb6YGpL+PqGFVgyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687708; c=relaxed/simple;
	bh=ceJ0tzOvKTdWtiFfp3GeQq/eX2eX5AN93Rd95s5gHag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kyIIB/tWeGOePdSaTHLw4e3NoRdth0yUypHTWiHLxOHpRhtbNLi5afDb5Lsvoq/poGG2rjWHUt7VV6UYKq673LZhCS5R5SiooNFwRPdkOYBZ9hqBRkza6pAlI/gmpdg1vKiQpbSR0IBs0hIKQyn/hKQHYI3I1I326IPClcgHJXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mDdfuOGn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mDdfuOGn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D27C2BD10;
	Tue, 14 May 2024 11:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687707;
	bh=ceJ0tzOvKTdWtiFfp3GeQq/eX2eX5AN93Rd95s5gHag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mDdfuOGneaMVuNEyFBALEWjVn7ClduLeckEg9pJi5rZcrWCd1CoczQu31mNJf12l/
	 A2JKS8PxJsaH8pBNJyO3XHc1kCYmhngOyRIuMwhpAoSMWZnT3dLpOz7ojdm9AyprHp
	 I+G2J0sJJGLyOMWJxq+0HqLbFQ5ZOTVLypCV5OdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 046/168] ASoC: meson: cards: select SND_DYNAMIC_MINORS
Date: Tue, 14 May 2024 12:19:04 +0200
Message-ID: <20240514101008.430729008@linuxfoundation.org>
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



