Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272D818661A;
	Tue, 10 Sep 2024 09:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961629; cv=none; b=o/ibzp73hmlrvFQc6CTs5qcBL69fsCytN4QJfJpL0Gy7eYFhQR0N0D/AEV3Fs9J6ntJAc9VR37mVASfTtnDPLh0eNT3ddgcXgEv49bVhG3jnfzeAdpt8f0xIrt0pQvBgIXRJNZkjCouE14K8z8Xn57ZnP1bK/Wmv/34x3vwRycU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961629; c=relaxed/simple;
	bh=k5OMA1WOpGwXMPmYp0fd2vQbNq9avIn1qt0HrA8oJUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RHPgwdo7w9mh79xPegCz2vcppy7HO4sxJoFTIGbV1Z4UnMA33e/fsjiLgwBxV6bQ0xsTAVKoc0gv5hquKo0+WseMcWAAnAJ01IpaWL6nwUPew1OJdo+f4ohB9GdOKERLAM04xH0wvF7pCmXioyb3XgwnFAbHrEpWfwqpoZObdVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ayW0CuFb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ayW0CuFb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3FAEC4CEC3;
	Tue, 10 Sep 2024 09:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961629;
	bh=k5OMA1WOpGwXMPmYp0fd2vQbNq9avIn1qt0HrA8oJUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ayW0CuFbl1iarvVZJxEYBNzi/GPuXSTxwLwdA/LjfaPSgIw1tehquW9Hg8RdsW++b
	 Cc0pkz742NHGZTn75v5NGEb+ZAQrfXO9YgnHbEox/APbp0RdKSu590MAcB7dkyz56C
	 DkYRzn5F4izRxFYvFptCm2WY2fs73dP0CL6j8/uQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 107/375] af_unix: Remove put_pid()/put_cred() in copy_peercred().
Date: Tue, 10 Sep 2024 11:28:24 +0200
Message-ID: <20240910092625.988412047@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index be5266007b48..84a332f95aa8 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -692,9 +692,6 @@ static void init_peercred(struct sock *sk)
 
 static void copy_peercred(struct sock *sk, struct sock *peersk)
 {
-	const struct cred *old_cred;
-	struct pid *old_pid;
-
 	if (sk < peersk) {
 		spin_lock(&sk->sk_peer_lock);
 		spin_lock_nested(&peersk->sk_peer_lock, SINGLE_DEPTH_NESTING);
@@ -702,16 +699,12 @@ static void copy_peercred(struct sock *sk, struct sock *peersk)
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



