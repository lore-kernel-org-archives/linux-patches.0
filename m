Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11AC3C09E1;
	Tue, 16 Jun 2026 18:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633084; cv=none; b=gDGzxMFOEKFfk2/sv7A/x9q0UTlxcY/xDR0cH8Jds+jyG+DXiOnKfus3SBpZgEgY8nuz+3zhSjApGluf2zCdyczh4Nk0pel131i1ZRFam0mgOSGsQtF01V6Zz0oZmS4FtlTd69aR3zTQ4xQlMalyOcuTIc3X7uwEJ0f1ZrCEWc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633084; c=relaxed/simple;
	bh=8qB1rSUiAbgixj3XVRWPxgJ++PkPL6tDDaz+1itdO+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S0M7fk8lerdgE9jI/fSUxGupQiar/uv6ucYGPockNkDYExDM+rQgp/6wlXrnnSNNzTuddQ2tTxj9//tjUMQ8/TJPu8x1jvrt68wGP6ysbyy4fbzXYNmDItXjktWbVJWz78XaFmv0yr6UKPe2pAKLNKNWt3uDQxuHtwMPH0hmLec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R/0eU4Sk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R/0eU4Sk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A21671F000E9;
	Tue, 16 Jun 2026 18:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633083;
	bh=3IwV/crOlCAwPMC8yGgLgexcylYC1RnU5E46lfBnmao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R/0eU4SkyFqEWwT4I+cQAPHxbDH0USPtSDYjUWwKBJlEumfsmtNJZqykl7cQwfjvV
	 94n9Sg8fcGvGgLfY8AGQdpvZyNriSezgNFFPMulKdZMwkiPHcmB3asfV2zf2kpLedD
	 3O7vobOP699hyiGbWTat9qhLS5xdYNtwOfqTQpeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 008/411] nfc: llcp: Fix use-after-free in llcp_sock_release()
Date: Tue, 16 Jun 2026 20:24:06 +0530
Message-ID: <20260616145100.803677689@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lee Jones <lee@kernel.org>

[ Upstream commit f4268b466190dae95a7585f69b4f1f8ad097632c ]

llcp_sock_release() unconditionally unlinks the socket from the local
sockets list.  However, if the socket is still in connecting state, it
is on the connecting list.

Fix this by checking the socket state and unlinking from the correct list.

Fixes: b4011239a08e ("NFC: llcp: Fix non blocking sockets connections")
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://patch.msgid.link/20260429134115.3558604-1-lee@kernel.org
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/llcp_sock.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index 6e1fba2084930e..54af85d939c6b9 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -640,6 +640,8 @@ static int llcp_sock_release(struct socket *sock)
 
 	if (sock->type == SOCK_RAW)
 		nfc_llcp_sock_unlink(&local->raw_sockets, sk);
+	else if (sk->sk_state == LLCP_CONNECTING)
+		nfc_llcp_sock_unlink(&local->connecting_sockets, sk);
 	else
 		nfc_llcp_sock_unlink(&local->sockets, sk);
 
-- 
2.53.0



