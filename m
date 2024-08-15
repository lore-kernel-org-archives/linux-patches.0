Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664CA3214;
	Thu, 15 Aug 2024 14:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732647; cv=none; b=SxBf2dMAHOlS2x/VM9qSozivjUYiRZxi+dSi9rPD+yKAGBrxUpudkfy7E7KB0eURYIYN9VYXqqRMyCq+t0sBw4CrGzp1ZnP3igwxevK3p7WtlrchdFU7GmZG8MrIwnWVtoWgxnPrXeh7N4VqyWLLzDjsdBf1y75Ax9rIM7DM80w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732647; c=relaxed/simple;
	bh=/Tht8j/kmUYXF0BLFuxrVlsXs9U2JjDDVOZL8sMKlDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ab8A6cLtVsMoi6/RxNn9lez1F6ShY+7RZDxfDEqCXFlOTNifjsina0pfns2Lm4zt8hLvm/04VleUcDilNhaeYvHPXrI5MU88NTrXNBoSeB/+mkCjS8EJ51UBE1989wk/Tws2vcvAp+QsAZYaYzmpfWL8t9Z9GpJBp//IigKzc4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dtTZM6R7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dtTZM6R7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D15C8C32786;
	Thu, 15 Aug 2024 14:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732647;
	bh=/Tht8j/kmUYXF0BLFuxrVlsXs9U2JjDDVOZL8sMKlDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dtTZM6R7iK2znXpBU7I14C8MOy+A96DNDR0OKcDEwTcrHOLKFVY52sYeqLAk7//SU
	 qkHcHlwRRZXv67L/CVUOQZhk3d4kcP2rpJ7C+MbbEx2ZQ773FzlnJkkhmAqswHSo9S
	 0LgowVDgI0fCUtV4AJRnMW/FFh0koGEWDT43scFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sylvain BERTRAND <sylvain.bertrand@legeek.net>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 243/352] ALSA: usb-audio: Correct surround channels in UAC1 channel map
Date: Thu, 15 Aug 2024 15:25:09 +0200
Message-ID: <20240815131928.830025230@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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


