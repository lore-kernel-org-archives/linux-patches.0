Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C69E15FA85;
	Mon, 27 May 2024 19:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836401; cv=none; b=DjbJg7oWmjsKmxq5vqh0PtpjjQTqlfLL38Bh6PxDhye/v0qjYAkhgaELudbb6cqp6mAEegrSwFzEGy4TozID/xsxhWhUuMSc4v3ETkDzPeatfOXWXpmtk3tsP705yQex3wyelHSYQ/YVQvqaKpcaUeD8bDCx3/jrloqfG6YJgN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836401; c=relaxed/simple;
	bh=BoYLw7fHj9g3PiXf06bQQHws6B7at5mXiye8Rxvb/rI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QrXN9T8VkBDg4UA61KJjynPNuEDlQl1svFB+6ps9xlZJOolFiZIXjgliQnyoYzoTVz5QHCd6AstV2ksC9btktCHA6pY7S7bQl4uLc6o/w1QO5kf+DhNH+Vp5MIe+EzhPoEHKxrrpXGcS/nd3S4jdYkwGZn87UKMO1lRWjjrfgjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PQaFVBn6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PQaFVBn6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7DB3C2BBFC;
	Mon, 27 May 2024 19:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836401;
	bh=BoYLw7fHj9g3PiXf06bQQHws6B7at5mXiye8Rxvb/rI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PQaFVBn6GYx5eMN7LmGRjZoS1dEJ2k9rrlcwa4ztxIMB78kzyAUGXWr/cFB/ype3D
	 eX8DUCOMh2pdwNZ1+OJV5ruN+mNARCfR7kj1zEqlNYfJvZfc24rCZ2FnGcwFQt6FQ7
	 dMs8lqu+PP0P4NwRvVFaRclXB8jEcG01yB5ypbiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.9 038/427] ALSA: core: Fix NULL module pointer assignment at card init
Date: Mon, 27 May 2024 20:51:25 +0200
Message-ID: <20240527185605.215091474@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 39381fe7394e5eafac76e7e9367e7351138a29c1 upstream.

The commit 81033c6b584b ("ALSA: core: Warn on empty module")
introduced a WARN_ON() for a NULL module pointer passed at snd_card
object creation, and it also wraps the code around it with '#ifdef
MODULE'.  This works in most cases, but the devils are always in
details.  "MODULE" is defined when the target code (i.e. the sound
core) is built as a module; but this doesn't mean that the caller is
also built-in or not.  Namely, when only the sound core is built-in
(CONFIG_SND=y) while the driver is a module (CONFIG_SND_USB_AUDIO=m),
the passed module pointer is ignored even if it's non-NULL, and
card->module remains as NULL.  This would result in the missing module
reference up/down at the device open/close, leading to a race with the
code execution after the module removal.

For addressing the bug, move the assignment of card->module again out
of ifdef.  The WARN_ON() is still wrapped with ifdef because the
module can be really NULL when all sound drivers are built-in.

Note that we keep 'ifdef MODULE' for WARN_ON(), otherwise it would
lead to a false-positive NULL module check.  Admittedly it won't catch
perfectly, i.e. no check is performed when CONFIG_SND=y.  But, it's no
real problem as it's only for debugging, and the condition is pretty
rare.

Fixes: 81033c6b584b ("ALSA: core: Warn on empty module")
Reported-by: Xu Yang <xu.yang_2@nxp.com>
Closes: https://lore.kernel.org/r/20240520170349.2417900-1-xu.yang_2@nxp.com
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Tested-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://lore.kernel.org/r/20240522070442.17786-1-tiwai@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -313,8 +313,8 @@ static int snd_card_init(struct snd_card
 	card->number = idx;
 #ifdef MODULE
 	WARN_ON(!module);
-	card->module = module;
 #endif
+	card->module = module;
 	INIT_LIST_HEAD(&card->devices);
 	init_rwsem(&card->controls_rwsem);
 	rwlock_init(&card->ctl_files_rwlock);


