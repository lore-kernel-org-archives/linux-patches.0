Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E0719E7DC;
	Thu,  6 Jun 2024 14:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683107; cv=none; b=AqDRZd9m0Qe44LcWP0iFXJi899kUV/h+KdYWZm6zUeNT//BhGVdjUrlkB91xw2nTuV0q+PsXMB8Gdxk15lcJm4S5a2ef8gPddYji3PEpOk94t4PiicqwX8AbGI9meap14GogynF1hq7I7CVfIZlcs/ZuW8WyZExTEvm8eZtV/z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683107; c=relaxed/simple;
	bh=XMNGtvRLdA7W2+jyRni1dIr63CED2jb8nNiZ1kzx1+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PatRAuB1xFlxNImhC7C0cTCtUVDEPrLHRUWOWYKlLK3OAat57TgPyllV7OKfmvVk395DgzLSzdbCao6uV2LcKG9g/8ftxdDZC0xO56wDex+6Jc53+8mLDNUi+1joJSoUqYrKlj9n+YqZICCpMpjswUGgOFzV36IayL/vF8lj9/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TC6JRiGf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TC6JRiGf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D136DC32781;
	Thu,  6 Jun 2024 14:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683106;
	bh=XMNGtvRLdA7W2+jyRni1dIr63CED2jb8nNiZ1kzx1+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TC6JRiGfrRAFoqcv3gNFm0Ob3LaLXuIVSqvRoSTIceXHdMYXr1WjbFzyWr/vrrxgu
	 ki+ZnIlq38RdZ4fPE/UGlcS5/c2QxstOPdaSRQ0cop+asvTIFv1nceQ66jE4eRiGF2
	 VjUqCP5IN+ANha7meUxk5kpWAAWYPrykwgEXXiqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 030/744] ALSA: core: Fix NULL module pointer assignment at card init
Date: Thu,  6 Jun 2024 15:55:02 +0200
Message-ID: <20240606131733.422168119@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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
@@ -312,8 +312,8 @@ static int snd_card_init(struct snd_card
 	card->number = idx;
 #ifdef MODULE
 	WARN_ON(!module);
-	card->module = module;
 #endif
+	card->module = module;
 	INIT_LIST_HEAD(&card->devices);
 	init_rwsem(&card->controls_rwsem);
 	rwlock_init(&card->ctl_files_rwlock);


