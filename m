Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6811AC896;
	Thu, 15 Aug 2024 14:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731598; cv=none; b=IALIZU8g8l8F/B3KKhMwk3rd1F3rDfBpsmbebKBhjFumyu8bIlvcpJh072uZj+N0Ewv284KGTGw2AA3Al68z5modWvjJ8xaqmMoU16mk7T2Yk9ogKC+Yhv7ErsF3xiYKlFr1PNtAIPhCGS5I1Hg8hWwT2N2dg/S2UK+HmT0q92c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731598; c=relaxed/simple;
	bh=uAJP1AjGWD+ZU8mkhg1v0JuFKJHSnQPYCU0EkR+qlP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ApWZ3UPR+7kv80z4EmTTTedh7u79W62KPYubzVsRJj7e0zoQDnUk8PwiFML+PH4oOGwJY6nkWgI8+HkuMHVrpGJ76eB1Y+24ZlhKJBDQ/dVFrRfwWeCgPtOWxYiOeJPJE2zHQHLAUdPj9DPU838zd2MiqwqBaWKnAD0gnQYy2gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GbBBayE6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GbBBayE6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5CFC32786;
	Thu, 15 Aug 2024 14:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731597;
	bh=uAJP1AjGWD+ZU8mkhg1v0JuFKJHSnQPYCU0EkR+qlP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GbBBayE63TCBlhGI0TqgM8cBAi4whMTUHuDAuFt27ueKnlOAyj0raQ0Mr6f7GpfpC
	 f0c0edgsSBUAjz6sr6lTwFBejpWeMb2+BK22wPtA0WZRzpQGbgcKZinlzU/1zwEBpR
	 jHt/f2HsoZSAnZEzMe5gylZnGG6N85+7mXoc94rE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sylvain BERTRAND <sylvain.bertrand@legeek.net>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 180/259] ALSA: usb-audio: Correct surround channels in UAC1 channel map
Date: Thu, 15 Aug 2024 15:25:13 +0200
Message-ID: <20240815131909.730064865@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit b7b7e1ab7619deb3b299b5e5c619c3e6f183a12d upstream.

USB-audio driver puts SNDRV_CHMAP_SL and _SR as left and right
surround channels for UAC1 channel map, respectively.  But they should
have been SNDRV_CHMAP_RL and _RR; the current value *_SL and _SR are
rather "side" channels, not "surround".  I guess I took those
mistakenly when I read the spec mentioning "surround left".

This patch corrects those entries to be the right channels.

Suggested-by: Sylvain BERTRAND <sylvain.bertrand@legeek.net>
Closes: https://lore.kernel.orgZ/qIyJD8lhd8hFhlC@freedom
Fixes: 04324ccc75f9 ("ALSA: usb-audio: add channel map support")
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240731142018.24750-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/stream.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -245,8 +245,8 @@ static struct snd_pcm_chmap_elem *conver
 		SNDRV_CHMAP_FR,		/* right front */
 		SNDRV_CHMAP_FC,		/* center front */
 		SNDRV_CHMAP_LFE,	/* LFE */
-		SNDRV_CHMAP_SL,		/* left surround */
-		SNDRV_CHMAP_SR,		/* right surround */
+		SNDRV_CHMAP_RL,		/* left surround */
+		SNDRV_CHMAP_RR,		/* right surround */
 		SNDRV_CHMAP_FLC,	/* left of center */
 		SNDRV_CHMAP_FRC,	/* right of center */
 		SNDRV_CHMAP_RC,		/* surround */


