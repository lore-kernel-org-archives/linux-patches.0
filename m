Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A21188A38;
	Tue, 10 Sep 2024 10:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964106; cv=none; b=J+BMijp8zFKanbW6Y2ddQ5QA5OhF/LY8MWMF1oPPoXnenq1QhX6dMP7AInQ0fqR6ckUqFLafUMNq3KSru6jXi2zajFMBE3KDhF4bkjX2cj/XIyZClYfQkp/EnsfmAyjDWNUU+KIUa0IWqi0Bj5LbJWgtzJTMGmuwfVv5dcUByWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964106; c=relaxed/simple;
	bh=7YRYtOPBaV+/DGkg2O8d9vSOYjunepgAPP7I3XlnWz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aT2eN3X+vUfgz2zgrsLvzN17Euoc6XZYuO8UxZR0GSVqdl3TBvhsn5rjVz89x5JSHwP8PxSeE8hLKz293kReOJlWf6foOc7xCezb1kmyJEL74k2ZMIW91a+BiIIj+OeailN52LFzqcK4WrynQwdezsC5gbh+7g25Xd1PxBupHPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FgXfszi+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FgXfszi+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D022C4CEC3;
	Tue, 10 Sep 2024 10:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964105;
	bh=7YRYtOPBaV+/DGkg2O8d9vSOYjunepgAPP7I3XlnWz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FgXfszi+C22CDfXE0Pv7hSDLEJgfN0grTQaA4bCFNLwPP2/4fqZerOWNGNjJVQvas
	 xVt0zri8uIBO2GOjGvldIjZyHyRx/0tmoD9CHN6GfScw5L5dyLlhJPfYZzbm9s3sxQ
	 gCCl0pILdV8i1bxIqIbJrSUEEXtDMbQZDGFAcqmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 070/269] af_unix: Remove put_pid()/put_cred() in copy_peercred().
Date: Tue, 10 Sep 2024 11:30:57 +0200
Message-ID: <20240910092610.697624960@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b7f62442d826..dca4429014db 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -693,9 +693,6 @@ static void init_peercred(struct sock *sk)
 
 static void copy_peercred(struct sock *sk, struct sock *peersk)
 {
-	const struct cred *old_cred;
-	struct pid *old_pid;
-
 	if (sk < peersk) {
 		spin_lock(&sk->sk_peer_lock);
 		spin_lock_nested(&peersk->sk_peer_lock, SINGLE_DEPTH_NESTING);
@@ -703,16 +700,12 @@ static void copy_peercred(struct sock *sk, struct sock *peersk)
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



