Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F150346444;
	Tue, 10 Sep 2024 09:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961031; cv=none; b=qepE1PpVBlaywSiT4/BSvR/vjCYcCJP8BdZ9gkHM9E6w8COP4q1UKndRXpfG+Imc7fPD+NAkHW+C31iG0T7PYgQRl70R5tTPXIgNwm+I6uqHr+JqLQDBdGivsKU9e2UR/o7qSEFJ3dtgx42k8T+0zbNhpRGP3ixk5W3oZhN8/EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961031; c=relaxed/simple;
	bh=xfCS/yBynbX3CNradkBwglMhcQzATW13DqKhiu3fvSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ekub0HhVNsJR2smZ/6h5UuRJwWknJe696nfWE4VaLSo9hOGrdSRD7Pa6wFGpezOU2UDC6L0nUcfqh+T5s0UX9lCsAYfq9+tK3P6JwAzOmSHF4h9knDNqtX/BRmec+wG7znMIaljC8J6JDYx/MNHa5n7MiXpYPsCPHQuclNy7BHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qmdso5pQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qmdso5pQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E243C4CEC3;
	Tue, 10 Sep 2024 09:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961030;
	bh=xfCS/yBynbX3CNradkBwglMhcQzATW13DqKhiu3fvSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qmdso5pQ9+u/6bzCMZV5N+iUHb/j8dJODGaoOX4SWHGcn0vMrH6LuQurDJR969F06
	 wR6gxEJWYG31tVw/u1dM52rYYLs6C6v+s5M+64sNrnw1TaRMvCf36rjaJL2Zn1Ezqr
	 0Yja0EHaSW332oNHnMLzS7D8gli8rs6gD9ofsRt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 29/96] af_unix: Remove put_pid()/put_cred() in copy_peercred().
Date: Tue, 10 Sep 2024 11:31:31 +0200
Message-ID: <20240910092542.769700774@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit e4bd881d987121dbf1a288641491955a53d9f8f7 ]

When (AF_UNIX, SOCK_STREAM) socket connect()s to a listening socket,
the listener's sk_peer_pid/sk_peer_cred are copied to the client in
copy_peercred().

Then, the client's sk_peer_pid and sk_peer_cred are always NULL, so
we need not call put_pid() and put_cred() there.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index dfcafbb8cd0e..24fb6f00f597 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -610,9 +610,6 @@ static void init_peercred(struct sock *sk)
 
 static void copy_peercred(struct sock *sk, struct sock *peersk)
 {
-	const struct cred *old_cred;
-	struct pid *old_pid;
-
 	if (sk < peersk) {
 		spin_lock(&sk->sk_peer_lock);
 		spin_lock_nested(&peersk->sk_peer_lock, SINGLE_DEPTH_NESTING);
@@ -620,16 +617,12 @@ static void copy_peercred(struct sock *sk, struct sock *peersk)
 		spin_lock(&peersk->sk_peer_lock);
 		spin_lock_nested(&sk->sk_peer_lock, SINGLE_DEPTH_NESTING);
 	}
-	old_pid = sk->sk_peer_pid;
-	old_cred = sk->sk_peer_cred;
+
 	sk->sk_peer_pid  = get_pid(peersk->sk_peer_pid);
 	sk->sk_peer_cred = get_cred(peersk->sk_peer_cred);
 
 	spin_unlock(&sk->sk_peer_lock);
 	spin_unlock(&peersk->sk_peer_lock);
-
-	put_pid(old_pid);
-	put_cred(old_cred);
 }
 
 static int unix_listen(struct socket *sock, int backlog)
-- 
2.43.0



