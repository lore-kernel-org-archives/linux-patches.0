Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F7F1D0492;
	Tue, 15 Oct 2024 11:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993405; cv=none; b=BXkBqWzUqzAUO3Fd1L/dVD9VJfkg11M/9k+TKyaG+1cY/nrsQtOu2JVAdb4JHGSEy7IxsNxsHd4ngvunJh6UAtfxsCgeEe5Ldwz0XO3JwofvtVWhco7B6kGe4YHxzhW0CrPoOhERNNtvr35XcI7FMsG0hCC5byyHwOVqYDdEW5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993405; c=relaxed/simple;
	bh=rP4U+TPHiz7yv7lB3Ux5c7O9ZCu0T52mLbgSGwi3g4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TPp8Cgu2pAbrGP7FoTMAdHVQ9Nx1M9KPeEIv/M5GM3Uhk0SACMc1asqRTEsRQyUgXXkj215QzKaL2AEgDz4LbgMfAIW/CQHWgjB5XbQfjEtTDAX47jm5PRkH08bk/PWZYUukFFFBdYDWOIqVIeV7KnGvWcqqNPLjsWBNcKmwDls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LtUsIa2h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LtUsIa2h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F88AC4CEC6;
	Tue, 15 Oct 2024 11:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993405;
	bh=rP4U+TPHiz7yv7lB3Ux5c7O9ZCu0T52mLbgSGwi3g4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LtUsIa2hJKoJLNodynu2PdbmGLnhGj8T1d6yOBS+6sZ/mk4z60XS9irhApTh/4sa6
	 QsSbeJeuMljXKV5hiilgmNTbGek6bRXoUkiEL4dIrZQ2mn3hFug+hHz1Jo/74wq8Hc
	 9cqgUwpPGque3cnSGbhSvL8BJ5A3e1QW+CFP7yDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 401/691] ALSA: mixer_oss: Remove some incorrect kfree_const() usages
Date: Tue, 15 Oct 2024 13:25:49 +0200
Message-ID: <20241015112456.254503925@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 368e4663c557de4a33f321b44e7eeec0a21b2e4e ]

"assigned" and "assigned->name" are allocated in snd_mixer_oss_proc_write()
using kmalloc() and kstrdup(), so there is no point in using kfree_const()
to free these resources.

Switch to the more standard kfree() to free these resources.

This could avoid a memory leak.

Fixes: 454f5ec1d2b7 ("ALSA: mixer: oss: Constify snd_mixer_oss_assign_table definition")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://patch.msgid.link/63ac20f64234b7c9ea87a7fa9baf41e8255852f7.1727374631.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/oss/mixer_oss.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/core/oss/mixer_oss.c b/sound/core/oss/mixer_oss.c
index 9620115cfdc09..c8291869ef906 100644
--- a/sound/core/oss/mixer_oss.c
+++ b/sound/core/oss/mixer_oss.c
@@ -967,8 +967,8 @@ static void snd_mixer_oss_slot_free(struct snd_mixer_oss_slot *chn)
 	struct slot *p = chn->private_data;
 	if (p) {
 		if (p->allocated && p->assigned) {
-			kfree_const(p->assigned->name);
-			kfree_const(p->assigned);
+			kfree(p->assigned->name);
+			kfree(p->assigned);
 		}
 		kfree(p);
 	}
-- 
2.43.0



