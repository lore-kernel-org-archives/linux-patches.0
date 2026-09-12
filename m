Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8BB28B4FA;
	Sat, 12 Sep 2026 08:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203203; cv=none; b=isaOpL+UMI0c0NL7XTULfEY6/kAt9sOO/TE93Ov/EQPUqjdhzGhBphOP0vibGxlDKoxWE46ZzBLgo7aefQ4QBXDl+B00dnffGqGIv2lDYlVhhlwNNFho7Db8Dt9mJdCZVPS97ZFFJAJHyz1wwPSCslA/ThcJO5xXuZmO7foyhOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203203; c=relaxed/simple;
	bh=i/FSEsoyl3J9rBhqr1qWvc3TvCT8zxidjyaSfrjAW10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C2R/HLyzFqKmFHYup4/ENa51ALHSFko38/5IrirNpw3byXGKRNK+4TqcRWu8MFBxXP3pNZcWX42l7YxJ8rIvrNlkoAbv6HhUK8WtuGaYMZD5MX75ASSIZnU0FSV1eQVsc6eJaY1ZQt5bd7lMbIBXCa+oWca+jnYn2+wRlqotz24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ms+csIun; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ms+csIun"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D5F1F000FF;
	Sat, 12 Sep 2026 08:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203202;
	bh=ZGpLGu+0S0vs0/AXf+CJeHRVcihcJJLs2uU4JljY4CI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ms+csIunC+kVVoxD2de9f2MHFSiVw2QipUEv5X5pMeUmKW+wMVi6o8ofbsmXNacBk
	 QLZx0D7ENUGmLPFaYO/OBZaS1KW+O+LgYB2du5CZUY6tdbCuohPXYxgWq0f1Dl4ELL
	 y5++LVZ1R5HqViY1nXI/DpyGYLOJk2+8NE5N5Nzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1359/1815] ALSA: seq: Dont leak the extension cell pointer in the bounce payload
Date: Sat, 12 Sep 2026 08:51:49 +0200
Message-ID: <20260912065720.931459893@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 59e1592d3c270ff4642d5d6dc55c545306eb0693 ]

The bounce_error_event() embeds the failed event in the bounce payload
by pointing data.ext.ptr at it.  When that event is a queued
variable-length event, its own data.ext.ptr holds the address of its
first extension cell, put there by snd_seq_event_dup().  The payload
goes out verbatim through snd_seq_expand_var_event(), so the address
reaches userspace.

That is the same address commit 705dd6dcbc0e ("ALSA: seq: Clear
variable event pointer on read") removed from the event header.  The
read path still clears it there, just above the call that expands the
payload.

Embed a sanitised copy instead, treated exactly as snd_seq_read()
treats the header.  A stack copy is enough because delivery is
synchronous and snd_seq_event_dup() copies before returning.

An unprivileged client reaches this by setting SNDRV_SEQ_FILTER_BOUNCE,
queueing a variable-length event to a port that does not exist and
reading the bounce back.  Eight bytes on 64-bit, from its own pool.

Fixes: efc86691e4d8 ("ALSA: seq: Fix kernel heap address leak in bounce_error_event()")
Assisted-by: Claude:claude-opus-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20260811131835.3837024-1-sammiee5311@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_clientmgr.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/sound/core/seq/seq_clientmgr.c b/sound/core/seq/seq_clientmgr.c
index 28782e1776fa8..9ec6c1c0cabc5 100644
--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -528,7 +528,7 @@ static int bounce_error_event(struct snd_seq_client *client,
 			      struct snd_seq_event *event,
 			      int err, int atomic, int hop)
 {
-	struct snd_seq_event bounce_ev;
+	struct snd_seq_event bounce_ev, quoted;
 	int result;
 
 	if (client == NULL ||
@@ -548,15 +548,19 @@ static int bounce_error_event(struct snd_seq_client *client,
 		 * For user clients, send SNDRV_SEQ_EVENT_BOUNCE with the
 		 * original event embedded as variable-length data.  This
 		 * avoids exposing data.quote.event (a kernel pointer) to
-		 * userspace.  The variable-length path in snd_seq_event_dup()
-		 * copies the event data from data.ext.ptr into chained cells,
-		 * and snd_seq_expand_var_event() copies only the data content
-		 * -- never the pointer -- to userspace.
+		 * userspace.  Sanitise the embedded copy too - a queued
+		 * variable-length event carries the address of its own
+		 * extension cell, and the payload goes out verbatim.
 		 */
+		quoted = *event;
+		if (snd_seq_ev_is_variable(&quoted)) {
+			quoted.data.ext.len &= ~SNDRV_SEQ_EXT_MASK;
+			quoted.data.ext.ptr = NULL;
+		}
 		bounce_ev.type = SNDRV_SEQ_EVENT_BOUNCE;
 		bounce_ev.flags = SNDRV_SEQ_EVENT_LENGTH_VARIABLE;
 		bounce_ev.data.ext.len = sizeof(struct snd_seq_event);
-		bounce_ev.data.ext.ptr = (char *)event;
+		bounce_ev.data.ext.ptr = (char *)&quoted;
 	} else {
 		/*
 		 * For kernel clients, quote the event pointer directly.
-- 
2.53.0



