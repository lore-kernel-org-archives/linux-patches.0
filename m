Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7AE3A9DBA;
	Sat, 12 Sep 2026 20:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243497; cv=none; b=D3bsFN8+EX2o3hDevbfudsZhQVh0j8pn+wtlV/IjvzygPW98n+V6i3Gt6i39frr5iz5Fy8UgzeN9N+1yUf2VfPDzmLVmTbPaHM1ro2fOVZogCLR5HPWY7NskxsRBWy7tSwOI8MYKBmHmFBwr9UsPkrVlllhUkJd4yp9yV/HoDd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243497; c=relaxed/simple;
	bh=J6YrC3rBRQ8rcif/k5kpaqI+ZAMvkwt5LE3Z4cEFJ1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mWgcEFaGv8DoNFrj72MngZ0knp+NVm5OUMfx57S3WH0jpbNX1BsTooVYE0iCSHD9P0r4KcsPvujCO+NeTykyR/3p/Uu4nsSMedBePOFoByVC/vrUnxblQr4SafLki15xmDtGn5taIcPUTioAyw83whYxSwsjQbjeRZzJGcnMatQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KWV1N4l5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KWV1N4l5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3751F00893;
	Sat, 12 Sep 2026 20:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243487;
	bh=w8DzU2fmwp5NBipx974eHX23a614TKFWNio8WxN8M74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KWV1N4l5S6s0yytTPfCMxJJqieWyfuvlluClQ9A1/n5Ye1JpZLE3XwgJ6Sf1jTTb7
	 /W6okwSnrpxybd44qCC0upk0Mn3KlIQn+lY2lH7nvTIt/U4zAY9PSBYYP7hhYfVjFb
	 3+fsRzeIDRT/RiQHQegi8F83BvDd60Dj0xfnqKcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 771/798] ASoC: dapm: Fix off-by-one check on the second enum channel
Date: Sat, 12 Sep 2026 09:06:39 +0200
Message-ID: <20260912065534.741491019@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a3bebea5879b1..74043c1bb4584 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -3516,7 +3516,7 @@ int snd_soc_dapm_put_enum_double(struct snd_kcontrol *kcontrol,
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



