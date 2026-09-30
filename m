Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CDC03C4551;
	Wed, 30 Sep 2026 19:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794884; cv=none; b=gz0IZmcbz3DKy+v8GkZ/yw2RAj/SjMDjJE1C3FFtX1OZmTU7Rm7VpQBRCK6wWpGBkzyLnL2rmulRIyk8MKtepiIl4cpgl2GsX5tcKE/Vls1Yu+Jxl0BhuKPj4j1WfFo+pjNXhSil7fTKDS39LUyc2a30OVcOnFzhN5o9E10HkFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794884; c=relaxed/simple;
	bh=zoTLzRqNm/HzhctIIKkLHYcT0kXCOykYvEvww2mEF/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jVeALzHZyfrWWGEzdwDemopU7kqyhYEUPj8/cwt7PhVT8/NvXIPNmXczRANVWOiDlbirgt8duc6RxqczHUO41q8iWb+0ki92I8EmxqN0biDLBWR0q7eJdq1ILBOxWXpwIVm6wE3mu2FQiACFZSFOgMZwiLaF0Dg+wQ6AvLi3qB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HhQ346OS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HhQ346OS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41951F008A6;
	Wed, 30 Sep 2026 19:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794878;
	bh=Jh5pf/3PXDzYR9x9DAl/bQD16Hqc64V3L2N7FoRMiaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HhQ346OSRV/80Vy3C7N1nDyeqos2R5MLqttDWD1ryNf4XsvBxYiuKkR1lTRcYJDeC
	 XruT27qBZC/ky9PzYKorlNxvVHoilLDbzhM27uK1qarvJpTiZnmb4nwHgp7zSRaIHs
	 OQ9+Hwr16vds1t5zXVxbwRkuR8owmR68rZFYARpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0363/1193] ASoC: topology: Check PCM and DAI name strings before use
Date: Wed, 30 Sep 2026 17:17:27 +0200
Message-ID: <20260930152442.241444186@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a643ef654b9d7..ff6c9de25b968 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -1523,9 +1523,24 @@ static int soc_tplg_dapm_complete(struct soc_tplg *tplg)
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
@@ -1578,7 +1593,11 @@ static int soc_tplg_dai_create(struct soc_tplg *tplg,
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
@@ -1684,7 +1703,11 @@ static int soc_tplg_fe_link_create(struct soc_tplg *tplg,
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
@@ -1694,7 +1717,11 @@ static int soc_tplg_fe_link_create(struct soc_tplg *tplg,
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
@@ -2188,6 +2215,10 @@ static int soc_tplg_dai_config(struct soc_tplg *tplg,
 
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



