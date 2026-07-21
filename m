Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E293D16EF;
	Tue, 21 Jul 2026 22:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673144; cv=none; b=CUCzW7FhGeYKpAo7I1TgxQVaUT2JqnPjj9KSdAgeikKlDOJyn1e23qCkFkBa3iJgTu46Ym6BBAbvr9awjppWTDklAdkgUZ6CJ7T+zs1rVdXeoiGwiYPdyOBxStKZqfHrn0FcIuTcqO3G27Su0gXo1tSjDY189/Prrm3fJ5Eb7n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673144; c=relaxed/simple;
	bh=F6+9rwrb/yWbKaTRJFCmMqnujrxl3GcQKvD/OXWv2m8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RDwwPJJueuM8XHwuknDFfnnNiadibdL+fwpgSyMhaTX8d+aJm3Ntzj5a4Dl+WFpYKP7JBM9jJkxVBAgJmUyt9AWx5SXBsCgReeNYo8yOzAhlKaq6OUrpIX//V4PI9cvOieo1VRUvHfg6GIQYYfijS/5y4hHRFsnD8CVCYAzLn2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E3L7YGWt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E3L7YGWt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4050F1F000E9;
	Tue, 21 Jul 2026 22:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673142;
	bh=PaSFVravNxCSY7r9xqUkxv3e01hn+v+qPn8sCnvkh+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E3L7YGWtZ6XqCdlqlQuX6XBgyfMco1CMFTQsLMq8zPOkmJr9CQ7SwgnSAcK8MfmJh
	 9s4kZNGqU8QKGKK77kc0UBCrmZ73znNUV4aMpnpz1AxfoPDjSViS0JE7PutnvkbOzF
	 uS3ZCgBlJ6Axyo/OGF8HpLvBkLF0UEKjyJrochAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 052/699] ALSA: es1938: check snd_ctl_new1() return value
Date: Tue, 21 Jul 2026 17:16:51 +0200
Message-ID: <20260721152356.884290246@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1718,6 +1718,8 @@ static int snd_es1938_mixer(struct es193
 	for (idx = 0; idx < ARRAY_SIZE(snd_es1938_controls); idx++) {
 		struct snd_kcontrol *kctl;
 		kctl = snd_ctl_new1(&snd_es1938_controls[idx], chip);
+		if (!kctl)
+			return -ENOMEM;
 		switch (idx) {
 			case 0:
 				chip->master_volume = kctl;


