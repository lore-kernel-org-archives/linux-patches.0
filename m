Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64E73F44EA;
	Wed, 20 May 2026 17:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296526; cv=none; b=WIMW1AQlMigl2+GL+xOSfhjSy3EUBhJn1nJdfLuUqYCcWiKrGTqJ9E4O0l6AzvSNWoQWqxoPZp2DdyfcYCAoLfXFx8bp5jGkTPCkUZpjqpBwzVrBZxWvoaCzE8w7qJMsD/SscqGRg5nAV6pqgFbn7uTwcdwYsEuiAGzhrhjegFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296526; c=relaxed/simple;
	bh=r9FLj31QSPKuoMq43fcow4hKMC2XLpo6f/nyHFN+s2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iM25yAF0rPDQ0tiybekR/DUB9XVp3oBN1c1+CuxIX+sGHf5oduHKyBI0D0d1dY/RNI/TGmtEUiIZwZ9fhxPffiP3CZZjL5acHC5lTHx7d3i5ASZfFuQq3SqXyOUSyz/iuImXctbIZpZre30Ct92DxdutwfAOidKtNuqXm4h+pBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jyZ9j+7+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jyZ9j+7+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8791F000E9;
	Wed, 20 May 2026 17:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296524;
	bh=CpcOCVzvh7byRFcTVcinZWn8+aVtvXOiGd/Oxu/9WGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jyZ9j+7+9luZqhQe7WKRyG/rChFOj29AQMSG3Rhq745PKBVLut12GnCGUmV6MxoZo
	 5I2t6TcbZ9C8jFBL8x67kHODX8dm0zqz8YNEfPOXEDp0CusUiqVKvgoORu8b0W8mXp
	 ChQ7FcNXtR6LaDPc2KC4y95g2Gl5m1x/B7By9iL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0833/1146] sctp: fix sockets_allocated imbalance after sk_clone()
Date: Wed, 20 May 2026 18:18:03 +0200
Message-ID: <20260520162207.081451463@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 7c9b012d6367a335f1e91da28401a7c612305a46 ]

sk_clone() increments sockets_allocated and sets the socket refcount to 2.
SCTP performs additional accounting in sctp_clone_sock(), so the clone-time
increment must be undone to avoid double counting.

Note we cannot simply remove the SCTP-side increment, because the SCTP
destroy path in sctp_destroy_sock() only decrements sockets_allocated when
sp->ep is set, which may not be true for all failure paths in
sctp_clone_sock().

Fixes: 16942cf4d3e3 ("sctp: Use sk_clone() in sctp_accept().")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/af8d66f928dec3e9fcbee8d4a85b7d5a6b86f515.1776460180.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/socket.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 6c58ad092e512..aeffa10ff2d34 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4864,8 +4864,9 @@ static struct sock *sctp_clone_sock(struct sock *sk,
 	if (!newsk)
 		return ERR_PTR(err);
 
-	/* sk_clone() sets refcnt to 2 */
+	/* sk_clone() sets refcnt to 2 and increments sockets_allocated */
 	sock_put(newsk);
+	sk_sockets_allocated_dec(newsk);
 
 	newinet = inet_sk(newsk);
 	newsp = sctp_sk(newsk);
-- 
2.53.0



