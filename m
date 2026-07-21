Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCBA639BFFE;
	Tue, 21 Jul 2026 18:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659718; cv=none; b=r/kymPV21pdLqrnaxXwBINcnCxwiTFJz7lvQhglEg3XEU5WkE0ism3aLD6WNKHASiwlzy3Ty+dpYiRUQ2vNro6wjxjyEPrCOGbqymMD99iY75dKgtHCQjVSkf89QvwssXdR3RdSWaoKtrO4LcSDgWmWIvwA2XrpOcSPzKzB5ZPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659718; c=relaxed/simple;
	bh=AlyTtZtB3iY2B1+H52/8XYA+H81mlL0MTORru5NQeKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qrg5W66LtEjcvvbybkFTZYYApiPirTaSRvJO9oAYyauv6PXISgdzMQfQ1R+nfhHClxccIcD5lo4JcBCmddslZl3e9ju1fN7GI+d+VYGZJQDsf00VX19Atw34qAg37SL++2rE9MpDq/7L1xwA4Kd8YDRjVitWWGXUNzyarjuEyv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jiEcqvgH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jiEcqvgH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F351F000E9;
	Tue, 21 Jul 2026 18:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659717;
	bh=mssDxzNDiCy0VOtvDd3b5ZJujGG+zoiaBxeqkoNwgAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jiEcqvgHZMgc6lNtHBbw/hth5HsXbVmXNEsBNNU9M6k5Tt3hl5cf7Hoqy/aE1cZ/s
	 OVG4DTXK2ju11snAPBhqikk3FBmpJxYQVQKE5LCHbpdNJ3Gpz1jRiX8IVg//Lc1TRW
	 oV9GnZtat8zGM7RciqKiJTli0A0YQpoC2oGNJ8+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0707/2077] ASoC: topology: Check PCM and DAI name strings before use
Date: Tue, 21 Jul 2026 17:06:20 +0200
Message-ID: <20260721152609.469205956@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit b7e44d1986d6671342c19b82192189ca5db5dab7 ]

Topology objects store several PCM and DAI names in fixed-size UAPI
arrays. Other topology parser paths validate these fields with bounded
strnlen() checks before using them as C strings, but the PCM and DAI
paths still pass some fixed-size arrays directly to strlen(),
devm_kstrdup(), DAI lookup, and diagnostic prints.

A malformed topology blob with a non-NUL-terminated PCM, DAI, or stream
capability name can therefore make the parser read past the end of the
fixed-size field.

Reject unterminated PCM and DAI name fields before consuming them as C
strings.

Fixes: 64527e8a3529 ("ASoC: topology: Add FE DAIs dynamically")
Fixes: acfc7d46cddc ("ASoC: topology: Add FE DAI links dynamically")
Fixes: 0038be9a84dc ("ASoC: topology: Add support for configuring existing BE DAIs")
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260604-asoc-topology-check-pcm-dai-names-v1-1-e1b0f6f7c2ce@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-topology.c | 37 ++++++++++++++++++++++++++++++++++---
 1 file changed, 34 insertions(+), 3 deletions(-)

diff --git a/sound/soc/soc-topology.c b/sound/soc/soc-topology.c
index 85679c8e022999..35cbe29d227589 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -1326,9 +1326,24 @@ static int soc_tplg_dapm_complete(struct soc_tplg *tplg)
 	return ret;
 }
 
+static int soc_tplg_check_name(const char *name)
+{
+	if (strnlen(name, SNDRV_CTL_ELEM_ID_NAME_MAXLEN) ==
+	    SNDRV_CTL_ELEM_ID_NAME_MAXLEN)
+		return -EINVAL;
+
+	return 0;
+}
+
 static int set_stream_info(struct soc_tplg *tplg, struct snd_soc_pcm_stream *stream,
 			   struct snd_soc_tplg_stream_caps *caps)
 {
+	int ret;
+
+	ret = soc_tplg_check_name(caps->name);
+	if (ret)
+		return ret;
+
 	stream->stream_name = devm_kstrdup(tplg->dev, caps->name, GFP_KERNEL);
 	if (!stream->stream_name)
 		return -ENOMEM;
@@ -1380,7 +1395,11 @@ static int soc_tplg_dai_create(struct soc_tplg *tplg,
 	if (dai_drv == NULL)
 		return -ENOMEM;
 
-	if (strlen(pcm->dai_name)) {
+	ret = soc_tplg_check_name(pcm->dai_name);
+	if (ret)
+		goto err;
+
+	if (pcm->dai_name[0]) {
 		dai_drv->name = devm_kstrdup(tplg->dev, pcm->dai_name, GFP_KERNEL);
 		if (!dai_drv->name) {
 			ret = -ENOMEM;
@@ -1486,7 +1505,11 @@ static int soc_tplg_fe_link_create(struct soc_tplg *tplg,
 	if (tplg->ops)
 		link->dobj.unload = tplg->ops->link_unload;
 
-	if (strlen(pcm->pcm_name)) {
+	ret = soc_tplg_check_name(pcm->pcm_name);
+	if (ret)
+		goto err;
+
+	if (pcm->pcm_name[0]) {
 		link->name = devm_kstrdup(tplg->dev, pcm->pcm_name, GFP_KERNEL);
 		link->stream_name = devm_kstrdup(tplg->dev, pcm->pcm_name, GFP_KERNEL);
 		if (!link->name || !link->stream_name) {
@@ -1496,7 +1519,11 @@ static int soc_tplg_fe_link_create(struct soc_tplg *tplg,
 	}
 	link->id = le32_to_cpu(pcm->pcm_id);
 
-	if (strlen(pcm->dai_name)) {
+	ret = soc_tplg_check_name(pcm->dai_name);
+	if (ret)
+		goto err;
+
+	if (pcm->dai_name[0]) {
 		link->cpus->dai_name = devm_kstrdup(tplg->dev, pcm->dai_name, GFP_KERNEL);
 		if (!link->cpus->dai_name) {
 			ret = -ENOMEM;
@@ -1848,6 +1875,10 @@ static int soc_tplg_dai_config(struct soc_tplg *tplg,
 
 	memset(&dai_component, 0, sizeof(dai_component));
 
+	ret = soc_tplg_check_name(d->dai_name);
+	if (ret)
+		return ret;
+
 	dai_component.dai_name = d->dai_name;
 	dai = snd_soc_find_dai(&dai_component);
 	if (!dai) {
-- 
2.53.0



