Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F00298CAB;
	Thu, 16 Jul 2026 14:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210596; cv=none; b=J/FOBCtyfIAgCFwTQfUt0FT3EqqnmCOFUcosSLtOLavpRN1OLK/kW7Ln5MhTS18Bhd9m++C44IlV/bDJVQHzcba6nR9gzOW6DbL8pMT/QNez9+BPQwlYzVJu+GDHBus7wAvcnURTAtyvi3ueWQKPcZVZfdzNIZxDAxSw0RNbQUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210596; c=relaxed/simple;
	bh=ZWX23fkVwsmRnO7PepY+vs8LSeNNnRkW/lcjVfMMHVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KX8D+v/hY+/n4/Z9ZOiKcJN4nuI8d0S0aktBSgDst7ynSLfzVNP/cCUXqOPNDkAixPeFJHQb55d+YP4g5eWcB1DoKyMFB0DExR6wk+f1VJ6EBsBN5EikLZGG9nkNP9xCoqgNLt3R3mu2mwrh6R4oV0h9SItX6a4JtwElrC/W4t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yB8yk8oh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yB8yk8oh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866121F00A3A;
	Thu, 16 Jul 2026 14:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210595;
	bh=9x8kQzJuSr1OGhUIo9DkwE5UFRnY42xMaec3t8H1f5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yB8yk8ohuQ7tITm6p58Fvv8vgbHClN1YfZMkR613bHiGVlxPD3/wDi+VaonFz/t/P
	 6EDpkxB0OTNlSbF6MyD7ZsUfcX1v0q3rOdhTX+QP9fuyV1+H3r6UxUDHE6ryO2LvA3
	 iWaLw7poPuj8e6mZIqiswfVLRw3GSDawtVawGrrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 108/480] ALSA: seq: Fix uninitialised heap leak in snd_seq_event_dup()
Date: Thu, 16 Jul 2026 15:27:35 +0200
Message-ID: <20260716133047.046522109@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

commit 435990e25bf1f4af3e6df12a6fbfd1f7ba4a97d4 upstream.

snd_seq_event_dup() copies an incoming event into a pool cell and, in
the UMP-enabled build, clears the trailing cell->ump.raw.extra word that
the memcpy() did not cover.  The guard deciding whether to clear it
compares the copied size against sizeof(cell->event):

	memcpy(&cell->ump, event, size);
	if (size < sizeof(cell->event))
		cell->ump.raw.extra = 0;

For a legacy (non-UMP) event, size == sizeof(struct snd_seq_event) ==
sizeof(cell->event), so the condition is false and the extra word keeps
stale data.  The cell pool is allocated with kvmalloc() (not zeroed) and
cells are reused via a free list, so that word holds uninitialised heap
or leftover event data.

When such a cell is delivered to a UMP client (client->midi_version > 0)
that set SNDRV_SEQ_FILTER_NO_CONVERT -- so the legacy event reaches it
unconverted -- snd_seq_read() reads it out as the larger struct
snd_seq_ump_event and copies the stale word to user space, a 4-byte
kernel heap infoleak to an unprivileged /dev/snd/seq client.

Compare against sizeof(cell->ump) instead, so the trailing word is zeroed
for every event shorter than the UMP cell.

Fixes: 46397622a3fa ("ALSA: seq: Add UMP support")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20260623233841.853326-1-sammiee5311@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/seq/seq_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/core/seq/seq_memory.c
+++ b/sound/core/seq/seq_memory.c
@@ -364,7 +364,7 @@ int snd_seq_event_dup(struct snd_seq_poo
 	size = snd_seq_event_packet_size(event);
 	memcpy(&cell->ump, event, size);
 #if IS_ENABLED(CONFIG_SND_SEQ_UMP)
-	if (size < sizeof(cell->event))
+	if (size < sizeof(cell->ump))
 		cell->ump.raw.extra = 0;
 #endif
 


