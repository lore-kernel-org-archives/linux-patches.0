Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763F7472F6D;
	Tue, 21 Jul 2026 20:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664908; cv=none; b=A5D6TTJKrXpifzXjz1rlItIPzj7e1xRMSXcklDHM39fqMq4Bu9g/GcQWq0OMbBTxVHIrp6TPzTzYKk2TFz7ZcaedIZ2mNq823dTwbIt1UbVqVIayWrhERowiSzwb9jtc66jDTTf6lsNtBVy/yih1CdhTXg1RWj1mR47OpUbzBf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664908; c=relaxed/simple;
	bh=Egl9dmvDRTUvSK3yi+ctLesd9y/UyvemKz5QRB6qMrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lneuaR5U4HCCo/j+lrvd+NiZ5tsPR2AydINLn6ou7XWkhNRSr6cfWKPsaArD9WupZweOmcZGO4iuCq8UWl8Iz/vN94TR6z5QNVhP3dQaKjr+/5nNBwZXyz3OJ7n7NAbn+Yc1sCxI1t/+k/XemI2CD/xwxlcnW0t7+QjZuo8jfoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tdc1Rf5R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tdc1Rf5R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB57B1F000E9;
	Tue, 21 Jul 2026 20:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664907;
	bh=ESHkr6whmPZW4qGXERRyEvHMgJo1NVYb9aWVsjWEoDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tdc1Rf5RDgOFcPpJjjltXr6cnqPeWL2rcQJxnBXsZmOx0249pzSTcynG6AlLyKITd
	 NCR0Lh70UyqBqwFO1mVVRe1f6kAqIM5ZVOf4wrJLjYwePvqVVBWgx2vu/qMN1aQUIx
	 XWLUx/jmLymqOKH8bQpXyUiw31i0NQAAFlVjhap0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 0105/1266] ALSA: cmipci: check snd_ctl_new1() return value
Date: Tue, 21 Jul 2026 17:09:02 +0200
Message-ID: <20260721152444.150821767@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Dongdong <zhaodongdong@kylinos.cn>

commit c205bd1b28fb7e5f1061a4e78813fad7d315cb3e upstream.

snd_ctl_new1() can return NULL when memory allocation fails.
snd_cmipci_spdif_controls() does not check the return value before
dereferencing kctl->id.device, which can lead to a NULL pointer
dereference.

Add NULL checks after snd_ctl_new1() calls and return -ENOMEM if any
fails.

Assisted-by: Opencode:DeepSeek-V4-Flash
Cc: stable@vger.kernel.org
Fixes: f2f312ad88c6 ("ALSA: cmipci: Fix kctl->id initialization")
Signed-off-by: Zhao Dongdong <zhaodongdong@kylinos.cn>
Link: https://patch.msgid.link/tencent_964433DCD132125D5EDA79EE068A2D6EFA09@qq.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/cmipci.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/pci/cmipci.c
+++ b/sound/pci/cmipci.c
@@ -2688,16 +2688,22 @@ static int snd_cmipci_mixer_new(struct c
 		}
 		if (cm->can_ac3_hw) {
 			kctl = snd_ctl_new1(&snd_cmipci_spdif_default, cm);
+			if (!kctl)
+				return -ENOMEM;
 			kctl->id.device = pcm_spdif_device;
 			err = snd_ctl_add(card, kctl);
 			if (err < 0)
 				return err;
 			kctl = snd_ctl_new1(&snd_cmipci_spdif_mask, cm);
+			if (!kctl)
+				return -ENOMEM;
 			kctl->id.device = pcm_spdif_device;
 			err = snd_ctl_add(card, kctl);
 			if (err < 0)
 				return err;
 			kctl = snd_ctl_new1(&snd_cmipci_spdif_stream, cm);
+			if (!kctl)
+				return -ENOMEM;
 			kctl->id.device = pcm_spdif_device;
 			err = snd_ctl_add(card, kctl);
 			if (err < 0)


