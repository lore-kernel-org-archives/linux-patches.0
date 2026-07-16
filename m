Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371813D8127;
	Thu, 16 Jul 2026 14:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210588; cv=none; b=dFW+xRJIHAsMUYGjN9y8OpPc4G8vtG+8hFzAKZYuBzuhJpZrNd/jVcs1rh6mBwwa9WZAxPpjJ5xKAeNmKdpJN0UQa7AHKRODrQa1r6YE3c2bk4JdHb+54gpihjUKqpOUT2DnzNzaJRK9pEuaja3tpI+bGvjYgPSQyvuOy2Zd6Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210588; c=relaxed/simple;
	bh=0atuF00puT7sT95bX8OWDq9VQklhNjgrvFBR1C3/2CM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TSv2rQ9EUVhbuwacWIlvvTkIDJyIenCbQguPpf0t4oz9XqtrLmDk7ZLkYkoIZZJ8mBy6QfiYgu9Vn/MvCQ94z5Ut3AZKnaJzO7RcRq1bgVQbIiwGJYsVVPwDgx9igpiCWmjomP6iLfUksnVip/lNyTl3toG1X1d3EQg7KN0ifeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v3VYn1bX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v3VYn1bX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C8B81F000E9;
	Thu, 16 Jul 2026 14:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210587;
	bh=t7mCLWRTjhiQ1QsdRPpM8v8pX0nosSBmFldQr9bNv9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v3VYn1bXa18zoFb9LKMClff/9cDFT7L9Vv6lI1n3YrMAKZEX2CQ7wjBqSyZCJNpQf
	 09Tlbm6m3UPCRD7oXu7f0AKCjTQfojx5lxKAYAeHY36E9eaD/HX+IgMFdbangYIOd5
	 WMivKFDh+OOhugSvR3ctudmh4NBt7bQaWOydZRoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baoqi Zhang <zhangbaoqi@loongson.cn>,
	Haowei Zheng <zhenghaowei@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 105/480] ALSA: hda/hdmi: Use AC_PINSENSE_ELDV to detect pinsense for Loongson
Date: Thu, 16 Jul 2026 15:27:32 +0200
Message-ID: <20260716133046.984008691@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


