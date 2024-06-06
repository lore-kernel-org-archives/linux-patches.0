Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5613A19644F;
	Thu,  6 Jun 2024 14:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683153; cv=none; b=fHWrPCqjNWC0v3JCRpLlzSDvldtWJV4oyxWUTrjLV2F/rpj1kxoi3S6Hr0/ClKtZwUOnFmw2JX3FxiYdLXhmFsFGFsZC636xvnCEUUFAXSUeyKgnMSpVV1MaaX2mnllW3n1h7TruAOEW/F5kFVIXzosjuZLyu5CfBZNhAcaF9rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683153; c=relaxed/simple;
	bh=C1YAXD6G8WocK/TjVh7ZHO0KVvii580aFyu4IZBXsCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fw/Lqhf1n220oTsJeV6slNGHX7TkOrSjFI7eBFo9BkTJzH4UtKdnaiXy8WPDNwvbdZxDlNOe9XBaHAZYajUO+LpTwFpy7puydJXEWpkXsVPjZ/IGCtrlTTTT0MU0jx4KeAqE81ShPmfg2C6kueuPOJbf+HZ4mPv8grrNxzoFizg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q9JbLIEZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q9JbLIEZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365BDC2BD10;
	Thu,  6 Jun 2024 14:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683153;
	bh=C1YAXD6G8WocK/TjVh7ZHO0KVvii580aFyu4IZBXsCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q9JbLIEZ+ArB6crAEQODs/HvoLebpU2uKQBzfDrt3xGYLS+j/QXxKnygxv1mGq2xy
	 X2qWmz4uL9R4Iafqkzdr8dsUPgiNnUAdHnXydLGCSupxEzSHo8wEjU+GUpG/ycnvzN
	 bk5wvN4LBRY94shPycaorJ9CFFGV+JbkMHsikM/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 024/473] ALSA: core: Fix NULL module pointer assignment at card init
Date: Thu,  6 Jun 2024 15:59:13 +0200
Message-ID: <20240606131700.660431373@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -307,8 +307,8 @@ static int snd_card_init(struct snd_card
 	card->number = idx;
 #ifdef MODULE
 	WARN_ON(!module);
-	card->module = module;
 #endif
+	card->module = module;
 	INIT_LIST_HEAD(&card->devices);
 	init_rwsem(&card->controls_rwsem);
 	rwlock_init(&card->ctl_files_rwlock);


