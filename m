Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A30457E7A;
	Sat, 12 Sep 2026 11:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211703; cv=none; b=jYmlIHWZ2GJ89JGsO5llCKMtztv8uxrxN2ugxy7fgWvt4iiw2IL8E/cMRjeJPBNr9r+/gtfMsVFQ/I9C55hiDrSul79tyTa2km//8coCDPBNsn7bMFVy3pMI65DsnxAjqeDVDkVQdkhiV+lox83tvss9K1GkArxc0r6EZ2GEp0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211703; c=relaxed/simple;
	bh=x8wbwXLl/B2gcS27xZW6E3yvEB+mH5DDwjY3Z8lUA1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bww6EEAf25MCMu+WQp5sT8iGsMVNJ9kcvuLTZDfxUjZWaOfqXnE5ZoC6nPFWPju+ozuw8iR1Zmfr7cgGsppM3xHC/rSi7z5hsK14RF88wsYkwmLnlJsteiysrFA9g47PogQVcZ5mTuNljDFu3WfnzT1zh88J1Q6BERIbVq8RIag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n42mAw7a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n42mAw7a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E33A1F000FF;
	Sat, 12 Sep 2026 11:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211701;
	bh=pPRf4W8LVNxy6Oa+/J2gzLN/Aq9jG2GGcacvEGpGCeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n42mAw7aBn30c+NUR+4juVuZXfMEb/1vQEFh9JRkjiNwqWKU2kYcHtJIaMAi69fL5
	 GFDsQyuUobj9gHcgPqGOTv+Ai39RSbGU53WSsHu+4qfnr+eeGPq38qAvtq04DPcXLa
	 iOGlCkPfof306t3eX6Dthr9oLJUxG27AXkbEH4pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurence Rowe <laurencerowe@gmail.com>,
	Bobby Eshleman <bobbyeshleman@meta.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1283/1518] vsock: avoid timeout for non-blocking accept() with empty backlog
Date: Sat, 12 Sep 2026 08:57:32 +0200
Message-ID: <20260912065652.538385177@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index d007ce89d19b8..e6a8ac81662d0 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1760,10 +1760,10 @@ static int vsock_accept(struct socket *sock, struct socket *newsock,
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
@@ -1772,17 +1772,14 @@ static int vsock_accept(struct socket *sock, struct socket *newsock,
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



