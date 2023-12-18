Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F141D126;
	Mon, 18 Dec 2023 14:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IqXzmt5q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD1DEC433C8;
	Mon, 18 Dec 2023 14:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908147;
	bh=NpvnboC432ERCy5ckJUH256PvjfiuCJ5lF8fseGGps8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IqXzmt5qPA4+crQdEqac3JIxUFnr7rNXA2k1FMFFHYBWO9SSVWg93ZjGxa8eo9f8X
	 Q8oM7pZoPezJobKIMw+2tCSCLpzVrpX9xfFhCxnBhPaCw/Y0YZaZgXDtjBncWotjjF
	 6W+sEMUrJ8/9z/ceopo6omVi/kKB2rR4dH8sDVFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gergo Koteles <soyer@irl.hu>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 071/166] ALSA: hda/tas2781: call cleanup functions only once
Date: Mon, 18 Dec 2023 14:50:37 +0100
Message-ID: <20231218135108.238577220@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

commit 6c6fa2641402e8e753262fb61ed9a15a7cb225ad upstream.

If the module can load the RCA but not the firmware binary, it will call
the cleanup functions. Then unloading the module causes general
protection fault due to double free.

Do not call the cleanup functions in tasdev_fw_ready.

general protection fault, probably for non-canonical address
0x6f2b8a2bff4c8fec: 0000 [#1] PREEMPT SMP NOPTI
Call Trace:
 <TASK>
 ? die_addr+0x36/0x90
 ? exc_general_protection+0x1c5/0x430
 ? asm_exc_general_protection+0x26/0x30
 ? tasdevice_config_info_remove+0x6d/0xd0 [snd_soc_tas2781_fmwlib]
 tas2781_hda_unbind+0xaa/0x100 [snd_hda_scodec_tas2781_i2c]
 component_unbind+0x2e/0x50
 component_unbind_all+0x92/0xa0
 component_del+0xa8/0x140
 tas2781_hda_remove.isra.0+0x32/0x60 [snd_hda_scodec_tas2781_i2c]
 i2c_device_remove+0x26/0xb0

Fixes: 5be27f1e3ec9 ("ALSA: hda/tas2781: Add tas2781 HDA driver")
CC: stable@vger.kernel.org
Signed-off-by: Gergo Koteles <soyer@irl.hu>
Link: https://lore.kernel.org/r/1a0885c424bb21172702d254655882b59ef6477a.1702510018.git.soyer@irl.hu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/tas2781_hda_i2c.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/sound/pci/hda/tas2781_hda_i2c.c b/sound/pci/hda/tas2781_hda_i2c.c
index d3dafc9d150b..c8ee5f809c38 100644
--- a/sound/pci/hda/tas2781_hda_i2c.c
+++ b/sound/pci/hda/tas2781_hda_i2c.c
@@ -550,11 +550,6 @@ static void tasdev_fw_ready(const struct firmware *fmw, void *context)
 	tas2781_save_calibration(tas_priv);
 
 out:
-	if (tas_priv->fw_state == TASDEVICE_DSP_FW_FAIL) {
-		/*If DSP FW fail, kcontrol won't be created */
-		tasdevice_config_info_remove(tas_priv);
-		tasdevice_dsp_remove(tas_priv);
-	}
 	mutex_unlock(&tas_priv->codec_lock);
 	if (fmw)
 		release_firmware(fmw);
-- 
2.43.0



