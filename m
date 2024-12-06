Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C5C53A7;
	Fri,  6 Dec 2024 15:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498266; cv=none; b=slxzv57K7PGhN/TX9rkMQG8prIF3LU4M55w/sE/4R/IPdWl2Tm3ptgVgldTshozlf0hY2y8XEy6I33g568hWRsk/IwhZCexuRi3VkCplzeABvFw1Bw9+avlV45xqU0xjyO4FdLjoiWKN1Y2KGf8ESCqouAOh9DSrcuXwKrtTHLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498266; c=relaxed/simple;
	bh=agY3sBKLlQ5jmbjmzDg1BsLT2hEr8UxOzvtROAhwyYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sgA4Iv55as/JATizqBpPNx212I8WikngnluELQNKE0l85Hb6cQKQXVMpa+2VqqbXYKvWlPZTKS6oj4A5q56Ugdsfq42q6ddpw+B63kcPbhsy/3d1/Itg+Z5ox8HyTsRVDkY0o/0RE+GPclK7daumcXJI7hQ54z3isYqgOY132vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K+w1K72G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K+w1K72G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA76C4CED1;
	Fri,  6 Dec 2024 15:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498265;
	bh=agY3sBKLlQ5jmbjmzDg1BsLT2hEr8UxOzvtROAhwyYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K+w1K72GWug1fe+Vjlk0icxsktkJQX9q+dAJ2uFWNp3RGsWpjlq60Tl6qqzl3k4ZU
	 Xb1kwGKzSACIT5rJP+PuqMXIAj2fv/axVzfO3ZxQpPJdpycKkBYih/SDkxhZ6SgPxy
	 iH/AbzLJBs5kMCnc9LP87Iy3xnO+IQgeWuOK0IiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 534/676] ALSA: ump: Fix evaluation of MIDI 1.0 FB info
Date: Fri,  6 Dec 2024 15:35:53 +0100
Message-ID: <20241206143714.219869567@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -724,7 +724,10 @@ static void fill_fb_info(struct snd_ump_
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


