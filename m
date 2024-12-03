Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFBA01EE00B;
	Tue,  3 Dec 2024 16:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242562; cv=none; b=f5mi0tE7Mh5P4ThDeLb5A8atxD+Tls7OSHcaVtXO7MY+tzwrbct3dL1zdI2pdOCcudL9f2kr8Ikyz9S4oOsEjLTDA3Lc27S9EFYz8hIqjlaFXl/hJQ9eXCM4QYNP0t4ztdb01aI0zv8uUJ/3ErT7sTKKI01JtbBl7n/7BomTmTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242562; c=relaxed/simple;
	bh=m7WyHBC5pcG6e+opCAd1vB8sdKCBiEaEMCmGdHAJ5e8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eUB67A/kdwGPHeeFyZZAEgy3oDWwR7QFoAyMSG5D+1l7ZN0aRa7KmHY8OcUg5ZDFnOasom6qUl5wVzbgMaSjAd+i321HdFUbu9TG+VwS82IZ1sI8HgMisgJ7FPcCiYEuM6ZhOILfRz9ZFnRNukumrypnwZWdNiACnKVzsusWIN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uAdqXL/Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uAdqXL/Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF5AC4CECF;
	Tue,  3 Dec 2024 16:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242562;
	bh=m7WyHBC5pcG6e+opCAd1vB8sdKCBiEaEMCmGdHAJ5e8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uAdqXL/YjK92h0258SYm9XnesRf/t0f1lMBxDN26WFbQgCkBTehgKwgfJQNMrdVsr
	 ySklfDmyAFx3erBUw/tp+UwmhP3+idbYOOxB2f2gmqoeHMUfktm3ZMGgDcJRgC5yiL
	 dcWM8bikX4KXFm1a5MOUA7o+MmNwMy2IJzf4ajcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 741/826] ALSA: ump: Fix evaluation of MIDI 1.0 FB info
Date: Tue,  3 Dec 2024 15:47:48 +0100
Message-ID: <20241203144812.670127165@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Takashi Iwai <tiwai@suse.de>

commit 7be34f6feedd60e418de1c2c48e661d70416635f upstream.

The m1.0 field of UMP Function Block info specifies whether the given
FB is a MIDI 1.0 port or not.  When implementing the UMP support on
Linux, I somehow interpreted as if it were bit flags, but the field is
actually an enumeration from 0 to 2, where 2 means MIDI 1.0 *and* low
speed.

This patch corrects the interpretation and sets the right bit flags
depending on the m1.0 field of FB Info.  This effectively fixes the
missing detection of MIDI 1.0 FB when m1.0 is 2.

Fixes: 37e0e14128e0 ("ALSA: ump: Support UMP Endpoint and Function Block parsing")
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20241127070059.8099-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/ump.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/sound/core/ump.c
+++ b/sound/core/ump.c
@@ -788,7 +788,10 @@ static void fill_fb_info(struct snd_ump_
 	info->ui_hint = buf->fb_info.ui_hint;
 	info->first_group = buf->fb_info.first_group;
 	info->num_groups = buf->fb_info.num_groups;
-	info->flags = buf->fb_info.midi_10;
+	if (buf->fb_info.midi_10 < 2)
+		info->flags = buf->fb_info.midi_10;
+	else
+		info->flags = SNDRV_UMP_BLOCK_IS_MIDI1 | SNDRV_UMP_BLOCK_IS_LOWSPEED;
 	info->active = buf->fb_info.active;
 	info->midi_ci_version = buf->fb_info.midi_ci_version;
 	info->sysex8_streams = buf->fb_info.sysex8_streams;


