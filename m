Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F72F46D577;
	Wed, 30 Sep 2026 16:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785285; cv=none; b=H9kjX10yL7Xkk1Dlpu2qwwuRL3QtmtOk0KxrSm9HBB4ve+Qw95MYQtlkuN3L+yQyyJz+R5/qFc+u1/g2G9YDb2iNKk+Ix7SmEDIBQTUxNkdKMfhjuc6PJfkkcwKqzUmFhnNX+arpKufsijmxLeqwS9WfzTkPgeW21nMI4NjHh50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785285; c=relaxed/simple;
	bh=WtaNRjd0G71z6UxBMFCv0UEiRA+bdloq/19Zla2j2/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dXRnbZUxaR9BKwEZF/Uh3li8RH5IjiMOMH0IHIPfJjcHb2C6NW9ihfmUwDkdbOPXiJovVY8Er/VpWrdY0BB9bcUGHUcsUo47cV2lLSmtvoEd50yl9biK7OzlcFDKzrSGBT4Rx3JToDIhQnWs27cXc7jLQDwuu9doKRFyXcpIFxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uLUXlttL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uLUXlttL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 138BB1F000FF;
	Wed, 30 Sep 2026 16:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785279;
	bh=Oiijjesyv8+cN/un5sy3XCtNCIiQEA2iJ4l51QWmY7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uLUXlttLUkxNz5IKvFRSgVJDeYVI1Ob4fAIDRnFJ79N9M8BgIGb4yjL9Pi9no3kaQ
	 vHSRo0ydBa/Aeendr7zwE9s35/9mwsy6pW+aHiHBnXNNoU5c+tG1Mm2gRG3NhC3UZl
	 K+UWusab2lL4evWkrrZdwQoVpF6xt4poSG+G6PMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 454/982] ALSA: hda: Introduce auto cleanup macros for PM
Date: Wed, 30 Sep 2026 17:19:50 +0200
Message-ID: <20260930152426.542470580@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 5d8c9c987fbdd65677315198c2b1f35a440d7cdf ]

The temporary power up/down of the codec via snd_hda_power_up() and
_down() (or snd_hda_power_up_pm() and _down_pm()) is seen in various
places.  This patch introduces simple auto-cleanup macros for those
call patterns, so that the drivers don't have to call the
corresponding power-down calls explicitly.

Namely,
	err = snd_hda_power_up(codec);
	if (err < 0)
		return err;
	....
	snd_power_down(codec);

can drop the *_down() call by replacing with
	CLASS(snd_hda_power, pm)(codec);
	if (pm.err < 0)
		return pm.err;

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250827072916.31933-2-tiwai@suse.de
Stable-dep-of: 728478874312 ("ALSA: hda: Report a change when only the channel status bytes move")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/hda_codec.h | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/include/sound/hda_codec.h b/include/sound/hda_codec.h
index 4ca45d5895dfd..5788cec54a378 100644
--- a/include/sound/hda_codec.h
+++ b/include/sound/hda_codec.h
@@ -512,6 +512,36 @@ static inline bool hda_codec_need_resume(struct hda_codec *codec)
 	return !codec->relaxed_resume && codec->jacktbl.used;
 }
 
+/*
+ * PM with auto-cleanup: call like CLASS(snd_hda_power, pm)(codec)
+ * If the error handling is needed, refer pm.err.
+ */
+struct __hda_power_obj {
+	struct hda_codec *codec;
+	int err;
+};
+
+static inline struct __hda_power_obj __snd_hda_power_up(struct hda_codec *codec)
+{
+	struct __hda_power_obj T = { .codec = codec };
+	T.err = snd_hda_power_up(codec);
+	return T;
+}
+
+static inline struct __hda_power_obj __snd_hda_power_up_pm(struct hda_codec *codec)
+{
+	struct __hda_power_obj T = { .codec = codec };
+	T.err = snd_hda_power_up_pm(codec);
+	return T;
+}
+
+DEFINE_CLASS(snd_hda_power, struct __hda_power_obj,
+	     snd_hda_power_down((_T).codec), __snd_hda_power_up(codec),
+	     struct hda_codec *codec)
+DEFINE_CLASS(snd_hda_power_pm, struct __hda_power_obj,
+	     snd_hda_power_down_pm((_T).codec), __snd_hda_power_up_pm(codec),
+	     struct hda_codec *codec)
+
 #ifdef CONFIG_SND_HDA_PATCH_LOADER
 /*
  * patch firmware
-- 
2.53.0



