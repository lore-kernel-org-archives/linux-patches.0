Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7C1F4F1;
	Sat, 12 Sep 2026 16:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232004; cv=none; b=W1qoutOM8vyzzxmfkcbCH8TAozgeSVC9Vsz4zukpZikuZA4jzq4mhi4qlU+PnzhsXY1gkIpWzvlbMcaSx14TI/LHsyK/JwQjrul0PcLAikWKoAfGMTz4ubrxHhBzoi6U5VFP9LvKD7nrGmbHyPWN6YL5r2454VMKo/V5YLsEGLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232004; c=relaxed/simple;
	bh=LqtQGhvSObbCiCzEC7eB7TlunyerTaugpcgoBiCZJSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D4NF35DUSJXDoGvDte9cFbw+OFlmxUVyK2zT4MFMhJtbx+QLW2WszG8N/iANYeQzytM5TrvZEoMBVVJvCdsDFjdKMGwQudRhtq0RkTHgTb2dg6SH3FEcpDGwJKlOn3L6nhE/PGF668Ijv68YtfHxdEt5x/qM13Cg3Wchffybugo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ac3LcvY1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ac3LcvY1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8061F000FF;
	Sat, 12 Sep 2026 16:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232003;
	bh=yg2Ijt0QdqrdMmIyGISFaVvgty47gIn8jdjlk9PpjFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ac3LcvY15MZMyJ/xrcQI+rkQn/IivtX1a01hwvRf3AIrN55ZLvCFRD66FZLtMghdu
	 cMnuOVMwFwUjhoGc30qKTEma38vZh7xk0yrLZvktiRHAe2err49qdSui92XgeYtNG/
	 D/GjnwAbu6IM/uYefLWBmuwpJHcnAknW2+ujlnxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1115/1191] ASoC: dapm: Fix off-by-one check on the second enum channel
Date: Sat, 12 Sep 2026 09:04:03 +0200
Message-ID: <20260912065613.196302363@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 14511c9b54ceeeef487409d73947c89ee8563590 ]

The snd_soc_dapm_put_enum_double() rejects item[0] once it reaches
e->items, but it lets item[1] be equal to it.  Both go on to
snd_soc_enum_item_to_val(), which indexes e->values with no bound of
its own, so an enum with a value table reads one element past the end.

The indexing arrived with the MUX consolidation, which relaxed the
item[1] check in the same hunk.  The value MUX handler it deleted used
>= there, and the snd_soc_put_enum_double() in soc-ops.c still does.

Only adav80x pairs a value table with two shifts, and its second
channel looks accidental, but the control does report two values.
Writing three into it reads off the end of adav80x_mux_values.  The
core catches that only under CONFIG_SND_CTL_INPUT_VALIDATION, which
defaults off.

Fixes: 3727b4968453 ("ASoC: dapm: Consolidate MUXs and value MUXs")
Assisted-by: Claude:claude-opus-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20260825125745.932832-1-sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-dapm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index 481e5dd593b65..87a4ebf4aa0c2 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -3525,7 +3525,7 @@ int snd_soc_dapm_put_enum_double(struct snd_kcontrol *kcontrol,
 	val = snd_soc_enum_item_to_val(e, item[0]) << e->shift_l;
 	mask = e->mask << e->shift_l;
 	if (e->shift_l != e->shift_r) {
-		if (item[1] > e->items)
+		if (item[1] >= e->items)
 			return -EINVAL;
 		val |= snd_soc_enum_item_to_val(e, item[1]) << e->shift_r;
 		mask |= e->mask << e->shift_r;
-- 
2.53.0



