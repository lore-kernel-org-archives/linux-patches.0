Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD9332ED57;
	Mon, 27 Oct 2025 19:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591881; cv=none; b=MbcRKsDgsZYvL/Wo2dQ3x5f7RNOLBQ8ebMA+xm9Sa6+e3wbZLyCoXsFO5MLwhIxh76Su55lcJ+hihshLbMbJxlzqzrvgCzBni+OS9SlHIfCWaEp4y8DXSHsPGv2e7ZfA6Yl+uMxHr44IfKDpXjJFuKDFWu0giT0fd5K9NLMRVxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591881; c=relaxed/simple;
	bh=GEPJ9L8SPuqdzxQPAqnW9QG2nPxPix+CktoIBjwu+qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dR+mnmns30YRCCtI0bXjWi0RB+LtquFqQrfYclBnTmq3+bC+ZCm1fX3a3GylXRGSf4yB0nE0gxf/KBaB5vDfhtWmUespRLMnbXrsIIsYbz6375VFYsoVpyOHLj/C30+qBt9MyJHx2a6znIH7d6SMRESeqv8s09TTvf5Rh4BJRyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SzvRgrqx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SzvRgrqx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3D8C4CEF1;
	Mon, 27 Oct 2025 19:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591881;
	bh=GEPJ9L8SPuqdzxQPAqnW9QG2nPxPix+CktoIBjwu+qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SzvRgrqxMErX+MiXNLQv/V0JmCLRVQbNw2lxDkvyu17BfMP5m4b3wxhXq6AjojOdT
	 uDcVF2yjchsuL07AXThvFNfItgpZZPix37zqdl762nTixfDv/1DbGonc00vXJ4Fb9c
	 Fl8km03azkvYJKzEvHfiHJgj+7W1joV5LiN7KDFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 026/123] tls: wait for async encrypt in case of error during latter iterations of sendmsg
Date: Mon, 27 Oct 2025 19:35:06 +0100
Message-ID: <20251027183447.098753044@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit b014a4e066c555185b7c367efacdc33f16695495 ]

If we hit an error during the main loop of tls_sw_sendmsg_locked (eg
failed allocation), we jump to send_end and immediately
return. Previous iterations may have queued async encryption requests
that are still pending. We should wait for those before returning, as
we could otherwise be reading from memory that userspace believes
we're not using anymore, which would be a sort of use-after-free.

This is similar to what tls_sw_recvmsg already does: failures during
the main loop jump to the "wait for async" code, not straight to the
unlock/return.

Fixes: a42055e8d2c3 ("net/tls: Add support for async encryption of records for performance")
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/c793efe9673b87f808d84fdefc0f732217030c52.1760432043.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index d2cb19f5cb8bc..e08edfc639fd5 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1013,7 +1013,7 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 			if (ret == -EINPROGRESS)
 				num_async++;
 			else if (ret != -EAGAIN)
-				goto send_end;
+				goto end;
 		}
 	}
 
@@ -1162,8 +1162,9 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 			goto alloc_encrypted;
 	}
 
+send_end:
 	if (!num_async) {
-		goto send_end;
+		goto end;
 	} else if (num_zc || eor) {
 		int err;
 
@@ -1181,7 +1182,7 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 		tls_tx_records(sk, msg->msg_flags);
 	}
 
-send_end:
+end:
 	ret = sk_stream_error(sk, msg->msg_flags, ret);
 
 	release_sock(sk);
-- 
2.51.0



