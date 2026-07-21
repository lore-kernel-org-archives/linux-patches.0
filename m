Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF86943C7DA;
	Tue, 21 Jul 2026 22:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673016; cv=none; b=Lil7MSEhRN02IVzLRFb6n/VJX+oFFt0XxYrnc9x3xUdmlh/EhYREwsaHS6Bbs5LMJOxMhUuS9q2DzRnFBqWMIMp6EtbcX2PfpHx9zXN/KswnVXbh0ZKIbKx5ItuFLCPbTayMAWcoN6tS3RfIzwYc1nG4JR1cWgRNt53P8xdFvIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673016; c=relaxed/simple;
	bh=eabibipZgJRo+vopb+MuhjOFAmN+Glfow5TiaNIji/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aHF11NGY10Xj4SbCtZ4jeMxeQElLSSYA26o6czQFVIl3z5vsK+RLZMqZoO15NnBit1Byd7Gop+mvwNoF1xvCY52fWO7phOuO0OHl2f9zZhlPcl2SOLzFjxA+FIcx7BuIO+g9lRmEpkImn5K9SCDYVDl+ekymHwkOFGGwQBkfSqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qWGl+8kZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qWGl+8kZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F251F000E9;
	Tue, 21 Jul 2026 22:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673015;
	bh=dTBPq90QQo6CKd5roAJuEBPtKzWF/KYauU7/quffJlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qWGl+8kZhj0MSKFb77HQ3424swc/4fvE93XhnyKETMKglrGXeIHbknY9Bn3rlwMpw
	 Exw8FPwAsNgppiikgOBEZ74By39frn8NT2Ty3L+9ZclGz+jSJLyLFm1urvoa591URq
	 vBecvSfc3unnSV5VwcUXUAMcNDKGuSttnTxxpGic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 843/843] ALSA: seq: Fix uninitialised heap leak in snd_seq_event_dup()
Date: Tue, 21 Jul 2026 17:27:58 +0200
Message-ID: <20260721152425.039379621@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -309,7 +309,7 @@ int snd_seq_event_dup(struct snd_seq_poo
 	size = snd_seq_event_packet_size(event);
 	memcpy(&cell->ump, event, size);
 #if IS_ENABLED(CONFIG_SND_SEQ_UMP)
-	if (size < sizeof(cell->event))
+	if (size < sizeof(cell->ump))
 		cell->ump.raw.extra = 0;
 #endif
 


