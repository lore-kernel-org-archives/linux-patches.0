Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5B73358CC;
	Thu, 27 Nov 2025 14:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255301; cv=none; b=RZ94+CztcOmiRHtJf1SKvy5BpTWmL1qLm+JRsUa9r4asBBUgfAkhCOkfk2QXf1SsFCilUgGRzPMNqrJ2JedqHMV9GdkfpAJS3nbCFET6dqNlaTIjaJ2prKMI80l/uDe2kVkSRLAfFnFF2Z2FzQ8XbgeY0Y4BP3NuUSQ8frypjaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255301; c=relaxed/simple;
	bh=gEtc4kQWcwecqeBxjcOUID7N/FSGKWEVv1ujnxCM9xM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OhpJ/tX7JJfwIySnVL1ResyiD9LlUwkX2rLr61L4jZE0poQIlgs3OuAzqrCyVCihbPbvEf3Iw1/MtzPQjHB7kOOisPOe/E6jcacTztKq+NJ72pceHLC8ms2uCnWizTWih1CWXuiAx7KbnyRFfvmx8el4H/oqGLxrIgZT1tP4hgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yc8VBXNF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yc8VBXNF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8553C116C6;
	Thu, 27 Nov 2025 14:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255301;
	bh=gEtc4kQWcwecqeBxjcOUID7N/FSGKWEVv1ujnxCM9xM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yc8VBXNFY5zZMwsjmtT0873HHn/7UsIkUN/2R7twbvWDwwiKk7ZFKKovVo9ZwUU71
	 0OkMwn7ymFo86PLqHyJPLnO3xh5gzHHp3gvn1gRlyhYwCXPSshkPPt1A+KuLK+f6Nr
	 oE34UKxNfSNFBONZK25aNnhNrwADjxT2ow3sTsG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 078/112] af_unix: Cache state->msg in unix_stream_read_generic().
Date: Thu, 27 Nov 2025 15:46:20 +0100
Message-ID: <20251127144035.697471796@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 8b77338eb2af74bb93986e4a8cfd86724168fe39 ]

In unix_stream_read_generic(), state->msg is fetched multiple times.

Let's cache it in a local variable.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20250702223606.1054680-6-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 7bf3a476ce43 ("af_unix: Read sk_peek_offset() again after sleeping in unix_stream_read_generic().")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 45f8e21829ecd..26d37a90b755d 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2769,20 +2769,21 @@ static int unix_stream_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 static int unix_stream_read_generic(struct unix_stream_read_state *state,
 				    bool freezable)
 {
-	struct scm_cookie scm;
+	int noblock = state->flags & MSG_DONTWAIT;
 	struct socket *sock = state->socket;
+	struct msghdr *msg = state->msg;
 	struct sock *sk = sock->sk;
-	struct unix_sock *u = unix_sk(sk);
-	int copied = 0;
+	size_t size = state->size;
 	int flags = state->flags;
-	int noblock = flags & MSG_DONTWAIT;
 	bool check_creds = false;
-	int target;
+	struct scm_cookie scm;
+	unsigned int last_len;
+	struct unix_sock *u;
+	int copied = 0;
 	int err = 0;
 	long timeo;
+	int target;
 	int skip;
-	size_t size = state->size;
-	unsigned int last_len;
 
 	if (unlikely(READ_ONCE(sk->sk_state) != TCP_ESTABLISHED)) {
 		err = -EINVAL;
@@ -2802,6 +2803,8 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
 
 	memset(&scm, 0, sizeof(scm));
 
+	u = unix_sk(sk);
+
 	/* Lock the socket to prevent queue disordering
 	 * while sleeps in memcpy_tomsg
 	 */
@@ -2894,14 +2897,12 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
 		}
 
 		/* Copy address just once */
-		if (state->msg && state->msg->msg_name) {
-			DECLARE_SOCKADDR(struct sockaddr_un *, sunaddr,
-					 state->msg->msg_name);
-			unix_copy_addr(state->msg, skb->sk);
+		if (msg && msg->msg_name) {
+			DECLARE_SOCKADDR(struct sockaddr_un *, sunaddr, msg->msg_name);
 
-			BPF_CGROUP_RUN_PROG_UNIX_RECVMSG_LOCK(sk,
-							      state->msg->msg_name,
-							      &state->msg->msg_namelen);
+			unix_copy_addr(msg, skb->sk);
+			BPF_CGROUP_RUN_PROG_UNIX_RECVMSG_LOCK(sk, msg->msg_name,
+							      &msg->msg_namelen);
 
 			sunaddr = NULL;
 		}
@@ -2959,8 +2960,8 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
 	} while (size);
 
 	mutex_unlock(&u->iolock);
-	if (state->msg)
-		scm_recv_unix(sock, state->msg, &scm, flags);
+	if (msg)
+		scm_recv_unix(sock, msg, &scm, flags);
 	else
 		scm_destroy(&scm);
 out:
-- 
2.51.0



