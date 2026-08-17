Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F81321CC5C;
	Mon, 17 Aug 2026 14:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978546; cv=none; b=VQCmxoxVAcFD70EQY2VQmcyA0ErXj+Xu88uz64xy4PyfuVsaPs+qtFC4MVuaEkMROxUOJWtb6H4cjiRPL1G66iAsIMtLj649sTNcpHnjjrcmMTJz/1j/rZVP6QuK5aYCoWOFLp4AyEqanGgYcllgfQoHQvsRTV29S8RNwTA+LWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978546; c=relaxed/simple;
	bh=JSVeTcDq9b+EMenNMk1ay/kMwA5yvlEDbPyX1oChYpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KrVlQpVhzkgZOgjrmN1ZnA7NjkxVtW6ZuMUVKP3SuCPYXGwD+TNIG75JnL2JBcdVoLyySzYoX9E3kZBasO0mrxP5MTr+jgnE1Cz90R+8/drNfFRcyq0Evs2Di8uVrh1UE+P9tr4AdaAZrUeD/GPFtTNIZ06xJfgKek4/4J3rajE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uEf2TAZT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uEf2TAZT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E531F000E9;
	Mon, 17 Aug 2026 14:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978545;
	bh=lsuNE39cC85WVIRLNIqoLXUWPZNc7Nrukr0NPppqR5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uEf2TAZTIE3y7d2dH1aH3EbB5CfbKEX7MUt/iypFJgucPb4dWDz6zDUaNxJj4n4Bx
	 TmXiQgb7sECIS2Su1hs64gbVFWUsQRHHl11anZ2GFZaLg2DDZ9NC9YWH19kKr1PH+m
	 rRmhrrdE7nxeGcujJGxgHdb0iTcXQpNijqm/6+UQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 073/156] Input: evdev - fix information leak in evdev_pass_values()
Date: Mon, 17 Aug 2026 15:33:27 +0200
Message-ID: <20260817132537.449078494@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 90f305f2c7a30257c683e13f4bf7c798eea992a0 upstream.

In evdev_pass_values(), the input_event structure is allocated on the
kernel stack and populated field-by-field. However, it is never fully
initialized. On architectures where struct input_event contains explicit
or implicit padding (such as the 32-bit __pad field on SPARC64), these
padding bytes are left uninitialized.

When this event structure is subsequently passed to the client buffer
and later copied to userspace, the uninitialized padding bytes leak
kernel stack memory, potentially exposing sensitive information.

Similar issues exist in __evdev_queue_syn_dropped and __pass_event.

Fix this by explicitly zeroing the entire event structure with memset()
before populating its fields. This ensures all padding bytes are cleared
before the data crosses the security boundary.

Reported-by: sashiko-bot@kernel.org
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/ampGGKo4UMKru6f5@google.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/evdev.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -149,11 +149,11 @@ static void __evdev_queue_syn_dropped(st
 	struct timespec64 ts = ktime_to_timespec64(ev_time[client->clk_type]);
 	struct input_event ev;
 
+	memset(&ev, 0, sizeof(ev));
 	ev.input_event_sec = ts.tv_sec;
 	ev.input_event_usec = ts.tv_nsec / NSEC_PER_USEC;
 	ev.type = EV_SYN;
 	ev.code = SYN_DROPPED;
-	ev.value = 0;
 
 	client->buffer[client->head++] = ev;
 	client->head &= client->bufsize - 1;
@@ -221,20 +221,20 @@ static void __pass_event(struct evdev_cl
 	client->head &= client->bufsize - 1;
 
 	if (unlikely(client->head == client->tail)) {
+		struct input_event ev;
+
+		memset(&ev, 0, sizeof(ev));
+		ev.input_event_sec = event->input_event_sec;
+		ev.input_event_usec = event->input_event_usec;
+		ev.type = EV_SYN;
+		ev.code = SYN_DROPPED;
+
 		/*
 		 * This effectively "drops" all unconsumed events, leaving
 		 * EV_SYN/SYN_DROPPED plus the newest event in the queue.
 		 */
 		client->tail = (client->head - 2) & (client->bufsize - 1);
-
-		client->buffer[client->tail] = (struct input_event) {
-			.input_event_sec = event->input_event_sec,
-			.input_event_usec = event->input_event_usec,
-			.type = EV_SYN,
-			.code = SYN_DROPPED,
-			.value = 0,
-		};
-
+		client->buffer[client->tail] = ev;
 		client->packet_head = client->tail;
 	}
 
@@ -256,6 +256,8 @@ static void evdev_pass_values(struct evd
 	if (client->revoked)
 		return;
 
+	memset(&event, 0, sizeof(event));
+
 	ts = ktime_to_timespec64(ev_time[client->clk_type]);
 	event.input_event_sec = ts.tv_sec;
 	event.input_event_usec = ts.tv_nsec / NSEC_PER_USEC;


