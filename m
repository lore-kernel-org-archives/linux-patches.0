Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC0C1B395F;
	Mon, 10 Mar 2025 18:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630956; cv=none; b=ryL8efIcyZKGF8DYtkWvIkqxUVVNcYgjJFa2GI7U92XNoKuac9V3xD/kySx9uesQZtMl322DjgaBAf8s1uo4YwY1aaxMIbGxrpCRqEPMt2MRWuGVGbUD9CuOXROP6PhU7L+5u2QNgDicFLiPBuU7ScoRnyGDexaKYtVlFWMmS5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630956; c=relaxed/simple;
	bh=F8Kzt+K3lFXl8PiXaCzy2cnIS/hK+T2dp9Mqk52nG94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GMO68BMQ53OJ2Q8Zw+O3zkbq/zK0Bx9mJ3V2YhxqQAtNOFrcEURfOltPtmyIq3V3tUhQaJ3ZLx0eUbHY/3XLP0H5nDcUtkHy4kvW+GBKv/N9vanKR+1QhdGzqrNBIc0qei3uRVz6iDZG7cLiSLyCn0wnYtFPYW8tkHcISYCaLNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PH/dWnwE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PH/dWnwE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A65A4C4CEE5;
	Mon, 10 Mar 2025 18:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630956;
	bh=F8Kzt+K3lFXl8PiXaCzy2cnIS/hK+T2dp9Mqk52nG94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PH/dWnwEhIwD31D0RbwM7XP7CyvhHwfr4BZzdj9X2T4bDG8C7g6jNUe/n9rbwnrTQ
	 ZqExwY3df/lgpeoepSbB3T8gfavjZQxhuJhCgSMENMjBzatHIxTeibJr2suUiCJMLJ
	 AseWgGrh7DEOsO6t7Q1tssgTIY32gsdNs+XUCp5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 561/620] ALSA: usx2y: validate nrpacks module parameter on probe
Date: Mon, 10 Mar 2025 18:06:47 +0100
Message-ID: <20250310170607.685597693@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Murad Masimov <m.masimov@mt-integration.ru>

[ Upstream commit 172a0f509723fe4741d4b8e9190cf434b18320d8 ]

The module parameter defines number of iso packets per one URB. User is
allowed to set any value to the parameter of type int, which can lead to
various kinds of weird and incorrect behavior like integer overflows,
truncations, etc. Number of packets should be a small non-negative number.

Since this parameter is read-only, its value can be validated on driver
probe.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Murad Masimov <m.masimov@mt-integration.ru>
Link: https://patch.msgid.link/20250303100413.835-1-m.masimov@mt-integration.ru
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/usx2y/usbusx2y.c      | 11 +++++++++++
 sound/usb/usx2y/usbusx2y.h      | 26 ++++++++++++++++++++++++++
 sound/usb/usx2y/usbusx2yaudio.c | 27 ---------------------------
 3 files changed, 37 insertions(+), 27 deletions(-)

diff --git a/sound/usb/usx2y/usbusx2y.c b/sound/usb/usx2y/usbusx2y.c
index c3292afa883ee..b8f0c0298f14a 100644
--- a/sound/usb/usx2y/usbusx2y.c
+++ b/sound/usb/usx2y/usbusx2y.c
@@ -151,6 +151,12 @@ static int snd_usx2y_card_used[SNDRV_CARDS];
 static void snd_usx2y_card_private_free(struct snd_card *card);
 static void usx2y_unlinkseq(struct snd_usx2y_async_seq *s);
 
+#ifdef USX2Y_NRPACKS_VARIABLE
+int nrpacks = USX2Y_NRPACKS; /* number of packets per urb */
+module_param(nrpacks, int, 0444);
+MODULE_PARM_DESC(nrpacks, "Number of packets per URB.");
+#endif
+
 /*
  * pipe 4 is used for switching the lamps, setting samplerate, volumes ....
  */
