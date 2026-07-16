Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F94E400982;
	Thu, 16 Jul 2026 14:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211791; cv=none; b=Yeh0hM9nvUs7fQKf5nDp55OWLgT5qJahiJjEx7+wyDnIHFOuPtxU+TEBUHI/XCxc+D+KXFC5RH3b3jP/Ja3Su/Cr724LJ0y7XNEUtQmKn10pVeLJaqOxqeJa2duiOIOKCqlZgGvvjuVSLYtJydWn8tN3S4jKVtH2DX8c7qIQ3WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211791; c=relaxed/simple;
	bh=pGLxMQlMjDj7XQd6yIb3vUlNck2t6HBF3SScWvnzjAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s/pcSJWwKHiYNNbdjTtjXqCxWgvdk7pON4XPkA6R9QQ92fNDQxHpx9iFPZXzYurDV+dFbvIOlgVC71v/svNkJd7pxfWUwqVhIs0G/jF8r89VPwDOjd+eUxZLD8rMccUzHyzA7xdZbrcZCathKaTdirFC61A3BVTbWNHbNuaSxl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TI2NONQF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TI2NONQF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8535D1F00A3A;
	Thu, 16 Jul 2026 14:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211790;
	bh=Lfokem7yn0f4afWlThDkLDav1Wbm37iBjlgoTviuBXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TI2NONQF0kOt8gnz5TAG2Ei51iFJU4uWHiuv1m0wz3puNX0OfSgpjArpHqZqh2uKw
	 4swrlmzS6NHTxbh9StJ1EUNUT/VbSywkmesV2aj+M6BaCUiCI6X4NZjN+HDX+xDexb
	 kyx9QE67jFEnWO6gKbNbhuYMMAHwlMkyGhcnttvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 080/349] ALSA: seq: Fix uninitialised heap leak in snd_seq_event_dup()
Date: Thu, 16 Jul 2026 15:30:14 +0200
Message-ID: <20260716133035.106850897@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


