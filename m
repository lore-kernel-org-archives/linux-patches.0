Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD402F0C5C;
	Mon, 22 Sep 2025 19:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570197; cv=none; b=RaxPlIHDgRsZUTb3uPeXLO26/OS2GJXjlks5hRPBBocSIksPaWJlm3ZBnEhmqzH3pvgoZYQ0uoVkNsJiC9NAVSfvILIn1+oa7zrDK3xWfWixu6dQsqbFp2sg45HAie6CqAKKjBf5gsUshcStzfP5meRmxepazuefyXGutX/n8cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570197; c=relaxed/simple;
	bh=8dBvb8DSp3dNnpXP48lEx6o4tYUcb9OWJrn3SpZYm58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y3tRpdkm8MrFkM1SQLT/O43ytPVEPjnS09OYy+yqooPfzuX4BpV6AxYjYGPL7wsBITcNny1E8bWoemDss4HoubhxuOYht750MsA6ZcEOCzweNdWFdeR/k+ePYQGo7ixnxNPZG4DCJ369ZvhiRm1VqciOUBNabClUl8NFpmyUEPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XQdJMtTz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XQdJMtTz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC15FC4CEF5;
	Mon, 22 Sep 2025 19:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570197;
	bh=8dBvb8DSp3dNnpXP48lEx6o4tYUcb9OWJrn3SpZYm58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XQdJMtTzLl3Pig6S5LpfEleHsjZCWgNFysiTg2xS2Q3PAJjT9FvtWVDEnnSLn0R87
	 aCru1xu64Fdv21n55FsYgNAzzSHDUyRc30AU+HCgwliVHIr3e2/oDfF9I62vSn9ak2
	 2LqsdBOdERfXzAjtdEUjSSI7YA6KzeD0kxQXoMVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Vagin <avagin@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 043/149] net: clear sk->sk_ino in sk_set_socket(sk, NULL)
Date: Mon, 22 Sep 2025 21:29:03 +0200
Message-ID: <20250922192413.952284388@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 87ebb628a5acb892eba41ef1d8989beb8f036034 ]

Andrei Vagin reported that blamed commit broke CRIU.

Indeed, while we want to keep sk_uid unchanged when a socket
is cloned, we want to clear sk->sk_ino.

Otherwise, sock_diag might report multiple sockets sharing
the same inode number.

Move the clearing part from sock_orphan() to sk_set_socket(sk, NULL),
called both from sock_orphan() and sk_clone_lock().

Fixes: 5d6b58c932ec ("net: lockless sock_i_ino()")
Closes: https://lore.kernel.org/netdev/aMhX-VnXkYDpKd9V@google.com/
Closes: https://github.com/checkpoint-restore/criu/issues/2744
Reported-by: Andrei Vagin <avagin@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Andrei Vagin <avagin@google.com>
Link: https://patch.msgid.link/20250917135337.1736101-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index a348ae145eda4..6e9f4c126672d 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2061,6 +2061,9 @@ static inline void sk_set_socket(struct sock *sk, struct socket *sock)
 	if (sock) {
 		WRITE_ONCE(sk->sk_uid, SOCK_INODE(sock)->i_uid);
 		WRITE_ONCE(sk->sk_ino, SOCK_INODE(sock)->i_ino);
+	} else {
+		/* Note: sk_uid is unchanged. */
+		WRITE_ONCE(sk->sk_ino, 0);
 	}
 }
 
@@ -2082,8 +2085,6 @@ static inline void sock_orphan(struct sock *sk)
 	sock_set_flag(sk, SOCK_DEAD);
 	sk_set_socket(sk, NULL);
 	sk->sk_wq  = NULL;
-	/* Note: sk_uid is unchanged. */
-	WRITE_ONCE(sk->sk_ino, 0);
 	write_unlock_bh(&sk->sk_callback_lock);
 }
 
-- 
2.51.0



