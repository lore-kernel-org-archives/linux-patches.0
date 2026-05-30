Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C65C261B9E;
	Sat, 30 May 2026 17:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163679; cv=none; b=APRs3+LwuATqhOnHgkRkqbF7Zz6kDEHdCLSP6wUVY+t0jCIjpyzMxYIJbozfhqlfIpIFHJ0lDC0hI7+J2TTahPOaeVvp9wPI8Ol+v2zRozTgVZlCEFdTQ/xd6a9DkJ5PvuimGwwCihf3J5RqdNSTKrV/D7cnLnIa+KgqBOnQJiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163679; c=relaxed/simple;
	bh=ssZ4awLMfkFm6c4j+OntExXCL6mE9BYHnVWwMxyenT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FTQwC7tpD9BzSKA09NTpljDrsAilGiR8MiFPLVkoeUryra7O5TmWo2zHUk7U1LHdeGoOo/VYVzLm52emcEwD1fR6EIEOM52RzYARt0okeK2lN5y5GGqs0WN7vKQ47M3PsNPZLGDSNhrvD1CrDTd9dLpimap4yteqw4WpmDRaW+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1sogSMy5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1sogSMy5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE081F00893;
	Sat, 30 May 2026 17:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163678;
	bh=Bz5C08J8ejY64ZpwdxmrOKistZjhwW32sJ4ypCgVE5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1sogSMy55g6N18pnCuvjY+ISjdTQYoXGdee6Qm+GEjux8l4V3JgnzpfnjU9oqSVx3
	 xiTEIIUuqLn89aagHoMbI/LSLZ8rOymGposOo5ejWT2UkT9a9FPcTDsEspleLvh7ij
	 7E6FggcN/1hNBT3DjvmFDnTXFuSlqhMpSruBpn34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 300/776] ALSA: firewire-tascam: Do not drop unread control events
Date: Sat, 30 May 2026 18:00:14 +0200
Message-ID: <20260530160248.316830852@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

commit 0749daa8eb5ab90334aaad3b0671efd7150d43b1 upstream.

tscm_hwdep_read_queue() copies as many queued control events as fit in
the userspace buffer. When the buffer is smaller than the current
contiguous queue segment, length is rounded down to the number of bytes
that can be copied.

However, after copying that shortened length, the code advances pull_pos
to the original tail_pos, marking the whole contiguous segment as
consumed. Any events between the copied portion and tail_pos are lost.

Limit tail_pos to the position after the entries actually copied before
updating pull_pos. When the whole segment fits, this is equivalent to the
old tail_pos update; when the buffer is smaller, the remaining events
stay queued for the next read.

Fixes: a8c0d13267a4 ("ALSA: firewire-tascam: notify events of change of state for userspace applications")
Cc: stable@vger.kernel.org
Suggested-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Reviewed-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Co-developed-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260503-alsa-firewire-tascam-read-queue-v2-1-126c6efd7642@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/firewire/tascam/tascam-hwdep.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/firewire/tascam/tascam-hwdep.c
+++ b/sound/firewire/tascam/tascam-hwdep.c
@@ -73,6 +73,7 @@ static long tscm_hwdep_read_queue(struct
 			length = rounddown(remained, sizeof(*entries));
 		if (length == 0)
 			break;
+		tail_pos = head_pos + length / sizeof(*entries);
 
 		spin_unlock_irq(&tscm->lock);
 		if (copy_to_user(pos, &entries[head_pos], length))


