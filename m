Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1D6334695;
	Sat, 30 May 2026 17:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161943; cv=none; b=S4pnM6yKvzr2Pk0eoXCN7VTyL19IkWY9xrKLWz+FKOdEbDmUJeJZqq/OhqKc9xWdgRUHPWj4UiiuNHN0wXsYXfdl4tdJTxLvwLFu41HmPy2nCCOHpm/VvcgRVormF30dCDCqYBtJS6/zaDPhM6ehWK2AjehSnsele2gPJQDwp/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161943; c=relaxed/simple;
	bh=NdIxStAn4ioEe9YwG25o8Z9CK/AcltMXKO9F8gqISKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZgnWrXmzlx4UdZpXRClUF45+Pf6PNb8/G3LQUF0YAOCZCkt4H7opPMduJvJzP8sQHUkvf58CNz01WYSVXrcdYIhkq1vulS3Ayd910VhehFwoxgIp70fLc3DGH/MALGU8NU/SPaUBC+hI2F13X7FdQcFEclW7uylFNM3pfMMmst4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cbiUQPtD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cbiUQPtD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 819761F00898;
	Sat, 30 May 2026 17:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161942;
	bh=B+H3DzcoPFvodWmFobDWnueXUwHFEUAOsxqG2l3ffl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cbiUQPtDxnrCyYlkNVcwaBXoGIO4A/A5Pp4cRZFlFpWEQdPp8dfJsOf4Yj9SzBWHx
	 7Py7zZ2hDaknXgxtlAWF9V1mKfZt2ELp0qzvqw2C9SVgt+VwUJsJbt1IjvZBnGHbjV
	 64ZwN2JbPRT10xUF/1GejNPObdLSmfME2WXsn1TI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangdicheng <wangdicheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 774/969] ALSA: hda/conexant: Fix missing error check for jack detection
Date: Sat, 30 May 2026 18:04:58 +0200
Message-ID: <20260530160321.956661481@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: wangdicheng <wangdicheng@kylinos.cn>

[ Upstream commit b0e2333a231107adedd38c6fcfe1adc6162716fc ]

In cx_probe(), the return value of snd_hda_jack_detect_enable_callback()
is ignored. This function returns a pointer, and if it fails (e.g., due
to memory allocation failure), it returns an error pointer which must
be checked using IS_ERR().

If the registration fails, the driver continues to probe, but the jack
detection callback will not be registered. This can lead to a kernel
crash later when the driver attempts to handle jack events or accesses
the uninitialized structure.

Check the return value using IS_ERR() and propagate the error via
PTR_ERR() to the probe caller.

Fixes: 7aeb25908648 ("ALSA: hda/conexant: Fix headset auto detect fail in cx8070 and SN6140")
Signed-off-by: wangdicheng <wangdicheng@kylinos.cn>
Link: https://patch.msgid.link/20260428080450.108801-1-wangdich9700@163.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_conexant.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 7aeaccc9189c8..82186c4364c9b 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -1199,6 +1199,7 @@ static void add_cx5051_fake_mutes(struct hda_codec *codec)
 static int patch_conexant_auto(struct hda_codec *codec)
 {
 	struct conexant_spec *spec;
+	struct hda_jack_callback *callback;
 	int err;
 
 	codec_info(codec, "%s: BIOS auto-probing.\n", codec->core.chip_name);
@@ -1215,7 +1216,12 @@ static int patch_conexant_auto(struct hda_codec *codec)
 	case 0x14f11f86:
 	case 0x14f11f87:
 		spec->is_cx11880_sn6140 = true;
-		snd_hda_jack_detect_enable_callback(codec, 0x19, cx_update_headset_mic_vref);
+		callback = snd_hda_jack_detect_enable_callback(codec, 0x19,
+				cx_update_headset_mic_vref);
+		if (IS_ERR(callback)) {
+			err = PTR_ERR(callback);
+			goto error;
+		}
 		break;
 	}
 
-- 
2.53.0



