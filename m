Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E212C3A1A26;
	Sat, 30 May 2026 16:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159853; cv=none; b=rpfYJqYrYYTX8mLuQrtSO7cvOZ3/lIbp9EKhjEnkwJGACu5RhwdFGVPjjJ7Bke+lJBKTtm2gjDxVFp9wN7x2tOCgKUDJwx4C5oRwY/7vOw0lekajoaty2Hba7FcM0KxtUBKPPWxqhhSjL8GdT9oBt6sEYA8+8n/YjWx/d0c2Cyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159853; c=relaxed/simple;
	bh=9c2bd/T2FSYkE+fqb1zS3PDV4JW/IjYTcw4vTNNand0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=njFS4VbC7gvvlJhlA6p00Yak/v3BS5t7/ONfPb8c6zLkpTJzikAPWSXjQ+4C4VU8BTbli1dB5NLMCmdx815YFPT9fjIGNtiCzP37A6aOVGxb7sNQmIZ6UmpYwAuEjjyJVTtqhbLXy98Ad+Q8uqse+MZo7qBf7IzkV+rrOwsUjhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rXNZWcWG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rXNZWcWG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A0D31F00898;
	Sat, 30 May 2026 16:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159850;
	bh=7DpulDi9/EiMwXMwwwW+dDwkqgs1ZZrCpwMpHHUzQOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rXNZWcWGxk4DR5EBuaovoeneBE/BH4BBxzPcOYhr1fxI5+Tb8pbY+AfPJ1p13QOIM
	 y1Xqq79NpFIysaprsnJEe8JsQAPHHbGv6ALrXwXxHnprCbJDslfw6bDZglTRPCvOvg
	 N8yfzhY9JAXOeRihnfaNA6NGcJp5uI7gLzhNcz04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 161/969] ALSA: usb-audio: Fix Audio Advantage Micro II SPDIF switch
Date: Sat, 30 May 2026 17:54:45 +0200
Message-ID: <20260530160304.973481475@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2066,7 +2066,7 @@ static int snd_microii_spdif_switch_put(
 	int err;
 
 	reg = ucontrol->value.integer.value[0] ? 0x28 : 0x2a;
-	if (reg != list->kctl->private_value)
+	if (reg == list->kctl->private_value)
 		return 0;
 
 	kcontrol->private_value = reg;


