Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B6644AB72;
	Tue, 21 Jul 2026 21:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668175; cv=none; b=brc9aertp6KaNDd/MeJmCQTJdEf/Qco+tqH1dj8CseDSFNwi02lJa3RCBUBmyglCDM1yTwuxIy4KfdZbCb4W2wiWj/6JdswquQIXhPn1+706VQxL7UvE0DRvqOuUonxW/rzqesKWOzghtn1Oy72mIdFjbutsdEeyGuzd+WyT64I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668175; c=relaxed/simple;
	bh=aBv0h48SHqg6lVMINhji4nKJfsW9lOrKDJ2K1we4+iE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DNUFUV/ZPCrlZABK/94dRRFnJO324iklsYQgWg1bdtv8vLF1Ppj40LBZIvpjm59rpBFJqPLq7CvGFypvHZKa3YoSNZ8gqW1EQv/PLsgFvLJjZpUquckrIDO0/VkGMxpyr4g5T6BWKqRmFH5NyBBvf48oUT7yI/ZUkMLg8bNzAoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pek+aEz6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pek+aEz6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F231F000E9;
	Tue, 21 Jul 2026 21:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668174;
	bh=wERerfjICdad7S7ovRXgSnBqKh3VtuE8id5AksrNLIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pek+aEz6k5dU2+VB4VHRYUus1O77t9Jzqke9fwHxJ3q+pOOBEJL32GhMYLcHOlUnJ
	 bhJfLWGWx4hEb30CupCT04NnHkPU36VtNFtP71kH/ho2mMJTXRgJNxUlQ5IJF32mj9
	 7rBG25NXDJRFFh0qKm3+FNaDsW7Ms82gPXTZYe4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 0076/1067] ALSA: es1938: check snd_ctl_new1() return value
Date: Tue, 21 Jul 2026 17:11:17 +0200
Message-ID: <20260721152426.271094662@linuxfoundation.org>
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

commit 1edd1f02dddd20aeb6066ded41017615766ea42f upstream.

snd_ctl_new1() can return NULL when memory allocation fails.
snd_es1938_mixer() does not check the return value before dereferencing
the pointer, which can lead to a NULL pointer dereference.

Add a NULL check after snd_ctl_new1() and return -ENOMEM if it fails.

Assisted-by: Opencode:DeepSeek-V4-Flash
Cc: stable@vger.kernel.org
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Zhao Dongdong <zhaodongdong@kylinos.cn>
Link: https://patch.msgid.link/tencent_E0DC65165FDF2C8982BAFB6794B854B53B0A@qq.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/es1938.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/es1938.c
+++ b/sound/pci/es1938.c
@@ -1690,6 +1690,8 @@ static int snd_es1938_mixer(struct es193
 	for (idx = 0; idx < ARRAY_SIZE(snd_es1938_controls); idx++) {
 		struct snd_kcontrol *kctl;
 		kctl = snd_ctl_new1(&snd_es1938_controls[idx], chip);
+		if (!kctl)
+			return -ENOMEM;
 		switch (idx) {
 			case 0:
 				chip->master_volume = kctl;


