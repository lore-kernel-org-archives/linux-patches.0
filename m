Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D94F5443A91;
	Tue, 21 Jul 2026 22:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672755; cv=none; b=EEtCvCqog1oDharwEKVMmVeijNUaFpOypSyO1MiG9dU8+1XvLNGBsU5i3efv3gh8VvJA0zljZNF9iB6eqA8MV6h1di7dM55LhOrVwwOhLcZDgbZ3NzjBuNcFLavgvec7cXL5RDjS5bV+Oo/ZNWEBmsjRH1M1ont18mvOcPBIBvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672755; c=relaxed/simple;
	bh=hnQSS2oQj1pFF6cM5dS3v4WnRhav61M3WEToiRZi+CY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kkkbsJQe7UXXecp3zyz1iRK9V4MwegM7iGAnhLNoANSKlgsP9ENCIHzWQQQjQL2THZpXLAttm8MxqqxPLwPIOsg1LBXs8QtxZF52U4lEMtTetMbWNNqwVJo8NhTys8SGNoTZ3on/YU8HdcLS5lVMx2zZaX8cweOEXkLIEzThMnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0BEYSxfh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0BEYSxfh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A231F000E9;
	Tue, 21 Jul 2026 22:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672753;
	bh=DcIkp867C9kC94tplRAaxIzAw3G3keLNJ1BGRxR8myI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0BEYSxfhfIEflb1bFYqXT4cDkyTjY4KrJGhjLTfgPnOlIyut5bXkmlGBCQIZY2mOl
	 qWJFcq0xH/zuHeyB1OJt5uDcF+FaljYOzZfL9MPeNTSQeff4iRaZ7gHpJBMi1derbN
	 PpqxIaC3j98UKo+6h38n45vepmhelQt45FBe2PrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 744/843] ALSA: aoa: check snd_ctl_new1() return value
Date: Tue, 21 Jul 2026 17:26:19 +0200
Message-ID: <20260721152422.785674130@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


