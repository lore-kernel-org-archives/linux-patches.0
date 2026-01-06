Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C7936C0D4;
	Tue,  6 Jan 2026 17:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722289; cv=none; b=cPA8HC+zvov7fwZFs9Et+I8uIeVP1SxG/0xzt1f2X1ZvVVB6/rcFJ1uB4KTEFCF6Yv9FTyaT/KHRQYI4QDJmjFfWI9q2TQ6gSMRKM2igizSXgUqlfEoVQ5qXwwbEpHvGjszQhqgsZCeBs9vSPM+YWdg6vXZ3FueXCP7AF/ZwB5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722289; c=relaxed/simple;
	bh=h1aj4nzhbQz8xZt5sSTSiSoOPgdq/wk5IPoiVGKjB/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mhEsNt8QF13UI8f9xonzVR6o1qhD2BziN7v1wgBDSxnQcRayM5lEGKnFCxUDSMxikkU1mUGIsYPTmIvilLMxZTuSLFG+GKIUIWE6ODYiEzUqrZcsDQsLJjXY7QvoRydbJkzs+XwseCrI0VGVJxWfSsigpfrA7SDSwUzzjxJI4Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=omGtPVjP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="omGtPVjP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D879DC16AAE;
	Tue,  6 Jan 2026 17:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722289;
	bh=h1aj4nzhbQz8xZt5sSTSiSoOPgdq/wk5IPoiVGKjB/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=omGtPVjPwZuyi8iu81aIPQ/uQjjYaTwphpJxVWqqE/Zyq2TZ9z+Q188VUVHx2fL47
	 2fqQ1cQMF35CUl0SoVEum9qEr5ofULvBOUYIG+XjpfS6B14jyFJDzxm4zawv3oAHWl
	 TqIpVo/ps6lrYAa2930x77aA67zL10+L8oCt72X4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Orth <ju.orth@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 219/312] af_unix: dont post cmsg for SO_INQ unless explicitly asked for
Date: Tue,  6 Jan 2026 18:04:53 +0100
Message-ID: <20260106170555.765641919@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

commit 4d1442979e4a53b9457ce1e373e187e1511ff688 upstream.

A previous commit added SO_INQ support for AF_UNIX (SOCK_STREAM), but it
posts a SCM_INQ cmsg even if just msg->msg_get_inq is set. This is
incorrect, as ->msg_get_inq is just the caller asking for the remainder
to be passed back in msg->msg_inq, it has nothing to do with cmsg. The
original commit states that this is done to make sockets
io_uring-friendly", but it's actually incorrect as io_uring doesn't use
cmsg headers internally at all, and it's actively wrong as this means
that cmsg's are always posted if someone does recvmsg via io_uring.

Fix that up by only posting a cmsg if u->recvmsg_inq is set.

Additionally, mirror how TCP handles inquiry handling in that it should
only be done for a successful return. This makes the logic for the two
identical.

Cc: stable@vger.kernel.org
Fixes: df30285b3670 ("af_unix: Introduce SO_INQ.")
Reported-by: Julian Orth <ju.orth@gmail.com>
Link: https://github.com/axboe/liburing/issues/1509
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/07adc0c2-2c3b-4d08-8af1-1c466a40b6a8@kernel.dk
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/unix/af_unix.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2929,6 +2929,7 @@ static int unix_stream_read_generic(stru
 	unsigned int last_len;
 	struct unix_sock *u;
 	int copied = 0;
+	bool do_cmsg;
 	int err = 0;
 	long timeo;
 	int target;
@@ -2954,6 +2955,9 @@ static int unix_stream_read_generic(stru
 
 	u = unix_sk(sk);
 
+	do_cmsg = READ_ONCE(u->recvmsg_inq);
+	if (do_cmsg)
+		msg->msg_get_inq = 1;
 redo:
 	/* Lock the socket to prevent queue disordering
 	 * while sleeps in memcpy_tomsg
@@ -3113,10 +3117,11 @@ unlock:
 	if (msg) {
 		scm_recv_unix(sock, msg, &scm, flags);
 
-		if (READ_ONCE(u->recvmsg_inq) || msg->msg_get_inq) {
+		if (msg->msg_get_inq && (copied ?: err) >= 0) {
 			msg->msg_inq = READ_ONCE(u->inq_len);
-			put_cmsg(msg, SOL_SOCKET, SCM_INQ,
-				 sizeof(msg->msg_inq), &msg->msg_inq);
+			if (do_cmsg)
+				put_cmsg(msg, SOL_SOCKET, SCM_INQ,
+					 sizeof(msg->msg_inq), &msg->msg_inq);
 		}
 	} else {
 		scm_destroy(&scm);


