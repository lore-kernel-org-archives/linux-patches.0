Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D291E633C;
	Thu, 25 Jun 2026 13:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782392837; cv=none; b=qk+BtN1dO1kX8C7xPFqV6Ckz3WS1shPujSxcEvyveX/AgT0Y4kFPJm7PEAYnHSfsaTAOiHL8zu9BbO0GlKSBk3TUtGEQFIVQjXr+bA2BuWxaCJHzaOODGV54W6Sn45nYgueH57F5v62s3KICuLFiN7EPmUICvfpT7lxIqRzgFjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782392837; c=relaxed/simple;
	bh=vZ7J8JFv7l0isIyDRTPA64pHmmipIK7lJdpePB4Y8F8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DiQFPjqWnriQWO6r5N7U8sNiV4RPChx6mw/EKzRUOqKE4TKxzHkoQlpmlmSL6c8UMZe5jIhEWX7Dk3FpFxIgVShpfHkNwezsO7fIFVl0xXM02UtFoYFDYOPFZC4VfE2sA5moCYxxxlboiD7iU0hkuwyE6+gXNswC0NqLKwSoFec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T6yb9rfW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T6yb9rfW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA311F000E9;
	Thu, 25 Jun 2026 13:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782392835;
	bh=kMLUHQKCS41ug4zbI9wUjjcvJHC3AXo/3K1mc2ctTho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T6yb9rfWGi+FpwIRw64nY1cwtESWed1iyH2xiRnlitYk45NZO08YbtjXoqh6OKip4
	 7wvDL2Xv4fkAQEJ3/drJuR4FQ9wMhaoQBU57y/9a+Ob497yBVAG/Tr+RvVCOwdL12J
	 F8K1nwLHQukvtWmnCTJqKasVPZ1pb7TlS1YX+cE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>
Subject: [PATCH 6.18 24/60] rose: release netdev ref and destroy orphaned incoming sockets
Date: Thu, 25 Jun 2026 14:03:09 +0100
Message-ID: <20260625125649.103756507@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125645.554579168@linuxfoundation.org>
References: <20260625125645.554579168@linuxfoundation.org>
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

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

commit df12be096302d2c947388acc25764456c7f18cc1 upstream.

Two related cleanup gaps left the module unremovable after a loopback
session:

1. rose_destroy_socket() did not release the device reference.  When
   an unaccepted incoming socket (created by rose_rx_call_request()) is
   destroyed via rose_heartbeat_expiry(), it is removed from rose_list
   before rose_kill_by_device() can find it, so the netdev_hold() taken
   in rose_rx_call_request() was never matched by netdev_put().  Add the
   release at the top of rose_destroy_socket() guarded by a NULL check
   so that rose_release() and rose_kill_by_device(), which already call
   netdev_put() and set device = NULL, are not affected.

2. rose_heartbeat_expiry() STATE_0 cleanup required TCP_LISTEN in
   addition to SOCK_DEAD.  Unaccepted incoming sockets are
   TCP_ESTABLISHED, so the condition was never true and those sockets
   lingered forever, holding the module use count above zero and
   blocking rmmod.  Drop the TCP_LISTEN restriction: any STATE_0 +
   SOCK_DEAD socket is orphaned and should be destroyed.

Together with the earlier rose_make_new() double-hold fix these three
patches allow clean rmmod after loopback sessions.

Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rose/af_rose.c    |    9 +++++++++
 net/rose/rose_timer.c |    9 +++++----
 2 files changed, 14 insertions(+), 4 deletions(-)

--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -363,6 +363,7 @@ static void rose_destroy_timer(struct ti
  */
 void rose_destroy_socket(struct sock *sk)
 {
+	struct rose_sock *rose = rose_sk(sk);
 	struct sk_buff *skb;
 
 	rose_remove_socket(sk);
@@ -370,6 +371,14 @@ void rose_destroy_socket(struct sock *sk
 	rose_stop_idletimer(sk);
 	rose_stop_timer(sk);
 
+	/* Drop any device reference not already released by rose_kill_by_device()
+	 * or rose_release() -- e.g. incoming sockets that were never accepted.
+	 */
+	if (rose->device) {
+		netdev_put(rose->device, &rose->dev_tracker);
+		rose->device = NULL;
+	}
+
 	rose_clear_queues(sk);		/* Flush the queues */
 
 	while ((skb = skb_dequeue(&sk->sk_receive_queue)) != NULL) {
--- a/net/rose/rose_timer.c
+++ b/net/rose/rose_timer.c
@@ -128,10 +128,11 @@ static void rose_heartbeat_expiry(struct
 	}
 	switch (rose->state) {
 	case ROSE_STATE_0:
-		/* Magic here: If we listen() and a new link dies before it
-		   is accepted() it isn't 'dead' so doesn't get removed. */
-		if (sock_flag(sk, SOCK_DESTROY) ||
-		    (sk->sk_state == TCP_LISTEN && sock_flag(sk, SOCK_DEAD))) {
+		/* Destroy any orphaned STATE_0 socket: either explicitly
+		 * flagged SOCK_DESTROY, or SOCK_DEAD (covers both unaccepted
+		 * incoming connections and listening sockets whose link died).
+		 */
+		if (sock_flag(sk, SOCK_DESTROY) || sock_flag(sk, SOCK_DEAD)) {
 			bh_unlock_sock(sk);
 			rose_destroy_socket(sk);
 			sock_put(sk);


