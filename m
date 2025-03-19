Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF801E2834;
	Wed, 19 Mar 2025 14:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395072; cv=none; b=KE5omnYfEaZnvp1KVmdNvryBqV+ia5gUnlkzJriC52WEhreTG53ijr9dqK9h++kHFxQNORQ9p9LnW11TT/e2CqyOpetvldlwz49ANGgLJma9HaneuYRhxI0/M0/SJSpap4h8NK+Rjct+0JbQXGE+/vZHSANOEFkTGN1ym5/agMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395072; c=relaxed/simple;
	bh=31g12/a7DhEOgggP8Ax8vWMlfK49eTRO0JwvlWakx+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W0JRGgPQHLDI7A4cTy71r2mCxTHy5X4ZThZs4AHUZtRf+KF8um1ldfsLGo6gdbr/PjFMizd9sMLxxhG35VspZmCnRryNbalKQja7yeGhBshk146Z3uGEWcxIY16KEWaX9R1oUAdGpWnjYFzpDdlaYjP/aBXYv2Z+jARQ7OKApyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RIV8QpfM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RIV8QpfM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117F9C4CEE4;
	Wed, 19 Mar 2025 14:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395072;
	bh=31g12/a7DhEOgggP8Ax8vWMlfK49eTRO0JwvlWakx+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RIV8QpfMebJhs4XHC8tKME5wqOlnqdi4gh3eaUsInd/wA78qnpJvCtJczlL1eXhAY
	 7QaZzJFBf3lrzumzcSIHfTQNTtEBo1pXVikNPNn3dK3q/KvLzjYuZvOxbaAqD87zqH
	 I6GvHCj7IbMgTKazbuDnekmSkkLvgzfRFgHkXeOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 110/231] ASoC: rsnd: adjust convert rate limitation
Date: Wed, 19 Mar 2025 07:30:03 -0700
Message-ID: <20250319143029.555770306@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 89f9cf185885d4358aa92b48e51d0f09b71775aa ]

Current rsnd driver supports Synchronous SRC Mode, but HW allow to update
rate only within 1% from current rate. Adjust to it.

Becially, this feature is used to fine-tune subtle difference that occur
during sampling rate conversion in SRC. So, it should be called within 1%
margin of rate difference.

If there was difference over 1%, it will apply with 1% increments by using
loop without indicating error message.

Cc: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://patch.msgid.link/871pwd2qe8.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sh/rcar/src.c | 98 ++++++++++++++++++++++++++++++++---------
 1 file changed, 76 insertions(+), 22 deletions(-)

diff --git a/sound/soc/sh/rcar/src.c b/sound/soc/sh/rcar/src.c
index 3099180297722..7d73b183bda68 100644
--- a/sound/soc/sh/rcar/src.c
+++ b/sound/soc/sh/rcar/src.c
@@ -35,6 +35,7 @@ struct rsnd_src {
 	struct rsnd_mod *dma;
 	struct rsnd_kctrl_cfg_s sen;  /* sync convert enable */
 	struct rsnd_kctrl_cfg_s sync; /* sync convert */
+	u32 current_sync_rate;
 	int irq;
 };
 
