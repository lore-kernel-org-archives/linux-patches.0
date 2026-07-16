Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27A22475F7;
	Thu, 16 Jul 2026 13:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209177; cv=none; b=LiQ2yl/jZoBRKh3W7Rk7oQe/tPmuyb9qfNO8/7O9Aot7ePV9x1cKFB8d4FhjitNGLbpphchcoKKIbMh7a0ly04rkh0mEKAygQD08FzI8U5RF+Jfu0A5TFe2ZjcV1tR08uUsv/PqY+kkIeT0Vvm+FsisRhaJI1sgi2uwpW4yvjGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209177; c=relaxed/simple;
	bh=PWheMIuM+sPzIFsK+eXuzkuHOP8Jg005nRskxhHKHQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m1IiqbqurTQC0a0ktH0tMHggZTXp+G90j1uqsAsKPk+UlZ9SULkwQbhh0/1G1LAjPfsyy+mU7pRCLSgoG0MNJ3RBh9f6tUnBTpSUIrXyNxb89Fy5g1fdcAayQ5jiQh60mRhvl5LfMpylqbCncKknpqlPtbM9B5FmM2TijYNFLYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lN3INvXP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lN3INvXP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 232FF1F000E9;
	Thu, 16 Jul 2026 13:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209176;
	bh=OMEDivxsd72WXnfinkJpM2VvRkkZt2iL5iFdekMBmpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lN3INvXPeibmw2HuHq0g2lnpePLUkdcDfRlq2vxn0yk/wBWjaTLOyx2jQKCsaHskG
	 fCnN9UyuKFqXNufOtKo1up/x3764z7Rg6TWckYi72vmb8w2Zifo884RWGtiNi75dHP
	 CgUdr9qdtZPovslurXkQPbH5P5joXuk455adYU7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.1 087/518] ALSA: es1938: check snd_ctl_new1() return value
Date: Thu, 16 Jul 2026 15:25:55 +0200
Message-ID: <20260716133049.769635149@linuxfoundation.org>
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
@@ -1655,6 +1655,8 @@ static int snd_es1938_mixer(struct es193
 	for (idx = 0; idx < ARRAY_SIZE(snd_es1938_controls); idx++) {
 		struct snd_kcontrol *kctl;
 		kctl = snd_ctl_new1(&snd_es1938_controls[idx], chip);
+		if (!kctl)
+			return -ENOMEM;
 		switch (idx) {
 			case 0:
 				chip->master_volume = kctl;


