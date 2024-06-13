Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF49143878;
	Thu, 13 Jun 2024 12:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280794; cv=none; b=jdMaDwmWC2z4xgEnFJyo9hrdz2eYYsocBMuR+TzPRa09VupXO8zkwKZS/KVUJhMIr3pEcgFjEdajgJXrbGW4VGOEiUzffPkORjeI0G0o3lVPg5gE3aDmbSpAYGYplX3rwBCW8ecWBgqM1W3TG3tVU3Drm8YQDjJ5cyGQ1Jc8gkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280794; c=relaxed/simple;
	bh=rHdX88HN+kRB+mrcBKzFiWtY3i+zZqPwX/z5ULoXofc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ml48ofG1EsgTHT8fG258CPxGHUzbawEPzadDNdw45kX3pWjABdv6WR1Iir68meeLK4+Wps9B7FSX4dOwTUWpza7GCyMUOsHoexjmbSa0LmJ75vHOPHO5GP8Zv+GhiKcZY2Vjl5bR9WsIR3hO1rqcogWZCLVsSODwPSpzv8YL8pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kg3LrsFd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kg3LrsFd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F85AC2BBFC;
	Thu, 13 Jun 2024 12:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280794;
	bh=rHdX88HN+kRB+mrcBKzFiWtY3i+zZqPwX/z5ULoXofc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kg3LrsFdQedJRcXksv/hbKSa5tVKij6mdWkA+AFGw8RoADcXJy3genPblgOP9LscR
	 dTU50KMmCaZ+Zkh0LVqSxQ0OEoStDn2gybspwclUsPwk8KOWp5dwUTlGB4IpXvZN+X
	 9aKJtxcAOTh3EhITGuswYWJKZadoC33gi4r1uRN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 009/317] ALSA: core: Fix NULL module pointer assignment at card init
Date: Thu, 13 Jun 2024 13:30:27 +0200
Message-ID: <20240613113247.898100696@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -206,8 +206,8 @@ int snd_card_new(struct device *parent,
 	card->number = idx;
 #ifdef MODULE
 	WARN_ON(!module);
-	card->module = module;
 #endif
+	card->module = module;
 	INIT_LIST_HEAD(&card->devices);
 	init_rwsem(&card->controls_rwsem);
 	rwlock_init(&card->ctl_files_rwlock);


