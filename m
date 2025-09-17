Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16010333A81;
	Wed, 17 Sep 2025 12:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113724; cv=none; b=m8vDlZYp17YHjR7+6xXge4ifL3d7lT/1bFuxtHdhBN1G3+kYu8QVVzMnby4gdy2sdlBkjhMYbvfvpVsNujIoi/Ey2TWtqKHDekar7zRfimd8qabC0I/NXZWl4sTDyQPLUx2gUbezzeTXD429fGpoOOnONVL6TC9Dg+h52Cid8xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113724; c=relaxed/simple;
	bh=RdHbKZbIy+j6F2Xp5hkhWQdfxBd37tFN3IuscvQV1Hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O22nlwEeRt1rM/IMai25/+0ZNx88O49f+G/qRpqLCnbugojcc7IgybnVrKVDHFS7kgs+K38HWJxY4OP/AGo8mhPX9dWUbkp+osXVS6s7zR3KQYX5VTPJDYG2C2fbGaNbLZekj8ySeyntlwIgIuMB45GAh4nIWGfKWzP+H6bvthM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h1dByOsM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h1dByOsM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85639C4CEF0;
	Wed, 17 Sep 2025 12:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113724;
	bh=RdHbKZbIy+j6F2Xp5hkhWQdfxBd37tFN3IuscvQV1Hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h1dByOsMZN6hwUwirgA9JgsqZgl1ZnO06ix44BSxIa6Z+ed9YumlqlFz3H508lSJf
	 nYNGCm0qVNQIifQALBZDfxX93VWfqi06M/DVFBl3Mjg/6RWO6DI5xONc9o2/wiyP5e
	 SSn+7a1qNUNeWNl1kQareP60dFFFl+yyd8RMMaqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krister Johansen <kjlx@templeofstupid.com>,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 034/101] mptcp: sockopt: make sync_socket_options propagate SOCK_KEEPOPEN
Date: Wed, 17 Sep 2025 14:34:17 +0200
Message-ID: <20250917123337.673516008@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1471,13 +1471,12 @@ static void sync_socket_options(struct m
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


