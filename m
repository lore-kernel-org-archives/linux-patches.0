Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826969;
	b=vQeAqvHv7WcAlaGZJRN4xplot3EQ+mP/+q4SW/QOsuGVZF/KiZA3Gh2yNwxY9a6qLKkx
	 igOrPzzKwNfAOMsAgRH6gsrKWBbGd7AfHDHicxucw16roFn7oBwFiLdjErmddIdk7dXPo
	 fy/LCht3M2FYkRXlhtD9CZQ3h/Xm8QZAAKoGsA5kXSjCWus0qNPq0P/yHNkWcDqtW7x2K
	 om3qsvn+9TBCo5Aw1NXNV2S9rYLl0/r3WxK++FQnNY3oiNU5xLM7NzGODYcPbBLfBDI3V
	 AAgM6faWh1eSdSDo78FMEDEL8E42m4qtuONIqfO3t6TNtG0zBnae6SWD8eECEQuxvPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826969;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AnjKc+4Sd5Fshucc4w3vmX1yHDrLUtbg4Yl6qAjT6bo=;
	b=MwL3W6eyBSHcC8L7t0/TXFaQiR6/xhqSqYdYsMDC+41IDvI+yX+/P7uIyonNdRxMa1be
	 6X7+cH6PyoJo/zoIDSFPWKXh3lxIwDnSt8yntDS0g5TxMM9MEXPc/3VLRTLCyNFY56Hsa
	 XLbajK5A4b+BItxzlcO5DDQb+4tNCiXHSm0m2wcCgmxcRW4jNVgz2DNFsEe7CXUD3I02h
	 DjbFqX+LDG1TNYr5IuhIHKZv6l7wT2QdYlF/xIdNQfpf8+JRcmx5GNiJdJvZUKOBLyytz
	 2DayzK9Z6WD2NCY++BFLH/7WoYYxIyAucqevIJNmv8DhVk/D+5JK9v+N+7nVfHcvFhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="R1h2dF/q";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEE360BC541;
	Wed,  4 Nov 2026 21:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R1h2dF/q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 786E11F00A18;
	Wed,  4 Nov 2026 21:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826968;
	bh=AnjKc+4Sd5Fshucc4w3vmX1yHDrLUtbg4Yl6qAjT6bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R1h2dF/q2T8NAWKlcCi/mh7nPG77lNqT+Jqqdkbnaiqlh8jekFmCFaFu9q4KZonu0
	 Vv6il9mmMdP3r193QoVkgL6SCmwJewtpRNPCOM+GVYV5+EWXq4Wnr2QslcLdhjfgAg
	 r/3LTvRKo/QrBEs7xz23aC4eP6ivZUkqlDER4XtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdifatah Suruur <suruurism@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.3 115/547] ksmbd: defer connection scavenging while session locks are busy
Date: Wed,  4 Nov 2026 16:04:59 -0500
Message-ID: <20261104211041.472215936@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit b4bae7af1154089be87c7475218264fcbfd16d10 upstream.

The expiration worker holds conn_list_lock for reading while checking
for authenticated sessions. Without this change, the check can wait for
conn->session_lock or sessions_table_lock.

In destroy_previous_session(), the status updates after
ksmbd_conn_wait_idle_sess() run with both session locks held for
writing. Both the KSMBD_SESS_GOOD error path and the
KSMBD_SESS_NEED_SETUP success path call ksmbd_all_conn_set_status(),
which takes conn_list_lock for reading.

A writer queued on conn_list_lock can block these new read acquisitions.
The worker then waits for a session lock held by
destroy_previous_session(), which waits behind the writer. The writer
cannot proceed until the worker releases conn_list_lock.

Try both session locks instead of waiting in the scavenging check. Keep
the connection when either lock is busy and let the periodic worker
retry later.

Fixes: d7fd1f98607f ("ksmbd: follow SMB2 session expiration semantics")
Cc: stable@vger.kernel.org
Reported-by: Abdifatah Suruur <suruurism@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/mgmt/user_session.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -532,7 +532,12 @@ bool ksmbd_conn_has_valid_or_expired_ses
 	int state, bkt;
 	bool found = false;
 
-	down_read(&conn->session_lock);
+	/*
+	 * The expiration worker holds conn_list_lock, which session teardown
+	 * takes after the session locks. Defer scavenging if either is busy.
+	 */
+	if (!down_read_trylock(&conn->session_lock))
+		return true;
 	xa_for_each(&conn->sessions, id, sess) {
 		state = READ_ONCE(sess->state);
 		if (state == SMB2_SESSION_VALID ||
@@ -546,7 +551,8 @@ bool ksmbd_conn_has_valid_or_expired_ses
 		return true;
 
 	/* A session bound through SMB3 multichannel is not in conn->sessions. */
-	down_read(&sessions_table_lock);
+	if (!down_read_trylock(&sessions_table_lock))
+		return true;
 	hash_for_each(sessions_table, bkt, sess, hlist) {
 		state = READ_ONCE(sess->state);
 		if (state != SMB2_SESSION_VALID &&


