Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4A0438FEE;
	Tue, 21 Jul 2026 21:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670484; cv=none; b=L9OFxf16q/PHubsjYADjtAvEIw8AsLDGvJa5UZAriRYzyCn6LvJdfs1oWG8oIyQXiuEFK9pt2d5Vv4UNy58rPuh44jJT85WRHJa/A+RCWDBpd0jdDRxoPFFNe16zSo3/V9oYyVfKFKPHp0vuRFHXTb1du01VySlOXfexacN5/p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670484; c=relaxed/simple;
	bh=zJBEmHZ8q1pAcHinRN5ud8o/mkFFSFwiimKfSu4NBCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bqC3ON6K7J0wRnj1OnOoxkjaGInqRNDPNe47JOUabDuyM/vyjVOi2O5uk3GQS2g1mZF0wNHHU1mj8+sufQnlsTe+1ZXdsWfUbKh6IEkp/A5KOl3Y88byYFltqScYofg45Z6amIVpDJYyNfV5O7uuRelve4jU5DsoK6BkuQydgsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XbKSyiBo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XbKSyiBo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6024E1F000E9;
	Tue, 21 Jul 2026 21:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670481;
	bh=EukTSDZRopFDn1ZmpJo+cVrz8eJYd7LuJelMPiVLuVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XbKSyiBo16GtrA+DImh5te6IDMBhDVvQ0YPIYoL6dEnd8qLT5+CG9OeJi5jx9W0QH
	 6MDuefQ5FDMCQH8LB+OV0tfgVFfItsTBea0ihgpCP+XXxo6eTnn8H/q0yBJWokrf7o
	 RIr+XUljBqzjjeEAIBLBRtAqFGXpjbyvXTVuuOUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0950/1067] ALSA: aoa: check snd_ctl_new1() return value
Date: Tue, 21 Jul 2026 17:25:51 +0200
Message-ID: <20260721152445.791212331@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Zhao Dongdong <zhaodongdong@kylinos.cn>

[ Upstream commit 8df560fefe6fed6a20b7e06720eeaeccec349ac0 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/aoa/fabrics/layout.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/aoa/fabrics/layout.c
+++ b/sound/aoa/fabrics/layout.c
@@ -947,6 +947,8 @@ static void layout_attached_codec(struct
 			if (lineout == 1)
 				ldev->gpio.methods->set_lineout(codec->gpio, 1);
 			ctl = snd_ctl_new1(&lineout_ctl, codec->gpio);
+			if (!ctl)
+				return;
 			if (cc->connected & CC_LINEOUT_LABELLED_HEADPHONE)
 				strscpy(ctl->id.name,
 					"Headphone Switch", sizeof(ctl->id.name));
@@ -961,6 +963,8 @@ static void layout_attached_codec(struct
 			if (ldev->have_lineout_detect) {
 				ctl = snd_ctl_new1(&lineout_detect_choice,
 						   ldev);
+				if (!ctl)
+					return;
 				if (cc->connected & CC_LINEOUT_LABELLED_HEADPHONE)
 					strscpy(ctl->id.name,
 						"Headphone Detect Autoswitch",
@@ -968,6 +972,8 @@ static void layout_attached_codec(struct
 				aoa_snd_ctl_add(ctl);
 				ctl = snd_ctl_new1(&lineout_detected,
 						   ldev);
+				if (!ctl)
+					return;
 				if (cc->connected & CC_LINEOUT_LABELLED_HEADPHONE)
 					strscpy(ctl->id.name,
 						"Headphone Detected",


