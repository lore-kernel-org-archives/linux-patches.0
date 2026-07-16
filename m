Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E642475F7;
	Thu, 16 Jul 2026 13:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209197; cv=none; b=at+XMsej3EbQEJiTYn5mIKR4Gicta9ThVClN6MVFY7lALpQK8OqteE2pYKZNLaljL8fH72ffjAc1C2VmnoQaaVAbisukIauIu7lo0YZDIzp9gpHKSBPMqBOAiAjQhcdShwIfMYb53Ihdr02ssDKxYDvAfm9w4f4iNA4QBJRY6ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209197; c=relaxed/simple;
	bh=Hq5w2nB3wRJn+ldyZizDmiSGkL2ylBl3B19ZYkMyUlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XQupragr824Fk6h7h6q9b8ZLUNyYT7TWNos7vul9VwRmcpIQZFh94IGVCYcRm2Ox6nJoIoxuDqwhLAIuPergVUO1fFRqp2hqVJqhgmuDJup2vNPh3YP0vBfX9y3YSz5SG1WQwOMOtpTESG8NvWiq+UZOG+2IloXu8ITfKFhgmtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m0Quphe4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m0Quphe4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC821F000E9;
	Thu, 16 Jul 2026 13:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209195;
	bh=6OgdYhoGcw2ngiCXmbalotlT/GiYxiMKpiFmPMdsMzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m0Quphe4sWHbFiEFRlzV4mZ3fnOYa05tp+q/hVME5/29TX7vhR9vOShODpLmUL76q
	 +Opzb7OVgro6/ScW2Jqur8ALcSgkehFw7s8nv3jdGJjhKaXotwjG9qMDeA65FG7Y3M
	 udZ3i2lt1wysSFbhZgJnRk7nF91Ax0mOm2YjAZBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baoqi Zhang <zhangbaoqi@loongson.cn>,
	Haowei Zheng <zhenghaowei@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.1 093/518] ALSA: hda/hdmi: Use AC_PINSENSE_ELDV to detect pinsense for Loongson
Date: Thu, 16 Jul 2026 15:26:01 +0200
Message-ID: <20260716133049.900097830@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit 958e4450e961d75bd9d8f5bfe245fb15bc78e02a upstream.

Due to a hardware defect, for Loongson PCI HDMI devices with a reversion
ID of 2, the pin sense status must be determined via the ELD.

Add a codec flag, eld_jack_detect, to indicate this case, and do special
handlings in read_pin_sense().

Cc: stable@vger.kernel.org
Signed-off-by: Baoqi Zhang <zhangbaoqi@loongson.cn>
Signed-off-by: Haowei Zheng <zhenghaowei@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Link: https://patch.msgid.link/20260527140841.3407183-1-chenhuacai@loongson.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/sound/hda_codec.h    |    1 +
 sound/hda/codecs/hdmi/hdmi.c |    8 +++++++-
 sound/hda/common/jack.c      |    6 ++++++
 3 files changed, 14 insertions(+), 1 deletion(-)

--- a/include/sound/hda_codec.h
+++ b/include/sound/hda_codec.h
@@ -259,6 +259,7 @@ struct hda_codec {
 	unsigned int forced_resume:1; /* forced resume for jack */
 	unsigned int no_stream_clean_at_suspend:1; /* do not clean streams at suspend */
 	unsigned int ctl_dev_id:1; /* old control element id build behaviour */
+	unsigned int eld_jack_detect:1;	/* Machine jack-detection by ELD */
 
 	unsigned long power_on_acct;
 	unsigned long power_off_acct;
--- a/sound/hda/codecs/hdmi/hdmi.c
+++ b/sound/hda/codecs/hdmi/hdmi.c
@@ -2286,6 +2286,7 @@ EXPORT_SYMBOL_NS_GPL(snd_hda_hdmi_acomp_
 enum {
 	MODEL_GENERIC,
 	MODEL_GF,
+	MODEL_LOONGSON,
 };
 
 static int generichdmi_probe(struct hda_codec *codec,
@@ -2303,6 +2304,11 @@ static int generichdmi_probe(struct hda_
 	if (id->driver_data == MODEL_GF)
 		codec->no_sticky_stream = 1;
 
+	if (id->driver_data == MODEL_LOONGSON) {
+		if (codec->bus && codec->bus->pci->revision == 0x2)
+			codec->eld_jack_detect = 1; /* Jack-detection by ELD */
+	}
+
 	return 0;
 }
 
@@ -2320,7 +2326,7 @@ static const struct hda_codec_ops generi
 /*
  */
 static const struct hda_device_id snd_hda_id_generichdmi[] = {
-	HDA_CODEC_ID_MODEL(0x00147a47, "Loongson HDMI",		MODEL_GENERIC),
+	HDA_CODEC_ID_MODEL(0x00147a47, "Loongson HDMI",		MODEL_LOONGSON),
 	HDA_CODEC_ID_MODEL(0x10951390, "SiI1390 HDMI",		MODEL_GENERIC),
 	HDA_CODEC_ID_MODEL(0x10951392, "SiI1392 HDMI",		MODEL_GENERIC),
 	HDA_CODEC_ID_MODEL(0x11069f84, "VX11 HDMI/DP",		MODEL_GENERIC),
--- a/sound/hda/common/jack.c
+++ b/sound/hda/common/jack.c
@@ -58,6 +58,12 @@ static u32 read_pin_sense(struct hda_cod
 				  AC_VERB_GET_PIN_SENSE, dev_id);
 	if (codec->inv_jack_detect)
 		val ^= AC_PINSENSE_PRESENCE;
+	if (codec->eld_jack_detect) {
+		if (val & AC_PINSENSE_ELDV)
+			val |= AC_PINSENSE_PRESENCE;
+		else
+			val &= ~AC_PINSENSE_PRESENCE;
+	}
 	return val;
 }
 


