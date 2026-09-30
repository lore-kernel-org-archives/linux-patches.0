Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED6293D333C;
	Wed, 30 Sep 2026 18:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794019; cv=none; b=Yo+vRd5L+Qbn85oXYyobL2moQEGvv1WwdATjS7ok8Fd/DaEiQCir4KE/vZyD7fRiHWNQSt3D6gaTeWM+fii4Vuh9yyYdUXww8rXj2JoBjN0nVHBd9Ei0SQUI4b+M2ZvtWYku4MvJhbS9Z+R9OEJVwvG/uhsyu/0EBsXyWKUr/W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794019; c=relaxed/simple;
	bh=lkRAmfAD6f3GOtEdkS4p6mi7JdWPju0ZDGPfJFMpHxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LhCoSmwKqhR1c8Cj6YiibA06asRUxh8ItF3YX37FDhyKiwxUgxYPqEBJ2aW78Y5EQiUU9Hxx4lBog9yqMii5Zk6kpxWeciXtERTRo9ho3DnPZDN+pqR87v4JRDMcbhhMXMPPbHsLjMZIJ+hmp3XHD8DvO4GJnh49biHo9JYANFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h85G/CbU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h85G/CbU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A9D91F000FF;
	Wed, 30 Sep 2026 18:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794017;
	bh=F9Edz8PLoVul+PmFU5RLLehocqOMIUlKJMBxBA2Ezgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h85G/CbU99FQVUxeLZz2WdoIhpRfR+PaigAEhNGcYPiUKSAKn3GE+77kyi7jDxpr0
	 +batfEHrZMNkTFv5j4bMyKiPZBFnQe4SmsgTOXO9Wv/JQ1hDCPiypYFH/Uc2Oy1EB+
	 JTsYdVTTP2KNu9f0KksV8wXgj0vK5B3p8WJDljDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0064/1193] ALSA: usx2y: Drain pending US-428 pipe-4 output commands
Date: Wed, 30 Sep 2026 17:12:28 +0200
Message-ID: <20260930152435.695080593@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit 18977c0dd722f52217027ff75de2811c53cce2cc ]

The US-428 pipe-4 output path submits at most one pending p4out
entry from the shared-memory ring per input interrupt. If userspace
queues more than one command before the interrupt handler runs, later
commands remain pending until later input interrupts, even when async
pipe-4 URBs are available.

Drain pending entries while idle async URBs are available. Copy each
command into the existing per-URB async buffer before submission, so the
submitted transfer does not depend on a userspace-mapped ring slot
remaining unchanged after p4out_sent is advanced.

Also update p4out_sent only after usb_submit_urb() succeeds, so a
failed submission is not reported as sent.

This keeps the shared-memory ABI unchanged and fixes only the local
queue-draining behavior.

Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260519-alsa-usx2y-p4out-drain-v1-1-8f0a4550bae2@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/usx2y/usbusx2y.c | 39 ++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/sound/usb/usx2y/usbusx2y.c b/sound/usb/usx2y/usbusx2y.c
index 0fe989a633769..e4385b18edfbe 100644
--- a/sound/usb/usx2y/usbusx2y.c
+++ b/sound/usb/usx2y/usbusx2y.c
@@ -180,7 +180,7 @@ static void i_usx2y_in04_int(struct urb *urb)
 	struct usx2ydev		*usx2y = urb->context;
 	struct us428ctls_sharedmem	*us428ctls = usx2y->us428ctls_sharedmem;
 	struct us428_p4out *p4out;
-	int i, j, n, diff, send;
+	int i, j, n, diff, send, len;
 
 	usx2y->in04_int_calls++;
 
@@ -223,24 +223,31 @@ static void i_usx2y_in04_int(struct urb *urb)
 			} while (!err && usx2y->us04->submitted < usx2y->us04->len);
 		}
 	} else {
-		if (us428ctls && us428ctls->p4out_last >= 0 && us428ctls->p4out_last < N_US428_P4OUT_BUFS) {
-			if (us428ctls->p4out_last != us428ctls->p4out_sent) {
-				send = us428ctls->p4out_sent + 1;
-				if (send >= N_US428_P4OUT_BUFS)
-					send = 0;
-				for (j = 0; j < URBS_ASYNC_SEQ && !err; ++j) {
-					if (!usx2y->as04.urb[j]->status) {
-						p4out = us428ctls->p4out + send;	// FIXME if more than 1 p4out is new, 1 gets lost.
-						usb_fill_bulk_urb(usx2y->as04.urb[j], usx2y->dev,
-								  usb_sndbulkpipe(usx2y->dev, 0x04), &p4out->val.vol,
-								  p4out->type == ELT_LIGHT ? sizeof(struct us428_lights) : 5,
-								  i_usx2y_out04_int, usx2y);
-						err = usb_submit_urb(usx2y->as04.urb[j], GFP_ATOMIC);
+		while (us428ctls &&
+		       us428ctls->p4out_last >= 0 &&
+		       us428ctls->p4out_last < N_US428_P4OUT_BUFS &&
+		       us428ctls->p4out_last != us428ctls->p4out_sent) {
+			for (j = 0; j < URBS_ASYNC_SEQ && !err; ++j) {
+				if (!usx2y->as04.urb[j]->status) {
+					send = us428ctls->p4out_sent + 1;
+					if (send >= N_US428_P4OUT_BUFS)
+						send = 0;
+
+					p4out = us428ctls->p4out + send;
+					len = p4out->type == ELT_LIGHT ?
+						sizeof(struct us428_lights) : 5;
+					memcpy(usx2y->as04.urb[j]->transfer_buffer,
+					       &p4out->val.vol, len);
+					usx2y->as04.urb[j]->transfer_buffer_length = len;
+					err = usb_submit_urb(usx2y->as04.urb[j], GFP_ATOMIC);
+					if (!err)
 						us428ctls->p4out_sent = send;
-						break;
-					}
+
+					break;
 				}
 			}
+			if (j >= URBS_ASYNC_SEQ || err)
+				break;
 		}
 	}
 
-- 
2.53.0