@@ -100,7 +101,7 @@ static u32 rsnd_src_convert_rate(struct rsnd_dai_stream *io,
 	if (!rsnd_src_sync_is_enabled(mod))
 		return rsnd_io_converted_rate(io);
 
-	convert_rate = src->sync.val;
+	convert_rate = src->current_sync_rate;
 
 	if (!convert_rate)
 		convert_rate = rsnd_io_converted_rate(io);
@@ -201,13 +202,73 @@ static const u32 chan222222[] = {
 static void rsnd_src_set_convert_rate(struct rsnd_dai_stream *io,
 				      struct rsnd_mod *mod)
 {
+	struct snd_pcm_runtime *runtime = rsnd_io_to_runtime(io);
 	struct rsnd_priv *priv = rsnd_mod_to_priv(mod);
-	struct device *dev = rsnd_priv_to_dev(priv);
+	struct rsnd_src *src = rsnd_mod_to_src(mod);
+	u32 fin, fout, new_rate;
+	int inc, cnt, rate;
+	u64 base, val;
+
+	if (!runtime)
+		return;
+
+	if (!rsnd_src_sync_is_enabled(mod))
+		return;
+
+	fin	= rsnd_src_get_in_rate(priv, io);
+	fout	= rsnd_src_get_out_rate(priv, io);
+
+	new_rate = src->sync.val;
+
+	if (!new_rate)
+		new_rate = fout;
+
+	/* Do nothing if no diff */
+	if (new_rate == src->current_sync_rate)
+		return;
+
+	/*
+	 * SRCm_IFSVR::INTIFS can change within 1%
+	 * see
+	 *	SRCm_IFSVR::INTIFS Note
+	 */
+	inc = fout / 100;
+	cnt = abs(new_rate - fout) / inc;
+	if (fout > new_rate)
+		inc *= -1;
+
+	/*
+	 * After start running SRC, we can update only SRC_IFSVR
+	 * for Synchronous Mode
+	 */
+	base = (u64)0x0400000 * fin;
+	rate  = fout;
+	for (int i = 0; i < cnt; i++) {
+		val   = base;
+		rate += inc;
+		do_div(val, rate);
+
+		rsnd_mod_write(mod, SRC_IFSVR, val);
+	}
+	val   = base;
+	do_div(val, new_rate);
+
+	rsnd_mod_write(mod, SRC_IFSVR, val);
+
+	/* update current_sync_rate */
+	src->current_sync_rate = new_rate;
+}
+
+static void rsnd_src_init_convert_rate(struct rsnd_dai_stream *io,
+				       struct rsnd_mod *mod)
+{
 	struct snd_pcm_runtime *runtime = rsnd_io_to_runtime(io);
+	struct rsnd_priv *priv = rsnd_mod_to_priv(mod);
+	struct device *dev = rsnd_priv_to_dev(priv);
 	int is_play = rsnd_io_is_play(io);
 	int use_src = 0;
 	u32 fin, fout;
-	u32 ifscr, fsrate, adinr;
+	u32 ifscr, adinr;
 	u32 cr, route;
 	u32 i_busif, o_busif, tmp;
 	const u32 *bsdsr_table;
@@ -245,26 +306,15 @@ static void rsnd_src_set_convert_rate(struct rsnd_dai_stream *io,
 	adinr = rsnd_get_adinr_bit(mod, io) | chan;
 
 	/*
-	 * SRC_IFSCR / SRC_IFSVR
-	 */
-	ifscr = 0;
-	fsrate = 0;
-	if (use_src) {
-		u64 n;
-
-		ifscr = 1;
-		n = (u64)0x0400000 * fin;
-		do_div(n, fout);
-		fsrate = n;
-	}
-
-	/*
+	 * SRC_IFSCR
 	 * SRC_SRCCR / SRC_ROUTE_MODE0
 	 */
+	ifscr	= 0;
 	cr	= 0x00011110;
 	route	= 0x0;
 	if (use_src) {
 		route	= 0x1;
+		ifscr	= 0x1;
 
 		if (rsnd_src_sync_is_enabled(mod)) {
 			cr |= 0x1;
@@ -335,7 +385,6 @@ static void rsnd_src_set_convert_rate(struct rsnd_dai_stream *io,
 	rsnd_mod_write(mod, SRC_SRCIR, 1);	/* initialize */
 	rsnd_mod_write(mod, SRC_ADINR, adinr);
 	rsnd_mod_write(mod, SRC_IFSCR, ifscr);
-	rsnd_mod_write(mod, SRC_IFSVR, fsrate);
 	rsnd_mod_write(mod, SRC_SRCCR, cr);
 	rsnd_mod_write(mod, SRC_BSDSR, bsdsr_table[idx]);
 	rsnd_mod_write(mod, SRC_BSISR, bsisr_table[idx]);
@@ -348,6 +397,9 @@ static void rsnd_src_set_convert_rate(struct rsnd_dai_stream *io,
 
 	rsnd_adg_set_src_timesel_gen2(mod, io, fin, fout);
 
+	/* update SRC_IFSVR */
+	rsnd_src_set_convert_rate(io, mod);
+
 	return;
 
 convert_rate_err:
@@ -467,7 +519,8 @@ static int rsnd_src_init(struct rsnd_mod *mod,
 	int ret;
 
 	/* reset sync convert_rate */
-	src->sync.val = 0;
+	src->sync.val		=
+	src->current_sync_rate	= 0;
 
 	ret = rsnd_mod_power_on(mod);
 	if (ret < 0)
@@ -475,7 +528,7 @@ static int rsnd_src_init(struct rsnd_mod *mod,
 
 	rsnd_src_activation(mod);
 
-	rsnd_src_set_convert_rate(io, mod);
+	rsnd_src_init_convert_rate(io, mod);
 
 	rsnd_src_status_clear(mod);
 
@@ -493,7 +546,8 @@ static int rsnd_src_quit(struct rsnd_mod *mod,
 	rsnd_mod_power_off(mod);
 
 	/* reset sync convert_rate */
-	src->sync.val = 0;
+	src->sync.val		=
+	src->current_sync_rate	= 0;
 
 	return 0;
 }
@@ -601,7 +655,7 @@ static int rsnd_src_pcm_new(struct rsnd_mod *mod,
 			       "SRC Out Rate Switch" :
 			       "SRC In Rate Switch",
 			       rsnd_kctrl_accept_anytime,
-			       rsnd_src_set_convert_rate,
+			       rsnd_src_init_convert_rate,
 			       &src->sen, 1);
 	if (ret < 0)
 		return ret;
-- 
2.39.5



