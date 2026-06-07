Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA642E3709;
	Sun,  7 Jun 2026 10:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826784; cv=none; b=YqTUwNryaw/bv6TJfUq1im2BEW6zMb9K2Ke4QqxxQOf8DIT0k4Wb9F+Ou1ZpFEc6YJoMJKZQp7ip+33SxOvP9XzqDzV3DDCRJ/0FSFaZbV1upV8T+1bcDTL978/52atv9nPctS+FU2qhfeBwweI5z6AkBeynallbjb5rRtoRceQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826784; c=relaxed/simple;
	bh=edf8rLT3RoeNJBy1tH6rwuupLOl3bV6kO4hycQsX/pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rw0JwgnCxsjxzq6sx2uivCWyTnK0OJ77+t6f0/HbwJr6km+XNTezEzXxCY1NooVgZfriTyirqSerKXCQ817C91jG/3FRCxDSkJLK1BqKlA6RhNlSjWIO0xkiDCHWqEasF0ayJ70fIwkve8ku9ZQwdEOl2Fe6FF+0PQag5s4IS1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qGbtINB4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qGbtINB4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF3A61F00893;
	Sun,  7 Jun 2026 10:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780826783;
	bh=w3MPcx6VW1mWw9wMVHwvQ2RfCSRtqlrMBCcvoUy3nIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qGbtINB4Kywgpq+P69P1s2V6h/fcaQ46isA/KmVZ78nENOdXLYryka7b5daaEWbrw
	 LvrGNVA7XwUUCrrowIzDfPhvAV258/H7NZGEsHfzuXQWgAA9hSJwebkU8M0cjO7mEq
	 tywvpOr2kCFkVAR6+f7kr7xpKgd/0CrDOfNAivgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 007/332] nfc: llcp: Fix use-after-free in llcp_sock_release()
Date: Sun,  7 Jun 2026 11:56:16 +0200
Message-ID: <20260607095728.294721645@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index f1be1e84f66537..feab29fc62f44b 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -633,6 +633,8 @@ static int llcp_sock_release(struct socket *sock)
 
 	if (sock->type == SOCK_RAW)
 		nfc_llcp_sock_unlink(&local->raw_sockets, sk);
+	else if (sk->sk_state == LLCP_CONNECTING)
+		nfc_llcp_sock_unlink(&local->connecting_sockets, sk);
 	else
 		nfc_llcp_sock_unlink(&local->sockets, sk);
 
-- 
2.53.0



