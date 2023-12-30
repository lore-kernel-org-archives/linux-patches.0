Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B7979C2;
	Sat, 30 Dec 2023 12:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SB+uaCJj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E2EDC433C8;
	Sat, 30 Dec 2023 12:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937945;
	bh=fAAxMhoaR2AmsJODD3yzNlbif+fJVLE68KrApxbUilw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SB+uaCJjn4/CaYM8ILko/ciMPIkiMDVtIvJ9MrP5tA9cM83c5NeFyXxr6q8Vj74uW
	 PiC+heiq+sPN17PpjG1An3Ek1Y8VhEufe9QTZizwd/MZGjTAMSCuxTJuPJjaR2G/k9
	 gXVEblw6yZDVt6hT4NuHAhrQ/rFOZ4y9Js8szILs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gergo Koteles <soyer@irl.hu>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 106/156] ALSA: hda/tas2781: select program 0, conf 0 by default
Date: Sat, 30 Dec 2023 11:59:20 +0000
Message-ID: <20231230115815.833248150@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gergo Koteles <soyer@irl.hu>

commit ec1de5c214eb5a892fdb7c450748249d5e2840f5 upstream.

Currently, cur_prog/cur_conf remains at the default value (-1), while
program 0 has been loaded into the amplifiers.

In the playback hook, tasdevice_tuning_switch tries to restore the
cur_prog/cur_conf. In the runtime_resume/system_resume,
tasdevice_prmg_load tries to load the cur_prog as well.

Set cur_prog and cur_conf to 0 if available in the firmware.

Fixes: 5be27f1e3ec9 ("ALSA: hda/tas2781: Add tas2781 HDA driver")
CC: stable@vger.kernel.org
Signed-off-by: Gergo Koteles <soyer@irl.hu>
Link: https://lore.kernel.org/r/038add0bdca1f979cc7abcce8f24cbcd3544084b.1702596646.git.soyer@irl.hu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/tas2781_hda_i2c.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/pci/hda/tas2781_hda_i2c.c b/sound/pci/hda/tas2781_hda_i2c.c
index 63a90c7e8976..2fb1a7037c82 100644
--- a/sound/pci/hda/tas2781_hda_i2c.c
+++ b/sound/pci/hda/tas2781_hda_i2c.c
@@ -543,6 +543,10 @@ static void tasdev_fw_ready(const struct firmware *fmw, void *context)
 
 	tas_priv->fw_state = TASDEVICE_DSP_FW_ALL_OK;
 	tasdevice_prmg_load(tas_priv, 0);
+	if (tas_priv->fmw->nr_programs > 0)
+		tas_priv->cur_prog = 0;
+	if (tas_priv->fmw->nr_configurations > 0)
+		tas_priv->cur_conf = 0;
 
 	/* If calibrated data occurs error, dsp will still works with default
 	 * calibrated data inside algo.
-- 
2.43.0



