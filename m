Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C54263F5F;
	Tue, 25 Mar 2025 12:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905582; cv=none; b=MN6xp3g/agB0bGOjvSxswVDg7i9dq2dlHqMPnXnpCtukaTXQxTDZvh0oIcugox2lRAIwr1xp7lKvfCuhDbvX65DKkrOkIVKsY3oZhp59O5pA/lx6XzRD5UFMFnfp8r+HANcs/irkTVZ9n7i7vOQ9DQkWCb98VvNedtMhN4fkL8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905582; c=relaxed/simple;
	bh=YtHlrQOmMF4j9LgAMc+iR9FAraaq8E3hiH3mAhev6zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fz3OFlbubEVZpMBhSCAgg47yOqKyNPYQdWDcjW6J72rkh6cBbYg20LeH44tKxSXyyPeZh2h297Izh0rV7YZymeO7Xyhqq6JGNawN6ED7eWfrV0blrfIsMlX2jmQZzjkTXk78qofcfeBAmr+1wDvzewEmpkF5hdtz3Gfdh6TpvxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sBUls83e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sBUls83e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D80AC4CEE4;
	Tue, 25 Mar 2025 12:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905581;
	bh=YtHlrQOmMF4j9LgAMc+iR9FAraaq8E3hiH3mAhev6zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sBUls83eo8buTu0m/pDcRWswS5YvJ8UQ0uWzaSB0YJl6Sdj8WmmWtTTz/89n504ha
	 R6QllHRqYRbOjl5Go54u9ZMI8J6WOtmLvjj9dXzEgfo9mEoMEAfS4Xuh4enDEN4BlJ
	 edyI6MOlYB2cC4ngKTUSf4A+k9aI3YOysMUfOxSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 053/198] ASoC: rsnd: dont indicate warning on rsnd_kctrl_accept_runtime()
Date: Tue, 25 Mar 2025 08:20:15 -0400
Message-ID: <20250325122158.025148021@linuxfoundation.org>
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

[ Upstream commit c3fc002b206c6c83d1e3702b979733002ba6fb2c ]

rsnd_kctrl_accept_runtime() (1) is used for runtime convert rate
(= Synchronous SRC Mode). Now, rsnd driver has 2 kctrls for it

(A):	"SRC Out Rate Switch"
(B):	"SRC Out Rate"		// it calls (1)

(A): can be called anytime
(B): can be called only runtime, and will indicate warning if it was used
   at non-runtime.

To use runtime convert rate (= Synchronous SRC Mode), user might uses
command in below order.

(X):	> amixer set "SRC Out Rate" on
	> aplay xxx.wav &
(Y):	> amixer set "SRC Out Rate" 48010 // convert rate to 48010Hz

(Y): calls B
(X): calls both A and B.

In this case, when user calls (X), it calls both (A) and (B), but it is not
yet start running. So, (B) will indicate warning.

This warning was added by commit b5c088689847 ("ASoC: rsnd: add warning
message to rsnd_kctrl_accept_runtime()"), but the message sounds like the
operation was not correct. Let's update warning message.

The message is very SRC specific, implement it in src.c

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://patch.msgid.link/8734gt2qed.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sh/rcar/core.c | 14 --------------
 sound/soc/sh/rcar/rsnd.h |  1 -
 sound/soc/sh/rcar/src.c  | 18 +++++++++++++++++-
 3 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/sound/soc/sh/rcar/core.c b/sound/soc/sh/rcar/core.c
index 7e380d71b0f88..0964b4e3fbdfb 100644
--- a/sound/soc/sh/rcar/core.c
+++ b/sound/soc/sh/rcar/core.c
@@ -1694,20 +1694,6 @@ int rsnd_kctrl_accept_anytime(struct rsnd_dai_stream *io)
 	return 1;
 }
 
-int rsnd_kctrl_accept_runtime(struct rsnd_dai_stream *io)
-{
-	struct snd_pcm_runtime *runtime = rsnd_io_to_runtime(io);
-	struct rsnd_priv *priv = rsnd_io_to_priv(io);
-	struct device *dev = rsnd_priv_to_dev(priv);
-
-	if (!runtime) {
-		dev_warn(dev, "Can't update kctrl when idle\n");
-		return 0;
-	}
-
-	return 1;
-}
-
 struct rsnd_kctrl_cfg *rsnd_kctrl_init_m(struct rsnd_kctrl_cfg_m *cfg)
 {
 	cfg->cfg.val = cfg->val;
diff --git a/sound/soc/sh/rcar/rsnd.h b/sound/soc/sh/rcar/rsnd.h
index f8ef6836ef84e..690f4932357c1 100644
--- a/sound/soc/sh/rcar/rsnd.h
+++ b/sound/soc/sh/rcar/rsnd.h
@@ -742,7 +742,6 @@ struct rsnd_kctrl_cfg_s {
 #define rsnd_kctrl_vals(x)	((x).val)	/* = (x).cfg.val[0] */
 
 int rsnd_kctrl_accept_anytime(struct rsnd_dai_stream *io);
-int rsnd_kctrl_accept_runtime(struct rsnd_dai_stream *io);
 struct rsnd_kctrl_cfg *rsnd_kctrl_init_m(struct rsnd_kctrl_cfg_m *cfg);
 struct rsnd_kctrl_cfg *rsnd_kctrl_init_s(struct rsnd_kctrl_cfg_s *cfg);
 int rsnd_kctrl_new(struct rsnd_mod *mod,
diff --git a/sound/soc/sh/rcar/src.c b/sound/soc/sh/rcar/src.c
index f832165e46bc0..9893839666d7b 100644
--- a/sound/soc/sh/rcar/src.c
+++ b/sound/soc/sh/rcar/src.c
@@ -530,6 +530,22 @@ static irqreturn_t rsnd_src_interrupt(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
+static int rsnd_src_kctrl_accept_runtime(struct rsnd_dai_stream *io)
+{
+	struct snd_pcm_runtime *runtime = rsnd_io_to_runtime(io);
+
+	if (!runtime) {
+		struct rsnd_priv *priv = rsnd_io_to_priv(io);
+		struct device *dev = rsnd_priv_to_dev(priv);
+
+		dev_warn(dev, "\"SRC Out Rate\" can use during running\n");
+
+		return 0;
+	}
+
+	return 1;
+}
+
 static int rsnd_src_probe_(struct rsnd_mod *mod,
 			   struct rsnd_dai_stream *io,
 			   struct rsnd_priv *priv)
@@ -593,7 +609,7 @@ static int rsnd_src_pcm_new(struct rsnd_mod *mod,
 			       rsnd_io_is_play(io) ?
 			       "SRC Out Rate" :
 			       "SRC In Rate",
-			       rsnd_kctrl_accept_runtime,
+			       rsnd_src_kctrl_accept_runtime,
 			       rsnd_src_set_convert_rate,
 			       &src->sync, 192000);
 
-- 
2.39.5



