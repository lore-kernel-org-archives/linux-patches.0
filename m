Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73371E98E3;
	Sun,  7 Jun 2026 10:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826960; cv=none; b=g5BjC0FB3XY+m/4urneuMFwDyZaS9Hr7ykgMv2RY+Sx0r1IUtdXi1bnWaOJn+5UiLotVmf8UQqutff1nTuSJAhxlY3xD3aU2QqxAi91FwjrksH7Q0lUKaH5kEqnM3GpAMs7JaBIj929s8p1QoBkWuHOE6ax02OhpkN6QyZ0mRmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826960; c=relaxed/simple;
	bh=Hjj9RBb+GvyjRAsk6/xitc4XLCR3exAKKvs1GsXeCy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zqf1zGk0/HGIi9F8C70GMPOJMxJScxJQm2eF8e7JVmQYaHL6rV0FutKODidnKl8fVttVhs5qY9cyTCw1JZ0x/e/5XtTM7J7GEdU5hIagrVqZ4aIPlJV7MrC1hM5AXuVYqX/x/C94CQFCqKUkC/dENW/ZY5Yk6bDyMpvCyxWB9A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EPNmJ4jh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EPNmJ4jh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 352F51F00893;
	Sun,  7 Jun 2026 10:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780826959;
	bh=ztNByOwl7kBa09RqWUVIMfUXcH7NXljVyK4RJAXjzeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EPNmJ4jhyzjLAnXNw9fJ3VYTRQFCId1WoUykVer1T9qClFj+I31tNzxJ0LbgUmHk7
	 tyJtv3gJtwCne1Gs9szrmr9rFfsMzxVc/mRvNI/LsKPK6Dy1j6o2F3/p5TrWInS0tn
	 cvnzGIsGSb0Oz7wAK/ZATO83/w2NDdCmxnUZbbNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 007/315] nfc: llcp: Fix use-after-free in llcp_sock_release()
Date: Sun,  7 Jun 2026 11:56:34 +0200
Message-ID: <20260607095727.780756532@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 57a2f97004e172..915929cd724f90 100644
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



