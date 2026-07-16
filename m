Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D932DF137;
	Thu, 16 Jul 2026 13:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209167; cv=none; b=lnpTmLStBAlz9GqcSe1ffZD0VA6GBkZGmJIXYc70Mw0ksziNQATLpZ34SFXiaga4ojuYpg8zFDnYY9aLLPwOSZXEX3IXoCcR+lr4G4mzAXwfEW0OWuDC3p1ovMTqJMnsONjwMQBACxkhmuJ4HEByY80d5PMWW+WHrZyiYbAsqOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209167; c=relaxed/simple;
	bh=U2Qlfh/D5wP+SO0a4rpXiT/5H1u5iyZwOxuOqmGzLm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eCsk0E2y9Lrjz20YZ00nJwE9Vpo9AIXjQgheD289hvyfOsl3Bt4djanVz43fw3HiLSTCX3I65l/HR4lnSTarGL09EA05+0eY9UlI1Tsx2bHwz6UtkaHi4vN3MhVIb3NTsyurTpbDZn3ztxvZ7VVJ9SLW0SW1CQrxkR3nGhtAK2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YEcIkSft; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YEcIkSft"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AB6D1F000E9;
	Thu, 16 Jul 2026 13:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209166;
	bh=tVAzGJ4EseYij5Zbi+9sIHZroTkwfxY7piKHqZnFMvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YEcIkSft+UZyWSIq1YCNrCSzQ6Cx1+DuRp131HhZ/cL21P/YIqenLnY0ogY2Ms2DM
	 +YtRYG+66YWjo6lzOasVyvHFeLr8dEsO+du7hh8GTDqfBjxjgJPTDQhNlT24/NxUTp
	 quVbjbfEj26o/KOTeYQbD6mZ9AC3Ms+Gyi6pSoik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.1 083/518] ALSA: aoa: check snd_ctl_new1() return value
Date: Thu, 16 Jul 2026 15:25:51 +0200
Message-ID: <20260716133049.605213871@linuxfoundation.org>
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

From: Zhao Dongdong <zhaodongdong@kylinos.cn>

commit 8df560fefe6fed6a20b7e06720eeaeccec349ac0 upstream.

snd_ctl_new1() can return NULL when memory allocation fails. In
layout.c, the function does not check the return value before
dereferencing ctl->id.name or passing to aoa_snd_ctl_add(), which can
lead to a NULL pointer dereference.

Add NULL checks after snd_ctl_new1() calls and return early if any
fails.

Assisted-by: Opencode:DeepSeek-V4-Flash
Cc: stable@vger.kernel.org
Fixes: f3d9478b2ce4 ("[ALSA] snd-aoa: add snd-aoa")
Signed-off-by: Zhao Dongdong <zhaodongdong@kylinos.cn>
Link: https://patch.msgid.link/tencent_35F3A25FEEBF190A2E15ED787754C57E3708@qq.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/aoa/fabrics/layout.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/aoa/fabrics/layout.c
+++ b/sound/aoa/fabrics/layout.c
@@ -948,6 +948,8 @@ static void layout_attached_codec(struct
 			if (lineout == 1)
 				ldev->gpio.methods->set_lineout(codec->gpio, 1);
 			ctl = snd_ctl_new1(&lineout_ctl, codec->gpio);
+			if (!ctl)
+				return;
 			if (cc->connected & CC_LINEOUT_LABELLED_HEADPHONE)
 				strscpy(ctl->id.name, "Headphone Switch");
 			ldev->lineout_ctrl = ctl;
@@ -961,12 +963,16 @@ static void layout_attached_codec(struct
 			if (ldev->have_lineout_detect) {
 				ctl = snd_ctl_new1(&lineout_detect_choice,
 						   ldev);
+				if (!ctl)
+					return;
 				if (cc->connected & CC_LINEOUT_LABELLED_HEADPHONE)
 					strscpy(ctl->id.name,
 						"Headphone Detect Autoswitch");
 				aoa_snd_ctl_add(ctl);
 				ctl = snd_ctl_new1(&lineout_detected,
 						   ldev);
+				if (!ctl)
+					return;
 				if (cc->connected & CC_LINEOUT_LABELLED_HEADPHONE)
 					strscpy(ctl->id.name,
 						"Headphone Detected");


