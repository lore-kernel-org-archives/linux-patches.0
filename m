Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7925C3B7767;
	Sat, 17 Oct 2026 17:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259276; cv=none; b=m0mpvWn+W0NeBrAmrkS4+R+GPWKSDHD60whNVTxFVjlZhD+5DkgK8Ay6thwie/6Y9Z/nFT0UPkcbdar1kWg8DACJ+sdvq2Jtap/0HdHuNMoWO8LOTljE/x2dK5v9OHBrjbUrDOMg1wOI/YgMUngPhp9cx1EDRpf1apqzOqmkRqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259276; c=relaxed/simple;
	bh=vcT31Bk8shLSGDHzX1LQkd5Jx0PnDorirUVWuI8nps4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UC2UQy/3ygpxX0/GyoAKpKY4n01qk5ZFDAm2PinVdJKE/Xfhp1Hqn5c5J1sM5qZE1IzqmeC7m31ZKFCUMOCXz+6BV1PByYrzU0phNlyYj40NHtZTUhiXZJzqVpmD46NfhTsdrEWaB3qsFQA/Y+ybRj8otU4xjKxQufuMyKfiUr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=geEe3ofB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="geEe3ofB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D10851F000C6;
	Sat, 17 Oct 2026 17:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259274;
	bh=s11CgZPNCCxsfFMDp6yBw5qDxrb4r8tI/WExkbqyw64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=geEe3ofBNaELyN4kxpD84TnYZaAa0bM0n/uv3Tyi2clvYobg9E5Xrq8uVSqYRIuQJ
	 Wh+jn3cQZUa7bMuaF/GITuZzeVN5EWoCKBK4szfI3bUPKrcJZ2+pvvO9pgU2C3Nqq6
	 uIQ1Z9cR3Y5o0xrbrpaTpzRUiBJOF4OW8oEb3UE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HanQuan <eilaimemedsnaimel@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1160/1674] ALSA: seq: Fix kernel heap address leak in bounce_error_event()
Date: Sat, 17 Oct 2026 17:57:12 +0200
Message-ID: <20261017160500.924561993@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HanQuan <eilaimemedsnaimel@gmail.com>

[ Upstream commit efc86691e4d8083d9e380ea95042c2cf679f65fd ]

The comment above bounce_error_event() documents that user clients
should receive SNDRV_SEQ_EVENT_BOUNCE with the original event embedded
as variable-length data, while kernel clients should receive
SNDRV_SEQ_EVENT_KERNEL_ERROR with a quoted kernel pointer.

However, the implementation unconditionally uses
SNDRV_SEQ_EVENT_KERNEL_ERROR with data.quote.event set to the raw
struct snd_seq_event pointer for all clients.  When a bounce error
event is delivered to a USER_CLIENT via snd_seq_read(), the kernel
heap address in data.quote.event is exposed to userspace through
copy_to_user() in the fixed-length branch.

This is a distinct leak path from the one addressed by commit
705dd6dcbc0e ("ALSA: seq: Clear variable event pointer on read"),
which sanitizes data.ext.ptr in the variable-length branch of
snd_seq_read().  The bounce_error_event() leak uses fixed-length
events that take the else branch where no sanitization occurs.

Differentiate the bounce event by client type.  For USER_CLIENT,
send SNDRV_SEQ_EVENT_BOUNCE with SNDRV_SEQ_EVENT_LENGTH_VARIABLE
and data.ext pointing to the original event.  The variable-length
path in snd_seq_event_dup() copies the event data into chained
cells, and snd_seq_expand_var_event() copies only the content --
never the pointer -- to userspace.  For KERNEL_CLIENT, keep the
existing SNDRV_SEQ_EVENT_KERNEL_ERROR behavior with the quoted
pointer.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: HanQuan <eilaimemedsnaimel@gmail.com>
Link: https://patch.msgid.link/20260612103222.2528305-1-eilaimemedsnaimel@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_clientmgr.c | 32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

diff --git a/sound/core/seq/seq_clientmgr.c b/sound/core/seq/seq_clientmgr.c
index 7f117d4a369d0..f039fd6ee3a74 100644
--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -588,16 +588,38 @@ static int bounce_error_event(struct snd_seq_client *client,
 
 	/* set up quoted error */
 	memset(&bounce_ev, 0, sizeof(bounce_ev));
-	bounce_ev.type = SNDRV_SEQ_EVENT_KERNEL_ERROR;
-	bounce_ev.flags = SNDRV_SEQ_EVENT_LENGTH_FIXED;
+
+	if (client->type == USER_CLIENT) {
+		/*
+		 * For user clients, send SNDRV_SEQ_EVENT_BOUNCE with the
+		 * original event embedded as variable-length data.  This
+		 * avoids exposing data.quote.event (a kernel pointer) to
+		 * userspace.  The variable-length path in snd_seq_event_dup()
+		 * copies the event data from data.ext.ptr into chained cells,
+		 * and snd_seq_expand_var_event() copies only the data content
+		 * -- never the pointer -- to userspace.
+		 */
+		bounce_ev.type = SNDRV_SEQ_EVENT_BOUNCE;
+		bounce_ev.flags = SNDRV_SEQ_EVENT_LENGTH_VARIABLE;
+		bounce_ev.data.ext.len = sizeof(struct snd_seq_event);
+		bounce_ev.data.ext.ptr = (char *)event;
+	} else {
+		/*
+		 * For kernel clients, quote the event pointer directly.
+		 * Kernel consumers can safely dereference the pointer.
+		 */
+		bounce_ev.type = SNDRV_SEQ_EVENT_KERNEL_ERROR;
+		bounce_ev.flags = SNDRV_SEQ_EVENT_LENGTH_FIXED;
+		bounce_ev.data.quote.origin = event->dest;
+		bounce_ev.data.quote.event = event;
+		bounce_ev.data.quote.value = -err; /* use positive value */
+	}
+
 	bounce_ev.queue = SNDRV_SEQ_QUEUE_DIRECT;
 	bounce_ev.source.client = SNDRV_SEQ_CLIENT_SYSTEM;
 	bounce_ev.source.port = SNDRV_SEQ_PORT_SYSTEM_ANNOUNCE;
 	bounce_ev.dest.client = client->number;
 	bounce_ev.dest.port = event->source.port;
-	bounce_ev.data.quote.origin = event->dest;
-	bounce_ev.data.quote.event = event;
-	bounce_ev.data.quote.value = -err; /* use positive value */
 	result = snd_seq_deliver_single_event(NULL, &bounce_ev, atomic, hop + 1);
 	if (result < 0) {
 		client->event_lost++;
-- 
2.53.0



