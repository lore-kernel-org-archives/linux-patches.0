Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD90B4E0205;
	Thu, 17 Sep 2026 18:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668641; cv=none; b=qCwdHnnTtEIVZOvkAlwX86k1zqcB26FFylj4C83wLf4tnnzq/lIAtflzWtOxnQHRxd76eW+C+uLNfZz+Tbcn+AXWXRFfeV8HNurzdWtCW1nYdAf1zURbupBRxCaG8ZAfeFTuTcLJ9gWnDlnp6xwACexCHmzPlJV/y89s99HpuS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668641; c=relaxed/simple;
	bh=1bADyNkn/exGJuhGHaEUMLS16o48udB+h6BhqV31Ki4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D8b8ocDUB7OYse9f5azxJ/KVD9LuCbCjoAMbjxCqO4G3OvNbb7XVwvZePxDDO+pGWIzhsuyHNZIg4hux2oX9NDZZZS1G3r1byjnXvDJcBbPDLysEoW/kGjtQZXdbkjyu6W8NMxdteOb/TsmRESghIS2YD7Q4r5WxHp8VZTvrHX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EA4nxhGY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EA4nxhGY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D651F000FF;
	Thu, 17 Sep 2026 18:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668639;
	bh=RA5/oiO102ZbQB7PoX2vyV22WSNI1QzeTOuasmo+W20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EA4nxhGYhxf8E+WR84Nql4xYV6VNoQQx20ldZ8UCyljg/Qbg/YI7zXPuzu0DRrG42
	 P0fgSOsZb2/c0wEuDGFJ91VdO2GrHLiFWvaJQIheQnJNtyUbLAj1cZIzps4UAC5/a9
	 giNHINYEHqsSBQ5wky6whBhvydn10VkIgn0dzkxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0491/1102] ASoC: topology: Check PCM and DAI name strings before use
Date: Thu, 17 Sep 2026 16:07:14 +0100
Message-ID: <20260917151552.039078534@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 97517423d1f0b..ea451b227a66b 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -1348,9 +1348,24 @@ static int soc_tplg_dapm_complete(struct soc_tplg *tplg)
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
@@ -1403,7 +1418,11 @@ static int soc_tplg_dai_create(struct soc_tplg *tplg,
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
@@ -1509,7 +1528,11 @@ static int soc_tplg_fe_link_create(struct soc_tplg *tplg,
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
@@ -1519,7 +1542,11 @@ static int soc_tplg_fe_link_create(struct soc_tplg *tplg,
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
@@ -1871,6 +1898,10 @@ static int soc_tplg_dai_config(struct soc_tplg *tplg,
 
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



