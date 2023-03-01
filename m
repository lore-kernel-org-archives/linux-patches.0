Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB6E847A
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 18:08:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8A73C433EF;
	Wed,  1 Mar 2023 18:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677694128;
	bh=QPcNFvGHkkNV4wKWo7XyJcP3fiArJMHCz3/xNZTjLzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BQ0ujDyBeOIlnnNhLzOWUDeyhWloGXx7VctuO4pcVdtEwENd7ksTq6SXvIZRWiHYh
	 Qbf06J2xsum8A/lKZXTweD41mrbHIopMa4Uf4YcfftGPi8UVo0cCKoEATh0KNZ3Mgw
	 M2/u8qa+blKQ3y+IEa5LrwPgB9jLrAI5U+BO5k/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Rodionov <vitalyr@opensource.cirrus.com>,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Richard Fitzgerald <rf@opensource.cirrus.com>
Subject: [PATCH 6.2 01/16] ALSA: hda: cs35l41: Correct error condition handling
Date: Wed,  1 Mar 2023 19:07:37 +0100
Message-Id: <20230301180653.314613545@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180653.263532453@linuxfoundation.org>
References: <20230301180653.263532453@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Vitaly Rodionov <vitalyr@opensource.cirrus.com>

commit 943f4e64ee177cf44d7f2c235281fcda7c32bb28 upstream.

Function cs_dsp_coeff_write_ctrl() can return 3 possible values:
0 - no change, 1 - value has changed and -1 - error, so positive value
is not an error.
Fixes: 7406bdbc4fb8 ("ASoC: wm_adsp: Return whether changed when writing controls")

Signed-off-by: Vitaly Rodionov <vitalyr@opensource.cirrus.com>
Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20230213145008.1215849-2-sbinding@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: Richard Fitzgerald <rf@opensource.cirrus.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/hda_cs_dsp_ctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/hda_cs_dsp_ctl.c
+++ b/sound/pci/hda/hda_cs_dsp_ctl.c
@@ -218,10 +218,10 @@ int hda_cs_dsp_write_ctl(struct cs_dsp *
 	cs_ctl = cs_dsp_get_ctl(dsp, name, type, alg);
 	ret = cs_dsp_coeff_write_ctrl(cs_ctl, 0, buf, len);
 	mutex_unlock(&dsp->pwr_lock);
-	if (ret)
+	if (ret < 0)
 		return ret;
 
-	if (cs_ctl->flags & WMFW_CTL_FLAG_SYS)
+	if (ret == 0 || (cs_ctl->flags & WMFW_CTL_FLAG_SYS))
 		return 0;
 
 	ctl = cs_ctl->priv;


