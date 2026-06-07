Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9951E98EF;
	Sun,  7 Jun 2026 10:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827144; cv=none; b=qld8EklHrLmcaz+mfdrL/Mn+zb4WFB/FS9Jvoc3Oaozaj/yOW+XW6qWSPgb4DFSu5n4QGjXRXBvRg/BlgIQvBIahb+H3QQ+0vLYQH0swYquyzCHrCklUP45lZmpsYNnDjxYzRi4z+o4DuH5An0O0zggQxEmJ66EULqwdFpA7BxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827144; c=relaxed/simple;
	bh=E2pt966dfcBg/EB6RBc7g7Z0qMQIdWPy/ZU4EjMFwzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EQC3+vdaOb3txhSBESZpu0VOql33YNID0zXkaxy6fCLn5uEqzxpIMceaN4NcmpC2V9uPJ0u3zrTgInfh8w2M/OxztWwDNqIWFMwTQWTaaoUmA7oZviScDh8PjviIRoKUd5+8tTTmUWlYm5eTgR3I1RMWX6MU9n2jZe7T5iZm3kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f/LQ43nB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f/LQ43nB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662791F00893;
	Sun,  7 Jun 2026 10:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827143;
	bh=RIpx/VPr9Y0F2If96+2gZZXAPRAMN1BS+4oW4lUOf7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f/LQ43nB73/oeVwGqvoy8hW21f/AJhTr55jrmT0NARWdAxjlJ3uBuUpeYdaUN5JGy
	 E/DWZ/z0kuc2njBkb7U7YdQ8vZOdWqFjCnwALmxWTy1MX6DkQmc7C4QZAMRiBISGj2
	 YVFcGi+momHOfL8KxCo44ZNvaZwfxlVZSBzFdIzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Simon Horman <horms@kernel.org>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 026/307] nfc: llcp: Fix use-after-free race in nfc_llcp_recv_cc()
Date: Sun,  7 Jun 2026 11:57:03 +0200
Message-ID: <20260607095728.606331360@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

From: Lee Jones <lee@kernel.org>

[ Upstream commit b493ea2765cc17cb8aa7e7544a4b6dcb05b6ed77 ]

A race condition exists in the NFC LLCP connection state machine where
the connection acceptance packet (CC) can be processed concurrently with
socket release.  This can lead to a use-after-free of the socket object.

When nfc_llcp_recv_cc() moves the socket from the connecting_sockets
list to the sockets list, it does so without holding the socket lock.
If llcp_sock_release() is executing concurrently, it might have already
unlinked the socket and dropped its references, which can result in
nfc_llcp_recv_cc() linking a freed socket into the live list.

Fix this by holding lock_sock() during the state transition and list
movement in nfc_llcp_recv_cc().  After acquiring the lock, check if
the socket is still hashed to ensure it hasn't already been unlinked
and marked for destruction by the release path.  This aligns the locking
pattern with recv_hdlc() and recv_disc().

Fixes: a69f32af86e3 ("NFC: Socket linked list")
Signed-off-by: Lee Jones <lee@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260429134115.3558604-2-lee@kernel.org
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/llcp_core.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/nfc/llcp_core.c b/net/nfc/llcp_core.c
index d9562840fa180b..62b0f2d6686eb8 100644
--- a/net/nfc/llcp_core.c
+++ b/net/nfc/llcp_core.c
@@ -1216,6 +1216,15 @@ static void nfc_llcp_recv_cc(struct nfc_llcp_local *local,
 
 	sk = &llcp_sock->sk;
 
+	lock_sock(sk);
+
+	/* Check if socket was destroyed whilst waiting for the lock */
+	if (!sk_hashed(sk)) {
+		release_sock(sk);
+		nfc_llcp_sock_put(llcp_sock);
+		return;
+	}
+
 	/* Unlink from connecting and link to the client array */
 	nfc_llcp_sock_unlink(&local->connecting_sockets, sk);
 	nfc_llcp_sock_link(&local->sockets, sk);
@@ -1227,6 +1236,8 @@ static void nfc_llcp_recv_cc(struct nfc_llcp_local *local,
 	sk->sk_state = LLCP_CONNECTED;
 	sk->sk_state_change(sk);
 
+	release_sock(sk);
+
 	nfc_llcp_sock_put(llcp_sock);
 }
 
-- 
2.53.0



