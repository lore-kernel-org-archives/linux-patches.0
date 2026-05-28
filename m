Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB7F33F5B4;
	Thu, 28 May 2026 19:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998226; cv=none; b=lyZdMLf0u3uVY9CSqnGLVOkj6lg35u9MHoGxKRWTQVazG7y4rny+bMqzJAtFWKRyUmYRMo0r3alHnvNPBxNFCeZjPMfSrfW86clHNgiCL/KB2kougDyhgKDlJLwT91oxzXvdAStae3Y94q/beoMJOHt1+sFTOgpuXtkF6UWLzUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998226; c=relaxed/simple;
	bh=Cnpnl5hB/wZTUyIExlMBWE4ErhH4hrVYTszEV+ZeH+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XP4gfyfQ6vrnAOEE4hjiVGwPClxUPqr2vXdm4h/1ldH6H82Nu1XmU1ya9qZyTszQpY6sLthFfO2StXxo1K/YvIDz8vU2UAHBkOaihU95ifmGq8qyDnGCEpmQ9SHpajp/L9sXvom8a0vx6ARA2ShCXcHMqOtTdXKOLyxd2UojUPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rrVMjYRr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rrVMjYRr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BA291F000E9;
	Thu, 28 May 2026 19:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998225;
	bh=g/khfj49g37Fw2oDLYHsSgYULotdA7walskFZG9nvtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rrVMjYRrhFPnHaBox9ilrLPUlRgdRKEBswo83MaR1kPygJ8x1XsfozFZmpzqsl9Tw
	 GkyKUX5ZV6d9/GzdHgoIYhzxTckEwLQlbFT2z0ThZjIFnzBrPHPVqdgGh84T/u3spO
	 esNn5xT+2hMbNq9rJctHU9QIyiPqvHMKARxI8jEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jeongjun Park <aha310510@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 098/461] ASoC: codecs: pcm512x: fix null-ptr dereference in pcm512x_overclock_xxx_put()
Date: Thu, 28 May 2026 21:43:47 +0200
Message-ID: <20260528194649.788180815@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeongjun Park <aha310510@gmail.com>

commit 09e8f9a9aa19aa8c1b0cc7a0ebc68f6ecf86a660 upstream.

In the pcm512x chipset driver, pcm512x_overclock_xxx_put() is defined as
a general mixer kcontrol instead of a DAPM kcontrol, so struct
snd_soc_dapm_context must not be accessed via
snd_soc_dapm_kcontrol_to_dapm().

This causes a NULL pointer dereference, so it must be modified to use
snd_soc_component_to_dapm().

Cc: stable@kernel.org
Closes: https://github.com/raspberrypi/linux/issues/7242
Fixes: 02dbbb7e982a ("ASoC: codecs: pcm512x: convert to snd_soc_dapm_xxx()")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Link: https://patch.msgid.link/20260521113712.227438-1-aha310510@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/pcm512x.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/soc/codecs/pcm512x.c
+++ b/sound/soc/codecs/pcm512x.c
@@ -235,7 +235,7 @@ static int pcm512x_overclock_pll_put(str
 				     struct snd_ctl_elem_value *ucontrol)
 {
 	struct snd_soc_component *component = snd_kcontrol_chip(kcontrol);
-	struct snd_soc_dapm_context *dapm = snd_soc_dapm_kcontrol_to_dapm(kcontrol);
+	struct snd_soc_dapm_context *dapm = snd_soc_component_to_dapm(component);
 	struct pcm512x_priv *pcm512x = snd_soc_component_get_drvdata(component);
 
 	switch (snd_soc_dapm_get_bias_level(dapm)) {
@@ -264,7 +264,7 @@ static int pcm512x_overclock_dsp_put(str
 				     struct snd_ctl_elem_value *ucontrol)
 {
 	struct snd_soc_component *component = snd_kcontrol_chip(kcontrol);
-	struct snd_soc_dapm_context *dapm = snd_soc_dapm_kcontrol_to_dapm(kcontrol);
+	struct snd_soc_dapm_context *dapm = snd_soc_component_to_dapm(component);
 	struct pcm512x_priv *pcm512x = snd_soc_component_get_drvdata(component);
 
 	switch (snd_soc_dapm_get_bias_level(dapm)) {
@@ -293,7 +293,7 @@ static int pcm512x_overclock_dac_put(str
 				     struct snd_ctl_elem_value *ucontrol)
 {
 	struct snd_soc_component *component = snd_kcontrol_chip(kcontrol);
-	struct snd_soc_dapm_context *dapm = snd_soc_dapm_kcontrol_to_dapm(kcontrol);
+	struct snd_soc_dapm_context *dapm = snd_soc_component_to_dapm(component);
 	struct pcm512x_priv *pcm512x = snd_soc_component_get_drvdata(component);
 
 	switch (snd_soc_dapm_get_bias_level(dapm)) {


