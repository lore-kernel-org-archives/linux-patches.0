Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9466A1E7C2D;
	Wed, 17 Sep 2025 12:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112716; cv=none; b=dDTs7VfnuoLBR6JuvT8EPycFx7Gr2HwBqySrwls6ZRr2n/tSym+0WGiepG5mbzrsadYxkccll8b5rzJi3gQy63rZ0Gg41skBRAvNpvJezqqFDK0R2S+UjmXFXhXsrtL4yzqA6weL4ZHqScAyRUidMkcQeNQbR5XjMzorbImzRb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112716; c=relaxed/simple;
	bh=UfSNHuC2ZQkWlnQeQ6PUfkQpOrFJcWpz3n1Rz3dD06A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tzv9L6/AiT5k7+USQv8ZIAX9EUHR7iyi5Cr8t853hG+e/olP74Eoj0j1EKDMJ8fIaT5+ShLByP4QEGwe4XvYT4Jrwlc7SsAS0yNocmyB+sqpDZQEgOtLTvdB4K3QvYl08FaiGiy9e5fSXDPAesATS/xfZUtZHrJFSvJ+37KUUVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IU+6CWt5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IU+6CWt5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE35DC4CEF0;
	Wed, 17 Sep 2025 12:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112716;
	bh=UfSNHuC2ZQkWlnQeQ6PUfkQpOrFJcWpz3n1Rz3dD06A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IU+6CWt56MFpDHHVnAjxIf9ghfXXBA40PP54E3O4/W8X0UiSSCrVkZE6ZM0ORi3d9
	 wPiW0knJgPtPFUzua6tX96T52eMuHzJRlJCSQIheIVNheN6Sh4lPkPUsRHIPgyQu5O
	 AgOaG5r0Rq7bDqwHAm6FyRHEKm1n3HrOhHA8EAl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krister Johansen <kjlx@templeofstupid.com>,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.16 053/189] mptcp: sockopt: make sync_socket_options propagate SOCK_KEEPOPEN
Date: Wed, 17 Sep 2025 14:32:43 +0200
Message-ID: <20250917123353.161504117@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krister Johansen <kjlx@templeofstupid.com>

commit 648de37416b301f046f62f1b65715c7fa8ebaa67 upstream.

Users reported a scenario where MPTCP connections that were configured
with SO_KEEPALIVE prior to connect would fail to enable their keepalives
if MTPCP fell back to TCP mode.

After investigating, this affects keepalives for any connection where
sync_socket_options is called on a socket that is in the closed or
listening state.  Joins are handled properly. For connects,
sync_socket_options is called when the socket is still in the closed
state.  The tcp_set_keepalive() function does not act on sockets that
are closed or listening, hence keepalive is not immediately enabled.
Since the SO_KEEPOPEN flag is absent, it is not enabled later in the
connect sequence via tcp_finish_connect.  Setting the keepalive via
sockopt after connect does work, but would not address any subsequently
created flows.

Fortunately, the fix here is straight-forward: set SOCK_KEEPOPEN on the
subflow when calling sync_socket_options.

The fix was valdidated both by using tcpdump to observe keepalive
packets not being sent before the fix, and being sent after the fix.  It
was also possible to observe via ss that the keepalive timer was not
enabled on these sockets before the fix, but was enabled afterwards.

Fixes: 1b3e7ede1365 ("mptcp: setsockopt: handle SO_KEEPALIVE and SO_PRIORITY")
Cc: stable@vger.kernel.org
Signed-off-by: Krister Johansen <kjlx@templeofstupid.com>
Reviewed-by: Geliang Tang <geliang@kernel.org>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/aL8dYfPZrwedCIh9@templeofstupid.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/sockopt.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -1508,13 +1508,12 @@ static void sync_socket_options(struct m
 {
 	static const unsigned int tx_rx_locks = SOCK_RCVBUF_LOCK | SOCK_SNDBUF_LOCK;
 	struct sock *sk = (struct sock *)msk;
+	bool keep_open;
 
-	if (ssk->sk_prot->keepalive) {
-		if (sock_flag(sk, SOCK_KEEPOPEN))
-			ssk->sk_prot->keepalive(ssk, 1);
-		else
-			ssk->sk_prot->keepalive(ssk, 0);
-	}
+	keep_open = sock_flag(sk, SOCK_KEEPOPEN);
+	if (ssk->sk_prot->keepalive)
+		ssk->sk_prot->keepalive(ssk, keep_open);
+	sock_valbool_flag(ssk, SOCK_KEEPOPEN, keep_open);
 
 	ssk->sk_priority = sk->sk_priority;
 	ssk->sk_bound_dev_if = sk->sk_bound_dev_if;


