Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702272FFDE1;
	Thu, 16 Jul 2026 14:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210572; cv=none; b=TdJEVmQnC8UF8TqsElMz4nTb4HQgi5pc3iZ9TLvzYEINljLkbcPNa58UWpQlBIwzPWf0UVskoRpuJBXyb7SySMrU6WOJcr2OZMBHsQoKQVp7SSZXbdbfHt5VxWjAEy7qidzoSYEUDYNUZL4F7JWns6xPRzvAXGgDDB+Q9Gefqpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210572; c=relaxed/simple;
	bh=MWNh5EMLT+G4dBEaPftWupKw/UVz+gce4hO20PhqxTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XmDh7a8BTwplWjDthl9KCK7I6/ZqBZJEjETzlDW+hFXWqyA0b1NH9X2oVaYA/wcUk7811kp9//5hm99LGKgMWe9Oly0vKDbKbKpThvmOJFCEbiUgMyvwlX4aNrgTkAKYjObfREQwtCZnSP8bLOlw0SCTjAon1Je0k5AJRiZpRMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F57h6Pr2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F57h6Pr2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D583E1F000E9;
	Thu, 16 Jul 2026 14:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210571;
	bh=4Nh+J2u0B+6nKmZB5/S9jg3HZCyeS7X8JM4iCHzlzS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F57h6Pr2O4fQa32CAaa2rAYMvqDVz6HachrkiELvN/NhUoIoZq0rdOIwuhQlzAOQ2
	 KhrZ6afMhIiD5HWo2qXfKXgaKJg2YrYoqA5eBYQRKjZ4lF2VWo63L+/8IH7TU2hCv/
	 olyaZsG/8ERyBGAEy9HW1hFAih9UwmgykQ1y0a44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 099/480] ALSA: es1938: check snd_ctl_new1() return value
Date: Thu, 16 Jul 2026 15:27:26 +0200
Message-ID: <20260716133046.853688644@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