@@ -433,6 +439,11 @@ static int snd_usx2y_probe(struct usb_interface *intf,
 	struct snd_card *card;
 	int err;
 
+#ifdef USX2Y_NRPACKS_VARIABLE
+	if (nrpacks < 0 || nrpacks > USX2Y_NRPACKS_MAX)
+		return -EINVAL;
+#endif
+
 	if (le16_to_cpu(device->descriptor.idVendor) != 0x1604 ||
 	    (le16_to_cpu(device->descriptor.idProduct) != USB_ID_US122 &&
 	     le16_to_cpu(device->descriptor.idProduct) != USB_ID_US224 &&
diff --git a/sound/usb/usx2y/usbusx2y.h b/sound/usb/usx2y/usbusx2y.h
index 8d82f5cc2fe1c..0538c457921e6 100644
--- a/sound/usb/usx2y/usbusx2y.h
+++ b/sound/usb/usx2y/usbusx2y.h
@@ -7,6 +7,32 @@
 
 #define NRURBS	        2
 
+/* Default value used for nr of packs per urb.
+ * 1 to 4 have been tested ok on uhci.
+ * To use 3 on ohci, you'd need a patch:
+ * look for "0000425-linux-2.6.9-rc4-mm1_ohci-hcd.patch.gz" on
+ * "https://bugtrack.alsa-project.org/alsa-bug/bug_view_page.php?bug_id=0000425"
+ *
+ * 1, 2 and 4 work out of the box on ohci, if I recall correctly.
+ * Bigger is safer operation, smaller gives lower latencies.
+ */
+#define USX2Y_NRPACKS 4
+
+#define USX2Y_NRPACKS_MAX 1024
+
+/* If your system works ok with this module's parameter
+ * nrpacks set to 1, you might as well comment
+ * this define out, and thereby produce smaller, faster code.
+ * You'd also set USX2Y_NRPACKS to 1 then.
+ */
+#define USX2Y_NRPACKS_VARIABLE 1
+
+#ifdef USX2Y_NRPACKS_VARIABLE
+extern int nrpacks;
+#define nr_of_packs() nrpacks
+#else
+#define nr_of_packs() USX2Y_NRPACKS
+#endif
 
 #define URBS_ASYNC_SEQ 10
 #define URB_DATA_LEN_ASYNC_SEQ 32
diff --git a/sound/usb/usx2y/usbusx2yaudio.c b/sound/usb/usx2y/usbusx2yaudio.c
index c39cc6851e2d7..a6ed4f0230b7f 100644
--- a/sound/usb/usx2y/usbusx2yaudio.c
+++ b/sound/usb/usx2y/usbusx2yaudio.c
@@ -28,33 +28,6 @@
 #include "usx2y.h"
 #include "usbusx2y.h"
 
-/* Default value used for nr of packs per urb.
- * 1 to 4 have been tested ok on uhci.
- * To use 3 on ohci, you'd need a patch:
- * look for "0000425-linux-2.6.9-rc4-mm1_ohci-hcd.patch.gz" on
- * "https://bugtrack.alsa-project.org/alsa-bug/bug_view_page.php?bug_id=0000425"
- *
- * 1, 2 and 4 work out of the box on ohci, if I recall correctly.
- * Bigger is safer operation, smaller gives lower latencies.
- */
-#define USX2Y_NRPACKS 4
-
-/* If your system works ok with this module's parameter
- * nrpacks set to 1, you might as well comment
- * this define out, and thereby produce smaller, faster code.
- * You'd also set USX2Y_NRPACKS to 1 then.
- */
-#define USX2Y_NRPACKS_VARIABLE 1
-
-#ifdef USX2Y_NRPACKS_VARIABLE
-static int nrpacks = USX2Y_NRPACKS; /* number of packets per urb */
-#define  nr_of_packs() nrpacks
-module_param(nrpacks, int, 0444);
-MODULE_PARM_DESC(nrpacks, "Number of packets per URB.");
-#else
-#define nr_of_packs() USX2Y_NRPACKS
-#endif
-
 static int usx2y_urb_capt_retire(struct snd_usx2y_substream *subs)
 {
 	struct urb	*urb = subs->completed_urb;
-- 
2.39.5



