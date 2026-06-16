Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5585B46AED1;
	Tue, 16 Jun 2026 16:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628072; cv=none; b=l5n+Uj3TJ7khvN/Ftk8O2btj64SOiipCnNxXMtSB3RmMFHIzZKkwvikh0UkUIP5/RZKj7Z+QDG5AInQ1Iu0QGkx7FEMddWTacgWRa39FDW6ftq1VIKZNgYDxmvKQQTvjAvDNYRPE/bXBfGooGlWhvDS7gjk7akdeU6VcSKnA7WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628072; c=relaxed/simple;
	bh=LK8A/y7VpoMIkbmRJJxp0INVknFwMvYaXzu4vgioIZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lV2rqPF/tJhQMN9nfKV1RNC9uNAmOjrA6QvwG7y3JvPk+d2Qlz8q0ZQs4/epY2s2y8/3imXNbT6nAaYl0VIjAmnsF3+9RcZmFcgijwghZXccnmFCCXCW5pY0WLu5OXmnb0VSyOPEEFIzd3nZiobjMc+UvlD7OYqOCm5ka3BfstU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NPDxTDtF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NPDxTDtF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 610B61F000E9;
	Tue, 16 Jun 2026 16:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628071;
	bh=ACNt1lXu1Js5/FUlxxtDHMeOJe82wYFIOyMVyGtZ7xU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NPDxTDtFEeKEWxhUffJIJuCztG7GNIsxejslmqBnfNLNirDzJFSfcMTuy3aaUYY5m
	 w31qNjhAbNRcsZ6x2WwHT/f9FW+e6Bclf1R9sfExmXlvr/6mP4Y3PgpQUaj/r6sX5l
	 tOd4buU3PiUZVqQgckq7jqlQ9bvRIk+F7DNPVMu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 008/452] nfc: llcp: Fix use-after-free in llcp_sock_release()
Date: Tue, 16 Jun 2026 20:23:55 +0530
Message-ID: <20260616145118.232016973@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d5344563e525c9..cd1fdf0beefb6b 100644
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



