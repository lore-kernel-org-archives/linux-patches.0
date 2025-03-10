Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1538517A2E8;
	Mon, 10 Mar 2025 18:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629680; cv=none; b=MF1PLoSlh4vcP99tKFyi4EVOSxWuMnPipqEMfjQKkNa3XAgn7lfH2OMlwmY7zgGJf6e+EREyu8OJOYzsAA+a3stDJ+eXHAuenYURqKPaVVtrO19flksqLcAOwR4XdT1NN8QXTiXJWTVZu1O+O6wIJbI4aEMjH9lSkBDY3zruQC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629680; c=relaxed/simple;
	bh=jgZuwKW9D53vgsef2jpXgT3jeHB0v5mJpIWmbPYnFbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jt82+QmPe9bDIYQ1M5Q2egwpgQz1R/+z9/cLS1sK0cYrsRRS+fWvZqEq4OeQHzs1el+a1fRH9nIl7bZKF+MlJp89QTzo6hx3oqL3yCNtvsfxwrwMYWka8mDmRCxptB+HlKo3Iaep+nH0pR81uXcxppAgz3zQoRxMQiOIbqSwu/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=byMW8Xpp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="byMW8Xpp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C48C4CEE5;
	Mon, 10 Mar 2025 18:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629678;
	bh=jgZuwKW9D53vgsef2jpXgT3jeHB0v5mJpIWmbPYnFbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=byMW8Xppmkmji19h7g3vcvd3S8VSfJLoWKvdBCfdVL6Rqr+wds5nXkh4PHOpMgTXn
	 h4P4UnPQwbpxpCbRwen6MmgX8UBHZZiO3Q77+f2DfiuQNKpxqJKipKY00g512FhoD8
	 8tncYqIP1OB3chTEgyarcU4aP2FMeJF6ynlt9kTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alexander=20H=C3=B6lzl?= <alexander.hoelzl@gmx.net>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.15 377/620] can: j1939: j1939_sk_send_loop(): fix unable to send messages with data length zero
Date: Mon, 10 Mar 2025 18:03:43 +0100
Message-ID: <20250310170600.478060274@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Hölzl <alexander.hoelzl@gmx.net>

commit 44de577e61ed239db09f0da9d436866bef9b77dd upstream.

The J1939 standard requires the transmission of messages of length 0.

For example proprietary messages are specified with a data length of 0
to 1785. The transmission of such messages is not possible. Sending
results in no error being returned but no corresponding can frame
being generated.

Enable the transmission of zero length J1939 messages. In order to
facilitate this two changes are necessary:

1) If the transmission of a new message is requested from user space
the message is segmented in j1939_sk_send_loop(). Let the segmentation
take into account zero length messages, do not terminate immediately,
queue the corresponding skb.

2) j1939_session_skb_get_by_offset() selects the next skb to transmit
for a session. Take into account that there might be zero length skbs
in the queue.

Signed-off-by: Alexander Hölzl <alexander.hoelzl@gmx.net>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/20250205174651.103238-1-alexander.hoelzl@gmx.net
Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Cc: stable@vger.kernel.org
[mkl: commit message rephrased]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/j1939/socket.c    |    4 ++--
 net/can/j1939/transport.c |    5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)

--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -1130,7 +1130,7 @@ static int j1939_sk_send_loop(struct j19
 
 	todo_size = size;
 
-	while (todo_size) {
+	do {
 		struct j1939_sk_buff_cb *skcb;
 
 		segment_size = min_t(size_t, J1939_MAX_TP_PACKET_SIZE,
@@ -1175,7 +1175,7 @@ static int j1939_sk_send_loop(struct j19
 
 		todo_size -= segment_size;
 		session->total_queued_size += segment_size;
-	}
+	} while (todo_size);
 
 	switch (ret) {
 	case 0: /* OK */
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -382,8 +382,9 @@ sk_buff *j1939_session_skb_get_by_offset
 	skb_queue_walk(&session->skb_queue, do_skb) {
 		do_skcb = j1939_skb_to_cb(do_skb);
 
-		if (offset_start >= do_skcb->offset &&
-		    offset_start < (do_skcb->offset + do_skb->len)) {
+		if ((offset_start >= do_skcb->offset &&
+		     offset_start < (do_skcb->offset + do_skb->len)) ||
+		     (offset_start == 0 && do_skcb->offset == 0 && do_skb->len == 0)) {
 			skb = do_skb;
 		}
 	}


