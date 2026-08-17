Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3B843F4C3;
	Mon, 17 Aug 2026 13:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974993; cv=none; b=dLz530q3auTsY7yqxxiKS3mWIUgb0B2fgWc0lvFDiGm7PsKvE07EC19zLxfaR+qJWUWugQqH1bBV/rm/TAVqdBcQeHNtNuU/Gofqi4GQe2bFNFTpWsWkhh4Qxnya7YrTmjIQIQU/4MKdh+Ak5OsVmsou6u5x0MctUseYwI+2uXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974993; c=relaxed/simple;
	bh=cJNBAJqWVxsK14kceL/F9zVvQuBGEWuGm5PFBPOKJPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQomZx7yMfFyT3k0vmGBX2/yd0KRc1+JYI6+NarSvTrabTqk44udRHqmtGFKE0pWCyxeBV7a8aq0T3V2Wod1gjKuEJw7L0VkI0G4wEsodvJP5rcWhozwZE9tvDRJshSBrDQ9gM/h98khWaZT0xvbqUQFmgQ42iVJLXHr2+ryJpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HYP8LIVP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HYP8LIVP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 681831F00A3A;
	Mon, 17 Aug 2026 13:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974990;
	bh=R/xBEqrToHsZNAZDZvwCs0nUKzsUq7rDFnFKFWK8gMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HYP8LIVPYpWxmpl7K6lP0l0/kBLd1Kw1eVG+PQEV0FD5KkVPSyibDxZisZoY8qSfc
	 S0X2JhemqVz0gZsg+RU6ehmZ1DRAdf4X5+NCTYVlHtH+SULLWvk7/TbiEuXMjKYi+S
	 OhzpMuZagdglgt31yZ17+cErGQUxtdXhW15O7row=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 125/250] Input: evdev - fix information leak in evdev_pass_values()
Date: Mon, 17 Aug 2026 15:31:26 +0200
Message-ID: <20260817132541.702704100@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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


