Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B641472F62;
	Tue, 21 Jul 2026 20:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664911; cv=none; b=JjV25+Oe9gok4a39fKnFM1KR8xzs3msghkn7N3GjS57kg0Ed2j3KT4T/kqX3sNG6Wh8vWtiAVe5tblo0sxcMiyXrWvinvNz6g5j4t7ShRdsmpZzhBY92dCnee//vrMr3eZ/mKT1V00rbdEGEoakfRN/wEYj+75b3yzwwO5bmiiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664911; c=relaxed/simple;
	bh=VxALhKaETNgVCjHaNskG6f3LcldxrdXAgwQ2mZoKITc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9bTDPt9YPANJe/ioExgWbJBBPyzPxskUa+DS0Oo7ZepHDzVL7CftXOiKSTIBhqVEDNtIVuPK2UEZVQbSdTnJfuyQoh/wbmkYsx9p6M6MOzm3Aw+7ObSuDKPfQ6FAlD/zdH/y1XEZg2nnRsJ+oQKltg1hSy3/ZW6GZiWTrcdgsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FXhfLRiD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FXhfLRiD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 813301F000E9;
	Tue, 21 Jul 2026 20:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664910;
	bh=XTI4BTKRJKFI/qsBw9LFPJQLzOImVZuJWh5OgTnSd4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FXhfLRiDlb9OZTFaxsOz9sV3k2xw25HpobPzT7VkRpi3E+DXUQbSDUqmD4gp7zswC
	 AD2hZ1yHKn5bM2sHT0KsXLM3/MNJ7bDCfIOUoCrOpk4kDuTleA3fXoFBD1XsHZWzwb
	 ABNv8a3eGJviJN0DnGbl2sXcT/mrJSBbiNgSdIbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 0106/1266] ALSA: es1938: check snd_ctl_new1() return value
Date: Tue, 21 Jul 2026 17:09:03 +0200
Message-ID: <20260721152444.172588877@linuxfoundation.org>
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
@@ -1670,6 +1670,8 @@ static int snd_es1938_mixer(struct es193
 	for (idx = 0; idx < ARRAY_SIZE(snd_es1938_controls); idx++) {
 		struct snd_kcontrol *kctl;
 		kctl = snd_ctl_new1(&snd_es1938_controls[idx], chip);
+		if (!kctl)
+			return -ENOMEM;
 		switch (idx) {
 			case 0:
 				chip->master_volume = kctl;


