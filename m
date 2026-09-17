Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D848D547077;
	Thu, 17 Sep 2026 17:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665104; cv=none; b=Eg7i4Sg9VqUYQOBFbTV4tC7anXGJFmhZu6G6WLbGdzAlk86pgbU1usNlBSw+PTjdksvtSZd43qknf5TpHeNjCcOKpye7quQR0B8vLtUUOw0+XzNkmRClBfWtU1tnb1hxx7V3/fce3Cl4nTznGJcMAFni1EHTL/dP761pir60f1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665104; c=relaxed/simple;
	bh=jBQBT5WszA3vpouQBJs2eWDuWYjnc7ayyoKSBX0ghIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GOh5mgR7OSsLkNhOVl1yDL7SXRPN1qa8qXStwSgdjCoVUcb3YkeSXUA/nqF241yMkQVjqbpd5KPg2R4+96PoUq9lmJWMp5wNeCQKtob738XKL9sCVCnl4sLmvY14sJtXu2/vnzJuUTib37t4p/16eEYnC0/CUtIP+OxFVdvIVCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JvYKna6r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JvYKna6r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 214441F000FF;
	Thu, 17 Sep 2026 17:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665102;
	bh=f8nY82PeDW5gqMY5LHkEFtW+UZTVkxdffXO0SXtzm3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JvYKna6rbmZszwZVfdQsLCZIULTfoDmT0Wn24HAT9hoIKrJ6McdFsvJSIdkcrQ4Dn
	 f0ZadEIM7gaEkqWUIx4AEYHnaCaPGIVkzgxbuT/MsbgYoAOeA48v5G+90m/IYkGFu2
	 dzEX+6l7SkhXPQJA5SHFgsFBAPwZdfBgfrbbQV4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0592/1250] ASoC: topology: Check PCM and DAI name strings before use
Date: Thu, 17 Sep 2026 16:06:27 +0100
Message-ID: <20260917151607.927898672@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 44b60324eaa2e..3e4f96e79021a 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -1320,9 +1320,24 @@ static int soc_tplg_dapm_complete(struct soc_tplg *tplg)
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
@@ -1375,7 +1390,11 @@ static int soc_tplg_dai_create(struct soc_tplg *tplg,
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
@@ -1481,7 +1500,11 @@ static int soc_tplg_fe_link_create(struct soc_tplg *tplg,
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
@@ -1491,7 +1514,11 @@ static int soc_tplg_fe_link_create(struct soc_tplg *tplg,
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
@@ -1843,6 +1870,10 @@ static int soc_tplg_dai_config(struct soc_tplg *tplg,
 
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



