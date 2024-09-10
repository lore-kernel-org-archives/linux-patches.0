Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5C4199920;
	Tue, 10 Sep 2024 10:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963582; cv=none; b=j3rRponmW6593e7Z8OANXRBrKO95+Ju+1Qw0NfJiyaEOWEWRcQzhZLWKiBBoDCac6mHtwL8D6EB+QxTcDzOPCN/oG/n3MGRlEG5ncC0j0XoTlI5cumRREIrejYOXOIsf0ZTDs/U8/w6IlAPtrHHI9kb6BKYhQdQOYpx4yjkp384=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963582; c=relaxed/simple;
	bh=Iuy+xfp9lSD7ybKTF9iilCJTBXF27W68SXVYn4y2RPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pkeKiP8kfPNALmrZRpJLwALPxHbHQaoLhCysJvYGpf/3mpO6u9z7ajtS/Ju+tT4zRto8diePFA+72yHiDWdvj8wTONOULWE7zuXJb2ZzOO66MuR3EUSbAeZ9GAHbURKwP306xYz5mWMMYERLEDaa2ks1QdDzD9hwq96wQR3Q8wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kNAW4BYS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kNAW4BYS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8891C4CEC3;
	Tue, 10 Sep 2024 10:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963582;
	bh=Iuy+xfp9lSD7ybKTF9iilCJTBXF27W68SXVYn4y2RPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kNAW4BYS4YU9VrO2ECFBYBzHMssdXqt4Cht2QVgKyDqd7EYUlKtPDJHRoEBYyIOaT
	 8uKlFQ+dkAbY+xWs9ILpL1KM7pzChDpHNlCGWYAH1NKtKgqcq3hsOSBwIc2hnyayvf
	 OYs8DEXVEakLVCDCiZHOHbobD3QBc8eM4r+DHIYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 106/214] af_unix: Remove put_pid()/put_cred() in copy_peercred().
Date: Tue, 10 Sep 2024 11:32:08 +0200
Message-ID: <20240910092603.134027913@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e73c1bbc5ff8..eb916b2eb673 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -616,9 +616,6 @@ static void init_peercred(struct sock *sk)
 
 static void copy_peercred(struct sock *sk, struct sock *peersk)
 {
-	const struct cred *old_cred;
-	struct pid *old_pid;
-
 	if (sk < peersk) {
 		spin_lock(&sk->sk_peer_lock);
 		spin_lock_nested(&peersk->sk_peer_lock, SINGLE_DEPTH_NESTING);
@@ -626,16 +623,12 @@ static void copy_peercred(struct sock *sk, struct sock *peersk)
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



