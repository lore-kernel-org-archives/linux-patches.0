Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E047361DDC;
	Sat, 12 Sep 2026 13:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218784; cv=none; b=Byxb3nMgaeMExR4tHZvN916OHePHlPy+m5E7uFPoPd1v/uDDftr5+NGWZhMt+j7kLNo6RkgqVh1vtg7jJQTjrKKuvh8Yc+/vzrJx7h8o6FIUZrl9juWQz2gFC4fsrseM7yj8Mjpd9ADoIFwo54bNLfRHEKcTf79eFB9OSovnbUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218784; c=relaxed/simple;
	bh=P4fmULpz4nwlJTFM/9iNplvLepB5jXD8VrlblhjqIqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RH9A71tO2ifVYh0R1DR2IdjadxepaWJJPql48WGTYjS4ZCbL05HxSgl/HYvnmlmj42YMgcLj5Sgbg7eK71Tdy8jRmWzmfdriG9g0MAq9UaIdfghpMXWQWQIpo47q/ipEuJ3LvuqJ2OIiX1lqMoYxspnWAUcZxA3R1e8msqHhJr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bWFaSsUJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bWFaSsUJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC911F00893;
	Sat, 12 Sep 2026 13:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218782;
	bh=toFcE1ru+Pshv4tKQKuWOx0ZlyLToEtxYaWI/vB14GM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bWFaSsUJ0UxXVf80k+Q006uxR4oCMoTG4jQiz1NUrGb+LmehMWii+o8MqbZOhW+Vb
	 K7hPpGS4q6j2QCIZcgbw45njrQhWGQf4F5hL26rPgGLUV0dUSOjp9VmOKBPsquZ/1h
	 vzd69yTb+MyZOvt8sWMSamcwsHB3Cjrkfhorm4Xs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurence Rowe <laurencerowe@gmail.com>,
	Bobby Eshleman <bobbyeshleman@meta.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1217/1376] vsock: avoid timeout for non-blocking accept() with empty backlog
Date: Sat, 12 Sep 2026 09:00:43 +0200
Message-ID: <20260912065634.675174026@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurence Rowe <laurencerowe@gmail.com>

[ Upstream commit 98f28d8d6e5a5ed058dd37854c19e9b3bae72eff ]

A common pattern in epoll network servers is to eagerly accept all
pending connections from the non-blocking listening socket after
epoll_wait indicates the socket is ready by calling accept in a loop
until EAGAIN is returned indicating that the backlog is empty.

Scheduling a timeout for a non-blocking accept with an empty backlog
meant AF_VSOCK sockets used by epoll network servers incurred hundreds
of microseconds of additional latency per accept loop compared to
AF_INET or AF_UNIX sockets.

Signed-off-by: Laurence Rowe <laurencerowe@gmail.com>
Reviewed-by: Bobby Eshleman <bobbyeshleman@meta.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://patch.msgid.link/20260402204918.130395-1-laurencerowe@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: b8c899cf5e7b ("vsock: don't check the listener's sk_err in vsock_accept()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/af_vsock.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index f03e00cae028a..f406b6ce70c15 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1715,10 +1715,10 @@ static int vsock_accept(struct socket *sock, struct socket *newsock,
 	 * created upon connection establishment.
 	 */
 	timeout = sock_rcvtimeo(listener, arg->flags & O_NONBLOCK);
-	prepare_to_wait(sk_sleep(listener), &wait, TASK_INTERRUPTIBLE);
 
 	while ((connected = vsock_dequeue_accept(listener)) == NULL &&
-	       listener->sk_err == 0) {
+	       listener->sk_err == 0 && timeout != 0) {
+		prepare_to_wait(sk_sleep(listener), &wait, TASK_INTERRUPTIBLE);
 		release_sock(listener);
 		timeout = schedule_timeout(timeout);
 		finish_wait(sk_sleep(listener), &wait);
@@ -1727,17 +1727,14 @@ static int vsock_accept(struct socket *sock, struct socket *newsock,
 		if (signal_pending(current)) {
 			err = sock_intr_errno(timeout);
 			goto out;
-		} else if (timeout == 0) {
-			err = -EAGAIN;
-			goto out;
 		}
-
-		prepare_to_wait(sk_sleep(listener), &wait, TASK_INTERRUPTIBLE);
 	}
-	finish_wait(sk_sleep(listener), &wait);
 
-	if (listener->sk_err)
+	if (listener->sk_err) {
 		err = -listener->sk_err;
+	} else if (!connected) {
+		err = -EAGAIN;
+	}
 
 	if (connected) {
 		sk_acceptq_removed(listener);
-- 
2.53.0



