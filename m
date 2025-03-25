Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC97E26563D;
	Tue, 25 Mar 2025 12:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905584; cv=none; b=Kn4QiouHc92VuO08lioYfh+fuk9AqnPmIBCAUySKQcV2GchpPjV2oWsvzg1k+kT0aG1GjvpzKR+MzQp4VJYDhyugWpgLGHO3qmrZ818cs/98K0Cqx/yBbq0u1sSrAqW/0TOP1I8kL0EKFEd15Rcf/vYKYAsGCFjLXB5ZekJdtQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905584; c=relaxed/simple;
	bh=cSZz9TbEs7TsWVgsezcTD9MXJMibHU0abNMmETrczlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JdBqx7i1ni6D63JDiOy026aFHrzeXBMXqqPPrF5b8J2Uop38cNYqQfvRTLEcV0yuTu+LGHUDGy3EVzb/etk2ZBBrVCbxEUzRhO5t9y8kQ6IGVeQiErsgq7xIX/glkHECwrVtanolM5rdaEWqTYBrQFFUfVwMGllxjyqj7a2UYvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e63NNfTQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e63NNfTQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A22C4CEE4;
	Tue, 25 Mar 2025 12:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905583;
	bh=cSZz9TbEs7TsWVgsezcTD9MXJMibHU0abNMmETrczlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e63NNfTQ96fQQzJeNny/NCaHp2hb1ih7aYki1V+zjxLzqJUBRq0+9sM+f2F8HpKyk
	 1y24hhp3fvGEsXMsgW65ufwy1pGgHOjs3g2BD3jwT8duH+5y7m5AFgnBsU1xa5202g
	 BNgdrRD6GKABLJn6yKvpqTLvUVK7W5c039U8sKSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 054/198] ASoC: rsnd: adjust convert rate limitation
Date: Tue, 25 Mar 2025 08:20:16 -0400
Message-ID: <20250325122158.051256697@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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
index 9893839666d7b..e985681363e25 100644
--- a/sound/soc/sh/rcar/src.c
+++ b/sound/soc/sh/rcar/src.c
@@ -34,6 +34,7 @@ struct rsnd_src {
 	struct rsnd_mod *dma;
 	struct rsnd_kctrl_cfg_s sen;  /* sync convert enable */
 	struct rsnd_kctrl_cfg_s sync; /* sync convert */
+	u32 current_sync_rate;
 	int irq;
 };
 
@@ -99,7 +100,7 @@ static u32 rsnd_src_convert_rate(struct rsnd_dai_stream *io,
 	if (!rsnd_src_sync_is_enabled(mod))
 		return rsnd_io_converted_rate(io);
 
-	convert_rate = src->sync.val;
+	convert_rate = src->current_sync_rate;
 
 	if (!convert_rate)
 		convert_rate = rsnd_io_converted_rate(io);
@@ -200,13 +201,73 @@ static const u32 chan222222[] = {
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
@@ -244,26 +305,15 @@ static void rsnd_src_set_convert_rate(struct rsnd_dai_stream *io,
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
@@ -334,7 +384,6 @@ static void rsnd_src_set_convert_rate(struct rsnd_dai_stream *io,
 	rsnd_mod_write(mod, SRC_SRCIR, 1);	/* initialize */
 	rsnd_mod_write(mod, SRC_ADINR, adinr);
 	rsnd_mod_write(mod, SRC_IFSCR, ifscr);
-	rsnd_mod_write(mod, SRC_IFSVR, fsrate);
 	rsnd_mod_write(mod, SRC_SRCCR, cr);
 	rsnd_mod_write(mod, SRC_BSDSR, bsdsr_table[idx]);
 	rsnd_mod_write(mod, SRC_BSISR, bsisr_table[idx]);
@@ -347,6 +396,9 @@ static void rsnd_src_set_convert_rate(struct rsnd_dai_stream *io,
 
 	rsnd_adg_set_src_timesel_gen2(mod, io, fin, fout);
 
+	/* update SRC_IFSVR */
+	rsnd_src_set_convert_rate(io, mod);
+
 	return;
 
 convert_rate_err:
@@ -466,7 +518,8 @@ static int rsnd_src_init(struct rsnd_mod *mod,
 	int ret;
 
 	/* reset sync convert_rate */
-	src->sync.val = 0;
+	src->sync.val		=
+	src->current_sync_rate	= 0;
 
 	ret = rsnd_mod_power_on(mod);
 	if (ret < 0)
@@ -474,7 +527,7 @@ static int rsnd_src_init(struct rsnd_mod *mod,
 
 	rsnd_src_activation(mod);
 
-	rsnd_src_set_convert_rate(io, mod);
+	rsnd_src_init_convert_rate(io, mod);
 
 	rsnd_src_status_clear(mod);
 
@@ -492,7 +545,8 @@ static int rsnd_src_quit(struct rsnd_mod *mod,
 	rsnd_mod_power_off(mod);
 
 	/* reset sync convert_rate */
-	src->sync.val = 0;
+	src->sync.val		=
+	src->current_sync_rate	= 0;
 
 	return 0;
 }
@@ -600,7 +654,7 @@ static int rsnd_src_pcm_new(struct rsnd_mod *mod,
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



