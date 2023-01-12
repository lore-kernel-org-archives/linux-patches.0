Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A7E79C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:39:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4753EC433EF;
	Thu, 12 Jan 2023 14:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673534364;
	bh=rFpDlR7+raVaZdvZ2lT7oO++36G3jmYYTjBaMsSI9oU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D8WPiO7RDF/0TC0bqc1i3b2J5NS6mk8ZT4vkZa+eHm0vb1LYEDLsuNfdoInk1FhG4
	 8dNflqbqumi+VgA3BdZCJ038ykVYUPdrUZzwef17l8xlWX5PqDaz+C7+82nDf5Hl+Q
	 JCl+ZKojS6mCcGaSUAsPEQRNKUNsW3UP3PZ7uikc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	slipper <slipper.alive@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 783/783] net/ulp: prevent ULP without clone op from entering the LISTEN status
Date: Thu, 12 Jan 2023 14:58:19 +0100
Message-Id: <20230112135600.700893341@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paolo Abeni <pabeni@redhat.com>

commit 2c02d41d71f90a5168391b6a5f2954112ba2307c upstream.

When an ULP-enabled socket enters the LISTEN status, the listener ULP data
pointer is copied inside the child/accepted sockets by sk_clone_lock().

The relevant ULP can take care of de-duplicating the context pointer via
the clone() operation, but only MPTCP and SMC implement such op.

Other ULPs may end-up with a double-free at socket disposal time.

We can't simply clear the ULP data at clone time, as TLS replaces the
socket ops with custom ones assuming a valid TLS ULP context is
available.

Instead completely prevent clone-less ULP sockets from entering the
LISTEN status.

Fixes: 734942cc4ea6 ("tcp: ULP infrastructure")
Reported-by: slipper <slipper.alive@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Link: https://lore.kernel.org/r/4b80c3d1dbe3d0ab072f80450c202d9bc88b4b03.1672740602.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/inet_connection_sock.c |   16 +++++++++++++++-
 net/ipv4/tcp_ulp.c              |    4 ++++
 2 files changed, 19 insertions(+), 1 deletion(-)

--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -916,11 +916,25 @@ void inet_csk_prepare_forced_close(struc
 }
 EXPORT_SYMBOL(inet_csk_prepare_forced_close);
 
+static int inet_ulp_can_listen(const struct sock *sk)
+{
+	const struct inet_connection_sock *icsk = inet_csk(sk);
+
+	if (icsk->icsk_ulp_ops && !icsk->icsk_ulp_ops->clone)
+		return -EINVAL;
+
+	return 0;
+}
+
 int inet_csk_listen_start(struct sock *sk, int backlog)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct inet_sock *inet = inet_sk(sk);
-	int err = -EADDRINUSE;
+	int err;
+
+	err = inet_ulp_can_listen(sk);
+	if (unlikely(err))
+		return err;
 
 	reqsk_queue_alloc(&icsk->icsk_accept_queue);
 
--- a/net/ipv4/tcp_ulp.c
+++ b/net/ipv4/tcp_ulp.c
@@ -136,6 +136,10 @@ static int __tcp_set_ulp(struct sock *sk
 	if (icsk->icsk_ulp_ops)
 		goto out_err;
 
+	err = -EINVAL;
+	if (!ulp_ops->clone && sk->sk_state == TCP_LISTEN)
+		goto out_err;
+
 	err = ulp_ops->init(sk);
 	if (err)
 		goto out_err;


