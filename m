Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8067514286;
	Tue, 21 Oct 2025 20:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076856; cv=none; b=IFZwponKubJJ1/lFgifkdrMwGXSHxdzXWKtzlLaLdcj4DScyxtEJJs590mdV6dTV/QWoLa66g4ChJFI2E0U3WGpED1od20MURGZLGjckvgCieCra19MEYbhczY2/TmZNhwPGqbhL9qkN1bPYeBmlJeaqGo6AMQpVuwM55UC9tC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076856; c=relaxed/simple;
	bh=n7k8f1nuU+cMQwwD7uUegr9MXjxCowQpl+cvtxO3nG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NJDwUeLsaE6k01MAMFKnMymZwPqbf2M49659TWwcVtjCbkI9nUxvCJsWmVk2HUylvs0M8iFH+LxoliX0ZXN8WyO2okvJXKRrAyTLG8/p400e7Ut07G6e6/m6/AVRtADAU7nBzkEVW0Zo9Q3ZsLksNKUjs7Oi9v3B+X3I09lYIs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lUGPeuE0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lUGPeuE0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA77BC4CEF1;
	Tue, 21 Oct 2025 20:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076856;
	bh=n7k8f1nuU+cMQwwD7uUegr9MXjxCowQpl+cvtxO3nG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lUGPeuE0uLtCetqE3pwyAgxNZmQhFwgwvREfzZ/Hxs0y77nJBrNu+BKTetu3NH25m
	 sctH5KUVo8JYwvXjzFt2QLzfYM9QvpSGv0lSBXVQgUcBf4JPGgVFKuvhcaXFTBGB41
	 Ii6duBazz5N6paydwJGwhs+gXXqHa/ZiBVptqhaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 060/136] tls: wait for async encrypt in case of error during latter iterations of sendmsg
Date: Tue, 21 Oct 2025 21:50:48 +0200
Message-ID: <20251021195037.421102087@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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
index aac685daf66c4..dc5a7e24d7b77 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1054,7 +1054,7 @@ static int tls_sw_sendmsg_locked(struct sock *sk, struct msghdr *msg,
 			if (ret == -EINPROGRESS)
 				num_async++;
 			else if (ret != -EAGAIN)
-				goto send_end;
+				goto end;
 		}
 	}
 
@@ -1226,8 +1226,9 @@ static int tls_sw_sendmsg_locked(struct sock *sk, struct msghdr *msg,
 			goto alloc_encrypted;
 	}
 
+send_end:
 	if (!num_async) {
-		goto send_end;
+		goto end;
 	} else if (num_zc || eor) {
 		int err;
 
@@ -1245,7 +1246,7 @@ static int tls_sw_sendmsg_locked(struct sock *sk, struct msghdr *msg,
 		tls_tx_records(sk, msg->msg_flags);
 	}
 
-send_end:
+end:
 	ret = sk_stream_error(sk, msg->msg_flags, ret);
 	return copied > 0 ? copied : ret;
 }
-- 
2.51.0



