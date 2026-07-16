Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7D4423785;
	Thu, 16 Jul 2026 13:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209172; cv=none; b=YOtxcIinVG9MfHNX2ymcGKpdw9B1YPmVycLGN26LVR8ThD77X0yUboGZBfH1NmiJFvAQlFlE3aJYSgYWCDs7tZKGnrQ9GOXt/lHdLlrBqZkCBr2EbcHj4iQA2YLb+ZS3ui+G1xbx+wUXYFnbrhbcGdSVTz44rHiBt+wrtDjc0hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209172; c=relaxed/simple;
	bh=RTCHA/lQ+uPt4oWelF0L8WENRja3LykpPVKR8BMiSNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aDiHFDZIoKOh4PtjV2VxS1H09OCustcszaw+mKXaBOwwAQtVpjo2AuHifyIvlOpWQjTlp2rjAC5x6PevwUxDr2kBmgtnvq9qBto61EJEWjU//vn3x7AJm++XqcUyYj4dj87HKO+J2o9asrBxFWgPDunjupuOQc9J+fOPpXWTcqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NiuPZ1V/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NiuPZ1V/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D07011F000E9;
	Thu, 16 Jul 2026 13:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209171;
	bh=zwoBlfSF1SrJa4E+5G5q2SbpZ1JfPte3bzdbuE1PLXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NiuPZ1V/NpIKqE81uKJveSgIftlomU/zc9Wjxs1chiQ1CWRIRMt0txEZuIot4q9Ta
	 xxQxp7FkDmG64J9XjnFjrjBE+kvZKlvaSm2TG4tpxRK0KglsBZiEQiy5HJXVlfa9nW
	 srPfM7GSSBdP4tdMpVhBFmoShhKvqayPT6zu2crY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.1 085/518] ALSA: cmipci: check snd_ctl_new1() return value
Date: Thu, 16 Jul 2026 15:25:53 +0200
Message-ID: <20260716133049.723806628@linuxfoundation.org>
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
@@ -2637,16 +2637,22 @@ static int snd_cmipci_mixer_new(struct c
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


