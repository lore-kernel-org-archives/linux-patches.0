Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A55279DC9;
	Sat, 30 May 2026 18:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165767; cv=none; b=qMyO2EwCMdVPJ0U4VXBc184Lunea7A5P7wk/S2aQAjtFI1RAVNlKiKssbDXBsKz1hOvc4QuflTPUegGG2NahhsgzSx0VlQ0p0fra5vQFGFwBRDpc6w/55XzK2faK0wfjEsPljDvdf2LXDBVKLVXcdDEd4nBjE3lbhUUFVC9pwsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165767; c=relaxed/simple;
	bh=Z8eVvl7M2RQ/Pd6q+FDl+hHmizcgLCqlXxAfEIu1f7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NtCTQ6j5fHtHr9g/FzCOXxBEvH+fHSB5OF/pqTsXQ5mZ2a2xDNGMWGDz60C1DGznZf5q6o9rVbd+qkvTXkrJiWHW80emxbubkVWwBy4jQh/6KVQPr3Ie81bIJOVZoD1MtAypkXv/b/8VdK9SmpR1a+1BrHg2parg+mVEHSbApYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vxNCke0o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vxNCke0o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F871F00893;
	Sat, 30 May 2026 18:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165765;
	bh=UMvSiXCzwb5CIJlK6jl9wZGe6zfcHeVLdFTiYb4ZWoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vxNCke0o5Uo0awVkCtJ+RLPhSC6DN8Rq17YNvQbOueRaJAT4DmINYsKxyubsQfBq+
	 KwxTOZyTQ3UVkma4rLyQ2K+jzoUymYQHkFX1jw98tdqp1xslHMhOYXIbW7BJ9wYnly
	 +LIO/RPB8WJhkiPwgpvZMG07ib2IzaNYA/TP8HgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 139/589] ALSA: usb-audio: Fix Audio Advantage Micro II SPDIF switch
Date: Sat, 30 May 2026 18:00:20 +0200
Message-ID: <20260530160228.433170957@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1925,7 +1925,7 @@ static int snd_microii_spdif_switch_put(
 	int err;
 
 	reg = ucontrol->value.integer.value[0] ? 0x28 : 0x2a;
-	if (reg != list->kctl->private_value)
+	if (reg == list->kctl->private_value)
 		return 0;
 
 	kcontrol->private_value = reg;


