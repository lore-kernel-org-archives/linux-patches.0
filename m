Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1082825C715;
	Tue, 11 Mar 2025 15:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705901; cv=none; b=BDQPwGv9OXm8LLvlDIj6tSD8ngcUQ8wIwt1UU1sCTXRnn+VNFAeKjeGrDX+L75T5PnjqJ60PiLO8bETuHGzBsxsk4AJND4yoDXu0smrNc8ed2asLn+9fVaVmhSwW8EI5M/8hom1KB0DbCziqYLDl2fCvgVYCQxawAFr7QZnlHy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705901; c=relaxed/simple;
	bh=UknQmDxGXovqXruIIq/yLrR0tweB0Ig8+877FuDr/UI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dvSJ0T/2wQ0MzkqKcu6IBwVJmQ4GFMarr9m6txEsEvOI6RQ54DOs50bGj0zb3ewhRA9LZg6pEmuxPFRO7OJY6yUjPiTq0iHK8xLFjHDLtqYyPrWMlwZoVzGHMbflNPeSqWWGdILXfacxMUAcaFDI+k8P7swUfBEp2z+/Kx6Nuzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RtqaR7d9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RtqaR7d9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91316C4CEE9;
	Tue, 11 Mar 2025 15:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705900;
	bh=UknQmDxGXovqXruIIq/yLrR0tweB0Ig8+877FuDr/UI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RtqaR7d96ndXfVDExO2C7Ahp1nnSLILnVlXBJt11Zdvfodvo6bM0t9PJRubZDEmVa
	 hOJTi1PKpPpBUmGgU60Vro17oHsjZ2RvPuc/27+NdG/2S80OE6VZQKn03OooHopaGk
	 fOPJID+t/7zb1fZSg3QPe8KZTZ4B97JEl13IREio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alexander=20H=C3=B6lzl?= <alexander.hoelzl@gmx.net>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.4 194/328] can: j1939: j1939_sk_send_loop(): fix unable to send messages with data length zero
Date: Tue, 11 Mar 2025 15:59:24 +0100
Message-ID: <20250311145722.612411353@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1055,7 +1055,7 @@ static int j1939_sk_send_loop(struct j19
 
 	todo_size = size;
 
-	while (todo_size) {
+	do {
 		struct j1939_sk_buff_cb *skcb;
 
 		segment_size = min_t(size_t, J1939_MAX_TP_PACKET_SIZE,
@@ -1100,7 +1100,7 @@ static int j1939_sk_send_loop(struct j19
 
 		todo_size -= segment_size;
 		session->total_queued_size += segment_size;
-	}
+	} while (todo_size);
 
 	switch (ret) {
 	case 0: /* OK */
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -378,8 +378,9 @@ sk_buff *j1939_session_skb_get_by_offset
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


