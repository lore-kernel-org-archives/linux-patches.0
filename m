Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F0229E116;
	Mon,  4 May 2026 14:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904409; cv=none; b=CBZV8l8KuNLSGF+8KwxxBjaMGlPM9qWomxRNof3hKn+EYPtIJm1TT+d/CnAg8aNCkRwNLSWZJBLl0cLTmkKSDOEcu5IdWTP8rdYJ7TWkePSA9HF7wST7vqoKB5iS0loGnhNjwnhTBY4u5A4tKICb62pjA2cCWUVsxbV0eIzCDU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904409; c=relaxed/simple;
	bh=1dqHSckN09R5MaVfJ2y2RFoI+fMi7jcnpPt7BC7XMwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jFkKGSkst89St9HRNpwkDtTx2SBluPBYyXAXVliSWvZpcWzYTiAkrjJ5R56hXhagmoA2TSSJLm0HYqShIBpZV0VsYumFcNb0ctpafSU+Ed6v0/e+LOmWi3YzzWuZUwpStVrgj8A33foWvRYwM6VKnWbedQZK0H5iIJM0LDDy5T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iqgnQfPo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iqgnQfPo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 948DAC2BCB8;
	Mon,  4 May 2026 14:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904408;
	bh=1dqHSckN09R5MaVfJ2y2RFoI+fMi7jcnpPt7BC7XMwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iqgnQfPo62+AxchwbVw1hG7bKXtdAjTbuezcsqvlvbkdYD2uFIpEr//yWmceEc/bL
	 qdqef5JzxwaVw7Auu0/XbvlrgQleFcQ1OD5ShaUfZ53l7GCYKCAYVXBm9NOAVQXZYg
	 z2HFdesZGLDTZyirApLdViBOug0mgyD3ecr3XENM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 003/215] ALSA: usb-audio: Fix Audio Advantage Micro II SPDIF switch
Date: Mon,  4 May 2026 15:50:22 +0200
Message-ID: <20260504135130.299988734@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

commit a9224f26b754b5034719248891ff3c2ea0d11144 upstream.

snd_microii_spdif_switch_put() returns 0 when the requested
vendor register value differs from the cached one.

This comparison was inverted by the resume-support conversion,
so real SPDIF switch toggles are ignored while no-op writes still
issue SET_CUR and report success.

Return early only when the requested value matches the cached one.

Fixes: 288673beae6c ("ALSA: usb-audio: Add resume support for MicroII SPDIF ctls")
Cc: stable@vger.kernel.org
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260421-microii-spdif-switch-fix-v1-1-5c50dc28b88f@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_quirks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -2064,7 +2064,7 @@ static int snd_microii_spdif_switch_put(
 	int err;
 
 	reg = ucontrol->value.integer.value[0] ? 0x28 : 0x2a;
-	if (reg != list->kctl->private_value)
+	if (reg == list->kctl->private_value)
 		return 0;
 
 	kcontrol->private_value = reg;


