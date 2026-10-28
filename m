Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215561;
	b=ucV2g3vlG+8nNbe5nOnWeOBJd5L+AwCXQRY7w2SGNsyLVtfpcR8XbtA/YMqBM8p7g1Al
	 rKLFOpwBQ+rYf4tuaNCsjhKmF+bdclmqmOZVhciB1n9ZbmLQHNdEbtTwm6j3k2YcLZASz
	 yEl7Z3GdHxPLxR8HuwsERwtL5AVbUIlpIBjk92ce5jcbIfeURm+pB01K1s3WmUm00wh5q
	 bIlYWhabR2whvCj7DoAA5poTVLx5gHEcDfxyFK/ui/3ZU9ztpLNMxolxvGX55RHS9VMWn
	 UN09tKkeW4gwv4NyZpfRzQKtGIrbuDzJiJGbFeloXt9/VbNCA+YFQEDSEME7HQ2azKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215561;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dKXnmMF3L9/J+FZm/wO1smf+fdAf6E4L1VvJ519CEHg=;
	b=s4DeuMfIHKSnlNH3tF93cQvFJw/2WTY6lxdnzZYFDtlSRefm8ruZYA7SnGI1LdbNxhUe
	 8rgNdEH4OLiCAstlwQOdscMPn64cbgUMXezr4phStZbGIfYlqHz19liy4H9vZ2JqQneNp
	 gqWbm4HqPuFltqOF55kOImmINXu4SIDX2Ri+sGe4fdCrf48i5TS/z9LK8M4RSKR8Z7I6r
	 LTsBmNaSuHEDjpime8CX8fbzjrLI1YbzzRc/9gY77KAOMEHiFn6N68vDaN45ddjjaLgQ1
	 8NRxgQdw/B++Omux1PLY/z+smIjdO/1WYaqMlAmnkxyZ872X2H88s5qP2E25fBePHVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V1vwiGZR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF6C606A31A;
	Wed, 28 Oct 2026 19:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V1vwiGZR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA801F01825;
	Wed, 28 Oct 2026 19:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215560;
	bh=dKXnmMF3L9/J+FZm/wO1smf+fdAf6E4L1VvJ519CEHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V1vwiGZRq2Hc6ZiM0L9lLT5ZbBihEGVGRMqxxWw21RvVvrnwphEBBAvPUhTPu1jQt
	 rAN2c8O5PIPNtIhFq2tLzDezkVlZXPjtUcgsdBTfRpENj5vUYKE8FiXbFZ3XwbTRHz
	 LmQf4KFRHv72CUDpSIQ6auptX7VqC9wUkQmprv7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HanQuan <eilaimemedsnaimel@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1253/1887] ALSA: seq: Fix kernel heap address leak in bounce_error_event()
Date: Wed, 28 Oct 2026 17:55:49 +0100
Message-ID: <20261028170527.938986003@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 07b1b8bf7e3cb..140e1510b8de5 100644
--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -564,16 +564,38 @@ static int bounce_error_event(struct snd_seq_client *client,
 
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



