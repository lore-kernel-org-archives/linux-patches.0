Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1631BD9C6;
	Wed, 19 Feb 2025 09:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957507; cv=none; b=My+50L3dKfRePw264AhDbdW/fur6zXJMhQoPNMuETYLzhVoF5rYyi9oIGqUz5+KDa0DmH3O/sLTiWb4QLVf5Imf/i+Pc9t9GVBt4Rh+TW1lRXNdqGBuNfyYb4lLmuATdwoFlhKSZ1xafwegebg+J0I3h57moN6+xrfWXgD5DR0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957507; c=relaxed/simple;
	bh=UK1GRPdlk9RcRScnNgv2Bo75wDQHuR7ZaBqZ0fgLFT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XVGttl3VXA1+g7BRYcQxSi4grTmQX1gDpoPhJCXoNjhAmlh5IlBtGEzN7+uHivWSmAnH7QwrKDneOnZc0iZ3p8EtC/nWR1RJqaIBTinUcdxBhvpQaGhzUHDXILHdFyzulq/boZbzlFHbARsmFrT5KKPl75v8kqz05lxaaTUUawY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U0p8JCa1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U0p8JCa1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE19C4CED1;
	Wed, 19 Feb 2025 09:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957505;
	bh=UK1GRPdlk9RcRScnNgv2Bo75wDQHuR7ZaBqZ0fgLFT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U0p8JCa1VTy11aKD5y/it7gVVKmDumUG3JM2JlJdDnwkGSvrOwH1xGL7beM4GmsIF
	 AhZsU4JTmZq3cjOCHMxF2K0+IwDZBcH7yquyuThEWD9HJbhU2ESgdpHnbspdjMDzBS
	 IqeamWFwmxniiLzJdxW7xUmiqcUwVuk3hWudxCAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alexander=20H=C3=B6lzl?= <alexander.hoelzl@gmx.net>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.1 522/578] can: j1939: j1939_sk_send_loop(): fix unable to send messages with data length zero
Date: Wed, 19 Feb 2025 09:28:46 +0100
Message-ID: <20250219082713.509594159@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1132,7 +1132,7 @@ static int j1939_sk_send_loop(struct j19
 
 	todo_size = size;
 
-	while (todo_size) {
+	do {
 		struct j1939_sk_buff_cb *skcb;
 
 		segment_size = min_t(size_t, J1939_MAX_TP_PACKET_SIZE,
@@ -1177,7 +1177,7 @@ static int j1939_sk_send_loop(struct j19
 
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


