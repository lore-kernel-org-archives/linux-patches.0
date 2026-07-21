Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E73144AB6E;
	Tue, 21 Jul 2026 21:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670800; cv=none; b=on4EWiBKDMU/elh1yly/YjNSAGQvGS+nN+ZwoYJ3/7q75bRmUojfNjO2RI/wgPB9So1wx/zqDOjcdP1e6o0rhlcjxIIjfcDjQJ6lFAwabzxiawlcRuWX3+dukGrABQxjHB5Et04zpjFWBK5jb63v4u5sERQJTBGwy4kuKbwaeVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670800; c=relaxed/simple;
	bh=4ZLc6CpYhkjCbZwG9PAyr3oBxXVhn1GeMmcYQyKpZgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RqGkBpUvNpWVOq+JuyYzRzGBz9pQDTSwZhOYt6UBrBpKiZMR+aTMfE+ab1dLnv34BRVLX6MKqCBkYYMQ60yv4olxsFIi+QyanwNInbJR9Jp3ja2rwL29SaJBMhGJNADapIIPjwKirrjFgJ7uPlSUgUzIdzVHQTBq+iKll3xv3Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZvcX+WUF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZvcX+WUF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E419D1F000E9;
	Tue, 21 Jul 2026 21:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670799;
	bh=6k0WX/ELNl/1K8iuNrDS6H0UurpvBrdNmL2Wuuc+yyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZvcX+WUFfCoaP/OrAl/mzOHCEoGCdG7vBDwm+kn1y+UIwqGGUV6vn3BiT2dE7LV4w
	 2FWyfX/9dhJDacseah8X0AMcUT4IUMUmWDxFLKHaCm3d7IAPxItWWIxPZtrb5Q21kx
	 N3r1cQJufSOf1W9M9vuPgO7cdbhVVB5zCqmGJix0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 1067/1067] ALSA: seq: Fix uninitialised heap leak in snd_seq_event_dup()
Date: Tue, 21 Jul 2026 17:27:48 +0200
Message-ID: <20260721152448.455852833@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


