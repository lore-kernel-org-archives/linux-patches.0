Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F513DF007;
	Tue, 16 Jun 2026 18:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635264; cv=none; b=L1FZn16+BelTrkbPk+0hRwsIgBfaiwbKg/qT7El+Fy6R+w4lkmdRM2gunOnLbydQqYU6pCCOewiqnlx7I7m+w58dQtbXpzU39TEWy+k8b7d3ng9zCvAsxclYZkg0YT1zioRfR89Pe98+jZbcfaBDrgeVGAzOitLtkMm1su3HHBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635264; c=relaxed/simple;
	bh=H00Ygf3SBTVA6R1JyVQS1ilA6U1ZYTPsPsfPXcxDImw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tiek3KkfI8owGw3tioksJnYJd0G069QMdkrVJOmeR7wKwqsubXOK8O9NbyUkyhSOlFujHxQUFxzNIP7c1z/gcK5lb7JTVUicXxXH6LrfRhbe1YDeB1RNQlv/PSYUsE4kgEHogbeskWg0zs62ohYnOffS4JLMMlqnibyvj4dNIAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R/ScRSrt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R/ScRSrt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D44BA1F00A3A;
	Tue, 16 Jun 2026 18:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635262;
	bh=jTADwDiA2Iyb9pEmZmpJiJKH7+f2Er6uvQ/LfiSWpAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R/ScRSrt5oe+dIklu77JCnjlbtQpFzYh++AISkNnshlrpje8IRJOvRMEFcjWxkUpb
	 oNNj6eB5flj1eBnHGoASyuaWkKgeUUi2DSPhGnheKbUy4c7JK0qKLk98yDpqOzBysh
	 VQ0ma0kvYJzxCY+5GhOrLKftUuWBWC059amlSl/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Simon Horman <horms@kernel.org>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 008/342] nfc: llcp: Fix use-after-free race in nfc_llcp_recv_cc()
Date: Tue, 16 Jun 2026 20:25:04 +0530
Message-ID: <20260616145048.712218161@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e04634f22b49f4..c7de44637e0187 100644
--- a/net/nfc/llcp_core.c
+++ b/net/nfc/llcp_core.c
@@ -1225,6 +1225,15 @@ static void nfc_llcp_recv_cc(struct nfc_llcp_local *local,
 
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
@@ -1236,6 +1245,8 @@ static void nfc_llcp_recv_cc(struct nfc_llcp_local *local,
 	sk->sk_state = LLCP_CONNECTED;
 	sk->sk_state_change(sk);
 
+	release_sock(sk);
+
 	nfc_llcp_sock_put(llcp_sock);
 }
 
-- 
2.53.0



