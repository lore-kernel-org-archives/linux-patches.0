Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928C922424C;
	Tue,  8 Apr 2025 11:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112428; cv=none; b=Q5AK94fLDAohMGko6U17audI4PfcDyEVkcCeg/dtrz/hEMHlw1Kb9uYH8j/pxPNCcR2NIiFBK3rVRKgN1goKUVXIG3F8TLOCLpJHKd4M6ljx23qE50NtkjiZnSUXu+VVvj9qabG5/uppVJCd921HtEuS0nZno356oRTfoOB0bnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112428; c=relaxed/simple;
	bh=F4kjI2UU0dXmWfYongOQLHR3WIpOrhoAvDdTBcdeEhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fbhEFuZQ/pYfNsunO2hsIEUWqi7glh43f9E40Pk/9797WRVREPyn/WeSV2zcHRcdcBeRqGOEye1m2TbVtF38WUaA4KnaKi4lEOCzdhfytrDC/NVXMyWmecSs5W3uHv+XAW4krdaHPAzEXU3plXAQW0XGvFkOQPushc+xTQXT25U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A3wxHzwm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A3wxHzwm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 228B7C4CEE5;
	Tue,  8 Apr 2025 11:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112428;
	bh=F4kjI2UU0dXmWfYongOQLHR3WIpOrhoAvDdTBcdeEhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A3wxHzwm/Uq87vlmwMcxL6dZT0KHY9s7DeelBVxxfVhfTrtc4Wb6Br8Az14pR6h8C
	 NqMMZbCCO1RNZdrL7egV5RigT2zzkyhgoKU8iLR3yO0ZIldQKcZcA9ldid5R99KCxh
	 tVT5N/Is7NdYqJYeetclF0wZb7DaIK46K5IedS5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 038/279] ASoC: rsnd: dont indicate warning on rsnd_kctrl_accept_runtime()
Date: Tue,  8 Apr 2025 12:47:01 +0200
Message-ID: <20250408104827.409578069@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index af8ef2a27d341..65022ba5c5875 100644
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



