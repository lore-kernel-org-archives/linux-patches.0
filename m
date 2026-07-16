Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43C73DB336;
	Thu, 16 Jul 2026 14:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211777; cv=none; b=NPUho75HiFs0uxtaxgujra7kDbOJZdpoACC90+wfzihtGUjvTqnp2Ley4ihqj/CupDQWp86/wAnYIoW2Pylf3g7mW/XvST00QPv855VYdksaTcFpdE98e8PElnJ0AaqZZzoSqdatAGJNqVxYzD8fxYVf8Ydr4SreOa0sIcKL2QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211777; c=relaxed/simple;
	bh=BAmxWHVwLGQkpWc7aNopPFY6tD8GeZ8mXCxrMv+MFOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TdmX8aXVQUTGDHYX5Oef9iOqCNipkH2A33RSqakUzObFHfdV9SlacWs9BGnELTnr4Q3gcJy7ogbv1u+BD0CxuL3sV+TG6oO+SlSjDfmx2+C7nZaSkZd7i2oZduiK6LwHcEjDba7QQ4d1WcHXt+eT8JX3+e6+8oo/UaBWWqyDIFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DiL1VzUt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DiL1VzUt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD3D1F000E9;
	Thu, 16 Jul 2026 14:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211776;
	bh=3AHFmOip9GoW0Bvwu56DFJGZHyLgFogrKA73whFfsdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DiL1VzUthOCImr+FQWpsw7EeKDFzOEpSRtMqOFw/zOBCyusdYDd8GjW8xm9/lygwi
	 gJjZFz7BSjSjpygPA00Z9XMMQZgUmZgovwidUNKHYgbI+meXnQPje8gkb33i8xa2o8
	 WAvqaJBh36g3ThsWmS1YZdrBRgegYPog6arzZFxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 076/349] ALSA: es1938: check snd_ctl_new1() return value
Date: Thu, 16 Jul 2026 15:30:10 +0200
Message-ID: <20260716133035.020914194@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1663,6 +1663,8 @@ static int snd_es1938_mixer(struct es193
 	for (idx = 0; idx < ARRAY_SIZE(snd_es1938_controls); idx++) {
 		struct snd_kcontrol *kctl;
 		kctl = snd_ctl_new1(&snd_es1938_controls[idx], chip);
+		if (!kctl)
+			return -ENOMEM;
 		switch (idx) {
 			case 0:
 				chip->master_volume = kctl;


